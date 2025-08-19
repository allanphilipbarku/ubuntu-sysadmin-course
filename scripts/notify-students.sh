#!/bin/bash

# Teacher Notification System
# Automates communication to students about new releases and provides monitoring
# Supports multiple notification channels and tracking of student engagement

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
NOTIFICATION_LOG="$PROJECT_ROOT/.notification-log"

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
log_header() { echo -e "${PURPLE}[NOTIFY]${NC} $1"; }

# Help function
show_help() {
    cat << EOF
Teacher Notification System

This script helps teachers communicate with students about new releases,
track adoption rates, and manage multi-channel notifications.

Usage: $0 [command] [options]

Commands:
  release         Announce a new task release
  reminder        Send reminder about pending tasks
  adoption        Check release adoption rates
  emergency       Send urgent notification to all students
  schedule        Schedule recurring notifications
  
Options:
  --level         Level number (1-5)
  --week          Week number (1-10)
  --message       Custom message text
  --urgency       Notification urgency (normal, high, emergency) [default: normal]
  --channel       Notification channel (github, file, all) [default: all]
  --template      Use predefined template (release, reminder, emergency)
  --dry-run       Show what would be sent without actually sending
  --help          Show this help message

Examples:
  $0 release --level 2 --week 3                    # Announce Level 2 Week 3 release
  $0 reminder --message "Don't forget Level 1 tasks"
  $0 adoption --level 2 --week 3                   # Check adoption rate
  $0 emergency --message "Server maintenance tonight"
  $0 schedule --template reminder --weekly          # Weekly reminders

Notification Channels:
  - GitHub Issues (with appropriate labels)
  - GitHub Discussions (announcements category)
  - Local file notifications (for integration with other tools)
  - Email integration (if configured)

For setup instructions, see docs/TEACHER_RELEASE_WORKFLOW.md
EOF
}

# Create notification templates
create_templates() {
    local templates_dir="$PROJECT_ROOT/.notification-templates"
    mkdir -p "$templates_dir"
    
    # Release announcement template
    cat > "$templates_dir/release.md" << 'EOF'
# 🎉 Level {LEVEL} Week {WEEK} Released: {TOPIC}

## What's New
- **Focus**: {FOCUS}
- **Skills**: {SKILLS}
- **Duration**: Estimated {HOURS} hours over {DAYS} days

## Learning Objectives
{OBJECTIVES}

## Key Tasks
{TASKS}

## Getting the Updates

### Step 1: Sync Your Fork
```bash
git checkout student-YOUR-USERNAME
git fetch upstream
git pull upstream main
git push origin student-YOUR-USERNAME
```

### Step 2: Check New Content
```bash
ls levels/level-{LEVEL}-*/week-{WEEK}/
```

### Step 3: Start Working
```bash
cd submissions/YOUR-USERNAME/level-{LEVEL}/
# Begin your work here
```

## 📅 Timeline
- **Released**: {RELEASE_DATE}
- **Suggested completion**: {DUE_DATE}
- **Office hours**: {OFFICE_HOURS}
- **Peer review deadline**: {REVIEW_DATE}

## 🆘 Need Help?
- **Git issues**: [Student Workflow Guide](docs/STUDENT_WORKFLOW_GUIDE.md)
- **Technical questions**: Post in GitHub Discussions
- **Sync problems**: Use `./scripts/student-sync.sh status`

## 📊 Progress Check
After completing the tasks:
- [ ] Submit your work via Pull Request
- [ ] Participate in peer reviews
- [ ] Join discussions to share insights
- [ ] Help newer students if needed

---
*Happy learning! 🚀*

**Quick Sync Command:** `./scripts/student-sync.sh sync`
EOF

    # Reminder template
    cat > "$templates_dir/reminder.md" << 'EOF'
# 📢 Reminder: {SUBJECT}

## Current Status
{STATUS_MESSAGE}

## Action Items
{ACTION_ITEMS}

## Quick Commands
```bash
# Check what's new
./scripts/student-sync.sh check

# Sync your fork
./scripts/student-sync.sh sync

# Check your status
./scripts/student-sync.sh status
```

## Need Help?
- Post questions in GitHub Discussions
- Check the [Student Workflow Guide](docs/STUDENT_WORKFLOW_GUIDE.md)
- Use `./scripts/student-sync.sh recover` if you're stuck

---
*Reminder sent on {TIMESTAMP}*
EOF

    # Emergency template
    cat > "$templates_dir/emergency.md" << 'EOF'
# 🚨 URGENT: {SUBJECT}

## Immediate Action Required
{EMERGENCY_MESSAGE}

## What You Need to Do
{EMERGENCY_ACTIONS}

## Timeline
{EMERGENCY_TIMELINE}

---
**This is an urgent notification sent on {TIMESTAMP}**
EOF

    log_info "Notification templates created in $templates_dir"
}

# Get level information
get_level_info() {
    local level="$1"
    local week="$2"
    
    case "$level" in
        1)
            case "$week" in
                1) echo "Foundation|File System Exploration|file system navigation and basic commands|System inventory and configuration analysis|20-25" ;;
                2) echo "Foundation|Log Analysis and Monitoring|log analysis and system monitoring|Log monitoring scripts and analysis|20-25" ;;
            esac
            ;;
        2)
            case "$week" in
                3) echo "Services|Service Management|systemd and service control|Service troubleshooting and dependencies|25-30" ;;
                4) echo "Services|Process Management|process monitoring and control|Advanced service integration|25-30" ;;
            esac
            ;;
        3)
            case "$week" in
                5) echo "Networking|Network Configuration|network interfaces and DNS|Network setup and routing|30-35" ;;
                6) echo "Networking|Security and Monitoring|firewalls and network security|Network troubleshooting and monitoring|30-35" ;;
            esac
            ;;
        4)
            case "$week" in
                7) echo "Storage|Storage Management|LVM and filesystems|Storage systems and backup|35-40" ;;
                8) echo "Storage|Performance Optimization|system monitoring and tuning|Performance analysis and optimization|35-40" ;;
            esac
            ;;
        5)
            case "$week" in
                9) echo "Advanced|Automation|scripting and configuration management|Infrastructure as code|40-45" ;;
                10) echo "Advanced|Integration|final projects and integration|Complete infrastructure deployment|40-45" ;;
            esac
            ;;
        *)
            echo "Unknown|Unknown|unknown topic|unknown objectives|20-25"
            ;;
    esac
}

# Fill template with actual values
fill_template() {
    local template_file="$1"
    local level="$2"
    local week="$3"
    local custom_message="$4"
    
    if [ ! -f "$template_file" ]; then
        log_error "Template file not found: $template_file"
        return 1
    fi
    
    local level_info=$(get_level_info "$level" "$week")
    local topic=$(echo "$level_info" | cut -d'|' -f1)
    local focus=$(echo "$level_info" | cut -d'|' -f2)
    local skills=$(echo "$level_info" | cut -d'|' -f3)
    local objectives=$(echo "$level_info" | cut -d'|' -f4)
    local hours=$(echo "$level_info" | cut -d'|' -f5)
    
    # Read template and substitute variables
    local content=$(cat "$template_file")
    
    # Substitute template variables
    content=${content//\{LEVEL\}/$level}
    content=${content//\{WEEK\}/$week}
    content=${content//\{TOPIC\}/$topic}
    content=${content//\{FOCUS\}/$focus}
    content=${content//\{SKILLS\}/$skills}
    content=${content//\{OBJECTIVES\}/$objectives}
    content=${content//\{HOURS\}/$hours}
    content=${content//\{DAYS\}/7}
    content=${content//\{RELEASE_DATE\}/$(date '+%Y-%m-%d')}
    content=${content//\{DUE_DATE\}/$(date -d '+7 days' '+%Y-%m-%d')}
    content=${content//\{OFFICE_HOURS\}/"Tuesdays and Thursdays 2-4 PM"}
    content=${content//\{REVIEW_DATE\}/$(date -d '+10 days' '+%Y-%m-%d')}
    content=${content//\{TIMESTAMP\}/$(date '+%Y-%m-%d %H:%M:%S')}
    content=${content//\{SUBJECT\}/$custom_message}
    content=${content//\{STATUS_MESSAGE\}/$custom_message}
    content=${content//\{ACTION_ITEMS\}/$custom_message}
    content=${content//\{EMERGENCY_MESSAGE\}/$custom_message}
    content=${content//\{EMERGENCY_ACTIONS\}/$custom_message}
    content=${content//\{EMERGENCY_TIMELINE\}/"Immediate action required"}
    
    echo "$content"
}

# Send notification via GitHub Issues
send_github_issue() {
    local title="$1"
    local body="$2"
    local urgency="$3"
    
    local labels=""
    case "$urgency" in
        "emergency") labels="--label emergency --label announcement" ;;
        "high") labels="--label important --label announcement" ;;
        "normal") labels="--label announcement" ;;
    esac
    
    if command -v gh >/dev/null 2>&1; then
        if gh issue create --title "$title" --body "$body" $labels 2>/dev/null; then
            log_success "✅ GitHub Issue created"
            return 0
        else
            log_warning "⚠️  GitHub Issue creation failed (may not be authenticated)"
            return 1
        fi
    else
        log_warning "⚠️  GitHub CLI not available"
        return 1
    fi
}

# Send notification via GitHub Discussions
send_github_discussion() {
    local title="$1"
    local body="$2"
    local urgency="$3"
    
    if command -v gh >/dev/null 2>&1; then
        # Try to create discussion (requires repo access)
        if gh api repos/:owner/:repo/discussions --method POST \
           --field title="$title" \
           --field body="$body" \
           --field category_id="announcements" 2>/dev/null; then
            log_success "✅ GitHub Discussion created"
            return 0
        else
            log_warning "⚠️  GitHub Discussion creation failed"
            return 1
        fi
    else
        log_warning "⚠️  GitHub CLI not available"
        return 1
    fi
}

# Send notification to file (for integration with other tools)
send_file_notification() {
    local title="$1"
    local body="$2"
    local urgency="$3"
    
    local notifications_dir="$PROJECT_ROOT/.notifications"
    mkdir -p "$notifications_dir"
    
    local timestamp=$(date '+%Y%m%d-%H%M%S')
    local filename="$notifications_dir/${urgency}-${timestamp}.md"
    
    cat > "$filename" << EOF
---
title: $title
urgency: $urgency
timestamp: $(date '+%Y-%m-%d %H:%M:%S')
---

$body
EOF
    
    log_success "✅ File notification created: $filename"
    return 0
}

# Log notification
log_notification() {
    local title="$1"
    local urgency="$2"
    local channels="$3"
    
    echo "$(date '+%Y-%m-%d %H:%M:%S') | $urgency | $channels | $title" >> "$NOTIFICATION_LOG"
}

# Send notification through specified channels
send_notification() {
    local title="$1"
    local body="$2"
    local urgency="${3:-normal}"
    local channels="${4:-all}"
    local dry_run="$5"
    
    if [ "$dry_run" = "true" ]; then
        log_info "[DRY RUN] Would send notification:"
        echo "Title: $title"
        echo "Urgency: $urgency"
        echo "Channels: $channels"
        echo "Body preview:"
        echo "$body" | head -10
        echo "..."
        return 0
    fi
    
    log_header "Sending notification: $title"
    
    local success_count=0
    local total_channels=0
    
    case "$channels" in
        "github"|"all")
            ((total_channels++))
            if send_github_issue "$title" "$body" "$urgency"; then
                ((success_count++))
            fi
            
            ((total_channels++))
            if send_github_discussion "$title" "$body" "$urgency"; then
                ((success_count++))
            fi
            ;;&
        "file"|"all")
            ((total_channels++))
            if send_file_notification "$title" "$body" "$urgency"; then
                ((success_count++))
            fi
            ;;
    esac
    
    # Log the notification
    log_notification "$title" "$urgency" "$channels"
    
    if [ $success_count -gt 0 ]; then
        log_success "✅ Notification sent successfully ($success_count/$total_channels channels)"
    else
        log_error "❌ Failed to send notification through any channel"
        return 1
    fi
}

# Announce new release
announce_release() {
    local level="$1"
    local week="$2"
    local dry_run="$3"
    
    if [ -z "$level" ] || [ -z "$week" ]; then
        log_error "Level and week are required for release announcement"
        return 1
    fi
    
    log_header "Preparing release announcement for Level $level Week $week"
    
    # Ensure templates exist
    create_templates
    
    # Generate announcement content
    local template_file="$PROJECT_ROOT/.notification-templates/release.md"
    local content=$(fill_template "$template_file" "$level" "$week" "")
    
    local level_info=$(get_level_info "$level" "$week")
    local topic=$(echo "$level_info" | cut -d'|' -f2)
    local title="🎉 Level $level Week $week Released: $topic"
    
    send_notification "$title" "$content" "high" "all" "$dry_run"
}

# Send reminder
send_reminder() {
    local message="$1"
    local dry_run="$2"
    
    if [ -z "$message" ]; then
        message="Don't forget to check for new tasks and sync your fork!"
    fi
    
    log_header "Sending reminder to students"
    
    # Ensure templates exist
    create_templates
    
    # Generate reminder content
    local template_file="$PROJECT_ROOT/.notification-templates/reminder.md"
    local content=$(fill_template "$template_file" "" "" "$message")
    
    local title="📢 Reminder: $message"
    
    send_notification "$title" "$content" "normal" "all" "$dry_run"
}

# Send emergency notification
send_emergency() {
    local message="$1"
    local dry_run="$2"
    
    if [ -z "$message" ]; then
        log_error "Emergency message is required"
        return 1
    fi
    
    log_header "Sending emergency notification"
    
    # Ensure templates exist
    create_templates
    
    # Generate emergency content
    local template_file="$PROJECT_ROOT/.notification-templates/emergency.md"
    local content=$(fill_template "$template_file" "" "" "$message")
    
    local title="🚨 URGENT: $message"
    
    send_notification "$title" "$content" "emergency" "all" "$dry_run"
}

# Check adoption rate for a release
check_adoption() {
    local level="$1"
    local week="$2"
    
    if [ -z "$level" ] || [ -z "$week" ]; then
        log_error "Level and week are required for adoption check"
        return 1
    fi
    
    log_header "Checking adoption rate for Level $level Week $week"
    
    # Get release date from log
    local release_pattern="Level $level Week $week\|level-$level.*week-$week"
    local release_date=$(grep "$release_pattern" "$NOTIFICATION_LOG" 2>/dev/null | head -1 | cut -d'|' -f1 || echo "")
    
    if [ -z "$release_date" ]; then
        release_date=$(date -d '1 week ago' '+%Y-%m-%d')
        log_warning "Release date not found in log, using 1 week ago: $release_date"
    fi
    
    # Count students and check sync status
    local total_students=0
    local synced_students=0
    
    if [ -d "$PROJECT_ROOT/submissions" ]; then
        for student_dir in "$PROJECT_ROOT/submissions"/*; do
            if [ -d "$student_dir" ] && [[ "$(basename "$student_dir")" != "example-student" ]]; then
                ((total_students++))
                
                # Check if student has activity after release date
                if find "$student_dir" -newermt "$release_date" -type f | grep -q .; then
                    ((synced_students++))
                fi
            fi
        done
    fi
    
    if [ $total_students -eq 0 ]; then
        log_warning "No students found in submissions directory"
        return 1
    fi
    
    local adoption_rate=$((synced_students * 100 / total_students))
    
    echo ""
    echo "📊 Adoption Report for Level $level Week $week"
    echo "=============================================="
    echo "Release date: $release_date"
    echo "Students who synced: $synced_students / $total_students"
    echo "Adoption rate: $adoption_rate%"
    echo ""
    
    # Provide recommendations
    if [ $adoption_rate -ge 80 ]; then
        echo "✅ Excellent adoption rate! Students are keeping up well."
    elif [ $adoption_rate -ge 60 ]; then
        echo "⚠️  Good adoption rate, but consider sending a reminder."
        echo "Suggestion: ./scripts/notify-students.sh reminder --message 'Level $level Week $week tasks are available'"
    elif [ $adoption_rate -ge 40 ]; then
        echo "🔔 Low adoption rate. Consider:"
        echo "  1. Sending a reminder"
        echo "  2. Checking if students are encountering sync issues"
        echo "  3. Providing additional office hours"
    else
        echo "🚨 Very low adoption rate. Immediate action needed:"
        echo "  1. Send urgent reminder"
        echo "  2. Check for technical issues"
        echo "  3. Consider extending deadline"
    fi
    
    # Show students who haven't synced
    echo ""
    echo "Students who may need reminders:"
    for student_dir in "$PROJECT_ROOT/submissions"/*; do
        if [ -d "$student_dir" ] && [[ "$(basename "$student_dir")" != "example-student" ]]; then
            if ! find "$student_dir" -newermt "$release_date" -type f | grep -q .; then
                echo "  - $(basename "$student_dir")"
            fi
        fi
    done
}

# Main function
main() {
    case "${1:-help}" in
        "release")
            local level=""
            local week=""
            local dry_run=false
            
            # Parse options
            shift
            while [[ $# -gt 0 ]]; do
                case $1 in
                    --level) level="$2"; shift ;;
                    --week) week="$2"; shift ;;
                    --dry-run) dry_run=true ;;
                    *) log_warning "Unknown option: $1" ;;
                esac
                shift
            done
            
            announce_release "$level" "$week" "$dry_run"
            ;;
        "reminder")
            local message=""
            local dry_run=false
            
            # Parse options
            shift
            while [[ $# -gt 0 ]]; do
                case $1 in
                    --message) message="$2"; shift ;;
                    --dry-run) dry_run=true ;;
                    *) log_warning "Unknown option: $1" ;;
                esac
                shift
            done
            
            send_reminder "$message" "$dry_run"
            ;;
        "emergency")
            local message=""
            local dry_run=false
            
            # Parse options
            shift
            while [[ $# -gt 0 ]]; do
                case $1 in
                    --message) message="$2"; shift ;;
                    --dry-run) dry_run=true ;;
                    *) log_warning "Unknown option: $1" ;;
                esac
                shift
            done
            
            send_emergency "$message" "$dry_run"
            ;;
        "adoption")
            local level=""
            local week=""
            
            # Parse options
            shift
            while [[ $# -gt 0 ]]; do
                case $1 in
                    --level) level="$2"; shift ;;
                    --week) week="$2"; shift ;;
                    *) log_warning "Unknown option: $1" ;;
                esac
                shift
            done
            
            check_adoption "$level" "$week"
            ;;
        "schedule")
            log_info "Scheduled notifications feature coming soon"
            log_info "For now, use cron jobs to schedule regular notifications"
            ;;
        "help"|"--help"|"-h")
            show_help
            ;;
        *)
            log_error "Unknown command: $1"
            echo ""
            show_help
            exit 1
            ;;
    esac
}

# Run main function
main "$@"