#!/bin/bash

# Repository Setup Script
# Initializes the Ubuntu System Administration Learning Project
# for immediate use by teachers and students

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
log_header() { echo -e "${PURPLE}[SETUP]${NC} $1"; }

# Help function
show_help() {
    cat << EOF
Ubuntu System Administration Learning Project - Repository Setup

This script initializes the repository for immediate use by teachers and students.

Usage: $0 [options]

Options:
  --quick           Quick setup with defaults
  --interactive     Interactive setup with prompts
  --teacher-only    Setup for teacher use only (no student examples)
  --demo           Setup with demo data for testing
  --help           Show this help message

Examples:
  $0 --quick                    # Quick setup with defaults
  $0 --interactive             # Interactive setup
  $0 --demo                    # Setup with demo data for testing

EOF
}

# Check prerequisites
check_prerequisites() {
    log_header "Checking Prerequisites"
    
    local missing_tools=()
    
    # Check for required commands
    if ! command -v git >/dev/null 2>&1; then
        missing_tools+=("git")
    fi
    
    if ! command -v bash >/dev/null 2>&1; then
        missing_tools+=("bash")
    fi
    
    # Check if we're in a git repository
    if ! git rev-parse --git-dir >/dev/null 2>&1; then
        log_warning "Not in a git repository. Initializing git repository..."
        git init
        log_success "Git repository initialized"
    fi
    
    if [ ${#missing_tools[@]} -ne 0 ]; then
        log_error "Missing required tools: ${missing_tools[*]}"
        log_error "Please install the missing tools and try again"
        exit 1
    fi
    
    log_success "All prerequisites satisfied"
}

# Interactive configuration
interactive_setup() {
    log_header "Interactive Setup Configuration"
    
    # Course information
    echo -n "Course Name [Ubuntu System Administration]: "
    read -r COURSE_NAME
    COURSE_NAME=${COURSE_NAME:-"Ubuntu System Administration"}
    
    echo -n "Semester/Term [Fall 2024]: "
    read -r SEMESTER
    SEMESTER=${SEMESTER:-"Fall 2024"}
    
    echo -n "Instructor Name: "
    read -r INSTRUCTOR_NAME
    
    echo -n "Instructor Email: "
    read -r INSTRUCTOR_EMAIL
    
    echo -n "GitHub Organization/Username: "
    read -r GITHUB_ORG
    
    echo -n "Release Schedule (weekly/biweekly) [weekly]: "
    read -r RELEASE_SCHEDULE
    RELEASE_SCHEDULE=${RELEASE_SCHEDULE:-"weekly"}
    
    # Create configuration
    create_configuration "$COURSE_NAME" "$SEMESTER" "$INSTRUCTOR_NAME" "$INSTRUCTOR_EMAIL" "$GITHUB_ORG" "$RELEASE_SCHEDULE"
}

# Quick setup with defaults
quick_setup() {
    log_header "Quick Setup with Defaults"
    
    create_configuration \
        "Ubuntu System Administration" \
        "Academic Year 2024" \
        "System Administrator" \
        "admin@institution.edu" \
        "your-organization" \
        "weekly"
}

# Create configuration files
create_configuration() {
    local course_name="$1"
    local semester="$2"
    local instructor_name="$3"
    local instructor_email="$4"
    local github_org="$5"
    local release_schedule="$6"
    
    log_info "Creating configuration files..."
    
    # Create .env file
    cat > "$PROJECT_ROOT/.env" << EOF
# Ubuntu System Administration Learning Project Configuration
COURSE_NAME="$course_name"
SEMESTER="$semester"
INSTRUCTOR_NAME="$instructor_name"
INSTRUCTOR_EMAIL="$instructor_email"
GITHUB_ORGANIZATION="$github_org"
RELEASE_SCHEDULE="$release_schedule"
SETUP_DATE="$(date '+%Y-%m-%d')"
VERSION="1.0"
EOF
    
    # Create course-specific README section
    local readme_header="$PROJECT_ROOT/.course-header.md"
    cat > "$readme_header" << EOF
# $course_name - $semester

**Instructor:** $instructor_name  
**Email:** $instructor_email  
**Organization:** $github_org  

---

EOF
    
    log_success "Configuration files created"
}

# Initialize directory structure
initialize_structure() {
    log_header "Initializing Directory Structure"
    
    # Ensure all required directories exist
    local directories=(
        "levels"
        "submissions" 
        "scripts"
        "resources/references"
        "resources/tools"
        "resources/templates"
        "docs"
        ".github"
    )
    
    for dir in "${directories[@]}"; do
        if [ ! -d "$PROJECT_ROOT/$dir" ]; then
            mkdir -p "$PROJECT_ROOT/$dir"
            log_info "Created directory: $dir"
        fi
    done
    
    # Create .gitignore if it doesn't exist
    if [ ! -f "$PROJECT_ROOT/.gitignore" ]; then
        cat > "$PROJECT_ROOT/.gitignore" << EOF
# Environment files
.env
.env.local

# Progress tracking (contains sensitive student data)
.progress/students/
.progress/cache/

# Temporary files
*.tmp
*.bak
*~
.DS_Store

# Log files
*.log
.release-log-backup-*

# IDE files
.vscode/
.idea/
*.swp
*.swo

# System files
Thumbs.db
*.pid

# Personal notes (teachers can keep private notes)
notes/
personal/
EOF
        log_success "Created .gitignore file"
    fi
    
    log_success "Directory structure initialized"
}

# Setup scripts and make them executable
setup_scripts() {
    log_header "Setting Up Scripts"
    
    # Make all scripts executable
    find "$PROJECT_ROOT/scripts" -name "*.sh" -type f -exec chmod +x {} \;
    log_success "Scripts made executable"
    
    # Create useful aliases script
    cat > "$PROJECT_ROOT/scripts/aliases.sh" << 'EOF'
#!/bin/bash
# Useful aliases for managing the learning platform

# Course management aliases
alias release-week='./scripts/release-tasks-enhanced.sh'
alias check-progress='./scripts/track-progress.sh update && ./scripts/track-progress.sh stats'
alias dashboard='./scripts/track-progress.sh dashboard'
alias class-report='./scripts/track-progress.sh report'

# Quick commands
alias release-status='./scripts/release-tasks.sh --status'
alias list-tasks='./scripts/release-tasks.sh --list'
alias quick-stats='./scripts/track-progress.sh stats'

# Development helpers
alias extract-content='./scripts/extract-content.sh'
alias init-progress='./scripts/track-progress.sh init'

echo "Ubuntu SysAdmin course management aliases loaded!"
echo "Use 'release-week 1 1' to release Level 1, Week 1"
echo "Use 'check-progress' for quick progress update"
echo "Use 'dashboard' to generate HTML dashboard"
EOF
    
    chmod +x "$PROJECT_ROOT/scripts/aliases.sh"
    log_success "Created utility aliases script"
}

# Initialize progress tracking
initialize_progress_tracking() {
    log_header "Initializing Progress Tracking System"
    
    # Run the progress tracking initialization
    if [ -x "$PROJECT_ROOT/scripts/track-progress.sh" ]; then
        "$PROJECT_ROOT/scripts/track-progress.sh" init
        log_success "Progress tracking system initialized"
    else
        log_warning "Progress tracking script not found or not executable"
    fi
}

# Extract curriculum content
setup_curriculum() {
    log_header "Setting Up Curriculum Content"
    
    # Run content extraction if the script exists
    if [ -x "$PROJECT_ROOT/scripts/extract-content.sh" ]; then
        "$PROJECT_ROOT/scripts/extract-content.sh"
        log_success "Curriculum content extracted and structured"
    else
        log_warning "Content extraction script not found"
    fi
}

# Create demo data for testing
create_demo_data() {
    log_header "Creating Demo Data"
    
    # Create sample students
    local demo_students=("alice-student" "bob-learner" "charlie-dev")
    
    for student in "${demo_students[@]}"; do
        # Create student directory structure
        mkdir -p "$PROJECT_ROOT/submissions/$student"/{level-1,level-2,level-3,level-4,level-5}
        
        # Create some sample content
        cat > "$PROJECT_ROOT/submissions/$student/level-1/README.md" << EOF
# Level 1 Submissions - $student

This is a demo submission showing the expected structure.

## Completed Tasks
- [x] Task 1.1: File system exploration
- [x] Task 1.2: Configuration analysis
- [ ] Task 1.3: Log monitoring (in progress)

## Learning Notes
This student is making good progress and documenting their learning effectively.
EOF
        
        # Create sample scripts
        mkdir -p "$PROJECT_ROOT/submissions/$student/level-1/scripts"
        cat > "$PROJECT_ROOT/submissions/$student/level-1/scripts/system-info.sh" << 'EOF'
#!/bin/bash
# Demo system information script

echo "=== System Information ==="
echo "Hostname: $(hostname)"
echo "OS: $(lsb_release -d | cut -f2)"
echo "Kernel: $(uname -r)"
echo "Uptime: $(uptime -p)"
EOF
        chmod +x "$PROJECT_ROOT/submissions/$student/level-1/scripts/system-info.sh"
        
        log_info "Created demo data for $student"
    done
    
    # Update progress tracking with demo data
    if [ -x "$PROJECT_ROOT/scripts/track-progress.sh" ]; then
        "$PROJECT_ROOT/scripts/track-progress.sh" update
    fi
    
    log_success "Demo data created successfully"
}

# Create welcome message and next steps
create_welcome_message() {
    log_header "Finalizing Setup"
    
    local setup_complete_file="$PROJECT_ROOT/SETUP_COMPLETE.md"
    
    cat > "$setup_complete_file" << EOF
# 🎉 Setup Complete!

Your Ubuntu System Administration Learning Project is ready to use!

## What's Been Set Up

✅ **Directory structure** created with all necessary folders  
✅ **Scripts** made executable and ready to use  
✅ **Progress tracking system** initialized  
✅ **Curriculum content** extracted and structured  
✅ **Configuration files** created  
✅ **Git repository** initialized and configured  

## Next Steps for Teachers

### 1. Review the Documentation
- Read [Teacher Guide](docs/TEACHER_GUIDE.md) for comprehensive instructions
- Review [Contributing Guidelines](docs/CONTRIBUTING.md) for community standards

### 2. Customize Your Course
\`\`\`bash
# Edit configuration
nano .env

# Customize course content
nano curriculum-content/level-1/foundation-content.md
\`\`\`

### 3. Release Your First Tasks
\`\`\`bash
# Release Level 1, Week 1
./scripts/release-tasks-enhanced.sh 1 1

# Check what was released
ls -la levels/level-1-foundation/week-1/
\`\`\`

### 4. Monitor Progress
\`\`\`bash
# Update student progress
./scripts/track-progress.sh update

# View class statistics
./scripts/track-progress.sh stats

# Generate dashboard
./scripts/track-progress.sh dashboard
\`\`\`

### 5. Set Up GitHub Features
- Enable **GitHub Discussions** for Q&A and community building
- Configure **Issues** for bug reports and feature requests
- Set up **GitHub Pages** to host the progress dashboard
- Create **branch protection rules** for the main branch

## Next Steps for Students

### 1. Fork and Clone
\`\`\`bash
# Fork the repository on GitHub, then clone your fork
git clone https://github.com/YOUR-USERNAME/ubuntu-sysadmin-project.git
cd ubuntu-sysadmin-project
\`\`\`

### 2. Create Your Student Branch
\`\`\`bash
git checkout -b student-YOUR-USERNAME
\`\`\`

### 3. Create Your Submissions Directory
\`\`\`bash
mkdir -p submissions/YOUR-USERNAME/{level-1,level-2,level-3,level-4,level-5}
\`\`\`

### 4. Start Learning!
- Check `levels/` directory for released tasks
- Read the main [README.md](README.md) for overview
- Join GitHub Discussions to connect with peers

## Quick Commands Reference

\`\`\`bash
# Load helpful aliases
source scripts/aliases.sh

# Release tasks (teachers)
release-week 1 1

# Check progress
check-progress

# Generate dashboard
dashboard

# View available tasks
list-tasks
\`\`\`

## Getting Help

- **Documentation**: Check the `docs/` folder
- **Issues**: Report problems using GitHub Issues
- **Discussions**: Ask questions in GitHub Discussions
- **Community**: Connect with other students and teachers

## Success! 🚀

Your collaborative learning platform is ready to transform system administration education!

---
*Setup completed on $(date) using setup-repository.sh*
EOF

    log_success "Setup complete! Check SETUP_COMPLETE.md for next steps."
}

# Validate setup
validate_setup() {
    log_header "Validating Setup"
    
    local validation_errors=()
    
    # Check critical files
    local required_files=(
        "README.md"
        "scripts/release-tasks-enhanced.sh"
        "scripts/track-progress.sh"
        "docs/TEACHER_GUIDE.md"
        "docs/CONTRIBUTING.md"
    )
    
    for file in "${required_files[@]}"; do
        if [ ! -f "$PROJECT_ROOT/$file" ]; then
            validation_errors+=("Missing file: $file")
        fi
    done
    
    # Check script permissions
    if [ -f "$PROJECT_ROOT/scripts/release-tasks-enhanced.sh" ] && [ ! -x "$PROJECT_ROOT/scripts/release-tasks-enhanced.sh" ]; then
        validation_errors+=("Script not executable: scripts/release-tasks-enhanced.sh")
    fi
    
    # Check directory structure
    local required_dirs=("levels" "submissions" "scripts" "docs")
    for dir in "${required_dirs[@]}"; do
        if [ ! -d "$PROJECT_ROOT/$dir" ]; then
            validation_errors+=("Missing directory: $dir")
        fi
    done
    
    # Report validation results
    if [ ${#validation_errors[@]} -eq 0 ]; then
        log_success "Setup validation passed! ✅"
        return 0
    else
        log_error "Setup validation failed with ${#validation_errors[@]} errors:"
        for error in "${validation_errors[@]}"; do
            log_error "  - $error"
        done
        return 1
    fi
}

# Main setup function
main() {
    log_header "Ubuntu System Administration Learning Project Setup"
    echo "============================================================"
    echo ""
    
    case "${1:-interactive}" in
        "--quick")
            check_prerequisites
            quick_setup
            initialize_structure
            setup_scripts
            initialize_progress_tracking
            setup_curriculum
            create_welcome_message
            ;;
        "--interactive")
            check_prerequisites
            interactive_setup
            initialize_structure
            setup_scripts
            initialize_progress_tracking
            setup_curriculum
            create_welcome_message
            ;;
        "--teacher-only")
            check_prerequisites
            quick_setup
            initialize_structure
            setup_scripts
            initialize_progress_tracking
            setup_curriculum
            create_welcome_message
            ;;
        "--demo")
            check_prerequisites
            quick_setup
            initialize_structure
            setup_scripts
            initialize_progress_tracking
            setup_curriculum
            create_demo_data
            create_welcome_message
            ;;
        "--help"|"-h")
            show_help
            exit 0
            ;;
        *)
            log_error "Unknown option: $1"
            show_help
            exit 1
            ;;
    esac
    
    echo ""
    log_header "Validating Setup"
    if validate_setup; then
        echo ""
        log_success "🎉 Setup completed successfully!"
        log_info "📖 Check SETUP_COMPLETE.md for next steps"
        log_info "📚 Review docs/TEACHER_GUIDE.md for detailed instructions"
        log_info "🚀 You're ready to start your collaborative learning journey!"
    else
        echo ""
        log_error "❌ Setup completed with validation errors"
        log_info "📋 Please review the errors above and fix them before proceeding"
        exit 1
    fi
}

# Run main function if script is executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi