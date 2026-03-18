#!/bin/bash

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

clear
echo -e "${BLUE}================================${NC}"
echo -e "${GREEN}Blackheart Toolkit Pro v2.0 Installer${NC}"
echo -e "${BLUE}================================${NC}"

echo -e "${YELLOW}→${NC} Updating packages..."
pkg update -y

echo -e "${YELLOW}→${NC} Installing required packages..."
pkg install -y git figlet lolcat curl wget ncurses-utils

echo -e "${YELLOW}→${NC} Setting permissions..."
chmod +x lty.sh
chmod +x core/*.sh 2>/dev/null
chmod +x plugins/*.sh 2>/dev/null

echo ""
echo -e "${GREEN}✅ Installation Complete!${NC}"
echo ""
echo "Run tool using:"
echo -e "${BLUE}cd lty-toolkit && ./lty.sh${NC}"
