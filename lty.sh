#!/bin/bash

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

clear
echo -e "${BLUE}===================================${NC}"
echo -e "${GREEN}  Blackheart Termux Toolkit v1.0${NC}"
echo -e "${BLUE}===================================${NC}"
echo "1. System Update"
echo "2. Install Package"
echo "3. Exit"
echo -e "${BLUE}===================================${NC}"

read -p "Select option: " choice

case $choice in
  1) 
     echo -e "${YELLOW}Updating system...${NC}"
     pkg update && pkg upgrade
     echo -e "${GREEN}✅ Update complete!${NC}"
     ;;
  2) 
     read -p "Enter package name: " pkg
     echo -e "${YELLOW}Installing $pkg...${NC}"
     pkg install $pkg
     ;;
  3) 
     echo -e "${GREEN}Thanks for using Blackheart Toolkit!${NC}"
     exit 0
     ;;
  *) 
     echo -e "${RED}Invalid option!${NC}"
     ;;
esac
