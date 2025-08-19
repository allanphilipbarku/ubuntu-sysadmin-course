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
