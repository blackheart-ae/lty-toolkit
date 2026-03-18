#!/bin/bash

# Authentication module
AUTH_USER="$DATA_DIR/users.db"

auth_login() {
    if [ ! -f "$AUTH_USER" ]; then
        echo -e "${YELLOW}First time setup - Register${NC}"
        read -p "Username: " username
        read -sp "Password: " password
        echo
        echo "$username:$(echo -n "$password" | md5sum | cut -d' ' -f1)" > "$AUTH_USER"
        echo -e "\n${GREEN}Registration successful!${NC}"
        log "New user registered: $username"
    fi

    echo -e "${YELLOW}Login Required${NC}"
    read -p "Username: " username
    read -sp "Password: " password
    echo

    stored_hash=$(cut -d':' -f2 "$AUTH_USER")
    input_hash=$(echo -n "$password" | md5sum | cut -d' ' -f1)

    if [ "$input_hash" = "$stored_hash" ]; then
        echo -e "${GREEN}Login successful!${NC}"
        log "User logged in: $username"
        return 0
    else
        echo -e "${RED}Login failed!${NC}"
        log "Failed login attempt: $username"
        exit 1
    fi
}
