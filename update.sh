#!/bin/bash

GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${YELLOW}Checking for updates...${NC}"

if git pull origin main | grep -q "Already up to date"; then
  echo -e "${GREEN}✅ Already up to date!${NC}"
else
  echo -e "${GREEN}✅ Update successful!${NC}"
  chmod +x lty.sh
fi
