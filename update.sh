#!/bin/bash

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'

clear
echo -e "${BLUE}================================${NC}"
echo -e "${GREEN}Blackheart Toolkit Updater${NC}"
echo -e "${BLUE}================================${NC}"

echo -e "${YELLOW}→${NC} Checking for updates..."

# Check if git is installed
if ! command -v git &> /dev/null; then
    echo -e "${RED}❌ Git not installed! Installing...${NC}"
    pkg install git -y
fi

# Pull latest changes
if git pull origin main | grep -q "Already up to date"; then
    echo -e "${GREEN}✅ Already up to date!${NC}"
else
    echo -e "${GREEN}✅ Update successful!${NC}"
    
    # Set permissions for new files
    echo -e "${YELLOW}→${NC} Setting permissions..."
    chmod +x lty.sh 2>/dev/null
    chmod +x core/*.sh 2>/dev/null
    chmod +x plugins/*.sh 2>/dev/null
    
    echo -e "${GREEN}✅ Permissions updated!${NC}"
fi

echo ""
echo -e "${BLUE}================================${NC}"
echo -e "${GREEN}Version: 2.0${NC}"
echo -e "${BLUE}================================${NC}"
