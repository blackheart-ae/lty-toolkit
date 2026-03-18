#!/bin/bash

# Menu system module
source "$CORE_DIR/utils.sh"

# System menu
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
        
        read -p "Select option: " choice
        case $choice in
            1) pkg update ;;
            2) pkg upgrade ;;
            3) termux-setup-storage ;;
            4) pkg clean ;;
            5) break ;;
            *) echo -e "${RED}Invalid!${NC}"; sleep 1 ;;
        esac
        pause
    done
}

# Package menu
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
        
        read -p "Select option: " choice
        case $choice in
            1) 
                read -p "Package name: " pkg
                pkg install "$pkg"
                ;;
            2) 
                read -p "Package name: " pkg
                pkg uninstall "$pkg"
                ;;
            3) 
                read -p "Search term: " term
                pkg search "$term"
                ;;
            4) pkg list-installed ;;
            5) break ;;
            *) echo -e "${RED}Invalid!${NC}"; sleep 1 ;;
        esac
        pause
    done
}

# Development menu
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
        echo -e "${CYAN}║${NC} 5. Install Java           ${CYAN}║${NC}"
        echo -e "${CYAN}║${NC} 6. Back to Main           ${CYAN}║${NC}"
        echo -e "${CYAN}╚════════════════════════════╝${NC}"
        
        read -p "Select option: " choice
        case $choice in
            1) pkg install python ;;
            2) pkg install nodejs ;;
            3) pkg install git ;;
            4) pkg install php ;;
            5) pkg install openjdk-17 ;;
            6) break ;;
            *) echo -e "${RED}Invalid!${NC}"; sleep 1 ;;
        esac
        pause
    done
}

# File manager
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
        echo -e "${BLUE}║${NC} 6. View File              ${BLUE}║${NC}"
        echo -e "${BLUE}║${NC} 7. Back to Main           ${BLUE}║${NC}"
        echo -e "${BLUE}╚════════════════════════════╝${NC}"
        
        read -p "Select option: " choice
        case $choice in
            1) ls -la ;;
            2) 
                read -p "File name: " f
                touch "$f"
                echo "Created: $f"
                ;;
            3) 
                read -p "File name: " f
                rm -i "$f"
                ;;
            4) 
                read -p "Folder name: " d
                mkdir -p "$d"
                echo "Created: $d"
                ;;
            5) 
                read -p "Folder name: " d
                rm -ri "$d"
                ;;
            6)
                read -p "File name: " f
                if [ -f "$f" ]; then
                    less "$f"
                else
                    echo "File not found"
                fi
                ;;
            7) break ;;
            *) echo -e "${RED}Invalid!${NC}"; sleep 1 ;;
        esac
        pause
    done
}

# Network menu
network_menu() {
    while true; do
        show_banner
        echo -e "${GREEN}╔════════════════════════════╗${NC}"
        echo -e "${GREEN}║     NETWORK TOOLS          ║${NC}"
        echo -e "${GREEN}╠════════════════════════════╣${NC}"
        echo -e "${GREEN}║${NC} 1. Ping Test             ${GREEN}║${NC}"
        echo -e "${GREEN}║${NC} 2. Show IP               ${GREEN}║${NC}"
        echo -e "${GREEN}║${NC} 3. Download File         ${GREEN}║${NC}"
        echo -e "${GREEN}║${NC} 4. Speed Test            ${GREEN}║${NC}"
        echo -e "${GREEN}║${NC} 5. Back to Main          ${GREEN}║${NC}"
        echo -e "${GREEN}╚════════════════════════════╝${NC}"
        
        read -p "Select option: " choice
        case $choice in
            1) 
                read -p "Host to ping: " host
                ping -c 4 "$host"
                ;;
            2) 
                echo "Your IP:"
                curl -s ifconfig.me
                echo
                ;;
            3) 
                read -p "URL: " url
                wget "$url"
                ;;
            4) 
                pkg install speedtest-cli -y
                speedtest-cli
                ;;
            5) break ;;
            *) echo -e "${RED}Invalid!${NC}"; sleep 1 ;;
        esac
        pause
    done
}

# Plugin menu
plugin_menu() {
    show_banner
    echo -e "${CYAN}╔════════════════════════════╗${NC}"
    echo -e "${CYAN}║     PLUGINS                ║${NC}"
    echo -e "${CYAN}╠════════════════════════════╣${NC}"
    
    if [ -z "$(ls -A $PLUGIN_DIR 2>/dev/null)" ]; then
        echo -e "${YELLOW}No plugins found${NC}"
        echo -e "${YELLOW}Creating example plugin...${NC}"
        
        mkdir -p "$PLUGIN_DIR"
        cat > "$PLUGIN_DIR/example.sh" << 'EOF'
#!/bin/bash
echo "🎯 Example Plugin"
echo "This is a sample plugin"
echo "Plugin executed at: $(date)"
EOF
        chmod +x "$PLUGIN_DIR/example.sh"
    fi
    
    echo -e "${CYAN}Available plugins:${NC}"
    ls -1 "$PLUGIN_DIR" | sed 's/^/   /'
    echo -e "${CYAN}╚════════════════════════════╝${NC}"
    
    read -p "Enter plugin name to run (or 'back'): " plugin
    if [ "$plugin" = "back" ]; then
        return
    fi
    
    if [ -f "$PLUGIN_DIR/$plugin" ]; then
        bash "$PLUGIN_DIR/$plugin"
        log "Plugin executed: $plugin"
    else
        echo -e "${RED}Plugin not found!${NC}"
    fi
    pause
}
