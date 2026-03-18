#!/bin/bash

# Utility functions

# Check and install dependencies
check_deps() {
    deps=("figlet" "lolcat" "whiptail" "curl" "wget")
    for dep in "${deps[@]}"; do
        if ! command -v $dep &> /dev/null; then
            echo -e "${YELLOW}Installing $dep...${NC}"
            pkg install $dep -y
        fi
    done
}

# Show banner
show_banner() {
    clear
    if command -v figlet &> /dev/null; then
        figlet "Blackheart" | lolcat
    else
        echo -e "${BLUE}================================${NC}"
        echo -e "${GREEN}   BLACKHEART TOOLKIT v$VERSION${NC}"
        echo -e "${BLUE}================================${NC}"
    fi
    echo -e "${CYAN}Developed by Blackheart${NC}"
    echo ""
}

# Pause function
pause() {
    read -p "Press Enter to continue..."
}

# Safe execution
safe_exec() {
    if "$@"; then
        echo -e "${GREEN}✅ Success${NC}"
        log "Command executed: $*"
    else
        echo -e "${RED}❌ Failed${NC}"
        log "Command failed: $*"
    fi
}
