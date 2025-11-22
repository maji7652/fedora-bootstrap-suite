# Fedora System Bootstrap Suite

This repository contains modular shell scripts for bootstrapping a Fedora/RHEL-based system. Each script installs and configures a specific category of tools or services, making it easy to set up a development-ready or personal-use Linux environment.

## 📦 Included Scripts

| Script                  | Purpose                                                                 |
|------------------------|-------------------------------------------------------------------------|
| `packagebootstrap.sh`  | Installs development tools, languages, build systems, and CLI utilities |
| `networkbootstrap.sh`  | Installs network diagnostics tools and configures Apache/Nginx          |
| `databasebootstrap.sh` | Installs MySQL, PostgreSQL, SQLite, and PHP database extensions         |
| `securitybootstrap.sh` | Configures firewall, fail2ban, SSH hardening, antivirus, and auto-updates |
| `bootstrap.sh`         | Main orchestrator — runs selected scripts in sequence                   |

## 🚀 Usage

Run the main bootstrap script with root privileges:

```bash
sudo ./bootstrap.sh
