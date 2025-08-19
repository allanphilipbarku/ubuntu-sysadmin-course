# Student Workflow Guide - Managing Your Fork

A comprehensive guide for students to synchronize their forked repositories with upstream changes while preserving their work.

## 📋 Table of Contents

- [Overview](#overview)
- [Initial Setup](#initial-setup)
- [Daily Workflow](#daily-workflow)
- [Pulling Upstream Changes](#pulling-upstream-changes)
- [Handling Conflicts](#handling-conflicts)
- [Troubleshooting](#troubleshooting)
- [Best Practices](#best-practices)

## 🎯 Overview

As a student in this collaborative learning environment, you'll need to:

- **Fork** the main repository to your GitHub account
- **Clone** your fork to work locally
- **Stay synchronized** with new task releases from teachers
- **Preserve your work** while pulling upstream changes
- **Submit** your solutions via Pull Requests

### Repository Structure
```
Main Repo (upstream) ← Teacher releases new tasks
     ↓ (you sync)
Your Fork (origin) ← Your personal copy on GitHub
     ↓ (you clone)
Local Copy ← Where you do your work
```

## 🚀 Initial Setup

### Step 1: Fork the Repository

1. **Go to the main repository** on GitHub
2. **Click "Fork"** in the top-right corner
3. **Select your account** as the destination
4. **Wait for the fork** to be created

### Step 2: Clone Your Fork

```bash
# Clone your fork (replace YOUR-USERNAME)
git clone https://github.com/YOUR-USERNAME/ubuntu-sysadmin-project.git
cd ubuntu-sysadmin-project
```

### Step 3: Add Upstream Remote

This is **crucial** - it allows you to pull new tasks from the teacher's repository:

```bash
# Add the original repository as 'upstream'
git remote add upstream https://github.com/TEACHER-ORG/ubuntu-sysadmin-project.git

# Verify your remotes
git remote -v
# Should show:
# origin    https://github.com/YOUR-USERNAME/ubuntu-sysadmin-project.git (fetch)
# origin    https://github.com/YOUR-USERNAME/ubuntu-sysadmin-project.git (push)
# upstream  https://github.com/TEACHER-ORG/ubuntu-sysadmin-project.git (fetch)
# upstream  https://github.com/TEACHER-ORG/ubuntu-sysadmin-project.git (push)
```

### Step 4: Create Your Student Branch

```bash
# Create and switch to your personal branch
git checkout -b student-YOUR-USERNAME

# Push your branch to your fork
git push -u origin student-YOUR-USERNAME
```

### Step 5: Set Up Your Submissions Directory

```bash
# Create your submission directories
mkdir -p submissions/YOUR-USERNAME/{level-1,level-2,level-3,level-4,level-5}

# Add a README to identify your work
cat > submissions/YOUR-USERNAME/README.md << EOF
# Submissions by YOUR-USERNAME

This directory contains my learning journey through the Ubuntu System Administration course.

## Contact Information
- GitHub: @YOUR-USERNAME
- Email: your-email@example.com
- Cohort: Fall 2024

## Progress Tracking
- [ ] Level 1: Foundation (Weeks 1-2)
- [ ] Level 2: Services (Weeks 3-4)
- [ ] Level 3: Networking (Weeks 5-6)
- [ ] Level 4: Storage (Weeks 7-8)
- [ ] Level 5: Advanced (Weeks 9-10)
EOF

# Commit your initial setup
git add submissions/YOUR-USERNAME/
git commit -m "Initial setup: Create student submission directory"
git push origin student-YOUR-USERNAME
```

## 📅 Daily Workflow

### Morning Routine (5 minutes)

```bash
# 1. Switch to your student branch
git checkout student-YOUR-USERNAME

# 2. Check for new releases from teachers
git fetch upstream

# 3. See what's new (optional)
git log --oneline upstream/main ^HEAD

# 4. Pull new changes if available
git pull upstream main

# 5. Push updates to your fork
git push origin student-YOUR-USERNAME
```

### Working on Tasks

```bash
# 1. Ensure you're on your branch
git checkout student-YOUR-USERNAME

# 2. Work on your tasks in submissions/YOUR-USERNAME/
# Edit files, create scripts, document your learning

# 3. Commit your work frequently
git add submissions/YOUR-USERNAME/level-1/week-1/
git commit -m "Level 1 Week 1: Complete file system exploration

- Added system inventory script
- Documented directory relationships
- Created configuration analysis"

# 4. Push your work to your fork
git push origin student-YOUR-USERNAME
```

## 🔄 Pulling Upstream Changes

### When Teachers Release New Tasks

You'll receive notifications when new tasks are available. Here's how to get them:

#### Method 1: Simple Pull (Recommended for Beginners)

```bash
# Ensure you're on your branch
git checkout student-YOUR-USERNAME

# Fetch the latest from upstream
git fetch upstream

# Pull changes from upstream main into your branch
git pull upstream main

# Push the updated branch to your fork
git push origin student-YOUR-USERNAME
```

#### Method 2: Rebase (For Advanced Users)

```bash
# Fetch the latest changes
git fetch upstream

# Rebase your work on top of upstream changes
git rebase upstream/main

# Force push (only to your own branch!)
git push --force-with-lease origin student-YOUR-USERNAME
```

### Checking for New Releases

```bash
# Script to check for new task releases
#!/bin/bash
# save as check-updates.sh

echo "Checking for new task releases..."

# Fetch latest from upstream
git fetch upstream

# Check for new commits in levels/ directory
NEW_RELEASES=$(git log --oneline --since="1 week ago" upstream/main -- levels/ | wc -l)

if [ "$NEW_RELEASES" -gt 0 ]; then
    echo "🎉 New task releases available!"
    echo "Recent releases:"
    git log --oneline --since="1 week ago" upstream/main -- levels/
    echo ""
    echo "Run 'git pull upstream main' to get the new tasks"
else
    echo "✅ You're up to date with all released tasks"
fi
```

## 🚨 Handling Conflicts

### Understanding Conflicts

Conflicts happen when:
- You've modified a file that was also updated upstream
- Git can't automatically merge the changes
- **Most common**: When README.md or shared files are edited

### Resolving Conflicts Step by Step

#### When you see conflict markers:

```bash
# After pulling, you might see:
# Auto-merging levels/level-1-foundation/week-1/README.md
# CONFLICT (content): Merge conflict in levels/level-1-foundation/week-1/README.md
# Automatic merge failed; fix conflicts and then commit the result.
```

#### Step 1: Identify Conflicted Files
```bash
# See which files have conflicts
git status

# Should show files under "Unmerged paths"
```

#### Step 2: Open and Resolve Conflicts
```bash
# Open the conflicted file in your editor
nano levels/level-1-foundation/week-1/README.md

# You'll see conflict markers like:
<<<<<<< HEAD
# Your version of the content
=======
# Upstream version of the content
>>>>>>> upstream/main
```

#### Step 3: Choose the Resolution
For **task files** (like README.md in levels/), usually keep the upstream version:
```markdown
# Keep the upstream version (teacher's latest content)
# Delete your changes if they conflict with task instructions
```

For **your submission files**, keep your work:
```markdown
# Keep your work in submissions/YOUR-USERNAME/
# These should never conflict since they're your personal files
```

#### Step 4: Complete the Merge
```bash
# After editing the file to resolve conflicts:
git add levels/level-1-foundation/week-1/README.md

# Commit the merge
git commit -m "Merge upstream changes: Level 1 Week 1 task updates"

# Push to your fork
git push origin student-YOUR-USERNAME
```

### Avoiding Conflicts

#### Golden Rules:
1. **Never edit files in `levels/`** - these contain task instructions
2. **Only work in `submissions/YOUR-USERNAME/`** - this is your space
3. **Pull upstream changes before starting new work**
4. **Commit your work frequently** to avoid losing progress

#### Safe Workflow:
```bash
# Before starting work each day:
git fetch upstream
git pull upstream main

# Work only in your directory:
cd submissions/YOUR-USERNAME/
# Do your work here

# Commit and push regularly:
git add submissions/YOUR-USERNAME/
git commit -m "Descriptive message about your work"
git push origin student-YOUR-USERNAME
```

## 🔧 Troubleshooting

### Common Issues and Solutions

#### Issue: "fatal: refusing to merge unrelated histories"

**Solution:**
```bash
git pull upstream main --allow-unrelated-histories
```

#### Issue: "error: Your local changes would be overwritten by merge"

**Solution:**
```bash
# If the changes are in your submission directory, stash them:
git stash push -m "Saving my work" submissions/YOUR-USERNAME/

# Pull the updates
git pull upstream main

# Restore your work
git stash pop
```

#### Issue: "error: failed to push some refs"

**Solution:**
```bash
# If your fork is behind, fetch and merge first:
git fetch origin
git merge origin/student-YOUR-USERNAME

# Then try pushing again:
git push origin student-YOUR-USERNAME
```

#### Issue: Accidentally worked in the wrong directory

**Solution:**
```bash
# If you accidentally edited files in levels/, reset them:
git checkout upstream/main -- levels/

# Then move your work to the right place:
mkdir -p submissions/YOUR-USERNAME/level-X/week-Y/
# Copy your work to the submissions directory
# Then commit it properly
```

### Emergency Recovery

#### If you're completely stuck:

1. **Backup your work:**
   ```bash
   cp -r submissions/YOUR-USERNAME ~/backup-my-work-$(date +%Y%m%d)
   ```

2. **Start fresh:**
   ```bash
   cd ..
   git clone https://github.com/YOUR-USERNAME/ubuntu-sysadmin-project.git fresh-clone
   cd fresh-clone
   git remote add upstream https://github.com/TEACHER-ORG/ubuntu-sysadmin-project.git
   git fetch upstream
   git checkout -b student-YOUR-USERNAME
   git pull upstream main
   ```

3. **Restore your work:**
   ```bash
   cp -r ~/backup-my-work-*/YOUR-USERNAME submissions/
   git add submissions/YOUR-USERNAME/
   git commit -m "Restore my work after fresh clone"
   git push -u origin student-YOUR-USERNAME
   ```

## 🏆 Best Practices

### Daily Habits

1. **Start each session with a sync:**
   ```bash
   git checkout student-YOUR-USERNAME
   git pull upstream main
   git push origin student-YOUR-USERNAME
   ```

2. **Commit work frequently:**
   - Commit after completing each task
   - Use descriptive commit messages
   - Push to your fork regularly

3. **Keep your workspace clean:**
   - Only work in `submissions/YOUR-USERNAME/`
   - Don't modify task instructions in `levels/`
   - Use `.gitignore` for temporary files

### Communication

1. **Stay informed:**
   - Watch the repository for notifications
   - Check GitHub Discussions regularly
   - Subscribe to release announcements

2. **Ask for help:**
   - Use GitHub Issues for technical problems
   - Use Discussions for learning questions
   - Tag instructors when needed

### Collaboration

1. **Participate in peer reviews:**
   - Review other students' Pull Requests
   - Provide constructive feedback
   - Learn from different approaches

2. **Share knowledge:**
   - Contribute to Discussions
   - Help newer students with Git issues
   - Document useful tricks you discover

## 📚 Quick Reference Commands

### Setup Commands
```bash
# Initial setup (run once)
git remote add upstream https://github.com/TEACHER-ORG/ubuntu-sysadmin-project.git
git checkout -b student-YOUR-USERNAME
git push -u origin student-YOUR-USERNAME
```

### Daily Sync Commands
```bash
# Get new task releases (run daily)
git checkout student-YOUR-USERNAME
git fetch upstream
git pull upstream main
git push origin student-YOUR-USERNAME
```

### Work Commands
```bash
# Working on tasks (run as needed)
cd submissions/YOUR-USERNAME/
# Do your work...
git add .
git commit -m "Level X Week Y: Completed [task description]"
git push origin student-YOUR-USERNAME
```

### Emergency Commands
```bash
# If things go wrong
git status                    # See what's happening
git stash                    # Save current work temporarily
git reset --hard HEAD       # Reset to last commit (loses changes!)
git clean -fd               # Remove untracked files (be careful!)
```

### Information Commands
```bash
git remote -v               # Check your remotes
git branch -a               # See all branches
git log --oneline -10       # See recent commits
git status                  # Check working directory status
```

---

**Need Help?** 🆘
- **Technical Issues**: Create a GitHub Issue
- **Learning Questions**: Post in GitHub Discussions
- **Git Problems**: Ask in the #git-help discussion category
- **Emergency**: Contact your instructor directly

**Remember**: Everyone struggles with Git at first. Don't hesitate to ask for help! 🤝