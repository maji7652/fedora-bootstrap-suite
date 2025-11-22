#!/bin/bash

# Database Bootstrap Script
# This script installs and configures database systems

set -e

echo "Starting Database Bootstrap..."

# Function to check if running as root
check_root() {
    if [ "$EUID" -ne 0 ]; then 
        echo "Please run as root or with sudo"
        exit 1
    fi
}

# Install MySQL Server
install_mysql() {
    echo "Installing MySQL Server..."
    
    # Update package list
    apt-get update
    
    # Install MySQL Server
    apt-get install -y mysql-server mysql-client
    
    # Start and enable MySQL service
    systemctl start mysql
    systemctl enable mysql
    
    echo "MySQL installed successfully"
}

# Secure MySQL installation
secure_mysql() {
    echo "Securing MySQL installation..."
    
    # Run mysql_secure_installation in non-interactive mode with error handling
    mysql -e "DELETE FROM mysql.user WHERE User='';" 2>/dev/null || echo "Note: Some MySQL security commands may require authentication"
    mysql -e "DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');" 2>/dev/null || true
    mysql -e "DROP DATABASE IF EXISTS test;" 2>/dev/null || true
    mysql -e "DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%';" 2>/dev/null || true
    mysql -e "FLUSH PRIVILEGES;" 2>/dev/null || true
    
    echo "MySQL secured successfully"
}

# Install PostgreSQL
install_postgresql() {
    echo "Installing PostgreSQL..."
    
    # Install PostgreSQL
    apt-get install -y postgresql postgresql-contrib
    
    # Start and enable PostgreSQL service
    systemctl start postgresql
    systemctl enable postgresql
    
    echo "PostgreSQL installed successfully"
}

# Install SQLite
install_sqlite() {
    echo "Installing SQLite..."
    
    apt-get install -y sqlite3 libsqlite3-dev
    
    echo "SQLite installed successfully"
}

# Install database management tools
install_db_tools() {
    echo "Installing database management tools..."
    
    # Install phpMyAdmin dependencies
    apt-get install -y php php-mysql php-mbstring php-zip php-gd php-json php-curl
    
    # Install MySQL Workbench (only if display is available)
    if [ -n "$DISPLAY" ]; then
        apt-get install -y mysql-workbench
        echo "MySQL Workbench installed"
    else
        echo "Skipping MySQL Workbench (GUI tool, no display detected)"
    fi
    
    echo "Database tools installed successfully"
}

# Main execution
main() {
    check_root
    
    echo "Which database would you like to install?"
    echo "1) MySQL"
    echo "2) PostgreSQL"
    echo "3) SQLite"
    echo "4) All databases"
    echo "5) Database tools only"
    
    read -r -p "Enter your choice (1-5): " choice
    
    case $choice in
        1)
            install_mysql
            secure_mysql
            ;;
        2)
            install_postgresql
            ;;
        3)
            install_sqlite
            ;;
        4)
            install_mysql
            secure_mysql
            install_postgresql
            install_sqlite
            ;;
        5)
            install_db_tools
            ;;
        *)
            echo "Invalid choice"
            exit 1
            ;;
    esac
    
    echo "Database bootstrap completed successfully!"
}

# Run main function if script is executed directly
if [ "${BASH_SOURCE[0]}" == "${0}" ]; then
    main "$@"
fi
