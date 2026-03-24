#!/bin/bash

set -euo pipefail

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

# Version
VERSION="2.0"

# Directories
BASE_DIR="$(cd "$(dirname "$0")" && pwd)"
CORE_DIR="$BASE_DIR/core"
PLUGIN_DIR="$BASE_DIR/plugins"
DATA_DIR="$BASE_DIR/data"
LOG_FILE="$DATA_DIR/activity.log"

# Create directories
mkdir -p "$CORE_DIR" "$PLUGIN_DIR" "$DATA_DIR"

# ============================================
# SAFE BANNER FUNCTION (No lolcat dependency)
# ============================================
show_banner() {
    clear
    if command -v figlet &> /dev/null; then
        # Try with lolcat if available
        if command -v lolcat &> /dev/null; then
            figlet "Blackheart" | lolcat 2>/dev/null || figlet "Blackheart"
        else
            figlet "Blackheart"
        fi
    else
        echo -e "${BLUE}================================${NC}"
        echo -e "${GREEN}   BLACKHEART TOOLKIT v$VERSION${NC}"
        echo -e "${BLUE}================================${NC}"
    fi
    echo -e "${CYAN}Developed by Blackheart${NC}"
    echo ""
}

# ============================================
# MUSIC MODULE (Safe)
# ============================================
MUSIC_FILE="$HOME/storage/music/termux-music/intense.mp3"

play_intense() {
    if command -v mpv &> /dev/null && [ -f "$MUSIC_FILE" ]; then
        mpv --no-video --volume=70 "$MUSIC_FILE" > /dev/null 2>&1 &
        local pid=$!
        sleep 3
        kill $pid 2>/dev/null || true
    fi
}

# ============================================
# LOGGER
# ============================================
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$LOG_FILE"
}

# ============================================
# LOGIN SYSTEM (Safe)
# ============================================
login_system() {
    if [ ! -f "$DATA_DIR/users.db" ]; then
        echo -e "${YELLOW}First time setup - Register${NC}"
        read -rp "Username: " username
        read -rsp "Password: " password
        echo
        # Simple hash (no md5sum dependency)
        hash=$(echo -n "$password" | sha256sum | cut -d' ' -f1)
        echo "$username:$hash" > "$DATA_DIR/users.db"
        echo -e "${GREEN}Registration successful!${NC}"
        log "New user registered: $username"
    fi

    echo -e "${YELLOW}Login Required${NC}"
    read -rp "Username: " username
    read -rsp "Password: " password
    echo

    if [ -f "$DATA_DIR/users.db" ]; then
        stored_user=$(cut -d':' -f1 "$DATA_DIR/users.db")
        stored_pass=$(cut -d':' -f2 "$DATA_DIR/users.db")
        input_hash=$(echo -n "$password" | sha256sum | cut -d' ' -f1)

        if [[ "$username" == "$stored_user" && "$input_hash" == "$stored_pass" ]]; then
            echo -e "${GREEN}Login successful!${NC}"
            log "User logged in: $username"
            return 0
        fi
    fi

    echo -e "${RED}Login failed!${NC}"
    log "Failed login attempt: $username"
    exit 1
}

# ============================================
# MAIN MENU
# ============================================
main_menu() {
    while true; do
        show_banner
        echo -e "${BLUE}╔════════════════════════════╗${NC}"
        echo -e "${BLUE}║     MAIN MENU              ║${NC}"
        echo -e "${BLUE}╠════════════════════════════╣${NC}"
        echo -e "${BLUE}║${NC} 1. System Commands        ${BLUE}║${NC}"
        echo -e "${BLUE}║${NC} 2. Package Management     ${BLUE}║${NC}"
        echo -e "${BLUE}║${NC} 3. Development Tools      ${BLUE}║${NC}"
        echo -e "${BLUE}║${NC} 4. File Manager           ${BLUE}║${NC}"
        echo -e "${BLUE}║${NC} 5. Network Tools          ${BLUE}║${NC}"
        echo -e "${BLUE}║${NC} 6. Plugins                ${BLUE}║${NC}"
        echo -e "${BLUE}║${NC} 7. GUI Mode               ${BLUE}║${NC}"
        echo -e "${BLUE}║${NC} 8. Exit                   ${BLUE}║${NC}"
        echo -e "${BLUE}╚════════════════════════════╝${NC}"
        
        read -rp "Select option: " choice
        
        case $choice in
            1) system_menu ;;
            2) package_menu ;;
            3) dev_menu ;;
            4) file_menu ;;
            5) network_menu ;;
            6) plugin_menu ;;
            7) gui_mode ;;
            8) 
                echo -e "${GREEN}Thanks for using Blackheart Toolkit!${NC}"
                log "User exited"
                exit 0 
                ;;
            *) 
                echo -e "${RED}Invalid option!${NC}"
                sleep 1
                ;;
        esac
    done
}

# ============================================
# SYSTEM MENU
# ============================================
system_menu() {
    while true; do
        show_banner
        echo -e "${YELLOW}╔════════════════════════════╗${NC}"
        echo -e "${YELLOW}║     SYSTEM COMMANDS        ║${NC}"
        echo -e "${YELLOW}╠════════════════════════════╣${NC}"
        echo -e "${YELLOW}║${NC} 1. Update Packages        ${YELLOW}║${NC}"
        echo -e "${YELLOW}║${NC} 2. Upgrade Packages       ${YELLOW}║${NC}"
        echo -e "${YELLOW}║${NC} 3. Storage Setup          ${YELLOW}║${NC}"
        echo -e "${YELLOW}║${NC} 4. Clear Cache            ${YELLOW}║${NC}"
        echo -e "${YELLOW}║${NC} 5. Back to Main           ${YELLOW}║${NC}"
        echo -e "${YELLOW}╚════════════════════════════╝${NC}"
        
        read -rp "Select option: " choice
        case $choice in
            1) pkg update ;;
            2) pkg upgrade ;;
            3) termux-setup-storage ;;
            4) pkg clean ;;
            5) break ;;
            *) echo -e "${RED}Invalid!${NC}"; sleep 1 ;;
        esac
        read -rp "Press Enter..."
    done
}

# ============================================
# PACKAGE MENU
# ============================================
package_menu() {
    while true; do
        show_banner
        echo -e "${GREEN}╔════════════════════════════╗${NC}"
        echo -e "${GREEN}║     PACKAGE MANAGEMENT     ║${NC}"
        echo -e "${GREEN}╠════════════════════════════╣${NC}"
        echo -e "${GREEN}║${NC} 1. Install Package        ${GREEN}║${NC}"
        echo -e "${GREEN}║${NC} 2. Remove Package         ${GREEN}║${NC}"
        echo -e "${GREEN}║${NC} 3. Search Package         ${GREEN}║${NC}"
        echo -e "${GREEN}║${NC} 4. List Installed         ${GREEN}║${NC}"
        echo -e "${GREEN}║${NC} 5. Back to Main           ${GREEN}║${NC}"
        echo -e "${GREEN}╚════════════════════════════╝${NC}"
        
        read -rp "Select option: " choice
        case $choice in
            1) 
                read -rp "Package name: " pkg
                [ -n "$pkg" ] && pkg install "$pkg"
                ;;
            2) 
                read -rp "Package name: " pkg
                [ -n "$pkg" ] && pkg uninstall "$pkg"
                ;;
            3) 
                read -rp "Search term: " term
                [ -n "$term" ] && pkg search "$term"
                ;;
            4) pkg list-installed ;;
            5) break ;;
            *) echo -e "${RED}Invalid!${NC}"; sleep 1 ;;
        esac
        read -rp "Press Enter..."
    done
}

# ============================================
# DEVELOPMENT MENU
# ============================================
dev_menu() {
    while true; do
        show_banner
        echo -e "${CYAN}╔════════════════════════════╗${NC}"
        echo -e "${CYAN}║     DEVELOPMENT TOOLS      ║${NC}"
        echo -e "${CYAN}╠════════════════════════════╣${NC}"
        echo -e "${CYAN}║${NC} 1. Install Python         ${CYAN}║${NC}"
        echo -e "${CYAN}║${NC} 2. Install Node.js        ${CYAN}║${NC}"
        echo -e "${CYAN}║${NC} 3. Install Git            ${CYAN}║${NC}"
        echo -e "${CYAN}║${NC} 4. Install PHP            ${CYAN}║${NC}"
        echo -e "${CYAN}║${NC} 5. Back to Main           ${CYAN}║${NC}"
        echo -e "${CYAN}╚════════════════════════════╝${NC}"
        
        read -rp "Select option: " choice
        case $choice in
            1) pkg install python ;;
            2) pkg install nodejs ;;
            3) pkg install git ;;
            4) pkg install php ;;
            5) break ;;
            *) echo -e "${RED}Invalid!${NC}"; sleep 1 ;;
        esac
        read -rp "Press Enter..."
    done
}

# ============================================
# FILE MANAGER
# ============================================
file_menu() {
    while true; do
        show_banner
        echo -e "${BLUE}╔════════════════════════════╗${NC}"
        echo -e "${BLUE}║     FILE MANAGER           ║${NC}"
        echo -e "${BLUE}╠════════════════════════════╣${NC}"
        echo -e "${BLUE}║${NC} 1. List Files             ${BLUE}║${NC}"
        echo -e "${BLUE}║${NC} 2. Create File            ${BLUE}║${NC}"
        echo -e "${BLUE}║${NC} 3. Delete File            ${BLUE}║${NC}"
        echo -e "${BLUE}║${NC} 4. Create Folder          ${BLUE}║${NC}"
        echo -e "${BLUE}║${NC} 5. Delete Folder          ${BLUE}║${NC}"
        echo -e "${BLUE}║${NC} 6. Back to Main           ${BLUE}║${NC}"
        echo -e "${BLUE}╚════════════════════════════╝${NC}"
        
        read -rp "Select option: " choice
        case $choice in
            1) ls -la ;;
            2) 
                read -rp "File name: " f
                [ -n "$f" ] && touch "$f"
                ;;
            3) 
                read -rp "File name: " f
                [ -n "$f" ] && rm -i "$f"
                ;;
            4) 
                read -rp "Folder name: " d
                [ -n "$d" ] && mkdir -p "$d"
                ;;
            5) 
                read -rp "Folder name: " d
                [ -n "$d" ] && rm -ri "$d"
                ;;
            6) break ;;
            *) echo -e "${RED}Invalid!${NC}"; sleep 1 ;;
        esac
        read -rp "Press Enter..."
    done
}

# ============================================
# NETWORK MENU
# ============================================
network_menu() {
    while true; do
        show_banner
        echo -e "${GREEN}╔════════════════════════════╗${NC}"
        echo -e "${GREEN}║     NETWORK TOOLS          ║${NC}"
        echo -e "${GREEN}╠════════════════════════════╣${NC}"
        echo -e "${GREEN}║${NC} 1. Ping Test             ${GREEN}║${NC}"
        echo -e "${GREEN}║${NC} 2. Show IP               ${GREEN}║${NC}"
        echo -e "${GREEN}║${NC} 3. Download File         ${GREEN}║${NC}"
        echo -e "${GREEN}║${NC} 4. Back to Main          ${GREEN}║${NC}"
        echo -e "${GREEN}╚════════════════════════════╝${NC}"
        
        read -rp "Select option: " choice
        case $choice in
            1) 
                read -rp "Host: " host
                [ -n "$host" ] && ping -c 4 "$host"
                ;;
            2) 
                curl -s ifconfig.me || echo "No internet"
                echo
                ;;
            3) 
                read -rp "URL: " url
                [ -n "$url" ] && wget "$url"
                ;;
            4) break ;;
            *) echo -e "${RED}Invalid!${NC}"; sleep 1 ;;
        esac
        read -rp "Press Enter..."
    done
}

# ============================================
# PLUGIN MENU
# ============================================
plugin_menu() {
    show_banner
    echo -e "${CYAN}╔════════════════════════════╗${NC}"
    echo -e "${CYAN}║     PLUGINS                ║${NC}"
    echo -e "${CYAN}╠════════════════════════════╣${NC}"
    
    if [ -z "$(ls -A "$PLUGIN_DIR" 2>/dev/null)" ]; then
        echo -e "${YELLOW}No plugins found${NC}"
        echo -e "${YELLOW}Creating example plugin...${NC}"
        mkdir -p "$PLUGIN_DIR"
        cat > "$PLUGIN_DIR/example.sh" << 'EOF'
#!/bin/bash
echo "🎯 Example Plugin"
echo "Plugin executed at: $(date)"
EOF
        chmod +x "$PLUGIN_DIR/example.sh"
    fi
    
    echo -e "${CYAN}Available plugins:${NC}"
    ls -1 "$PLUGIN_DIR" | sed 's/^/   /'
    echo -e "${CYAN}╚════════════════════════════╝${NC}"
    
    read -rp "Enter plugin name (or 'back'): " plugin
    if [ "$plugin" = "back" ]; then
        return
    fi
    
    if [ -f "$PLUGIN_DIR/$plugin" ]; then
        bash "$PLUGIN_DIR/$plugin"
        log "Plugin executed: $plugin"
    else
        echo -e "${RED}Plugin not found!${NC}"
    fi
    read -rp "Press Enter..."
}

# ============================================
# GUI MODE
# ============================================
gui_mode() {
    if ! command -v whiptail &> /dev/null; then
        pkg install whiptail -y
    fi
    
    CHOICE=$(whiptail --title "Blackheart Toolkit v$VERSION" \
        --menu "Choose an option:" 20 60 5 \
        "1" "System Update" \
        "2" "Install Python" \
        "3" "Network Tools" \
        "4" "Exit" 3>&1 1>&2 2>&3)
    
    case $CHOICE in
        1) pkg update && pkg upgrade ;;
        2) pkg install python ;;
        3) 
            NET=$(whiptail --title "Network" --menu "Select:" 15 50 2 \
                "1" "Ping Google" \
                "2" "Show IP" 3>&1 1>&2 2>&3)
            case $NET in
                1) ping -c 4 google.com ;;
                2) curl -s ifconfig.me ;;
            esac
            ;;
        4) return ;;
    esac
}

# ============================================
# MAIN EXECUTION
# ============================================
log "Tool started"
show_banner
login_system
play_intense
main_menu
