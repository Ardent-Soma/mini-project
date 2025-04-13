#!/bin/bash
# Prompt for username
read -p "Enter your preferred username: " username

# Validate username format
if [[ ! "$username" =~ ^[a-z][a-z0-9_]{0,31}$ ]]; then
    echo "Error: Invalid username. Must start with lowercase letter and contain only lowercase letters, numbers, or underscores."
    exit 1
fi

# Create user with home directory
if sudo useradd -m "$username"; then
    # Set password
    if sudo passwd "$username"; then
        echo "User '$username' with password created successfully"
        
        # Ask if the user should have admin privileges
        read -p "Should this user have admin privileges? (y/n): " is_admin
        if [[ "$is_admin" == "y" || "$is_admin" == "Y" ]]; then
            sudo usermod -aG sudo "$username"
            echo "Admin permissions given to '$username' successfully"
        fi
    else
        echo "Failed to set password for user '$username'"
        exit 1
    fi
else
    echo "Failed to create user '$username'"
    exit 1
fi
