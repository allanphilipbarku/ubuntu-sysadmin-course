# Git Workflow Summary - Complete Reference Guide

A comprehensive visual and textual guide to managing Git workflows in the Ubuntu System Administration collaborative learning platform.

## 📋 Quick Navigation

- [Overview](#overview)
- [Visual Workflow Diagrams](#visual-workflow-diagrams)
- [Student Quick Reference](#student-quick-reference)
- [Teacher Quick Reference](#teacher-quick-reference)
- [Common Scenarios](#common-scenarios)
- [Troubleshooting Guide](#troubleshooting-guide)
- [Scripts and Tools](#scripts-and-tools)

## 🎯 Overview

This collaborative learning platform uses a **fork-based GitHub workflow** where:

- **Teachers** maintain the main repository with task releases
- **Students** fork the repository and work in personal branches
- **Synchronization** happens through upstream pulls and origin pushes
- **Collaboration** occurs through Pull Requests and peer reviews

### Repository Structure
```
Main Repository (Teacher's)
├── levels/                    # Task releases (teachers manage)
├── submissions/               # Student work directories
├── scripts/                   # Automation tools
├── docs/                     # Documentation
└── curriculum-content/        # Source content (teachers edit)

Student Fork
├── levels/                    # Synced from upstream (read-only for students)  
├── submissions/YOUR-USERNAME/ # Your work area (you own this)
├── scripts/                   # Automation tools (synced from upstream)
└── docs/                     # Documentation (synced from upstream)
```

## 🔄 Visual Workflow Diagrams

### Student Fork and Sync Workflow

```
┌─────────────────────────────────────────────────────────────────┐
│                    STUDENT WORKFLOW                             │
└─────────────────────────────────────────────────────────────────┘

   Main Repo                    Your Fork                   Local Copy
  (upstream)                    (origin)                   (your machine)
       │                           │                            │
       │ 1. Fork repo              │                            │
       ├──────────────────────────▶│                            │
       │                           │ 2. Clone fork              │
       │                           ├───────────────────────────▶│
       │                           │                            │
       │ 3. Teacher releases       │                            │
       │    new tasks              │                            │ 4. Student syncs
       │                           │  ┌─────────────────────────│    with upstream
       │◄──────────────────────────┼──┘                         │
       │                           │                            │
       │                           │ 5. Student pushes         │
       │                           │    work to fork            │
       │                           │◄───────────────────────────┤
       │                           │                            │
       │ 6. Student creates        │                            │
       │    Pull Request           │                            │
       │◄──────────────────────────┤                            │
       │                           │                            │
```

### Daily Sync Process

```
┌─────────────────────────────────────────────────────────────────┐
│                   DAILY SYNC PROCESS                            │
└─────────────────────────────────────────────────────────────────┘

Student's Daily Routine:

┌──────────────┐    ┌──────────────┐    ┌──────────────┐
│ 1. Check for │───▶│ 2. Pull from │───▶│ 3. Push to   │
│ new releases │    │   upstream   │    │   your fork  │
│              │    │              │    │              │
│ git fetch    │    │ git pull     │    │ git push     │
│ upstream     │    │ upstream main│    │ origin       │
└──────────────┘    └──────────────┘    └──────────────┘
        │                   │                   │
        ▼                   ▼                   ▼
┌──────────────┐    ┌──────────────┐    ┌──────────────┐
│OR use script:│    │OR use script:│    │Script handles│
│              │    │              │    │this auto-    │
│ ./scripts/   │    │ ./scripts/   │    │matically     │
│ student-sync.│    │ student-sync.│    │              │
│ sh check     │    │ sh sync      │    │              │
└──────────────┘    └──────────────┘    └──────────────┘
```

### Teacher Release Workflow

```
┌─────────────────────────────────────────────────────────────────┐
│                  TEACHER RELEASE WORKFLOW                       │
└─────────────────────────────────────────────────────────────────┘

┌──────────────┐    ┌──────────────┐    ┌──────────────┐
│ 1. Content   │───▶│ 2. Release   │───▶│ 3. Notify    │
│   Ready      │    │   Tasks      │    │   Students   │
│              │    │              │    │              │
│ Review       │    │ ./scripts/   │    │ ./scripts/   │
│ curriculum   │    │ release-     │    │ notify-      │
│ content      │    │ tasks.sh     │    │ students.sh  │
└──────────────┘    └──────────────┘    └──────────────┘
        │                   │                   │
        ▼                   ▼                   ▼
┌──────────────┐    ┌──────────────┐    ┌──────────────┐
│ 4. Monitor   │    │ 5. Support   │    │ 6. Next     │
│   Adoption   │    │   Students   │    │   Release    │
│              │    │              │    │              │
│ ./scripts/   │    │ Review PRs,  │    │ Plan next    │
│ notify-      │    │ answer       │    │ week's       │
│ students.sh  │    │ questions    │    │ content      │
│ adoption     │    │              │    │              │
└──────────────┘    └──────────────┘    └──────────────┘
```

## 👨‍🎓 Student Quick Reference

### First Time Setup

```bash
# 1. Fork repository on GitHub (click Fork button)

# 2. Clone your fork
git clone https://github.com/YOUR-USERNAME/ubuntu-sysadmin-project.git
cd ubuntu-sysadmin-project

# 3. Use the setup script (RECOMMENDED)
./scripts/student-sync.sh setup --username YOUR-USERNAME --upstream https://github.com/TEACHER-ORG/ubuntu-sysadmin-project.git

# OR do manual setup:
git remote add upstream https://github.com/TEACHER-ORG/ubuntu-sysadmin-project.git
git checkout -b student-YOUR-USERNAME
git push -u origin student-YOUR-USERNAME
mkdir -p submissions/YOUR-USERNAME/{level-1,level-2,level-3,level-4,level-5}
```

### Daily Commands

```bash
# Quick sync (RECOMMENDED)
./scripts/student-sync.sh sync

# Check for new releases
./scripts/student-sync.sh check

# Check your status
./scripts/student-sync.sh status

# Manual sync (alternative)
git checkout student-YOUR-USERNAME
git fetch upstream
git pull upstream main
git push origin student-YOUR-USERNAME
```

### Working on Tasks

```bash
# 1. Make sure you're synced
./scripts/student-sync.sh sync

# 2. Work in your submissions directory
cd submissions/YOUR-USERNAME/level-1/week-1/

# 3. Create your solutions (files, scripts, documentation)
nano README.md
nano system-analysis.md
mkdir scripts && nano scripts/inventory.sh

# 4. Commit your work frequently
git add submissions/YOUR-USERNAME/level-1/
git commit -m "Level 1 Week 1: Complete system inventory

- Added comprehensive system analysis
- Created inventory automation script  
- Documented findings and methodology"

# 5. Push to your fork
git push origin student-YOUR-USERNAME

# 6. Create Pull Request when ready for review
# (Use GitHub web interface)
```

### Emergency Recovery

```bash
# If you're stuck or have conflicts
./scripts/student-sync.sh recover

# If script isn't working, manual recovery:
git stash                    # Save your work
git reset --hard HEAD       # Reset to clean state
git pull upstream main       # Get latest changes
git stash pop               # Restore your work
```

## 👨‍🏫 Teacher Quick Reference

### Release New Tasks

```bash
# Release specific level and week
./scripts/release-tasks-enhanced.sh 2 3

# Check what can be released
./scripts/release-tasks.sh --list

# Check current release status  
./scripts/release-tasks.sh --status

# Preview release (dry run)
./scripts/release-tasks-enhanced.sh 2 3 --dry-run
```

### Communicate with Students

```bash
# Announce new release
./scripts/notify-students.sh release --level 2 --week 3

# Send reminder
./scripts/notify-students.sh reminder --message "Don't forget Level 1 tasks due Friday"

# Emergency notification
./scripts/notify-students.sh emergency --message "Server maintenance tonight 8-10 PM"

# Check adoption rates
./scripts/notify-students.sh adoption --level 2 --week 3
```

### Monitor Progress

```bash
# Update progress tracking
./scripts/track-progress.sh update

# View class statistics
./scripts/track-progress.sh stats

# Generate HTML dashboard
./scripts/track-progress.sh dashboard

# Individual student report
./scripts/track-progress.sh report student-username
```

### Weekly Teacher Routine

```bash
# Monday morning routine
./scripts/track-progress.sh stats                  # Check weekend progress
./scripts/release-tasks-enhanced.sh 2 4           # Release new week
./scripts/notify-students.sh release --level 2 --week 4  # Notify students

# Mid-week check
./scripts/notify-students.sh adoption --level 2 --week 4  # Check adoption

# Friday review
./scripts/track-progress.sh update                # Update all progress
./scripts/track-progress.sh dashboard             # Generate weekly dashboard
```

## 🔄 Common Scenarios

### Scenario 1: Student Gets New Tasks

**What Happens:**
1. Teacher releases Level 2 Week 3 tasks
2. Student runs sync command
3. New files appear in `levels/level-2-services/week-3/`
4. Student works in `submissions/USERNAME/level-2/`

**Student Commands:**
```bash
# Check for new releases
./scripts/student-sync.sh check
# Output: 🎉 1 new release(s) available!

# Sync the new tasks
./scripts/student-sync.sh sync
# Output: ✅ Successfully merged upstream changes

# Check what's new
ls levels/level-2-services/week-3/
# Output: README.md  tasks.md  scenarios.md  assessment.md
```

### Scenario 2: Student Has Merge Conflict

**What Happens:**
1. Student accidentally edited a file in `levels/`
2. Teacher releases update to same file
3. Merge conflict occurs during sync

**Resolution:**
```bash
# Sync fails with conflict message
./scripts/student-sync.sh sync
# Output: ❌ Merge conflicts detected!

# Check which files have conflicts
git status
# Output: Unmerged paths: levels/level-1-foundation/week-1/README.md

# Edit the conflicted file
nano levels/level-1-foundation/week-1/README.md

# Look for conflict markers:
# <<<<<<< HEAD
# Your changes
# =======
# Upstream changes  
# >>>>>>> upstream/main

# Keep the upstream version (teacher's content)
# Remove conflict markers and your changes

# Complete the merge
git add levels/level-1-foundation/week-1/README.md
git commit -m "Merge upstream changes: Keep teacher's task updates"
git push origin student-YOUR-USERNAME
```

### Scenario 3: Teacher Needs to Rollback Release

**What Happens:**
1. Teacher releases tasks with errors
2. Students start syncing broken content
3. Teacher needs to fix and re-release

**Teacher Actions:**
```bash
# Immediately notify students to stop
./scripts/notify-students.sh emergency --message "HOLD: Do not sync Level 2 Week 3 - fixing issues"

# Identify problematic commit
git log --oneline -5

# Revert the release
git revert [commit-hash]

# Fix the content
nano curriculum-content/level-2/services-content.md

# Re-release with fixes
./scripts/extract-content.sh
./scripts/release-tasks-enhanced.sh 2 3

# Notify all clear
./scripts/notify-students.sh release --level 2 --week 3
```

### Scenario 4: Student Needs to Catch Up

**What Happens:**
1. Student has been away for a week
2. Multiple releases have happened
3. Student needs to sync multiple updates

**Student Actions:**
```bash
# Check current status
./scripts/student-sync.sh status
# Shows what releases are available

# Sync all updates at once
./scripts/student-sync.sh sync
# Gets all accumulated changes

# Check what's new
find levels/ -name "README.md" -newer $(date -d '1 week ago' '+%Y-%m-%d') -ls
# Shows all recently released tasks
```

## 🔧 Troubleshooting Guide

### Common Student Issues

#### "I can't see new tasks"
**Diagnosis:**
```bash
./scripts/student-sync.sh status
git remote -v  # Check if upstream is configured
```

**Solutions:**
```bash
# If upstream not configured
./scripts/student-sync.sh setup

# If upstream configured but not synced
./scripts/student-sync.sh sync

# If still problems
./scripts/student-sync.sh recover
```

#### "I have merge conflicts"
**Quick Fix:**
```bash
# For files in levels/ (task files)
git checkout upstream/main -- levels/

# For files in your submissions/
# Edit manually to keep your work

# Complete the merge
git add .
git commit -m "Resolve merge conflicts"
```

#### "I worked in the wrong directory"
**Recovery:**
```bash
# Copy your work to correct location
cp -r levels/level-1-foundation/week-1/my-work submissions/YOUR-USERNAME/level-1/

# Reset the levels directory
git checkout upstream/main -- levels/

# Commit your work in correct location
git add submissions/YOUR-USERNAME/
git commit -m "Move work to correct directory"
```

### Common Teacher Issues

#### "Students can't sync new releases"
**Check:**
```bash
git log --oneline -5        # Verify release was committed
git status                  # Check for uncommitted changes
git push origin main        # Ensure changes are pushed
```

#### "Release has errors"
**Emergency Fix:**
```bash
./scripts/notify-students.sh emergency --message "Hold on syncing - fixing release"
git revert [commit-hash]    # Revert problematic release
# Fix issues, then re-release
```

### Debug Commands

#### Student Debug
```bash
./scripts/student-sync.sh status    # Complete status check
git remote -v                       # Check remotes
git branch -a                       # Check branches
git log --oneline -10               # Recent commits
git status                          # Working directory status
```

#### Teacher Debug
```bash
./scripts/release-tasks.sh --status    # Release status
./scripts/track-progress.sh stats      # Student progress
git log --oneline --since="1 week ago" -- levels/  # Recent releases
find levels/ -name "*.md" -ls          # Verify release files exist
```

## 🛠️ Scripts and Tools

### Student Tools

| Script | Purpose | Usage |
|--------|---------|-------|
| `student-sync.sh` | Complete sync automation | `./scripts/student-sync.sh sync` |
| `student-sync.sh setup` | First-time repository setup | `./scripts/student-sync.sh setup --username john-doe` |
| `student-sync.sh check` | Check for new releases | `./scripts/student-sync.sh check` |
| `student-sync.sh status` | Show sync status | `./scripts/student-sync.sh status` |
| `student-sync.sh recover` | Emergency recovery | `./scripts/student-sync.sh recover` |

### Teacher Tools

| Script | Purpose | Usage |
|--------|---------|-------|
| `release-tasks-enhanced.sh` | Release new tasks | `./scripts/release-tasks-enhanced.sh 2 3` |
| `notify-students.sh` | Send notifications | `./scripts/notify-students.sh release --level 2 --week 3` |
| `track-progress.sh` | Monitor student progress | `./scripts/track-progress.sh stats` |
| `extract-content.sh` | Update curriculum content | `./scripts/extract-content.sh` |

### Administrative Tools

| Script | Purpose | Usage |
|--------|---------|-------|
| `setup-repository.sh` | Initialize entire platform | `./scripts/setup-repository.sh --demo` |
| `aliases.sh` | Load helpful aliases | `source scripts/aliases.sh` |

## 📚 Quick Reference Cards

### Student Cheat Sheet
```bash
# Daily commands
./scripts/student-sync.sh sync          # Get new tasks
cd submissions/YOUR-USERNAME/            # Work here
git add . && git commit -m "message"    # Save work
git push origin student-YOUR-USERNAME   # Upload work

# When stuck
./scripts/student-sync.sh status        # Check status
./scripts/student-sync.sh recover       # Emergency help
```

### Teacher Cheat Sheet
```bash
# Weekly routine
./scripts/release-tasks-enhanced.sh L W  # Release level L week W
./scripts/notify-students.sh release --level L --week W  # Notify
./scripts/track-progress.sh stats       # Check progress
./scripts/notify-students.sh adoption --level L --week W  # Check adoption
```

## 🎯 Best Practices Summary

### For Students
- ✅ Always sync before starting work: `./scripts/student-sync.sh sync`
- ✅ Work only in `submissions/YOUR-USERNAME/`
- ✅ Commit frequently with descriptive messages
- ✅ Never edit files in `levels/` directory
- ✅ Use the automation scripts when possible
- ✅ Ask for help early if you're stuck

### For Teachers
- ✅ Release tasks on consistent schedule (e.g., Monday mornings)
- ✅ Always test releases with `--dry-run` first
- ✅ Send notifications after each release
- ✅ Monitor adoption rates and follow up
- ✅ Keep backups of important content
- ✅ Communicate clearly about deadlines and expectations

## 🆘 Getting Help

### For Students
- **Quick Help**: `./scripts/student-sync.sh --help`
- **Detailed Guide**: [docs/STUDENT_WORKFLOW_GUIDE.md](STUDENT_WORKFLOW_GUIDE.md)
- **GitHub Issues**: Report technical problems
- **GitHub Discussions**: Ask learning questions

### For Teachers  
- **Quick Help**: `./scripts/notify-students.sh --help`
- **Detailed Guide**: [docs/TEACHER_RELEASE_WORKFLOW.md](TEACHER_RELEASE_WORKFLOW.md)
- **Setup Guide**: [docs/TEACHER_GUIDE.md](TEACHER_GUIDE.md)
- **Contributing**: [docs/CONTRIBUTING.md](CONTRIBUTING.md)

---

**Remember**: The goal is smooth collaboration and learning. When in doubt, use the automation scripts and don't hesitate to ask for help! 🚀📚