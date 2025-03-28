# Project Documentation

## Overview
This repository contains various automation scripts and projects developed for linux administration, Git, Bash scripting, and basic networking

## Table of Contents
1. [Git Repository Setup](#git-repository-setup)
2. [Linux Server Administration](#linux-server-administration)
3. [Networking Configuration](#networking-configuration)
4. [Bash Automation Scripts](#bash-automation-scripts)
5. [Cron Jobs & Logging](#cron-jobs--logging)
6. [Documentation & Reporting](#documentation--reporting)

## Git Repository Setup
### Repository Structure
```
repository/
│-- scripts/          # Automation scripts
│-- config/           # Configuration files
│-- monitoring/       # Monitoring scripts
│-- documentation/    # Project documentation
│-- .gitignore        # Git ignore file
```

### Git Best Practices
- Use meaningful commit messages
- Create branches for each feature/script and merge them properly
- Implement a pre-commit hook for syntax checking

## Linux Server Administration
### Setup
- Two Linux virtual machines:
  - **Admin Server**
  - **Target Server**
- Configure SSH with key-based authentication
- Implement user management, package management, service management, file system management, and process management

### Implementation
Each of these tasks has been implemented as scripts stored in the `scripts/` folder:
- **User Management** (`scripts/user_mgt.sh`): Creates users, assigns appropriate permissions, and configures SSH.
- **Package Management** (`scripts/package-mgt.sh`): Installs and configures necessary packages.
- **Service Management** (`scripts/service-mgt.sh`): Enables and configures system services.
- **File System Management** (`scripts/file_manager.sh`): Manages storage, partitions, and mounting.
- **Process Management** (`scripts/process-mgt.sh`): Monitors and controls running processes.

## Networking Configuration
### Configuration Steps
- Set up static IP addressing
- Configure SSH key-based authentication
- Implement firewall rules (iptables/ufw)
- Create a private network between servers
- Configure and test DNS resolution

### Network Documentation
- Network topology diagram
- IP addressing scheme
- Firewall rule explanations
- Service ports in use

## Bash Automation Scripts
### 1. `system_inventory.sh`
- Collects hardware information (CPU, memory, disk)
- Lists installed packages
- Identifies running services
- Outputs a formatted report

### 2. `user_manager.sh`
- Creates, modifies, and removes users
- Sets up SSH keys for users
- Implements password policies
- Manages user groups

### 3. `system_hardening.sh`
- Configures SSH securely
- Disables unnecessary services
- Updates system packages
- Implements basic security policies

### 4. `network_monitor.sh`
- Monitors network connections
- Logs unusual network activity
- Tests connectivity between servers
- Reports bandwidth usage

### 5. `backup_manager.sh`
- Creates timestamped backups of important directories
- Implements a rotation policy (keeps X most recent backups)
- Verifies backup integrity
- Logs backup operations

## Cron Jobs & Logging
### Scheduled Tasks
- System inventory: Weekly
- Network monitoring: Hourly
- Backups: Daily
- System updates check: Daily

### Logging Implementation
- Centralized logging for all scripts
- Log rotation configuration
- Timestamps and appropriate log levels
- Email notifications for critical events


### System Monitoring Script
- Generates a daily report including:
  - System uptime
  - Disk usage
  - Memory usage
  - Failed login attempts
  - Package update status

### Usage
To execute the daily report script manually:
```bash
bash daily_report.sh
```
To schedule it as a daily cron job:
```bash
crontab -e
```
Add the following line:
```bash
0 0 * * * /path/to/daily_report.sh
```





