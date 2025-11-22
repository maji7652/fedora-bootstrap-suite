#!/bin/bash

# Main Bootstrap Script
# This script orchestrates various bootstrap operations for system setup
# It groups commands into different categories and calls specialized bootstrap scripts

set -e

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Function to print colored messages
print_message() {
    local color=$1
    local message=$2
    echo -e "${color}${message}${NC}"
}

# Function to check if running as root
check_root() {
    if [ "$EUID" -ne 0 ]; then 
        print_message "$RED" "Please run as root or with sudo"
        exit 1
    fi
}

# Function to display header
display_header() {
    clear
    print_message "$GREEN" "========================================="
    print_message "$GREEN" "  Linux System Bootstrap Script"
    print_message "$GREEN" "========================================="
    echo ""
}

# Function to run a bootstrap script
run_bootstrap() {
    local script=$1
    local script_path="${SCRIPT_DIR}/${script}"
    
    if [ -f "$script_path" ]; then
        print_message "$YELLOW" "Running ${script}..."
        chmod +x "$script_path"
        bash "$script_path"
    else
        print_message "$RED" "Error: ${script} not found at ${script_path}"
        return 1
    fi
}

# Function to display menu
display_menu() {
    echo ""
    print_message "$YELLOW" "Select bootstrap operations to perform:"
    echo ""
    echo "1) Package Bootstrap - Install common packages and development tools"
    echo "2) Database Bootstrap - Install and configure databases (MySQL, PostgreSQL, SQLite)"
    echo "3) Security Bootstrap - Configure security settings and tools"
    echo "4) Network Bootstrap - Install network tools and configure networking"
    echo "5) Full Bootstrap - Run all bootstrap operations"
    echo "6) Custom Selection - Choose multiple bootstrap operations"
    echo "0) Exit"
    echo ""
}

# Function to run full bootstrap
run_full_bootstrap() {
    print_message "$GREEN" "Running full system bootstrap..."
    
    run_bootstrap "packagebootstrap.sh"
    run_bootstrap "databasebootstrap.sh"
    run_bootstrap "securitybootstrap.sh"
    run_bootstrap "networkbootstrap.sh"
    
    print_message "$GREEN" "Full bootstrap completed successfully!"
}

# Function to run custom selection
run_custom_bootstrap() {
    local -a selected_scripts=()
    
    echo ""
    print_message "$YELLOW" "Select bootstrap scripts to run (space-separated numbers):"
    echo "1) Package Bootstrap"
    echo "2) Database Bootstrap"
    echo "3) Security Bootstrap"
    echo "4) Network Bootstrap"
    echo ""
    
    read -r -p "Enter your choices: " -a choices
    
    for choice in "${choices[@]}"; do
        case $choice in
            1) selected_scripts+=("packagebootstrap.sh") ;;
            2) selected_scripts+=("databasebootstrap.sh") ;;
            3) selected_scripts+=("securitybootstrap.sh") ;;
            4) selected_scripts+=("networkbootstrap.sh") ;;
            *) print_message "$RED" "Invalid choice: $choice" ;;
        esac
    done
    
    if [ ${#selected_scripts[@]} -eq 0 ]; then
        print_message "$RED" "No valid scripts selected"
        return 1
    fi
    
    for script in "${selected_scripts[@]}"; do
        run_bootstrap "$script"
    done
    
    print_message "$GREEN" "Custom bootstrap completed successfully!"
}

# Main execution
main() {
    check_root
    display_header
    
    while true; do
        display_menu
        read -r -p "Enter your choice: " choice
        
        case $choice in
            1)
                run_bootstrap "packagebootstrap.sh"
                ;;
            2)
                run_bootstrap "databasebootstrap.sh"
                ;;
            3)
                run_bootstrap "securitybootstrap.sh"
                ;;
            4)
                run_bootstrap "networkbootstrap.sh"
                ;;
            5)
                run_full_bootstrap
                ;;
            6)
                run_custom_bootstrap
                ;;
            0)
                print_message "$GREEN" "Exiting bootstrap script. Goodbye!"
                exit 0
                ;;
            *)
                print_message "$RED" "Invalid choice. Please try again."
                ;;
        esac
        
        echo ""
        read -r -p "Press Enter to continue..."
        display_header
    done
}

# Run main function if script is executed directly
if [ "${BASH_SOURCE[0]}" == "${0}" ]; then
    main "$@"
fi
