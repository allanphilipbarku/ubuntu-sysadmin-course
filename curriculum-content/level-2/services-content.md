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
