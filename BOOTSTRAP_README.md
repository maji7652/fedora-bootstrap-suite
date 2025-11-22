# Bootstrap Scripts Usage Guide

This directory contains organized bootstrap scripts for Linux system setup and configuration.

## Overview

The bootstrap scripts are divided into specialized modules:

- **bootstrap.sh** - Main orchestration script that provides an interactive menu
- **databasebootstrap.sh** - Database installation and configuration (MySQL, PostgreSQL, SQLite)
- **packagebootstrap.sh** - Common packages and development tools
- **securitybootstrap.sh** - Security settings and tools (firewall, fail2ban, SSH hardening)
- **networkbootstrap.sh** - Network tools and web server configuration

## Quick Start

### Running the Main Bootstrap Script

```bash
sudo ./bootstrap.sh
```

This will present an interactive menu where you can choose:
1. Package Bootstrap
2. Database Bootstrap (includes MySQL)
3. Security Bootstrap
4. Network Bootstrap
5. Full Bootstrap (all operations)
6. Custom Selection

### Running Individual Bootstrap Scripts

Each bootstrap script can also be run independently:

```bash
# Install and configure databases
sudo ./databasebootstrap.sh

# Install packages and development tools
sudo ./packagebootstrap.sh

# Configure security settings
sudo ./securitybootstrap.sh

# Setup network tools
sudo ./networkbootstrap.sh
```

## Database Bootstrap Details

The database bootstrap script includes:

### MySQL
- MySQL Server and Client installation
- Automatic service startup and enabling
- Security hardening (removal of test databases, anonymous users)
- Interactive installation options

### PostgreSQL
- PostgreSQL server installation
- PostgreSQL contrib packages
- Automatic service configuration

### SQLite
- SQLite3 installation
- Development libraries

### Database Tools
- PHP and MySQL modules (for phpMyAdmin)
- MySQL Workbench
- Database management utilities

## Package Bootstrap Details

Installs:
- Build essentials (gcc, g++, make)
- Version control (git)
- Text editors (vim, nano)
- System utilities (htop, tmux, screen)
- Programming languages (Python, Node.js, Java, Go)
- Archive tools (zip, tar, gzip)

## Security Bootstrap Details

Configures:
- UFW firewall with default deny incoming
- fail2ban for intrusion prevention
- SSH hardening (disable root login, configure authentication)
- Security scanning tools (rkhunter, chkrootkit, lynis)
- ClamAV antivirus
- Automatic security updates

## Network Bootstrap Details

Installs:
- Network diagnostic tools (netstat, traceroute, nmap)
- Traffic monitoring (iftop, nethogs)
- Web servers (Apache or Nginx)
- Network configuration utilities

## Requirements

- Ubuntu/Debian-based Linux distribution
- Root or sudo privileges
- Internet connection

## Notes

- All scripts include error handling with `set -e`
- Scripts check for root privileges before execution
- Each script can be sourced or executed directly
- Backup of configuration files is performed where applicable

## Safety Features

- Root privilege checking
- Backup creation for modified configs
- Error handling and exit on failures
- Non-interactive mode support for automation

## Examples

### Install only MySQL database
```bash
sudo ./databasebootstrap.sh
# Choose option 1 when prompted
```

### Full system setup
```bash
sudo ./bootstrap.sh
# Choose option 5 for full bootstrap
```

### Custom setup (packages and database only)
```bash
sudo ./bootstrap.sh
# Choose option 6 for custom selection
# Enter: 1 2
```

## Troubleshooting

If a script fails:
1. Check that you're running as root or with sudo
2. Verify internet connectivity
3. Review error messages in the console
4. Check system logs: `journalctl -xe`

## Contributing

To add new bootstrap categories:
1. Create a new `*bootstrap.sh` script following the existing pattern
2. Add the script to the menu in `bootstrap.sh`
3. Ensure the script includes proper error handling and root checks

## License

These scripts are provided as-is for system administration and automation purposes.
