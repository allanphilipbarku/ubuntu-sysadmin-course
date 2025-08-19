#!/bin/bash

# Enhanced Task Release Script with Real Content
# Sources content from curriculum-content directory

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
CONTENT_DIR="$PROJECT_ROOT/curriculum-content"

# Source the original release script functions
source "$SCRIPT_DIR/release-tasks.sh"

# Override content functions with real curriculum content
get_week_overview() {
    local level="$1"
    local week="$2"
    local level_num=$(echo "$level" | cut -d'-' -f2)
    
    case "$level_num" in
        1) get_level1_week_overview "$week" ;;
        2) get_level2_week_overview "$week" ;;
        3) get_level3_week_overview "$week" ;;
        4) get_level4_week_overview "$week" ;;
        5) get_level5_week_overview "$week" ;;
    esac
}

get_level1_week_overview() {
    local week="$1"
    local week_num=$(echo "$week" | cut -d'-' -f2)
    
    case "$week_num" in
        1) echo "Focus on file system exploration and configuration discovery. You'll create comprehensive system inventories and understand Linux directory structures." ;;
        2) echo "Deep dive into log analysis and system monitoring. Learn to investigate system issues through log files and create monitoring solutions." ;;
    esac
}

get_level2_week_overview() {
    local week="$1"
    local week_num=$(echo "$week" | cut -d'-' -f2)
    
    case "$week_num" in
        3) echo "Master service management fundamentals and process control using systemd and process monitoring tools." ;;
        4) echo "Understand service dependencies and integration. Work with complex multi-service scenarios and troubleshooting." ;;
    esac
}

get_level3_week_overview() {
    local week="$1"
    local week_num=$(echo "$week" | cut -d'-' -f2)
    
    case "$week_num" in
        5) echo "Configure network interfaces, DNS, and routing. Build solid foundation in network configuration management." ;;
        6) echo "Implement network security with firewalls and monitoring. Set up comprehensive network troubleshooting capabilities." ;;
    esac
}

get_level4_week_overview() {
    local week="$1"
    local week_num=$(echo "$week" | cut -d'-' -f2)
    
    case "$week_num" in
        7) echo "Manage storage systems, LVM, and filesystems. Implement disk quotas and storage monitoring solutions." ;;
        8) echo "Design backup strategies and performance optimization. Create comprehensive monitoring and alerting systems." ;;
    esac
}

get_level5_week_overview() {
    local week="$1"
    local week_num=$(echo "$week" | cut -d'-' -f2)
    
    case "$week_num" in
        9) echo "Implement automation and configuration management. Create infrastructure as code solutions with version control." ;;
        10) echo "Advanced monitoring and final integration projects. Complete comprehensive infrastructure deployment challenges." ;;
    esac
}

# Run the main function with enhanced content
main "$@"
