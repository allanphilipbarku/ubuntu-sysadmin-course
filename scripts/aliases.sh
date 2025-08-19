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
