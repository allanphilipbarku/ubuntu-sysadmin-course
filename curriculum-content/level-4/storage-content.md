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
