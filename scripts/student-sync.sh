#!/bin/bash

# Student Sync Helper Script
# Automates the process of syncing student forks with upstream changes
# while preserving student work and handling common issues

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

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
log_header() { echo -e "${PURPLE}[SYNC]${NC} $1"; }

# Help function
show_help() {
    cat << EOF
Student Sync Helper Script

This script helps students synchronize their forked repositories with upstream changes
while preserving their work and handling common Git issues automatically.

Usage: $0 [command] [options]

Commands:
  setup           Set up upstream remote and student branch (first time only)
  sync            Sync with upstream changes (daily use)
  check           Check for new releases without syncing
  status          Show current sync status and branch information
  recover         Recover from sync issues (emergency use)
  
Options:
  --username      Your GitHub username (for setup)
  --upstream      Upstream repository URL (for setup)
  --force         Force sync even if there are uncommitted changes
  --dry-run       Show what would be done without actually doing it
  --help          Show this help message

Examples:
  $0 setup --username john-doe --upstream https://github.com/teacher/repo.git
  $0 sync                           # Daily sync with upstream
  $0 check                          # Check for new releases
  $0 status                         # Show current status
  $0 recover                        # Emergency recovery

For detailed instructions, see docs/STUDENT_WORKFLOW_GUIDE.md
EOF
}

# Check if we're in a git repository
check_git_repo() {
    if ! git rev-parse --git-dir >/dev/null 2>&1; then
        log_error "Not in a Git repository. Please run this script from your project directory."
        exit 1
    fi
}

# Get student username from branch or prompt
get_username() {
    local username="$1"
    
    if [ -z "$username" ]; then
        # Try to extract from current branch
        local current_branch=$(git branch --show-current)
        if [[ "$current_branch" =~ ^student-(.+)$ ]]; then
            username="${BASH_REMATCH[1]}"
            log_info "Detected username from branch: $username"
        else
            echo -n "Enter your GitHub username: "
            read -r username
        fi
    fi
    
    echo "$username"
}

# Check if upstream remote exists
check_upstream() {
    if ! git remote | grep -q "^upstream$"; then
        log_error "Upstream remote not configured."
        log_info "Run '$0 setup' first to configure upstream remote."
        return 1
    fi
    return 0
}

# Setup upstream remote and student branch
setup_student_repo() {
    local username="$1"
    local upstream_url="$2"
    
    log_header "Setting up student repository"
    
    username=$(get_username "$username")
    
    if [ -z "$upstream_url" ]; then
        echo -n "Enter upstream repository URL: "
        read -r upstream_url
    fi
    
    # Add upstream remote if it doesn't exist
    if ! git remote | grep -q "^upstream$"; then
        log_info "Adding upstream remote: $upstream_url"
        git remote add upstream "$upstream_url"
    else
        log_info "Upstream remote already exists"
        git remote set-url upstream "$upstream_url"
    fi
    
    # Verify upstream is reachable
    log_info "Verifying upstream connection..."
    if ! git ls-remote upstream >/dev/null 2>&1; then
        log_error "Cannot connect to upstream repository. Please check the URL."
        exit 1
    fi
    
    # Fetch from upstream
    log_info "Fetching from upstream..."
    git fetch upstream
    
    # Create student branch if it doesn't exist
    local student_branch="student-$username"
    if ! git branch -a | grep -q "$student_branch"; then
        log_info "Creating student branch: $student_branch"
        git checkout -b "$student_branch"
        
        # Initial sync with upstream
        git pull upstream main
        
        # Push student branch to origin
        git push -u origin "$student_branch"
    else
        log_info "Student branch already exists: $student_branch"
        git checkout "$student_branch"
    fi
    
    # Create submissions directory if it doesn't exist
    local submissions_dir="submissions/$username"
    if [ ! -d "$submissions_dir" ]; then
        log_info "Creating submissions directory: $submissions_dir"
        mkdir -p "$submissions_dir"/{level-1,level-2,level-3,level-4,level-5}
        
        # Create README for student
        cat > "$submissions_dir/README.md" << EOF
# Submissions by $username

This directory contains my learning journey through the Ubuntu System Administration course.

## Contact Information
- GitHub: @$username
- Start Date: $(date '+%Y-%m-%d')

## Progress Tracking
- [ ] Level 1: Foundation (Weeks 1-2)
- [ ] Level 2: Services (Weeks 3-4)
- [ ] Level 3: Networking (Weeks 5-6)
- [ ] Level 4: Storage (Weeks 7-8)
- [ ] Level 5: Advanced (Weeks 9-10)

## Sync Status
Last synced: $(date '+%Y-%m-%d %H:%M:%S')
EOF
        
        git add "$submissions_dir/"
        git commit -m "Initial setup: Create student submission directory for $username"
        git push origin "$student_branch"
    fi
    
    log_success "Student repository setup complete!"
    log_info "Student branch: $student_branch"
    log_info "Submissions directory: $submissions_dir"
    log_info "You can now run '$0 sync' daily to get new releases"
}

# Check for new releases
check_releases() {
    local dry_run="$1"
    
    log_header "Checking for new releases..."
    
    check_upstream || exit 1
    
    # Fetch latest from upstream
    git fetch upstream
    
    # Check for new commits in levels/ directory
    local new_releases=$(git log --oneline HEAD..upstream/main -- levels/ 2>/dev/null | wc -l)
    
    if [ "$new_releases" -gt 0 ]; then
        log_success "🎉 $new_releases new release(s) available!"
        echo ""
        echo "Recent releases:"
        git log --oneline --since="2 weeks ago" upstream/main -- levels/ 2>/dev/null || echo "  No recent release history found"
        echo ""
        if [ "$dry_run" != "true" ]; then
            log_info "Run '$0 sync' to get the new releases"
        fi
        return 0
    else
        log_info "✅ You're up to date with all released tasks"
        return 1
    fi
}

# Show current status
show_status() {
    log_header "Current Repository Status"
    
    # Basic git info
    local current_branch=$(git branch --show-current)
    local repo_name=$(basename "$(git rev-parse --show-toplevel)")
    
    echo "Repository: $repo_name"
    echo "Current branch: $current_branch"
    echo ""
    
    # Remote information
    echo "Configured remotes:"
    git remote -v | while read -r remote url direction; do
        echo "  $remote: $url ($direction)"
    done
    echo ""
    
    # Check if upstream is configured
    if check_upstream >/dev/null 2>&1; then
        echo "✅ Upstream remote configured"
        
        # Check if we can reach upstream
        if git ls-remote upstream >/dev/null 2>&1; then
            echo "✅ Upstream accessible"
        else
            echo "❌ Cannot reach upstream remote"
        fi
        
        # Check for new releases
        if check_releases true >/dev/null 2>&1; then
            echo "🎉 New releases available"
        else
            echo "✅ Up to date with releases"
        fi
    else
        echo "❌ Upstream remote not configured"
        log_info "Run '$0 setup' to configure upstream"
    fi
    
    # Working directory status
    echo ""
    echo "Working directory status:"
    if git diff-index --quiet HEAD -- 2>/dev/null; then
        echo "✅ No uncommitted changes"
    else
        echo "⚠️  Uncommitted changes detected:"
        git status --porcelain | head -5
        if [ $(git status --porcelain | wc -l) -gt 5 ]; then
            echo "  ... and $(($(git status --porcelain | wc -l) - 5)) more files"
        fi
    fi
    
    # Recent commits
    echo ""
    echo "Recent commits on this branch:"
    git log --oneline -5 | while read -r line; do
        echo "  $line"
    done
}

# Sync with upstream
sync_with_upstream() {
    local force="$1"
    local dry_run="$2"
    
    log_header "Syncing with upstream repository"
    
    check_upstream || exit 1
    
    # Ensure we're on student branch
    local current_branch=$(git branch --show-current)
    if [[ ! "$current_branch" =~ ^student- ]]; then
        log_warning "Not on a student branch (current: $current_branch)"
        
        # Try to find student branch
        local student_branches=($(git branch | grep "student-" | tr -d ' *'))
        if [ ${#student_branches[@]} -eq 1 ]; then
            log_info "Switching to student branch: ${student_branches[0]}"
            git checkout "${student_branches[0]}"
        else
            log_error "Cannot determine student branch. Please checkout your student branch manually."
            exit 1
        fi
    fi
    
    # Check for uncommitted changes
    if ! git diff-index --quiet HEAD -- 2>/dev/null; then
        if [ "$force" = "true" ]; then
            log_warning "Uncommitted changes detected, but --force specified"
            log_info "Stashing changes before sync..."
            git stash push -m "Auto-stash before sync $(date)"
            local stashed=true
        else
            log_error "You have uncommitted changes. Please commit them first or use --force"
            log_info "Files with changes:"
            git status --porcelain
            log_info "To commit: git add . && git commit -m 'Your commit message'"
            log_info "To force sync: $0 sync --force"
            exit 1
        fi
    fi
    
    if [ "$dry_run" = "true" ]; then
        log_info "[DRY RUN] Would fetch from upstream and merge changes"
        check_releases true
        return 0
    fi
    
    # Fetch latest from upstream
    log_info "Fetching latest changes from upstream..."
    git fetch upstream
    
    # Check if there are actually new changes
    if ! check_releases true >/dev/null 2>&1; then
        log_info "Already up to date with upstream"
        return 0
    fi
    
    # Attempt to merge upstream changes
    log_info "Merging upstream changes..."
    if git merge upstream/main --no-edit; then
        log_success "✅ Successfully merged upstream changes"
        
        # Push updated branch to origin
        log_info "Pushing updates to your fork..."
        git push origin "$current_branch"
        
        # Restore stashed changes if any
        if [ "$stashed" = "true" ]; then
            log_info "Restoring your uncommitted changes..."
            if git stash pop; then
                log_success "✅ Restored your changes successfully"
            else
                log_warning "⚠️  Could not restore changes automatically. Check 'git stash list'"
            fi
        fi
        
        # Update sync status in student README
        local username=$(echo "$current_branch" | sed 's/student-//')
        if [ -f "submissions/$username/README.md" ]; then
            sed -i.bak "s/Last synced:.*/Last synced: $(date '+%Y-%m-%d %H:%M:%S')/" "submissions/$username/README.md"
            rm -f "submissions/$username/README.md.bak" 2>/dev/null || true
        fi
        
        log_success "🎉 Sync completed successfully!"
        log_info "Check the levels/ directory for new tasks"
        
    else
        log_error "❌ Merge conflicts detected!"
        log_info "Don't panic! Here's how to resolve them:"
        echo ""
        echo "1. Check which files have conflicts:"
        echo "   git status"
        echo ""
        echo "2. For each conflicted file, choose the right version:"
        echo "   - For task files (levels/*): usually keep the upstream version"
        echo "   - For your work (submissions/$username/*): keep your version"
        echo ""
        echo "3. After resolving conflicts:"
        echo "   git add <resolved-files>"
        echo "   git commit -m 'Merge upstream changes'"
        echo "   git push origin $current_branch"
        echo ""
        log_info "For detailed help, see docs/STUDENT_WORKFLOW_GUIDE.md"
        exit 1
    fi
}

# Emergency recovery
emergency_recovery() {
    log_header "Emergency Recovery Mode"
    
    log_warning "This will help you recover from sync issues"
    echo ""
    
    # Show current situation
    echo "Current status:"
    git status
    echo ""
    
    # Backup current work
    local username=$(git branch --show-current | sed 's/student-//')
    if [ -d "submissions/$username" ]; then
        local backup_dir="$HOME/sysadmin-backup-$(date +%Y%m%d-%H%M%S)"
        log_info "Creating backup of your work at: $backup_dir"
        cp -r "submissions/$username" "$backup_dir"
        echo "Backup created at: $backup_dir"
    fi
    
    # Offer recovery options
    echo ""
    echo "Recovery options:"
    echo "1. Reset to clean state (loses uncommitted changes)"
    echo "2. Abort current merge"
    echo "3. Start fresh clone"
    echo "4. Cancel (let me fix manually)"
    echo ""
    echo -n "Choose option [1-4]: "
    read -r choice
    
    case "$choice" in
        1)
            log_info "Resetting to clean state..."
            git reset --hard HEAD
            git clean -fd
            log_success "Repository reset to clean state"
            ;;
        2)
            if git merge --abort 2>/dev/null; then
                log_success "Merge aborted successfully"
            else
                log_info "No merge to abort"
            fi
            ;;
        3)
            echo ""
            log_warning "Fresh clone will require manual setup"
            echo "After cloning:"
            echo "1. Copy your backup to the new clone"
            echo "2. Run setup again"
            echo "3. Commit your restored work"
            ;;
        4)
            log_info "Manual recovery selected"
            echo "Useful commands:"
            echo "  git status              - see current state"
            echo "  git stash              - save changes temporarily"
            echo "  git merge --abort      - cancel merge"
            echo "  git reset --hard HEAD  - reset to last commit"
            ;;
        *)
            log_info "Invalid option selected"
            ;;
    esac
}

# Main function
main() {
    check_git_repo
    
    case "${1:-help}" in
        "setup")
            setup_student_repo "$2" "$3"
            ;;
        "sync")
            local force=false
            local dry_run=false
            
            # Parse options
            while [[ $# -gt 1 ]]; do
                case $2 in
                    --force) force=true ;;
                    --dry-run) dry_run=true ;;
                    *) log_warning "Unknown option: $2" ;;
                esac
                shift
            done
            
            sync_with_upstream "$force" "$dry_run"
            ;;
        "check")
            check_releases false
            ;;
        "status")
            show_status
            ;;
        "recover")
            emergency_recovery
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