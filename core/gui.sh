#!/bin/bash

# GUI module
source "$CORE_DIR/menu.sh"

gui_mode() {
    if ! command -v whiptail &> /dev/null; then
        pkg install whiptail -y
    fi
    
    while true; do
        CHOICE=$(whiptail --title "Blackheart Toolkit v$VERSION" \
            --menu "Choose an option:" 20 60 10 \
            "1" "System Update" \
            "2" "Install Python" \
            "3" "Network Tools" \
            "4" "Exit" 3>&1 1>&2 2>&3)
        
        case $CHOICE in
            1) 
                pkg update && pkg upgrade
                whiptail --msgbox "Update complete!" 8 40
                ;;
            2) 
                pkg install python
                whiptail --msgbox "Python installed!" 8 40
                ;;
            3)
                NET=$(whiptail --title "Network Tools" \
                    --menu "Select:" 15 50 3 \
                    "1" "Ping Google" \
                    "2" "Show IP" \
                    "3" "Back" 3>&1 1>&2 2>&3)
                case $NET in
                    1) ping -c 4 google.com ;;
                    2) curl -s ifconfig.me ;;
                esac
                read -p "Press Enter..."
                ;;
            4) 
                return
                ;;
        esac
    done
}
