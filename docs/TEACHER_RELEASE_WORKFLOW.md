# Teacher Release Workflow Guide

A comprehensive guide for teachers to manage task releases and coordinate with student forks in the collaborative learning environment.

## 📋 Table of Contents

- [Overview](#overview)
- [Release Workflow](#release-workflow)
- [Coordination Strategies](#coordination-strategies)
- [Communication](#communication)
- [Monitoring Student Progress](#monitoring-student-progress)
- [Troubleshooting](#troubleshooting)
- [Best Practices](#best-practices)

## 🎯 Overview

As a teacher managing this collaborative platform, you'll need to:

- **Release tasks progressively** using automated scripts
- **Coordinate timing** to ensure students can sync effectively
- **Communicate releases** to students through multiple channels
- **Monitor adoption** of new releases by students
- **Support students** who encounter sync issues

### Release Flow
```
Curriculum Content → Release Scripts → Main Repository → Student Forks
                                    ↓
                            GitHub Notifications
                                    ↓
                            Student Pull/Sync Process
```

## 📅 Release Workflow

### Pre-Release Preparation

#### 1. Content Review
```bash
# Review content before releasing
./scripts/release-tasks-enhanced.sh 2 3 --dry-run

# Check what will be created
ls -la curriculum-content/level-2/services-content.md

# Verify scripts work
./scripts/release-tasks-enhanced.sh --list
```

#### 2. Timing Coordination
```bash
# Check current student progress before releasing
./scripts/track-progress.sh stats

# See who's ready for next level
./scripts/track-progress.sh report | grep -A 5 "Level [0-9] Progress"

# Identify students who might need more time
./scripts/identify-struggling-students.sh
```

#### 3. Communication Preparation
```markdown
# Prepare release announcement template
## 🎉 New Tasks Released: Level 2 Week 3

**What's New:**
- Service management fundamentals
- Process monitoring and control
- Practical troubleshooting scenarios

**Getting the Updates:**
Students should run:
```bash
git checkout student-YOUR-USERNAME
git pull upstream main
git push origin student-YOUR-USERNAME
```

**Need Help?** Check the [Student Workflow Guide](docs/STUDENT_WORKFLOW_GUIDE.md)
```

### Release Process

#### Step 1: Execute Release
```bash
# Release the tasks
./scripts/release-tasks-enhanced.sh 2 3

# Verify the release worked
ls -la levels/level-2-services/week-3/

# Check git status
git status
git add levels/level-2-services/week-3/
git commit -m "Release Level 2 Week 3: Service management fundamentals

- Added service management tasks
- Included troubleshooting scenarios  
- Created assessment criteria
- Updated progress tracking"

# Push to main repository
git push origin main
```

#### Step 2: Update Release Log
```bash
# Check release was logged
cat .release-log | tail -5

# Update tracking system
./scripts/track-progress.sh update

# Generate updated dashboard
./scripts/track-progress.sh dashboard
```

#### Step 3: Notify Students
```bash
# Create GitHub notification (if using GitHub CLI)
gh issue create \
  --title "📢 Level 2 Week 3 Tasks Released" \
  --body-file release-announcement.md \
  --label "announcement"

# Or create a Discussion post
gh api repos/:owner/:repo/discussions \
  --method POST \
  --field title="New Tasks Released: Level 2 Week 3" \
  --field body="$(cat release-announcement.md)" \
  --field category_id="announcements"
```

### Batch Release Strategy

#### Weekly Release Schedule
```bash
#!/bin/bash
# weekly-release.sh - Automate weekly releases

WEEK_NUMBER=$(date +%V)  # ISO week number
COURSE_START_WEEK=36     # Adjust for your semester

CURRENT_COURSE_WEEK=$((WEEK_NUMBER - COURSE_START_WEEK + 1))

echo "Week $CURRENT_COURSE_WEEK of course"

case $CURRENT_COURSE_WEEK in
    1) ./scripts/release-tasks-enhanced.sh 1 1 ;;
    2) ./scripts/release-tasks-enhanced.sh 1 2 ;;
    3) ./scripts/release-tasks-enhanced.sh 2 3 ;;
    4) ./scripts/release-tasks-enhanced.sh 2 4 ;;
    5) ./scripts/release-tasks-enhanced.sh 3 5 ;;
    6) ./scripts/release-tasks-enhanced.sh 3 6 ;;
    7) ./scripts/release-tasks-enhanced.sh 4 7 ;;
    8) ./scripts/release-tasks-enhanced.sh 4 8 ;;
    9) ./scripts/release-tasks-enhanced.sh 5 9 ;;
    10) ./scripts/release-tasks-enhanced.sh 5 10 ;;
    *) 
        if [ $CURRENT_COURSE_WEEK -lt 1 ]; then
            echo "Course hasn't started yet"
        else
            echo "Course complete!"
        fi
        ;;
esac

# After release, update progress and notify
if [ $CURRENT_COURSE_WEEK -ge 1 ] && [ $CURRENT_COURSE_WEEK -le 10 ]; then
    ./scripts/track-progress.sh update
    ./scripts/notify-students.sh "Week $CURRENT_COURSE_WEEK tasks released"
fi
```

#### Progressive Release Based on Class Performance
```bash
#!/bin/bash
# performance-based-release.sh

# Check class completion rate for current level
COMPLETION_RATE=$(./scripts/track-progress.sh stats | grep "Level [0-9]:" | tail -1 | grep -o "[0-9]\+%" | tr -d '%')

echo "Current level completion rate: $COMPLETION_RATE%"

# Only release next level if 70% of students have completed current level
if [ "$COMPLETION_RATE" -ge 70 ]; then
    echo "Class ready for next level release"
    # Logic to determine and release next level
    NEXT_LEVEL=$(./scripts/determine-next-level.sh)
    NEXT_WEEK=$(./scripts/determine-next-week.sh)
    
    ./scripts/release-tasks-enhanced.sh "$NEXT_LEVEL" "$NEXT_WEEK"
    ./scripts/notify-students.sh "Next level released - class achieved $COMPLETION_RATE% completion"
else
    echo "Waiting for more students to complete current level ($COMPLETION_RATE% < 70%)"
fi
```

## 🎯 Coordination Strategies

### Release Timing

#### Best Practices for Timing:
- **Monday mornings**: Give students the full week to work
- **After office hours**: Address questions from previous week first
- **Consistent schedule**: Students expect releases at the same time
- **Avoid late Friday**: Students may not see notifications over weekend

#### Sample Schedule:
```
Monday 9:00 AM:  Check student progress from previous week
Monday 10:00 AM: Release new tasks (if appropriate)
Monday 10:15 AM: Send notifications to students
Monday 11:00 AM: Post announcement in discussions
Tuesday-Thursday: Monitor adoption and provide support
Friday: Review progress and plan next week's release
```

### Managing Different Student Paces

#### Advanced Students Strategy:
```bash
# Create advanced challenges for fast learners
mkdir -p levels/level-1-foundation/week-1/advanced-challenges/

# Release bonus content
./scripts/release-bonus-content.sh 1 1

# Encourage peer mentoring
echo "Advanced students, please help review beginner PRs" | ./scripts/send-message.sh
```

#### Supporting Struggling Students:
```bash
# Identify students falling behind
./scripts/identify-at-risk-students.sh

# Provide additional resources
./scripts/create-remedial-content.sh level-1

# Schedule additional office hours
echo "Extra help session scheduled for Level 1 catch-up" | ./scripts/announce.sh
```

### Rollback Procedures

#### If a Release Has Issues:
```bash
# 1. Immediately notify students to stop pulling
echo "🚨 HOLD: Do not pull latest changes. Issue being resolved." | ./scripts/emergency-notify.sh

# 2. Identify the problematic commit
git log --oneline -5

# 3. Revert the release
git revert [commit-hash]

# 4. Fix the issues in curriculum content
nano curriculum-content/level-2/services-content.md

# 5. Re-release with fixes
./scripts/release-tasks-enhanced.sh 2 3

# 6. Notify students that it's safe to sync
echo "✅ Issue resolved. Safe to sync with: git pull upstream main" | ./scripts/notify-students.sh
```

#### Emergency Rollback Script:
```bash
#!/bin/bash
# emergency-rollback.sh

LEVEL="$1"
WEEK="$2"

if [ -z "$LEVEL" ] || [ -z "$WEEK" ]; then
    echo "Usage: $0 <level> <week>"
    exit 1
fi

echo "🚨 EMERGENCY ROLLBACK: Level $LEVEL Week $WEEK"

# Notify students immediately
echo "⚠️ STOP: Do not pull changes for Level $LEVEL Week $WEEK. Issue being fixed." | ./scripts/emergency-notify.sh

# Remove the problematic release
rm -rf "levels/level-$LEVEL-*/week-$WEEK"/*
echo "# Temporarily removed due to issues" > "levels/level-$LEVEL-*/week-$WEEK/README.md"

# Commit the rollback
git add "levels/level-$LEVEL-*/"
git commit -m "Emergency rollback: Level $LEVEL Week $WEEK

Issues identified that need fixing before re-release.
Students notified to hold on syncing."

git push origin main

echo "Rollback complete. Fix issues and re-release when ready."
```

## 📢 Communication

### Notification Channels

#### GitHub-Based Notifications:
1. **Issues**: For announcements (with announcement label)
2. **Discussions**: For interactive Q&A about releases
3. **Wiki**: For persistent information and FAQ updates
4. **README updates**: For course-wide information

#### Automated Notification Script:
```bash
#!/bin/bash
# notify-students.sh

MESSAGE="$1"
URGENCY="${2:-normal}"  # normal, high, emergency

case "$URGENCY" in
    "emergency")
        # Use all channels for emergency
        echo "🚨 URGENT: $MESSAGE" | gh issue create --title "URGENT: $MESSAGE" --label "emergency"
        echo "🚨 $MESSAGE" | gh api repos/:owner/:repo/discussions --method POST --field title="URGENT" --field body="$MESSAGE"
        # Could integrate with Slack/Discord/email here
        ;;
    "high")
        gh issue create --title "📢 $MESSAGE" --label "announcement"
        gh api repos/:owner/:repo/discussions --method POST --field title="Announcement" --field body="$MESSAGE"
        ;;
    "normal")
        gh api repos/:owner/:repo/discussions --method POST --field title="Update" --field body="$MESSAGE"
        ;;
esac

# Log notification
echo "$(date): $URGENCY - $MESSAGE" >> .notification-log
```

### Release Announcements Template

#### Comprehensive Release Announcement:
```markdown
# 🎉 Level [X] Week [Y] Released: [Topic Name]

## What's New
- **Focus**: [Brief description of the week's focus]
- **Skills**: [Key skills students will learn]
- **Duration**: Estimated [X] hours over [Y] days

## Learning Objectives
- [Objective 1]
- [Objective 2] 
- [Objective 3]

## Key Tasks
1. **[Task 1 Name]**: [Brief description]
2. **[Task 2 Name]**: [Brief description]
3. **[Task 3 Name]**: [Brief description]

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
ls levels/level-[X]-[topic]/week-[Y]/
```

### Step 3: Start Working
```bash
cd submissions/YOUR-USERNAME/level-[X]/
# Begin your work here
```

## 📅 Timeline
- **Released**: [Date]
- **Suggested completion**: [Date] 
- **Office hours**: [Day/Time] for questions
- **Peer review deadline**: [Date]

## 🆘 Need Help?
- **Git issues**: [Student Workflow Guide](docs/STUDENT_WORKFLOW_GUIDE.md)
- **Technical questions**: Post in [#level-[x]-help](discussions)
- **Office hours**: [Schedule/Link]

## 📊 Progress Check
After completing the tasks:
- [ ] Submit your work via Pull Request
- [ ] Participate in peer reviews
- [ ] Join the discussion to share insights
- [ ] Help newer students if needed

---
*Happy learning! 🚀*
```

### Follow-up Communications

#### Day 1 After Release:
```bash
# Check adoption rate
STUDENTS_SYNCED=$(git log --since="1 day ago" --grep="pull upstream" --oneline | wc -l)
TOTAL_STUDENTS=$(./scripts/track-progress.sh stats | grep "Total Students" | grep -o "[0-9]\+")

echo "$STUDENTS_SYNCED of $TOTAL_STUDENTS students have synced the new release"

if [ $STUDENTS_SYNCED -lt $((TOTAL_STUDENTS / 2)) ]; then
    echo "📢 Reminder: New Level [X] Week [Y] tasks are available! Don't forget to sync your fork." | ./scripts/notify-students.sh
fi
```

#### Week Progress Check:
```bash
# Mid-week progress reminder
echo "📊 Week [Y] Progress Check:
- How are the Level [X] tasks going?
- Share your experience in discussions
- Help classmates if you're ahead
- Ask questions if you're stuck

Office hours tomorrow at [time]!" | ./scripts/notify-students.sh
```

## 📈 Monitoring Student Progress

### Daily Monitoring Routine

#### Morning Check (10 minutes):
```bash
# Update progress tracking
./scripts/track-progress.sh update

# Check overnight activity
./scripts/recent-activity.sh --hours 12

# Identify students needing attention
./scripts/check-student-status.sh --alert-inactive 48

# Review new submissions
find submissions/ -name "*.md" -newermt "$(date -d '1 day ago' '+%Y-%m-%d')" -ls
```

### Progress Analytics

#### Release Adoption Tracking:
```bash
#!/bin/bash
# track-release-adoption.sh

LEVEL="$1"
WEEK="$2"
RELEASE_DATE="$3"

echo "=== Release Adoption Report ==="
echo "Level $LEVEL Week $WEEK (Released: $RELEASE_DATE)"
echo ""

# Count students who have synced since release
SYNCED_STUDENTS=$(find submissions/ -type d -name "level-$LEVEL" -newermt "$RELEASE_DATE" | wc -l)
TOTAL_STUDENTS=$(find submissions/ -maxdepth 1 -type d | wc -l)

echo "Students who synced: $SYNCED_STUDENTS / $TOTAL_STUDENTS"

# Show adoption rate over time
for days in 1 2 3 7; do
    CUTOFF=$(date -d "$days days ago" '+%Y-%m-%d')
    ACTIVE=$(find submissions/ -name "*level-$LEVEL*" -newermt "$CUTOFF" | wc -l)
    echo "Active in last $days days: $ACTIVE"
done

# Identify students who haven't synced yet
echo ""
echo "Students who may need reminders:"
find submissions/ -maxdepth 1 -type d ! -newermt "$RELEASE_DATE" | sed 's|submissions/||' | tail -n +2
```

#### Completion Rate Monitoring:
```bash
#!/bin/bash
# completion-rate-monitor.sh

echo "=== Completion Rate Analysis ==="

for level in {1..5}; do
    echo ""
    echo "Level $level Analysis:"
    
    # Count total submissions for this level
    SUBMISSIONS=$(find submissions/ -path "*/level-$level/*" -name "*.md" | wc -l)
    STUDENTS=$(find submissions/ -maxdepth 1 -type d | tail -n +2 | wc -l)
    
    if [ $STUDENTS -gt 0 ]; then
        AVG_SUBMISSIONS=$((SUBMISSIONS / STUDENTS))
        echo "  Average submissions per student: $AVG_SUBMISSIONS"
        
        # Estimate completion based on submission count
        if [ $AVG_SUBMISSIONS -ge 5 ]; then
            echo "  Status: ✅ High completion rate"
        elif [ $AVG_SUBMISSIONS -ge 3 ]; then
            echo "  Status: ⚠️  Moderate completion rate"
        else
            echo "  Status: ❌ Low completion rate - consider intervention"
        fi
    fi
done
```

## 🔧 Troubleshooting

### Common Student Issues

#### Issue: Students Can't Sync New Releases

**Diagnosis:**
```bash
# Check if release was properly pushed
git log --oneline -5

# Verify release files exist
ls -la levels/level-*/week-*/

# Check for merge conflicts in release
git status
```

**Solutions:**
```bash
# If release wasn't pushed:
git push origin main

# If students have conflicts:
echo "For students with merge conflicts:
1. git stash (save your work)
2. git pull upstream main
3. git stash pop (restore your work)
4. Resolve conflicts manually" | ./scripts/notify-students.sh
```

#### Issue: Students Working in Wrong Directories

**Prevention:**
```bash
# Add validation to release announcements
echo "⚠️  IMPORTANT: Only work in submissions/YOUR-USERNAME/
Never edit files in levels/ directory!" | ./scripts/notify-students.sh --urgency high
```

**Recovery:**
```bash
# Script to help students recover from wrong directory work
echo "If you accidentally worked in levels/ directory:
1. Copy your work: cp levels/level-X/week-Y/your-file submissions/YOUR-USERNAME/
2. Reset levels: git checkout upstream/main -- levels/
3. Commit your work in the right place" | ./scripts/help-recovery.sh
```

### Release Issues

#### Issue: Broken Content in Release

**Immediate Response:**
```bash
# Emergency notification
./scripts/emergency-rollback.sh 2 3
echo "🚨 Level 2 Week 3 release has issues. DO NOT SYNC until further notice." | ./scripts/emergency-notify.sh
```

**Fix and Re-release:**
```bash
# Fix the content
nano curriculum-content/level-2/services-content.md

# Test the fix
./scripts/release-tasks-enhanced.sh 2 3 --dry-run

# Re-release
./scripts/extract-content.sh
./scripts/release-tasks-enhanced.sh 2 3

# Notify all clear
echo "✅ Level 2 Week 3 issues fixed. Safe to sync now!" | ./scripts/notify-students.sh
```

## 🏆 Best Practices

### Release Management

#### Timing Best Practices:
1. **Consistent schedule**: Same day/time each week
2. **Advance notice**: Announce planned release schedule
3. **Buffer time**: Allow fixing issues before students sync
4. **Weekend consideration**: Avoid Sunday night releases

#### Quality Assurance:
```bash
# Pre-release checklist script
#!/bin/bash
# pre-release-check.sh

LEVEL="$1"
WEEK="$2"

echo "Pre-release checklist for Level $LEVEL Week $WEEK:"

# Check content exists
if [ -f "curriculum-content/level-$LEVEL/*.md" ]; then
    echo "✅ Curriculum content exists"
else
    echo "❌ Missing curriculum content"
    exit 1
fi

# Test release generation
if ./scripts/release-tasks-enhanced.sh "$LEVEL" "$WEEK" --dry-run >/dev/null 2>&1; then
    echo "✅ Release script works"
else
    echo "❌ Release script fails"
    exit 1
fi

# Check for placeholder content
PLACEHOLDERS=$(grep -r "TODO\|PLACEHOLDER\|XXX" curriculum-content/level-$LEVEL/ | wc -l)
if [ $PLACEHOLDERS -gt 0 ]; then
    echo "⚠️  Found $PLACEHOLDERS placeholder items to review"
fi

echo "Pre-release check complete!"
```

### Communication Best Practices

#### Clear Messaging:
- **Action required**: Be explicit about what students need to do
- **Timing**: Include deadlines and expectations
- **Support**: Always include help resources
- **Context**: Explain why the release is important

#### Multi-Channel Strategy:
1. **Immediate**: GitHub notifications for urgent items
2. **Persistent**: Wiki updates for reference information
3. **Interactive**: Discussions for Q&A and community building
4. **Direct**: Email/Slack for critical announcements (if available)

### Student Support

#### Proactive Support:
```bash
# Weekly support routine
#!/bin/bash
# weekly-support-routine.sh

echo "=== Weekly Student Support Check ==="

# Identify inactive students
./scripts/identify-inactive-students.sh --days 7

# Check for common issues
./scripts/check-common-problems.sh

# Prepare office hours agenda
./scripts/generate-office-hours-agenda.sh

# Update FAQ based on recent questions
./scripts/update-faq-from-discussions.sh
```

#### Escalation Procedures:
1. **Level 1**: Student posts question in discussions
2. **Level 2**: Peer community attempts to help
3. **Level 3**: Teacher intervention in discussions
4. **Level 4**: One-on-one office hours
5. **Level 5**: Direct communication for urgent issues

---

## 🎯 Success Metrics

### Release Success Indicators:
- **Adoption Rate**: >80% of students sync within 48 hours
- **Completion Rate**: >70% complete previous level before new release
- **Issue Rate**: <5% of releases require rollback or major fixes
- **Support Load**: <10 support requests per release

### Monitoring Dashboard:
```bash
# Generate weekly teacher dashboard
./scripts/teacher-dashboard.sh
```

**Remember**: The goal is smooth, predictable releases that support student learning without overwhelming them or creating technical barriers. 📚✨

---

*For technical implementation details, see the [Teacher Guide](TEACHER_GUIDE.md) and [Contributing Guidelines](CONTRIBUTING.md).*