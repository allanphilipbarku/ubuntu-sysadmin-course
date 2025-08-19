#!/bin/bash

# Task Release Automation Script
# This script allows teachers to progressively release tasks to students
# Usage: ./scripts/release-tasks.sh <level> <week> [--dry-run]

set -e

# Configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
TASKS_CONFIG="$SCRIPT_DIR/tasks-config.json"
TEMPLATES_DIR="$PROJECT_ROOT/resources/templates"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Functions
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Help function
show_help() {
    cat << EOF
Task Release Automation Script

Usage: $0 <level> <week> [options]

Arguments:
  level         Level to release (1-5 or level-1-foundation, level-2-services, etc.)
  week          Week to release (1-10 or week-1, week-2, etc.)

Options:
  --dry-run     Show what would be released without actually doing it
  --help        Show this help message
  --list        List available tasks that can be released
  --status      Show current release status

Examples:
  $0 1 1                    # Release Level 1, Week 1 tasks
  $0 level-2-services 3     # Release Level 2, Week 3 tasks
  $0 3 5 --dry-run         # Preview Level 3, Week 5 tasks release
  $0 --list                # List all available tasks
  $0 --status              # Show current release status

EOF
}

# Validate arguments
validate_args() {
    if [ $# -eq 0 ]; then
        show_help
        exit 1
    fi

    case "$1" in
        --help|-h)
            show_help
            exit 0
            ;;
        --list)
            list_available_tasks
            exit 0
            ;;
        --status)
            show_release_status
            exit 0
            ;;
    esac

    if [ $# -lt 2 ]; then
        log_error "Missing required arguments"
        show_help
        exit 1
    fi
}

# Convert level and week to standardized format
normalize_level() {
    local level="$1"
    case "$level" in
        1) echo "level-1-foundation" ;;
        2) echo "level-2-services" ;;
        3) echo "level-3-networking" ;;
        4) echo "level-4-storage" ;;
        5) echo "level-5-advanced" ;;
        level-*) echo "$level" ;;
        *) log_error "Invalid level: $level"; exit 1 ;;
    esac
}

normalize_week() {
    local week="$1"
    case "$week" in
        [1-9]|10) echo "week-$week" ;;
        week-*) echo "$week" ;;
        *) log_error "Invalid week: $week"; exit 1 ;;
    esac
}

# Check if tasks are already released
check_release_status() {
    local level_dir="$1"
    local week_dir="$2"
    
    if [ ! -d "$level_dir/$week_dir" ]; then
        log_error "Directory $level_dir/$week_dir does not exist"
        return 1
    fi
    
    # Check if there are files other than .gitkeep
    local file_count=$(find "$level_dir/$week_dir" -type f ! -name ".gitkeep" | wc -l)
    
    if [ "$file_count" -gt 0 ]; then
        return 0  # Already released
    else
        return 1  # Not released
    fi
}

# Release tasks for a specific level and week
release_tasks() {
    local level="$1"
    local week="$2"
    local dry_run="$3"
    
    local level_normalized=$(normalize_level "$level")
    local week_normalized=$(normalize_week "$week")
    local target_dir="$PROJECT_ROOT/levels/$level_normalized/$week_normalized"
    
    log_info "Preparing to release tasks for $level_normalized, $week_normalized"
    
    # Check if already released
    if check_release_status "$PROJECT_ROOT/levels/$level_normalized" "$week_normalized"; then
        log_warning "Tasks for $level_normalized/$week_normalized are already released"
        read -p "Do you want to update/overwrite? (y/N): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            log_info "Release cancelled"
            exit 0
        fi
    fi
    
    if [ "$dry_run" = true ]; then
        log_info "[DRY RUN] Would release tasks to: $target_dir"
        log_info "[DRY RUN] Files that would be created:"
        echo "  - README.md (Task overview and instructions)"
        echo "  - tasks.md (Detailed task descriptions)"
        echo "  - scenarios.md (Practical scenarios)"
        echo "  - assessment.md (Assessment criteria)"
        echo "  - resources.md (Additional resources and references)"
        return 0
    fi
    
    # Create task files
    create_task_files "$level_normalized" "$week_normalized" "$target_dir"
    
    # Update release status
    update_release_log "$level_normalized" "$week_normalized"
    
    log_success "Successfully released tasks for $level_normalized/$week_normalized"
    log_info "Tasks available at: $target_dir"
    
    # Create GitHub notification
    create_github_notification "$level_normalized" "$week_normalized"
}

# Create task files based on templates
create_task_files() {
    local level="$1"
    local week="$2"
    local target_dir="$3"
    
    log_info "Creating task files in $target_dir"
    
    # Create README.md for the week
    cat > "$target_dir/README.md" << EOF
# $(get_level_title "$level") - $(get_week_title "$week")

## Overview
$(get_week_overview "$level" "$week")

## Learning Objectives
$(get_learning_objectives "$level" "$week")

## Tasks
$(get_week_tasks "$level" "$week")

## Getting Started
1. Make sure you're on your student branch: \`git checkout student-[your-username]\`
2. Create a submission folder: \`mkdir -p submissions/[your-username]/$(echo $level | cut -d'-' -f2)/$(echo $week | cut -d'-' -f2)\`
3. Work on the tasks below
4. Document your solutions in the submission folder
5. Commit and push your work
6. Create a Pull Request when ready for review

## Submission Guidelines
- Document your thought process and methodology
- Include screenshots or logs where relevant
- Explain any challenges faced and how you overcame them
- Test your solutions thoroughly before submission

## Need Help?
- Check the [resources](../../resources/) folder for references
- Ask questions in GitHub Discussions
- Review other students' approaches (after submitting your own)
- Attend office hours for live assistance

---
**Estimated Time**: $(get_estimated_time "$level" "$week")
**Difficulty**: $(get_difficulty_level "$level" "$week")
EOF

    # Create detailed tasks file
    get_detailed_tasks "$level" "$week" > "$target_dir/tasks.md"
    
    # Create scenarios file
    get_scenarios "$level" "$week" > "$target_dir/scenarios.md"
    
    # Create assessment criteria
    get_assessment_criteria "$level" "$week" > "$target_dir/assessment.md"
    
    log_success "Task files created successfully"
}

# Helper functions to extract content from original markdown
get_level_title() {
    local level="$1"
    case "$level" in
        "level-1-foundation") echo "Level 1: Foundation - File System and Basic Commands" ;;
        "level-2-services") echo "Level 2: Services and Process Management" ;;
        "level-3-networking") echo "Level 3: Network Configuration and Monitoring" ;;
        "level-4-storage") echo "Level 4: Storage, Backup, and Performance" ;;
        "level-5-advanced") echo "Level 5: Advanced Integration and Automation" ;;
    esac
}

get_week_title() {
    local week="$1"
    local week_num=$(echo "$week" | cut -d'-' -f2)
    echo "Week $week_num"
}

get_week_overview() {
    local level="$1"
    local week="$2"
    echo "Detailed tasks and scenarios for this week will be populated here based on the learning content."
}

get_learning_objectives() {
    local level="$1"
    local week="$2"
    echo "- Learning objectives will be extracted from the main curriculum"
    echo "- And formatted appropriately for this week's focus"
}

get_week_tasks() {
    local level="$1"
    local week="$2"
    echo "Specific tasks for this week will be detailed here."
}

get_estimated_time() {
    echo "20-25 hours"
}

get_difficulty_level() {
    local level="$1"
    local level_num=$(echo "$level" | cut -d'-' -f2)
    case "$level_num" in
        1) echo "Beginner" ;;
        2) echo "Beginner-Intermediate" ;;
        3) echo "Intermediate" ;;
        4) echo "Intermediate-Advanced" ;;
        5) echo "Advanced" ;;
    esac
}

get_detailed_tasks() {
    local level="$1"
    local week="$2"
    echo "# Detailed Tasks for $(get_level_title "$level") - $(get_week_title "$week")"
    echo ""
    echo "## Core Tasks"
    echo "Detailed task descriptions will be populated here from the main curriculum."
    echo ""
    echo "## Deliverables"
    echo "- List of expected deliverables"
    echo "- Documentation requirements"
    echo "- Practical demonstrations"
}

get_scenarios() {
    local level="$1"
    local week="$2"
    echo "# Practical Scenarios"
    echo ""
    echo "## Scenario 1: [Title]"
    echo "**Problem**: Description of the problem"
    echo "**Tasks**: Step by step tasks to complete"
    echo "**Expected Outcome**: What students should achieve"
}

get_assessment_criteria() {
    local level="$1"
    local week="$2"
    echo "# Assessment Criteria"
    echo ""
    echo "## Technical Skills"
    echo "- Specific technical competencies to demonstrate"
    echo ""
    echo "## Problem-Solving Approach"
    echo "- Systematic methodology evaluation"
    echo ""
    echo "## Documentation Quality"
    echo "- Clear explanations and thought processes"
}

# Update release log
update_release_log() {
    local level="$1"
    local week="$2"
    local log_file="$PROJECT_ROOT/.release-log"
    
    echo "$(date '+%Y-%m-%d %H:%M:%S') - Released: $level/$week" >> "$log_file"
}

# Create GitHub notification
create_github_notification() {
    local level="$1"
    local week="$2"
    
    log_info "Creating GitHub notification for task release"
    
    # This would typically create a GitHub issue or discussion
    # For now, just log the information
    log_info "GitHub notification: New tasks released for $level/$week"
}

# List available tasks
list_available_tasks() {
    echo "Available tasks that can be released:"
    echo ""
    for level in 1 2 3 4 5; do
        local level_name=$(normalize_level "$level")
        local level_title=$(get_level_title "$level_name")
        echo "Level $level: $level_title"
        
        case "$level" in
            1|2|3|4|5)
                local start_week=$(( (level - 1) * 2 + 1 ))
                local end_week=$(( level * 2 ))
                for week in $(seq $start_week $end_week); do
                    local week_name=$(normalize_week "$week")
                    local status="Not Released"
                    if check_release_status "$PROJECT_ROOT/levels/$level_name" "$week_name" 2>/dev/null; then
                        status="Released"
                    fi
                    echo "  Week $week: [$status]"
                done
                ;;
        esac
        echo ""
    done
}

# Show current release status
show_release_status() {
    echo "Current Task Release Status:"
    echo "=========================="
    list_available_tasks
    
    if [ -f "$PROJECT_ROOT/.release-log" ]; then
        echo ""
        echo "Recent Releases:"
        echo "----------------"
        tail -10 "$PROJECT_ROOT/.release-log"
    fi
}

# Main execution
main() {
    validate_args "$@"
    
    local level="$1"
    local week="$2"
    local dry_run=false
    
    # Check for dry-run flag
    if [ "$3" = "--dry-run" ]; then
        dry_run=true
    fi
    
    release_tasks "$level" "$week" "$dry_run"
}

# Run main function if script is executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi