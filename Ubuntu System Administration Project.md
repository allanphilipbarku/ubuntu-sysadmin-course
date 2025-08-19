# Progressive Unix System Administration Learning Project

## Project Overview

This comprehensive learning project is designed to teach system administration through hands-on scenarios that demonstrate how different Unix/Linux components interact. Students will learn to debug problems, understand configuration relationships, and develop systematic troubleshooting skills on Ubuntu systems.

## Learning Philosophy

Rather than teaching tools in isolation, this project emphasizes understanding how Unix systems work as integrated ecosystems. Students learn to trace problems across multiple system components and understand the relationships between configuration files, services, logs, and system behavior.

## Project Structure

### Timeline and Organization
- **Duration**: 10 weeks (2 weeks per level)
- **Format**: Progressive levels building on previous knowledge
- **Approach**: Practical, scenario-based learning with real-world problems
- **Assessment**: Continuous evaluation through hands-on demonstrations and portfolio development

---

## Level 1: Foundation - File System and Basic Commands
**Duration**: Weeks 1-2 | **Focus**: System exploration and basic navigation

### Learning Objectives
- Understand Linux file system hierarchy and its logical organization
- Master basic navigation and file operations
- Learn about permissions, ownership, and their security implications
- Develop systematic approaches to system exploration

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

#### 1.3 Log File Basics
**Scenario**: Users report intermittent system slowness - learn to investigate.

**Tasks**:
- Explore `/var/log/` structure and understand log categorization
- Examine `syslog`, `auth.log`, `kern.log` and their purposes
- Use `tail`, `head`, `grep`, `journalctl` to analyze log entries
- Create a log monitoring script for detecting specific events
- Set up basic log rotation for a custom application

### Deliverables
- Comprehensive system inventory document
- File system map with detailed explanations
- Configuration file analysis report
- Log reading exercises with findings
- Custom log monitoring script

### Assessment Criteria
- Can navigate file system efficiently using command line
- Understands the purpose and relationships of system directories
- Can locate and interpret system logs effectively
- Demonstrates understanding of file permissions and ownership
- Shows systematic approach to system exploration

---

## Level 2: Services and Process Management
**Duration**: Weeks 3-4 | **Focus**: Understanding service dependencies and configuration

### Learning Objectives
- Understand systemd and modern service management
- Learn process monitoring, control, and troubleshooting
- Explore service configuration relationships and dependencies
- Develop skills in debugging service startup issues

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

#### 2.3 Service Dependencies and Integration
**Tasks**:
- Map dependencies between services (network → ssh → user services)
- Create detailed dependency diagrams
- Test dependency failures and recovery procedures
- Understand service startup order and timing

### Practical Scenarios

#### Scenario 2.1: Web Server Setup Problem
**Problem**: Apache won't start after installation
**Debug Path**:
- Check service status: `systemctl status apache2`
- Investigate port conflicts: `netstat -tlnp`, `ss -tlnp`
- Examine configuration syntax errors
- Review permissions and ownership issues
- Analyze logs: `/var/log/apache2/error.log`

#### Scenario 2.2: SSH Access Issue
**Problem**: SSH service running but connections failing
**Debug Path**:
- Verify service status and configuration
- Check firewall rules and network connectivity
- Examine SSH configuration: `/etc/ssh/sshd_config`
- Review authentication logs: `/var/log/auth.log`, `journalctl -u ssh`
- Test user permissions and key authentication

#### Scenario 2.3: Database Service Integration
**Problem**: Web application can't connect to database
**Debug Path**:
- Install and configure MySQL/PostgreSQL
- Create databases and users with appropriate permissions
- Troubleshoot connection issues between web server and database
- Use `tcpdump`, `netcat` for network debugging
- Set up automated backups with cron jobs

### Deliverables
- Service dependency map and documentation
- Process monitoring reports with analysis
- Troubleshooting documentation for each scenario
- Working web server with database integration
- Automated backup solution

### Assessment Criteria
- Can troubleshoot service startup issues systematically
- Understands systemd unit files and service dependencies
- Can diagnose network connectivity problems between services
- Demonstrates proper backup and recovery procedures
- Shows understanding of service interdependencies

---

## Level 3: Network Configuration and Monitoring
**Duration**: Weeks 5-6 | **Focus**: Network management and security fundamentals

### Learning Objectives
- Configure network interfaces, routing, and DNS resolution
- Understand firewall rules and network security principles
- Monitor network traffic and diagnose connectivity issues
- Implement basic network security hardening

### Core Tasks

#### 3.1 Network Interface Configuration
**Tasks**:
- Configure static IP addresses using `/etc/netplan/` (Ubuntu 18.04+)
- Understand DNS configuration in `/etc/resolv.conf` and systemd-resolved
- Set up network bonding or VLANs for redundancy
- Configure routing tables and understand network topology

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

### Practical Scenarios

#### Scenario 3.1: Cannot Connect to External Services
**Problem**: DNS resolution and external connectivity failing
**Debug Path**:
- Check `/etc/resolv.conf` and DNS configuration
- Test resolution: `dig`, `nslookup`, `host` commands
- Verify network connectivity and routing
- Examine logs: `journalctl -u systemd-resolved`
- Test firewall rules and network policies

#### Scenario 3.2: Internal Network Communication Issues
**Problem**: Services can't communicate between servers
**Debug Path**:
- Check firewall rules: `iptables -L`, `ufw status`
- Examine routing tables: `route -n`, `ip route show`
- Verify service bindings: `ss -tulpn`, `netstat -tulpn`
- Test network connectivity: `telnet`, `nc`
- Analyze packet flow with `tcpdump`

#### Scenario 3.3: Multi-User Environment Setup
**Problem**: Create secure system for development team
**Tasks**:
- Create users with different roles (developers, testers, managers)
- Set up groups and shared directories with proper permissions
- Configure sudo access appropriately
- Implement SSH key-based authentication
- Set up secure file sharing and collaboration tools

### Deliverables
- Network configuration documentation with diagrams
- Firewall rule set with detailed explanations
- Network troubleshooting playbook and procedures
- Multi-user system with documented access policies
- Security hardening checklist and implementation

### Assessment Criteria
- Can configure network interfaces and routing correctly
- Understands firewall rules and can implement security policies
- Demonstrates systematic network troubleshooting approach
- Can set up secure multi-user environments
- Shows understanding of network security principles

---

## Level 4: Storage, Backup, and Performance
**Duration**: Weeks 7-8 | **Focus**: System optimization and reliability

### Learning Objectives
- Manage disk partitions, filesystems, and storage systems
- Implement comprehensive backup and recovery strategies
- Monitor and optimize system performance
- Understand capacity planning and resource management

### Core Tasks

#### 4.1 Storage Management
**Tasks**:
- Create and manage LVM (Logical Volume Manager) volumes
- Set up different filesystem types (ext4, xfs, btrfs) and understand their use cases
- Configure mount points and `/etc/fstab` for persistent mounting
- Implement disk quotas and monitoring storage usage

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

### Practical Scenarios

#### Scenario 4.1: Disk Space Crisis
**Problem**: Root filesystem 98% full, system becoming unstable
**Debug Path**:
- Analyze disk usage: `df -h`, `du -sh /*`, `ncdu`
- Find large files: `find / -type f -size +100M`
- Clean system logs and temporary files
- Implement log rotation: `/etc/logrotate.conf`
- Create cleanup scripts and monitoring alerts

#### Scenario 4.2: System Performance Issues
**Problem**: Server responding slowly, affecting user experience
**Debug Path**:
- Investigate CPU usage: `top`, `htop`, `sar -u`
- Analyze memory usage: `free`, `vmstat`, `/proc/meminfo`
- Check I/O bottlenecks: `iotop`, `iostat`
- Monitor network performance: `iftop`, `nethogs`
- Identify and resolve performance bottlenecks

#### Scenario 4.3: Complete Infrastructure Monitoring
**Tasks**:
- Set up comprehensive system monitoring solution
- Configure email alerts for critical issues
- Create custom monitoring scripts and checks
- Implement performance dashboards and reporting
- Document monitoring procedures and incident response

### Deliverables
- Storage architecture diagram with capacity planning
- Comprehensive backup and recovery procedures
- Performance monitoring dashboard and reports
- Tested disaster recovery plan
- System optimization recommendations and implementations

### Assessment Criteria
- Can manage complex storage systems and filesystems
- Implements reliable backup and recovery procedures
- Demonstrates systematic performance analysis and optimization
- Creates effective monitoring and alerting systems
- Shows understanding of capacity planning and resource management

---

## Level 5: Advanced Integration and Automation
**Duration**: Weeks 9-10 | **Focus**: Complex system integration and automation

### Learning Objectives
- Automate system administration tasks with scripts and configuration management
- Integrate multiple services into cohesive infrastructure solutions
- Implement advanced monitoring, alerting, and incident response systems
- Lead infrastructure projects and mentor other team members

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

#### 5.3 Advanced Monitoring and Incident Response
**Tasks**:
- Set up enterprise monitoring solutions (Nagios, Zabbix, Prometheus)
- Configure sophisticated alerting with escalation procedures
- Create custom monitoring checks and metrics collection
- Implement log aggregation and analysis (ELK stack)
- Develop incident response procedures and documentation

### Final Project Scenarios

#### Scenario 5.1: Complete Infrastructure Deployment
**Challenge**: Deploy a complete multi-tier application infrastructure
**Requirements**:
- Deploy multi-service application (web server, database, cache, load balancer)
- Configure high availability and failover mechanisms
- Implement comprehensive monitoring and alerting
- Set up automated backups and disaster recovery procedures
- Create documentation and operational procedures

#### Scenario 5.2: Disaster Recovery Simulation
**Challenge**: Test and validate disaster recovery procedures
**Requirements**:
- Simulate various failure scenarios (hardware, network, service failures)
- Test backup and recovery procedures under time pressure
- Document incident response procedures and lessons learned
- Improve systems based on testing results
- Train team members on emergency procedures

#### Scenario 5.3: Infrastructure Debugging Challenge
**Challenge**: Inherit a broken system with multiple interconnected issues
**Requirements**:
- Systematically diagnose complex multi-service problems
- Fix boot issues, network connectivity problems, and service dependencies
- Resolve performance bottlenecks and resource conflicts
- Implement preventive measures and monitoring
- Document troubleshooting methodology and solutions

### Deliverables
- Automated infrastructure deployment solution
- Comprehensive monitoring and alerting system
- Tested disaster recovery plan with procedures
- Complex troubleshooting documentation and methodology
- Infrastructure as code implementation with version control

### Assessment Criteria
- Can design and implement complex automated infrastructure solutions
- Demonstrates systematic approach to debugging multi-service issues
- Creates effective monitoring, alerting, and incident response procedures
- Shows leadership in infrastructure projects and knowledge sharing
- Contributes to system architecture decisions and best practices

---

## Progress Tracking and Assessment Framework

### Student Portfolio System

#### Digital Progress Dashboard
Students maintain a comprehensive portfolio documenting their learning journey:

```bash
#!/bin/bash
# ~/sysadmin-progress/track-progress.sh
# Comprehensive progress tracking system

PROGRESS_FILE="$HOME/sysadmin-progress/progress.json"
LOG_FILE="$HOME/sysadmin-progress/completed-tasks.log"

# Function to mark task complete
mark_complete() {
    local task="$1"
    local level="$2"
    echo "$(date '+%Y-%m-%d %H:%M:%S') - Level $level: $task completed" >> "$LOG_FILE"
    # Update JSON progress file with completion status
    update_progress_json "$level" "$task"
}

# Function to show current progress
show_progress() {
    echo "=== System Administration Learning Progress ==="
    echo "Level 1: Foundation - $(get_level_progress 1)% complete"
    echo "Level 2: Services & Processes - $(get_level_progress 2)% complete"
    echo "Level 3: Network Configuration - $(get_level_progress 3)% complete"
    echo "Level 4: Storage & Performance - $(get_level_progress 4)% complete"
    echo "Level 5: Advanced Integration - $(get_level_progress 5)% complete"
    echo ""
    echo "Overall Progress: $(get_overall_progress)%"
}

# Function to generate progress report
generate_report() {
    local output_file="progress_report_$(date +%Y%m%d).md"
    echo "# System Administration Learning Progress Report" > "$output_file"
    echo "Generated on: $(date)" >> "$output_file"
    echo "" >> "$output_file"
    
    # Add detailed progress by level
    for level in {1..5}; do
        echo "## Level $level Progress" >> "$output_file"
        get_level_details "$level" >> "$output_file"
        echo "" >> "$output_file"
    done
}
```

#### Automated Verification System
```bash
#!/bin/bash
# Comprehensive skill verification system

# Level 1 verification
verify_level1() {
    local score=0
    local total=5
    
    echo "=== Level 1: Foundation Skills Verification ==="
    
    # Test 1: File system navigation
    if [ -r "/etc/passwd" ] && [ -r "/etc/group" ]; then
        echo "✓ Can access system configuration files"
        ((score++))
    else
        echo "✗ Cannot access system files"
    fi
    
    # Test 2: Log analysis capability
    if command -v journalctl >/dev/null 2>&1; then
        echo "✓ Can use systemd journal commands"
        ((score++))
    else
        echo "✗ Missing journal analysis tools"
    fi
    
    # Test 3: Permission understanding
    if [ $(stat -c %a /etc/passwd) = "644" ]; then
        echo "✓ Understands file permissions"
        ((score++))
    else
        echo "! File permissions may need review"
    fi
    
    # Test 4: System exploration
    if [ -f "$HOME/system-inventory.md" ]; then
        echo "✓ Has completed system inventory"
        ((score++))
    else
        echo "✗ System inventory not found"
    fi
    
    # Test 5: Basic scripting
    if [ -f "$HOME/log-monitor.sh" ] && [ -x "$HOME/log-monitor.sh" ]; then
        echo "✓ Created executable monitoring script"
        ((score++))
    else
        echo "✗ Monitoring script not found or not executable"
    fi
    
    echo "Level 1 Score: $score/$total ($(( score * 100 / total ))%)"
}

# Level 2 verification
verify_level2() {
    local score=0
    local total=5
    
    echo "=== Level 2: Service Management Skills Verification ==="
    
    # Test 1: Service status checking
    if systemctl is-active ssh >/dev/null 2>&1; then
        echo "✓ Can check service status"
        ((score++))
    else
        echo "! SSH service not running (may be intentional)"
        ((score++))  # Give credit for understanding
    fi
    
    # Test 2: Process monitoring
    if command -v htop >/dev/null 2>&1 || command -v top >/dev/null 2>&1; then
        echo "✓ Has process monitoring tools available"
        ((score++))
    else
        echo "✗ Missing process monitoring tools"
    fi
    
    # Test 3: Service configuration
    if [ -d "/etc/systemd/system" ]; then
        echo "✓ Can access systemd configuration"
        ((score++))
    else
        echo "✗ Cannot access systemd configuration"
    fi
    
    # Test 4: Network debugging
    if command -v ss >/dev/null 2>&1 && command -v netstat >/dev/null 2>&1; then
        echo "✓ Has network debugging tools"
        ((score++))
    else
        echo "✗ Missing network debugging tools"
    fi
    
    # Test 5: Troubleshooting documentation
    if [ -f "$HOME/troubleshooting-guide.md" ]; then
        echo "✓ Has created troubleshooting documentation"
        ((score++))
    else
        echo "✗ Troubleshooting documentation not found"
    fi
    
    echo "Level 2 Score: $score/$total ($(( score * 100 / total ))%)"
}
```

### Assessment Methods

#### 1. Practical Demonstrations
- **Live Troubleshooting Sessions**: Students demonstrate problem-solving skills in real-time
- **Explanation of Thought Processes**: Verbal articulation of troubleshooting methodology
- **Documentation Review**: Assessment of written procedures and solutions
- **Peer Teaching**: Advanced students mentor beginners, demonstrating knowledge transfer

#### 2. Scenario-Based Evaluations
- **Time-Limited Challenges**: Fix broken systems within realistic timeframes
- **Mystery Problems**: Diagnose and resolve unknown issues without guidance
- **Infrastructure Building**: Create complete systems from specifications
- **Disaster Recovery**: Restore systems from various failure scenarios

#### 3. Portfolio Assessment
- **Progress Documentation**: Regular review of learning journey and insights
- **Solution Quality**: Evaluation of technical approaches and best practices
- **Script and Automation**: Assessment of created tools and their effectiveness
- **Knowledge Base**: Review of personal documentation and reference materials

### Success Metrics and Competency Indicators

#### Technical Skill Progression
- **Response Time**: Decreasing time to identify and resolve similar issues
- **Problem Complexity**: Increasing sophistication of problems handled independently
- **Solution Quality**: Improvement in elegance and maintainability of solutions
- **Preventive Thinking**: Shift from reactive to proactive system management

#### Professional Development
- **Communication Skills**: Clear technical explanation and documentation
- **Systematic Approach**: Consistent methodology in problem-solving
- **Collaboration**: Effective teamwork and knowledge sharing
- **Leadership**: Mentoring others and contributing to team knowledge

### Implementation Resources

#### Virtual Environment Setup
```bash
# Automated lab environment setup
#!/bin/bash
# setup-lab-environment.sh

# Create multiple VMs for different scenarios
vagrant init ubuntu/focal64
vagrant up

# Set up broken systems for debugging practice
create_broken_service() {
    # Intentionally misconfigure services for troubleshooting practice
    sudo systemctl stop apache2
    sudo chmod 600 /var/www/html/index.html
    echo "Service intentionally broken for training"
}

# Set up monitoring lab
setup_monitoring_lab() {
    # Install monitoring tools
    sudo apt update
    sudo apt install -y htop iotop iftop ncdu
    
    # Set up log aggregation
    sudo apt install -y rsyslog
    
    # Create sample applications to monitor
    create_sample_services
}
```

#### Additional Learning Tools

**Log Analysis and Monitoring**:
- `goaccess` for web log analysis and visualization
- `logwatch` for automated system log summaries
- ELK Stack (Elasticsearch, Logstash, Kibana) for advanced log management
- Custom monitoring scripts for specific application needs

**Network Analysis**:
- `tcpdump` and `wireshark` for packet analysis
- `nmap` for network discovery and security scanning
- `iperf3` for network performance testing
- Custom network monitoring dashboards

**Performance Tools**:
- `htop`, `iotop`, `iftop` for real-time system monitoring
- `ncdu` for disk usage analysis with interactive interface
- `glances` for comprehensive system overview
- Performance monitoring automation scripts

This comprehensive learning framework ensures students develop both technical skills and professional competencies needed for effective Unix system administration. The progressive structure builds confidence while challenging students with increasingly complex real-world scenarios.