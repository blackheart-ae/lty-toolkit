#!/bin/bash

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
CYAN='\033[0;36m'
NC='\033[0m'

# Error handling
set -euo pipefail

# Log file
LOG_FILE="$HOME/.lty_install.log"

# Log function
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$LOG_FILE"
}

# Safe execution function
safe_exec() {
    if "$@" 2>/dev/null; then
        echo -e "${GREEN}✅ Success${NC}"
        log "Success: $*"
    else
        echo -e "${RED}❌ Failed${NC}"
        log "Failed: $*"
        return 1
    fi
}

clear
echo -e "${BLUE}================================${NC}"
echo -e "${GREEN}Blackheart Toolkit Pro v2.0 Installer${NC}"
echo -e "${BLUE}================================${NC}"
echo ""
log "Installation started"

# ============================================
# STEP 1: UPDATE SYSTEM
# ============================================
echo -e "${YELLOW}[1/6]${NC} Updating packages..."
safe_exec pkg update -y
safe_exec pkg upgrade -y

# ============================================
# STEP 2: INSTALL BASE PACKAGES
# ============================================
echo -e "${YELLOW}[2/6]${NC} Installing base packages..."
safe_exec pkg install -y git curl wget ncurses-utils

# ============================================
# STEP 3: INSTALL PYTHON (CRITICAL FOR LOLCAT)
# ============================================
echo -e "${YELLOW}[3/6]${NC} Installing Python..."
safe_exec pkg install python -y
safe_exec pkg install python-pip -y

# Get Python version and path
PYTHON_PATH=$(which python)
PYTHON_VERSION=$(python --version 2>&1 | cut -d' ' -f2 | cut -d'.' -f1-2)
log "Python installed: $PYTHON_PATH (version $PYTHON_VERSION)"

# ============================================
# STEP 4: FIX LOLCAT PYTHON INTERPRETER ERROR
# ============================================
echo -e "${YELLOW}[4/6]${NC} Fixing lolcat Python interpreter..."

# Remove old lolcat if exists
pkg uninstall lolcat -y 2>/dev/null || true
rm -f $PREFIX/bin/lolcat 2>/dev/null || true

# Install lolcat via pip (more reliable)
echo -e "${YELLOW}   → Installing lolcat via pip...${NC}"
pip install lolcat > /dev/null 2>&1

# Find where lolcat was installed
LOLCAT_PATH=$(find $PREFIX -name "lolcat" -type f 2>/dev/null | grep -E "bin/lolcat|local/bin/lolcat" | head -1)

if [ -z "$LOLCAT_PATH" ]; then
    # Try to find in site-packages
    LOLCAT_PATH=$(find $PREFIX/lib/python* -name "lolcat.py" 2>/dev/null | head -1)
    if [ -n "$LOLCAT_PATH" ]; then
        # Create wrapper script
        cat > $PREFIX/bin/lolcat << EOF
#!/usr/bin/env python
import sys
from lolcat import main
if __name__ == "__main__":
    sys.exit(main())
EOF
        chmod +x $PREFIX/bin/lolcat
        LOLCAT_PATH="$PREFIX/bin/lolcat"
    fi
fi

# Create python3.12 symlink if needed
if [ ! -f "$PREFIX/bin/python3.12" ]; then
    echo -e "${YELLOW}   → Creating Python symlink...${NC}"
    ln -sf $PYTHON_PATH $PREFIX/bin/python3.12
    log "Created symlink: $PREFIX/bin/python3.12 -> $PYTHON_PATH"
fi

# Fix lolcat shebang if file exists
if [ -f "$PREFIX/bin/lolcat" ]; then
    # Change shebang to use correct Python
    sed -i "1s|.*|#!$PYTHON_PATH|" $PREFIX/bin/lolcat
    chmod +x $PREFIX/bin/lolcat
    log "Fixed lolcat shebang to use $PYTHON_PATH"
    echo -e "${GREEN}   ✅ Lolcat fixed!${NC}"
else
    # Create simple lolcat alternative
    cat > $PREFIX/bin/lolcat << 'EOF'
#!/bin/bash
# Simple lolcat alternative
while IFS= read -r line; do
    for ((i=0; i<${#line}; i++)); do
        char="${line:$i:1}"
        color=$((31 + i % 7))
        echo -ne "\033[1;${color}m$char\033[0m"
    done
    echo
done
EOF
    chmod +x $PREFIX/bin/lolcat
    echo -e "${GREEN}   ✅ Created lolcat alternative!${NC}"
fi

# Test lolcat
echo -e "${YELLOW}   → Testing lolcat...${NC}"
if echo "Blackheart Toolkit" | lolcat 2>/dev/null; then
    echo -e "${GREEN}   ✅ Lolcat working correctly!${NC}"
    log "Lolcat test passed"
else
    echo -e "${YELLOW}   ⚠️ Lolcat may not work with colors, but tool will run fine${NC}"
    log "Lolcat test failed but continuing"
fi

# ============================================
# STEP 5: INSTALL FIGLET AND OTHER TOOLS
# ============================================
echo -e "${YELLOW}[5/6]${NC} Installing additional tools..."
safe_exec pkg install figlet -y

# Install whiptail for GUI
safe_exec pkg install whiptail -y

# Install mpv for music
safe_exec pkg install mpv -y

# ============================================
# STEP 6: SETUP MUSIC
# ============================================
echo -e "${YELLOW}[6/6]${NC} Setting up music..."

# Create music directory
mkdir -p ~/storage/music/termux-music

# Download sample music if not exists
if [ ! -f ~/storage/music/termux-music/intense.mp3 ]; then
    echo -e "${YELLOW}   → Downloading sample music...${NC}"
    cd ~/storage/music/termux-music
    wget -q -O intense.mp3 https://samplelib.com/lib/preview/mp3/sample-3s.mp3 2>/dev/null || true
    cd ~/lty-toolkit 2>/dev/null || cd ~
    echo -e "${GREEN}   ✅ Music downloaded!${NC}"
fi

# ============================================
# SET PERMISSIONS
# ============================================
echo -e "${YELLOW}   → Setting permissions...${NC}"
chmod +x lty.sh 2>/dev/null || true
chmod +x core/*.sh 2>/dev/null || true
chmod +x plugins/*.sh 2>/dev/null || true

# ============================================
# VERIFICATION
# ============================================
echo ""
echo -e "${BLUE}================================${NC}"
echo -e "${GREEN}✅ Installation Complete!${NC}"
echo -e "${BLUE}================================${NC}"
echo ""
echo -e "${CYAN}📊 Verification:${NC}"
echo -n "   Python      : "; python --version 2>/dev/null || echo "Not found"
echo -n "   Lolcat      : "; lolcat --version 2>/dev/null | head -1 || echo "Alternative installed"
echo -n "   Figlet      : "; figlet -v 2>/dev/null | head -1 || echo "Not found"
echo -n "   MPV         : "; mpv --version 2>/dev/null | head -1 || echo "Not found"
echo ""
echo -e "${GREEN}🚀 Run tool using:${NC}"
echo -e "${BLUE}   cd lty-toolkit && ./lty.sh${NC}"
echo ""
log "Installation completed successfully"
