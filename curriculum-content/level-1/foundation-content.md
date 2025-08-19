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
