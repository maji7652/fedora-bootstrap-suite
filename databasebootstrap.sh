#!/bin/bash
# Database Bootstrap Script - installs MySQL, PostgreSQL, SQLite, and tools

set -e

[ "$EUID" -ne 0 ] && echo "Run as root or with sudo" && exit 1

install_mysql() {
    apt-get update
    apt-get install -y mysql-server mysql-client
    systemctl enable --now mysql
    mysql -e "DELETE FROM mysql.user WHERE User='';" || true
    mysql -e "DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost','127.0.0.1','::1');" || true
    mysql -e "DROP DATABASE IF EXISTS test;" || true
    mysql -e "DELETE FROM mysql.db WHERE Db LIKE 'test%';" || true
    mysql -e "FLUSH PRIVILEGES;" || true
}

install_postgresql() {
    apt-get install -y postgresql postgresql-contrib
    systemctl enable --now postgresql
}

install_sqlite() {
    apt-get install -y sqlite3 libsqlite3-dev
}

install_db_tools() {
    apt-get install -y php php-mysql php-mbstring php-zip php-gd php-json php-curl
    [ -n "$DISPLAY" ] && apt-get install -y mysql-workbench
}

main() {
    install_mysql
    install_postgresql
    install_sqlite
    install_db_tools
    echo "All databases and tools installed successfully!"
}

[ "${BASH_SOURCE[0]}" == "$0" ] && main "$@"
 
