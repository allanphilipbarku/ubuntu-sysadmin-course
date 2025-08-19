#!/bin/bash

# Content Extraction Script
# Extracts content from the original Ubuntu System Administration Project.md
# and structures it for the progressive task release system

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
ORIGINAL_MD="$PROJECT_ROOT/Ubuntu System Administration Project.md"
CONTENT_DIR="$PROJECT_ROOT/curriculum-content"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

log_info() { echo -e "${BLUE}[INFO]${NC} $1"; }
log_success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }
log_warning() { echo -e "${YELLOW}[WARNING]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }

# Create content directory structure
setup_content_structure() {
    log_info "Setting up curriculum content structure..."
    
    mkdir -p "$CONTENT_DIR"/{level-1,level-2,level-3,level-4,level-5}
    mkdir -p "$CONTENT_DIR"/templates
    
    log_success "Content structure created"
}

# Extract Level 1 content (Lines 21-78 from original)
extract_level1_content() {
    local output_file="$CONTENT_DIR/level-1/foundation-content.md"
    
    log_info "Extracting Level 1: Foundation content..."
    
    cat > "$output_file" << 'EOF'
# Level 1: Foundation - File System and Basic Commands
**Duration**: Weeks 1-2 | **Focus**: System exploration and basic navigation

## Learning Objectives
- Understand Linux file system hierarchy and its logical organization
- Master basic navigation and file operations
- Learn about permissions, ownership, and their security implications
- Develop systematic approaches to system exploration

## Week 1: File System Exploration and Configuration Discovery

### Core Tasks

#### 1.1 File System Exploration
**Scenario**: You're the new sysadmin for a small company. Create a comprehensive system inventory.

**Tasks**:
- Map the `/etc`, `/var`, `/home`, `/usr`, `/bin` directories and their purposes
- Document the relationship between different directory structures
- Create a visual hierarchy chart showing system organization
- Generate system inventory including:
  - OS version and kernel information (`/etc/os-release`, `/proc/version`)
  - Installed packages and services (`dpkg -l`, `systemctl list-units`)
  - User accounts and groups (`/etc/passwd`, `/etc/group`)
  - Mounted filesystems and disk usage (`df -h`, `lsblk`, `mount`)
  - Network configuration (`ip addr`, `/etc/netplan/`)

#### 1.2 Configuration Files Discovery
**Tasks**:
- Locate and examine `/etc/passwd`, `/etc/group`, `/etc/hosts`
- Understand the relationship between user accounts and system files
- Practice reading different configuration file formats
- Document how configuration changes affect system behavior

## Week 2: Log File Analysis and System Monitoring

### Core Tasks

#### 1.3 Log File Basics
**Scenario**: Users report intermittent system slowness - learn to investigate.

**Tasks**:
- Explore `/var/log/` structure and understand log categorization
- Examine `syslog`, `auth.log`, `kern.log` and their purposes
- Use `tail`, `head`, `grep`, `journalctl` to analyze log entries
- Create a log monitoring script for detecting specific events
- Set up basic log rotation for a custom application

## Deliverables
- Comprehensive system inventory document
- File system map with detailed explanations
- Configuration file analysis report
- Log reading exercises with findings
- Custom log monitoring script

## Assessment Criteria
- Can navigate file system efficiently using command line
- Understands the purpose and relationships of system directories
- Can locate and interpret system logs effectively
- Demonstrates understanding of file permissions and ownership
- Shows systematic approach to system exploration

## Practical Exercises

### Exercise 1: System Discovery
Create a script that automatically generates a system report including:
- Hardware information (`lscpu`, `lsmem`, `lsblk`)
- Software inventory (installed packages, running services)
- Network configuration and connectivity
- Security status (users, groups, sudo access)

### Exercise 2: Log Analysis Challenge
Analyze provided log files to identify:
- Failed login attempts and their patterns
- System errors and their causes
- Network connection issues
- Performance bottlenecks

### Exercise 3: Configuration File Investigation
Examine and document the purpose and syntax of:
- `/etc/passwd` and `/etc/shadow`
- `/etc/fstab` and mount options
- `/etc/hosts` and `/etc/resolv.conf`
- Basic systemd unit files
EOF

    log_success "Level 1 content extracted to $output_file"
}

# Extract Level 2 content (Lines 79-154 from original)
extract_level2_content() {
    local output_file="$CONTENT_DIR/level-2/services-content.md"
    
    log_info "Extracting Level 2: Services content..."
    
    cat > "$output_file" << 'EOF'
# Level 2: Services and Process Management
**Duration**: Weeks 3-4 | **Focus**: Understanding service dependencies and configuration

## Learning Objectives
- Understand systemd and modern service management
- Learn process monitoring, control, and troubleshooting
- Explore service configuration relationships and dependencies
- Develop skills in debugging service startup issues

## Week 3: Service Management and Process Control

### Core Tasks

#### 2.1 Service Management Fundamentals
**Tasks**:
- List and analyze all services with `systemctl list-units`
- Practice starting, stopping, restarting, and enabling services
- Examine service configuration files in `/etc/systemd/system/`
- Understand service states and their meanings

#### 2.2 Process Investigation
**Tasks**:
- Use `ps`, `top`, `htop` for comprehensive process monitoring
- Understand parent-child process relationships and process trees
- Practice safe process termination techniques
- Monitor resource usage and identify bottlenecks

## Week 4: Service Dependencies and Integration

### Core Tasks

#### 2.3 Service Dependencies and Integration
**Tasks**:
- Map dependencies between services (network → ssh → user services)
- Create detailed dependency diagrams
- Test dependency failures and recovery procedures
- Understand service startup order and timing

## Practical Scenarios

### Scenario 2.1: Web Server Setup Problem
**Problem**: Apache won't start after installation
**Debug Path**:
- Check service status: `systemctl status apache2`
- Investigate port conflicts: `netstat -tlnp`, `ss -tlnp`
- Examine configuration syntax errors
- Review permissions and ownership issues
- Analyze logs: `/var/log/apache2/error.log`

### Scenario 2.2: SSH Access Issue
**Problem**: SSH service running but connections failing
**Debug Path**:
- Verify service status and configuration
- Check firewall rules and network connectivity
- Examine SSH configuration: `/etc/ssh/sshd_config`
- Review authentication logs: `/var/log/auth.log`, `journalctl -u ssh`
- Test user permissions and key authentication

### Scenario 2.3: Database Service Integration
**Problem**: Web application can't connect to database
**Debug Path**:
- Install and configure MySQL/PostgreSQL
- Create databases and users with appropriate permissions
- Troubleshoot connection issues between web server and database
- Use `tcpdump`, `netcat` for network debugging
- Set up automated backups with cron jobs

## Deliverables
- Service dependency map and documentation
- Process monitoring reports with analysis
- Troubleshooting documentation for each scenario
- Working web server with database integration
- Automated backup solution

## Assessment Criteria
- Can troubleshoot service startup issues systematically
- Understands systemd unit files and service dependencies
- Can diagnose network connectivity problems between services
- Demonstrates proper backup and recovery procedures
- Shows understanding of service interdependencies
EOF

    log_success "Level 2 content extracted to $output_file"
}

# Extract Level 3 content (Lines 155-232 from original)
extract_level3_content() {
    local output_file="$CONTENT_DIR/level-3/networking-content.md"
    
    log_info "Extracting Level 3: Networking content..."
    
    cat > "$output_file" << 'EOF'
# Level 3: Network Configuration and Monitoring
**Duration**: Weeks 5-6 | **Focus**: Network management and security fundamentals

## Learning Objectives
- Configure network interfaces, routing, and DNS resolution
- Understand firewall rules and network security principles
- Monitor network traffic and diagnose connectivity issues
- Implement basic network security hardening

## Week 5: Network Configuration and DNS

### Core Tasks

#### 3.1 Network Interface Configuration
**Tasks**:
- Configure static IP addresses using `/etc/netplan/` (Ubuntu 18.04+)
- Understand DNS configuration in `/etc/resolv.conf` and systemd-resolved
- Set up network bonding or VLANs for redundancy
- Configure routing tables and understand network topology

## Week 6: Network Security and Monitoring

### Core Tasks

#### 3.2 Firewall Management and Security
**Tasks**:
- Configure `ufw` (Uncomplicated Firewall) with appropriate rules
- Understand iptables rules and chain processing
- Create custom firewall rules for specific services
- Implement fail2ban for intrusion prevention
- Configure system updates and security patch management

#### 3.3 Network Troubleshooting and Monitoring
**Tasks**:
- Master tools: `ping`, `traceroute`, `netstat`, `ss`, `tcpdump`
- Analyze network connectivity and routing issues
- Monitor bandwidth usage and network performance
- Set up network monitoring and alerting

## Practical Scenarios

### Scenario 3.1: Cannot Connect to External Services
**Problem**: DNS resolution and external connectivity failing
**Debug Path**:
- Check `/etc/resolv.conf` and DNS configuration
- Test resolution: `dig`, `nslookup`, `host` commands
- Verify network connectivity and routing
- Examine logs: `journalctl -u systemd-resolved`
- Test firewall rules and network policies

### Scenario 3.2: Internal Network Communication Issues
**Problem**: Services can't communicate between servers
**Debug Path**:
- Check firewall rules: `iptables -L`, `ufw status`
- Examine routing tables: `route -n`, `ip route show`
- Verify service bindings: `ss -tulpn`, `netstat -tulpn`
- Test network connectivity: `telnet`, `nc`
- Analyze packet flow with `tcpdump`

### Scenario 3.3: Multi-User Environment Setup
**Problem**: Create secure system for development team
**Tasks**:
- Create users with different roles (developers, testers, managers)
- Set up groups and shared directories with proper permissions
- Configure sudo access appropriately
- Implement SSH key-based authentication
- Set up secure file sharing and collaboration tools

## Deliverables
- Network configuration documentation with diagrams
- Firewall rule set with detailed explanations
- Network troubleshooting playbook and procedures
- Multi-user system with documented access policies
- Security hardening checklist and implementation

## Assessment Criteria
- Can configure network interfaces and routing correctly
- Understands firewall rules and can implement security policies
- Demonstrates systematic network troubleshooting approach
- Can set up secure multi-user environments
- Shows understanding of network security principles
EOF

    log_success "Level 3 content extracted to $output_file"
}

# Extract Level 4 content (Lines 233-309 from original)
extract_level4_content() {
    local output_file="$CONTENT_DIR/level-4/storage-content.md"
    
    log_info "Extracting Level 4: Storage content..."
    
    cat > "$output_file" << 'EOF'
# Level 4: Storage, Backup, and Performance
**Duration**: Weeks 7-8 | **Focus**: System optimization and reliability

## Learning Objectives
- Manage disk partitions, filesystems, and storage systems
- Implement comprehensive backup and recovery strategies
- Monitor and optimize system performance
- Understand capacity planning and resource management

## Week 7: Storage Management and File Systems

### Core Tasks

#### 4.1 Storage Management
**Tasks**:
- Create and manage LVM (Logical Volume Manager) volumes
- Set up different filesystem types (ext4, xfs, btrfs) and understand their use cases
- Configure mount points and `/etc/fstab` for persistent mounting
- Implement disk quotas and monitoring storage usage

## Week 8: Backup Systems and Performance Optimization

### Core Tasks

#### 4.2 Backup and Recovery Systems
**Tasks**:
- Design and implement backup strategies using `rsync`, `tar`
- Set up incremental and differential backup procedures
- Test recovery procedures and document disaster recovery plans
- Automate backups with scripts and cron scheduling
- Implement off-site backup solutions

#### 4.3 Performance Monitoring and Optimization
**Tasks**:
- Use `sar`, `iostat`, `vmstat` for comprehensive system monitoring
- Set up monitoring with `collectd`, `nagios`, or similar tools
- Create performance baselines and capacity planning reports
- Optimize system performance based on monitoring data

## Practical Scenarios

### Scenario 4.1: Disk Space Crisis
**Problem**: Root filesystem 98% full, system becoming unstable
**Debug Path**:
- Analyze disk usage: `df -h`, `du -sh /*`, `ncdu`
- Find large files: `find / -type f -size +100M`
- Clean system logs and temporary files
- Implement log rotation: `/etc/logrotate.conf`
- Create cleanup scripts and monitoring alerts

### Scenario 4.2: System Performance Issues
**Problem**: Server responding slowly, affecting user experience
**Debug Path**:
- Investigate CPU usage: `top`, `htop`, `sar -u`
- Analyze memory usage: `free`, `vmstat`, `/proc/meminfo`
- Check I/O bottlenecks: `iotop`, `iostat`
- Monitor network performance: `iftop`, `nethogs`
- Identify and resolve performance bottlenecks

### Scenario 4.3: Complete Infrastructure Monitoring
**Tasks**:
- Set up comprehensive system monitoring solution
- Configure email alerts for critical issues
- Create custom monitoring scripts and checks
- Implement performance dashboards and reporting
- Document monitoring procedures and incident response

## Deliverables
- Storage architecture diagram with capacity planning
- Comprehensive backup and recovery procedures
- Performance monitoring dashboard and reports
- Tested disaster recovery plan
- System optimization recommendations and implementations

## Assessment Criteria
- Can manage complex storage systems and filesystems
- Implements reliable backup and recovery procedures
- Demonstrates systematic performance analysis and optimization
- Creates effective monitoring and alerting systems
- Shows understanding of capacity planning and resource management
EOF

    log_success "Level 4 content extracted to $output_file"
}

# Extract Level 5 content (Lines 310-387 from original)
extract_level5_content() {
    local output_file="$CONTENT_DIR/level-5/advanced-content.md"
    
    log_info "Extracting Level 5: Advanced content..."
    
    cat > "$output_file" << 'EOF'
# Level 5: Advanced Integration and Automation
**Duration**: Weeks 9-10 | **Focus**: Complex system integration and automation

## Learning Objectives
- Automate system administration tasks with scripts and configuration management
- Integrate multiple services into cohesive infrastructure solutions
- Implement advanced monitoring, alerting, and incident response systems
- Lead infrastructure projects and mentor other team members

## Week 9: Automation and Configuration Management

### Core Tasks

#### 5.1 Automation and Scripting
**Tasks**:
- Write comprehensive bash scripts for common administrative tasks
- Set up sophisticated cron jobs and scheduled maintenance
- Create system health check scripts with automated remediation
- Implement error handling and logging in automation scripts

#### 5.2 Configuration Management and Infrastructure as Code
**Tasks**:
- Use Ansible, Puppet, or Chef for configuration management
- Create playbooks and manifests for system setup and maintenance
- Implement infrastructure as code practices
- Version control configurations and track changes
- Set up automated deployment pipelines

## Week 10: Advanced Monitoring and Final Projects

### Core Tasks

#### 5.3 Advanced Monitoring and Incident Response
**Tasks**:
- Set up enterprise monitoring solutions (Nagios, Zabbix, Prometheus)
- Configure sophisticated alerting with escalation procedures
- Create custom monitoring checks and metrics collection
- Implement log aggregation and analysis (ELK stack)
- Develop incident response procedures and documentation

## Final Project Scenarios

### Scenario 5.1: Complete Infrastructure Deployment
**Challenge**: Deploy a complete multi-tier application infrastructure
**Requirements**:
- Deploy multi-service application (web server, database, cache, load balancer)
- Configure high availability and failover mechanisms
- Implement comprehensive monitoring and alerting
- Set up automated backups and disaster recovery procedures
- Create documentation and operational procedures

### Scenario 5.2: Disaster Recovery Simulation
**Challenge**: Test and validate disaster recovery procedures
**Requirements**:
- Simulate various failure scenarios (hardware, network, service failures)
- Test backup and recovery procedures under time pressure
- Document incident response procedures and lessons learned
- Improve systems based on testing results
- Train team members on emergency procedures

### Scenario 5.3: Infrastructure Debugging Challenge
**Challenge**: Inherit a broken system with multiple interconnected issues
**Requirements**:
- Systematically diagnose complex multi-service problems
- Fix boot issues, network connectivity problems, and service dependencies
- Resolve performance bottlenecks and resource conflicts
- Implement preventive measures and monitoring
- Document troubleshooting methodology and solutions

## Deliverables
- Automated infrastructure deployment solution
- Comprehensive monitoring and alerting system
- Tested disaster recovery plan with procedures
- Complex troubleshooting documentation and methodology
- Infrastructure as code implementation with version control

## Assessment Criteria
- Can design and implement complex automated infrastructure solutions
- Demonstrates systematic approach to debugging multi-service issues
- Creates effective monitoring, alerting, and incident response procedures
- Shows leadership in infrastructure projects and knowledge sharing
- Contributes to system architecture decisions and best practices
EOF

    log_success "Level 5 content extracted to $output_file"
}

# Update the release script with actual content
update_release_script() {
    log_info "Creating enhanced release script with real content..."
    
    # Create an enhanced version that uses the extracted content
    cat > "$PROJECT_ROOT/scripts/release-tasks-enhanced.sh" << 'EOF'
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
EOF

    chmod +x "$PROJECT_ROOT/scripts/release-tasks-enhanced.sh"
    log_success "Enhanced release script created"
}

# Main execution
main() {
    log_info "Starting curriculum content extraction..."
    
    setup_content_structure
    extract_level1_content
    extract_level2_content
    extract_level3_content
    extract_level4_content
    extract_level5_content
    update_release_script
    
    log_success "Content extraction completed!"
    log_info "Content available in: $CONTENT_DIR"
    log_info "Enhanced release script: $PROJECT_ROOT/scripts/release-tasks-enhanced.sh"
}

# Run if executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi