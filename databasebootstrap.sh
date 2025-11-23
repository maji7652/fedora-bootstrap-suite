#!/bin/bash
# Database Bootstrap Script - installs MySQL, PostgreSQL, SQLite, and tools (Fedora/RHEL version)

set -e

[ "$EUID" -ne 0 ] && echo "Run as root or with sudo" && exit 1

echo "Database script"

install_mysql() {
    dnf -y update
    dnf -y install mysql-server
    systemctl enable --now mysqld
    mysql -e "DELETE FROM mysql.user WHERE User='';" || true
    mysql -e "DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost','127.0.0.1','::1');" || true
    mysql -e "DROP DATABASE IF EXISTS test;" || true
    mysql -e "DELETE FROM mysql.db WHERE Db LIKE 'test%';" || true
    mysql -e "FLUSH PRIVILEGES;" || true
}

install_postgresql() {
    dnf -y install postgresql-server postgresql-contrib
    postgresql-setup --initdb --unit postgresql || true
    systemctl enable --now postgresql
}

install_sqlite() {
    dnf -y install sqlite sqlite-devel
}

install_db_tools() {
    dnf -y install php php-mysqlnd php-mbstring php-zip php-gd php-json php-curl

    # Add DBeaver official repo and install if running in a desktop environment
    if [ -n "$DISPLAY" ]; then
        rpm --import https://dbeaver.io/rpm/rpm-public.gpg
        dnf -y install https://dbeaver.io/rpm/dbeaver.repo
        dnf -y install dbeaver-ce
    fi
}


main() {
    install_mysql
    install_postgresql
    install_sqlite
    install_db_tools
    echo "All databases and tools installed successfully!"
}

[ "${BASH_SOURCE[0]}" == "$0" ] && main "$@"
