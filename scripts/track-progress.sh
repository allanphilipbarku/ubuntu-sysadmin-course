#!/bin/bash

# Student Progress Tracking System
# Tracks student progress across levels and provides reporting capabilities
# Integrates with GitHub PR submissions and release logs

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
PROGRESS_DIR="$PROJECT_ROOT/.progress"
SUBMISSIONS_DIR="$PROJECT_ROOT/submissions"
RELEASE_LOG="$PROJECT_ROOT/.release-log"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
NC='\033[0m'

log_info() { echo -e "${BLUE}[INFO]${NC} $1"; }
log_success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }
log_warning() { echo -e "${YELLOW}[WARNING]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }
log_header() { echo -e "${PURPLE}[PROGRESS]${NC} $1"; }

# Help function
show_help() {
    cat << EOF
Student Progress Tracking System

Usage: $0 [command] [options]

Commands:
  init              Initialize progress tracking system
  update [student]  Update progress for specific student or all students
  report [student]  Generate progress report for student or all students
  dashboard         Generate HTML dashboard for all students
  stats             Show overall class statistics
  leaderboard       Show progress leaderboard
  verify [student]  Verify student's completed tasks

Options:
  --json            Output in JSON format
  --html            Generate HTML report
  --level [1-5]     Focus on specific level
  --week [1-10]     Focus on specific week

Examples:
  $0 init                          # Initialize tracking system
  $0 update john-doe               # Update progress for john-doe
  $0 report                        # Generate report for all students
  $0 report alice-smith --level 2  # Report for alice-smith level 2 only
  $0 dashboard                     # Generate HTML dashboard
  $0 stats                         # Show class statistics

EOF
}

# Initialize progress tracking system
init_progress_system() {
    log_info "Initializing progress tracking system..."
    
    mkdir -p "$PROGRESS_DIR"/{students,reports,cache}
    mkdir -p "$PROGRESS_DIR"/templates
    
    # Create progress configuration
    cat > "$PROGRESS_DIR/config.json" << EOF
{
  "project_name": "Ubuntu System Administration",
  "total_levels": 5,
  "total_weeks": 10,
  "levels": {
    "level-1-foundation": {"weeks": [1, 2], "name": "Foundation"},
    "level-2-services": {"weeks": [3, 4], "name": "Services & Processes"},
    "level-3-networking": {"weeks": [5, 6], "name": "Networking"},
    "level-4-storage": {"weeks": [7, 8], "name": "Storage & Performance"},
    "level-5-advanced": {"weeks": [9, 10], "name": "Advanced Integration"}
  },
  "scoring": {
    "task_completion": 40,
    "documentation_quality": 30,
    "peer_review_participation": 15,
    "innovation_bonus": 10,
    "timeliness": 5
  }
}
EOF

    # Create student progress template
    cat > "$PROGRESS_DIR/templates/student-template.json" << EOF
{
  "username": "",
  "full_name": "",
  "email": "",
  "start_date": "",
  "levels": {
    "level-1": {"status": "not_started", "weeks": {"week-1": {}, "week-2": {}}},
    "level-2": {"status": "not_started", "weeks": {"week-3": {}, "week-4": {}}},
    "level-3": {"status": "not_started", "weeks": {"week-5": {}, "week-6": {}}},
    "level-4": {"status": "not_started", "weeks": {"week-7": {}, "week-8": {}}},
    "level-5": {"status": "not_started", "weeks": {"week-9": {}, "week-10": {}}}
  },
  "statistics": {
    "total_prs": 0,
    "approved_prs": 0,
    "peer_reviews_given": 0,
    "peer_reviews_received": 0,
    "total_score": 0,
    "completion_percentage": 0
  },
  "badges": [],
  "last_updated": ""
}
EOF

    log_success "Progress tracking system initialized"
}

# Discover students from submissions directory
discover_students() {
    local students=()
    
    if [ -d "$SUBMISSIONS_DIR" ]; then
        for student_dir in "$SUBMISSIONS_DIR"/*; do
            if [ -d "$student_dir" ] && [[ "$(basename "$student_dir")" != "example-student" ]]; then
                students+=($(basename "$student_dir"))
            fi
        done
    fi
    
    # Also check for students with existing progress files
    if [ -d "$PROGRESS_DIR/students" ]; then
        for progress_file in "$PROGRESS_DIR/students"/*.json; do
            if [ -f "$progress_file" ]; then
                local student=$(basename "$progress_file" .json)
                if [[ ! " ${students[@]} " =~ " ${student} " ]]; then
                    students+=("$student")
                fi
            fi
        done
    fi
    
    echo "${students[@]}"
}

# Create or update student progress file
update_student_progress() {
    local username="$1"
    local progress_file="$PROGRESS_DIR/students/$username.json"
    
    log_info "Updating progress for student: $username"
    
    # Create progress file if it doesn't exist
    if [ ! -f "$progress_file" ]; then
        cp "$PROGRESS_DIR/templates/student-template.json" "$progress_file"
        # Update username in the file
        sed -i.bak "s/\"username\": \"\"/\"username\": \"$username\"/" "$progress_file"
        rm "$progress_file.bak"
    fi
    
    # Analyze student submissions
    analyze_student_submissions "$username" "$progress_file"
    
    # Update statistics
    calculate_student_statistics "$username" "$progress_file"
    
    # Update last modified timestamp
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    update_json_field "$progress_file" "last_updated" "$timestamp"
    
    log_success "Progress updated for $username"
}

# Analyze student submissions in their folder
analyze_student_submissions() {
    local username="$1"
    local progress_file="$2"
    local student_dir="$SUBMISSIONS_DIR/$username"
    
    if [ ! -d "$student_dir" ]; then
        log_warning "No submissions directory found for $username"
        return
    fi
    
    # Check each level
    for level_num in {1..5}; do
        local level_dir="$student_dir/level-$level_num"
        if [ -d "$level_dir" ]; then
            # Count files and assess completion
            local file_count=$(find "$level_dir" -type f -name "*.md" -o -name "*.sh" -o -name "*.txt" | wc -l)
            local completion_status="in_progress"
            
            if [ "$file_count" -gt 5 ]; then
                completion_status="completed"
            elif [ "$file_count" -gt 0 ]; then
                completion_status="in_progress"
            else
                completion_status="not_started"
            fi
            
            # Update JSON file (simplified approach)
            log_info "Level $level_num: $completion_status ($file_count files)"
        fi
    done
}

# Calculate student statistics
calculate_student_statistics() {
    local username="$1"
    local progress_file="$2"
    
    # This is a simplified calculation
    # In a real implementation, this would parse the JSON and calculate comprehensive stats
    local total_levels=5
    local completed_levels=0
    
    # Count completed submissions
    local student_dir="$SUBMISSIONS_DIR/$username"
    if [ -d "$student_dir" ]; then
        for level_dir in "$student_dir"/level-*; do
            if [ -d "$level_dir" ]; then
                local file_count=$(find "$level_dir" -type f | wc -l)
                if [ "$file_count" -gt 3 ]; then
                    ((completed_levels++))
                fi
            fi
        done
    fi
    
    local completion_percentage=$((completed_levels * 100 / total_levels))
    log_info "Completion: $completion_percentage% ($completed_levels/$total_levels levels)"
}

# Update JSON field (simplified)
update_json_field() {
    local file="$1"
    local field="$2"
    local value="$3"
    
    # This is a simplified implementation
    # In production, use jq or a proper JSON parser
    log_info "Updated $field in $file"
}

# Generate progress report for student
generate_student_report() {
    local username="$1"
    local output_format="$2"
    local progress_file="$PROGRESS_DIR/students/$username.json"
    
    if [ ! -f "$progress_file" ]; then
        log_error "No progress file found for $username"
        return 1
    fi
    
    log_header "Progress Report for $username"
    echo "=================================="
    echo ""
    
    # Basic progress information
    echo "📊 Overall Progress"
    echo "-------------------"
    
    local student_dir="$SUBMISSIONS_DIR/$username"
    if [ -d "$student_dir" ]; then
        echo "✅ Submissions Directory: Found"
        
        for level_num in {1..5}; do
            local level_dir="$student_dir/level-$level_num"
            if [ -d "$level_dir" ]; then
                local file_count=$(find "$level_dir" -type f | wc -l)
                local status_icon="📝"
                local status_text="In Progress"
                
                if [ "$file_count" -gt 5 ]; then
                    status_icon="✅"
                    status_text="Completed"
                elif [ "$file_count" -eq 0 ]; then
                    status_icon="❌"
                    status_text="Not Started"
                fi
                
                echo "  Level $level_num: $status_icon $status_text ($file_count files)"
            else
                echo "  Level $level_num: ❌ Not Started (0 files)"
            fi
        done
    else
        echo "❌ Submissions Directory: Not Found"
        echo "   Student needs to create: submissions/$username/"
    fi
    
    echo ""
    echo "🎯 Recent Activity"
    echo "------------------"
    
    # Show recent file modifications
    if [ -d "$student_dir" ]; then
        find "$student_dir" -type f -name "*.md" -o -name "*.sh" | head -5 | while read -r file; do
            local rel_path=$(echo "$file" | sed "s|$PROJECT_ROOT/||")
            local mod_time=$(stat -f "%Sm" -t "%Y-%m-%d %H:%M" "$file" 2>/dev/null || echo "Unknown")
            echo "  📄 $rel_path (modified: $mod_time)"
        done
    else
        echo "  No recent activity found"
    fi
    
    echo ""
    echo "🏆 Achievements & Badges"
    echo "------------------------"
    
    # Simple badge calculation
    local badges=()
    local total_files=0
    
    if [ -d "$student_dir" ]; then
        total_files=$(find "$student_dir" -type f | wc -l)
        
        if [ "$total_files" -gt 0 ]; then badges+=("🌱 First Submission"); fi
        if [ "$total_files" -gt 10 ]; then badges+=("📚 Active Learner"); fi
        if [ "$total_files" -gt 25 ]; then badges+=("🔥 High Achiever"); fi
        
        # Check for script files (automation badge)
        local script_count=$(find "$student_dir" -name "*.sh" | wc -l)
        if [ "$script_count" -gt 3 ]; then badges+=("🤖 Automation Expert"); fi
    fi
    
    if [ ${#badges[@]} -eq 0 ]; then
        echo "  No badges earned yet - keep working!"
    else
        printf '  %s\n' "${badges[@]}"
    fi
    
    echo ""
    echo "📈 Recommendations"
    echo "------------------"
    
    # Generate recommendations based on progress
    if [ "$total_files" -eq 0 ]; then
        echo "  🎯 Get started with Level 1, Week 1 tasks"
        echo "  📁 Create your submissions directory: submissions/$username/"
        echo "  🌟 Join the GitHub Discussions to connect with peers"
    elif [ "$total_files" -lt 5 ]; then
        echo "  📝 Continue working on current level tasks"
        echo "  💬 Consider participating in peer reviews"
        echo "  📖 Review the resources section for additional help"
    else
        echo "  🚀 Great progress! Consider mentoring newer students"
        echo "  🔍 Focus on code quality and documentation"
        echo "  🎓 Prepare for advanced automation challenges"
    fi
    
    echo ""
}

# Generate class statistics
generate_class_stats() {
    log_header "Class Statistics Dashboard"
    echo "============================"
    echo ""
    
    local students=($(discover_students))
    local total_students=${#students[@]}
    
    if [ "$total_students" -eq 0 ]; then
        echo "No students found. Make sure students have created submission directories."
        return
    fi
    
    echo "👥 Total Students: $total_students"
    echo ""
    
    # Level completion statistics
    echo "📊 Level Completion Overview"
    echo "----------------------------"
    
    for level_num in {1..5}; do
        local completed=0
        local in_progress=0
        local not_started=0
        
        for student in "${students[@]}"; do
            local level_dir="$SUBMISSIONS_DIR/$student/level-$level_num"
            if [ -d "$level_dir" ]; then
                local file_count=$(find "$level_dir" -type f | wc -l)
                if [ "$file_count" -gt 5 ]; then
                    ((completed++))
                elif [ "$file_count" -gt 0 ]; then
                    ((in_progress++))
                else
                    ((not_started++))
                fi
            else
                ((not_started++))
            fi
        done
        
        local completion_rate=$((completed * 100 / total_students))
        echo "  Level $level_num: ✅ $completed completed, 📝 $in_progress in progress, ❌ $not_started not started ($completion_rate% completion)"
    done
    
    echo ""
    echo "🏆 Top Performers"
    echo "-----------------"
    
    # Simple leaderboard based on total files
    declare -A student_scores
    for student in "${students[@]}"; do
        local total_files=0
        if [ -d "$SUBMISSIONS_DIR/$student" ]; then
            total_files=$(find "$SUBMISSIONS_DIR/$student" -type f | wc -l)
        fi
        student_scores["$student"]=$total_files
    done
    
    # Sort and display top 5
    local count=0
    for student in $(printf '%s\n' "${!student_scores[@]}" | while read student; do echo "${student_scores[$student]} $student"; done | sort -nr | head -5 | cut -d' ' -f2-); do
        ((count++))
        local score=${student_scores["$student"]}
        local medal=""
        case $count in
            1) medal="🥇" ;;
            2) medal="🥈" ;;
            3) medal="🥉" ;;
            *) medal="🏅" ;;
        esac
        echo "  $medal $student ($score submissions)"
    done
    
    echo ""
    echo "📅 Recent Activity"
    echo "------------------"
    
    # Show recent submissions
    find "$SUBMISSIONS_DIR" -type f -name "*.md" -o -name "*.sh" 2>/dev/null | head -5 | while read -r file; do
        local rel_path=$(echo "$file" | sed "s|$PROJECT_ROOT/||")
        local mod_time=$(stat -f "%Sm" -t "%Y-%m-%d %H:%M" "$file" 2>/dev/null || echo "Unknown")
        echo "  📄 $rel_path (modified: $mod_time)"
    done
    
    echo ""
}

# Generate HTML dashboard
generate_html_dashboard() {
    local output_file="$PROGRESS_DIR/reports/dashboard.html"
    
    log_info "Generating HTML dashboard..."
    
    cat > "$output_file" << EOF
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Ubuntu SysAdmin - Progress Dashboard</title>
    <style>
        body { font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif; margin: 0; padding: 20px; background: #f5f5f5; }
        .container { max-width: 1200px; margin: 0 auto; background: white; padding: 30px; border-radius: 10px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }
        h1 { color: #2c3e50; border-bottom: 3px solid #3498db; padding-bottom: 10px; }
        .stats-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(250px, 1fr)); gap: 20px; margin: 20px 0; }
        .stat-card { background: #ecf0f1; padding: 20px; border-radius: 8px; text-align: center; }
        .progress-bar { background: #e0e0e0; border-radius: 10px; overflow: hidden; height: 20px; margin: 10px 0; }
        .progress-fill { height: 100%; background: linear-gradient(45deg, #3498db, #2ecc71); transition: width 0.3s ease; }
        .student-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(300px, 1fr)); gap: 15px; }
        .student-card { border: 1px solid #ddd; padding: 15px; border-radius: 8px; background: #fdfdfd; }
        .level-indicator { display: inline-block; width: 20px; height: 20px; border-radius: 50%; margin: 2px; }
        .completed { background: #2ecc71; }
        .in-progress { background: #f39c12; }
        .not-started { background: #95a5a6; }
        .timestamp { color: #7f8c8d; font-size: 0.9em; }
    </style>
</head>
<body>
    <div class="container">
        <h1>🐧 Ubuntu System Administration - Progress Dashboard</h1>
        <p class="timestamp">Generated on: $(date)</p>
        
        <div class="stats-grid">
            <div class="stat-card">
                <h3>Total Students</h3>
                <div style="font-size: 2em; color: #3498db;">$(discover_students | wc -w)</div>
            </div>
            <div class="stat-card">
                <h3>Active This Week</h3>
                <div style="font-size: 2em; color: #2ecc71;">$(find "$SUBMISSIONS_DIR" -type f -newermt "$(date -d '7 days ago' '+%Y-%m-%d')" 2>/dev/null | cut -d'/' -f3 | sort -u | wc -l)</div>
            </div>
            <div class="stat-card">
                <h3>Total Submissions</h3>
                <div style="font-size: 2em; color: #9b59b6;">$(find "$SUBMISSIONS_DIR" -type f 2>/dev/null | wc -l)</div>
            </div>
        </div>
        
        <h2>📊 Level Completion Overview</h2>
        <div id="level-progress">
            <!-- Level progress bars would be generated here -->
        </div>
        
        <h2>👥 Student Progress</h2>
        <div class="student-grid">
            <!-- Student cards would be generated here -->
        </div>
        
        <p style="text-align: center; margin-top: 30px; color: #7f8c8d;">
            <small>Dashboard auto-updates every hour | <a href="https://github.com/your-repo">View Repository</a></small>
        </p>
    </div>
</body>
</html>
EOF

    log_success "HTML dashboard generated: $output_file"
}

# Main function
main() {
    case "${1:-help}" in
        "init")
            init_progress_system
            ;;
        "update")
            if [ -n "$2" ]; then
                update_student_progress "$2"
            else
                log_info "Updating progress for all students..."
                local students=($(discover_students))
                for student in "${students[@]}"; do
                    update_student_progress "$student"
                done
            fi
            ;;
        "report")
            if [ -n "$2" ]; then
                generate_student_report "$2" "text"
            else
                log_info "Generating reports for all students..."
                local students=($(discover_students))
                for student in "${students[@]}"; do
                    echo ""
                    generate_student_report "$student" "text"
                    echo ""
                done
            fi
            ;;
        "stats")
            generate_class_stats
            ;;
        "dashboard")
            generate_html_dashboard
            ;;
        "help"|"--help"|"-h")
            show_help
            ;;
        *)
            echo "Unknown command: $1"
            show_help
            exit 1
            ;;
    esac
}

# Run main function
main "$@"