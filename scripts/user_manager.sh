#!/bin/bash

# ----------------------------------------
# Simple User Management Script
# ----------------------------------------
# This script allows you to:
# 1. Create a new user
# 2. Modify an existing user
# 3. Remove a user
# 4. Set up SSH keys for a user
# 5. Enforce a basic password policy
# 6. Add a user to a group
# ----------------------------------------

# Ensure the script is run as root
if [[ "$(id -u)" -ne 0 ]]; then
    echo "Please run this script as root or using sudo."
    exit 1
fi

# Function to create a new user
create_user() {
    read -p "Enter the new username: " username
    if id "$username" &>/dev/null; then
        echo "User '$username' already exists."
        return 1
    fi

    # Create the user with a home directory
    useradd -m "$username"
    echo "User '$username' has been created."

    # Set the user's password
    passwd "$username"
}

# Function to modify an existing user
modify_user() {
    read -p "Enter the username to modify: " username
    if ! id "$username" &>/dev/null; then
        echo "User '$username' does not exist."
        return 1
    fi

    read -p "Enter the new username: " new_username
    if id "$new_username" &>/dev/null; then
        echo "Username '$new_username' is already taken."
        return 1
    fi

    # Change the username
    usermod -l "$new_username" "$username"
    echo "User '$username' has been renamed to '$new_username'."
}

# Function to remove a user
remove_user() {
    read -p "Enter the username to remove: " username
    if ! id "$username" &>/dev/null; then
        echo "User '$username' does not exist."
        return 1
    fi

    # Delete the user and their home directory
    userdel -r "$username"
    echo "User '$username' has been removed."
}

# Function to set up SSH keys for a user
setup_ssh_keys() {
    read -p "Enter the username for SSH key setup: " username
    if ! id "$username" &>/dev/null; then
        echo "User '$username' does not exist."
        return 1
    fi

    # Create .ssh directory in the user's home directory
    sudo -u "$username" mkdir -p "/home/$username/.ssh"
    chmod 700 "/home/$username/.ssh"

    # Generate SSH key pair
    sudo -u "$username" ssh-keygen -t rsa -b 2048 -f "/home/$username/.ssh/id_rsa" -N ""
    echo "SSH keys have been generated for '$username'."

    # Add the public key to authorized_keys
    cat "/home/$username/.ssh/id_rsa.pub" >> "/home/$username/.ssh/authorized_keys"
    chmod 600 "/home/$username/.ssh/authorized_keys"
    echo "Public key added to authorized_keys for '$username'."
}

# Function to enforce a basic password policy
enforce_password_policy() {
    read -p "Enter the username to enforce password policy: " username
    if ! id "$username" &>/dev/null; then
        echo "User '$username' does not exist."
        return 1
    fi

    # Set password to expire every 30 days
    chage -M 30 "$username"
    echo "Password policy enforced: '$username' must change password every 30 days."
}

# Function to add a user to a group
add_user_to_group() {
    read -p "Enter the username to add to a group: " username
    if ! id "$username" &>/dev/null; then
        echo "User '$username' does not exist."
        return 1
    fi

    read -p "Enter the group name: " group
    if ! getent group "$group" &>/dev/null; then
        echo "Group '$group' does not exist. Creating it now."
        groupadd "$group"
    fi

    # Add the user to the group
    usermod -aG "$group" "$username"
    echo "User '$username' has been added to group '$group'."
}

# Main menu
while true; do
    echo "----------------------------------------"
    echo "User Management Menu"
    echo "1) Create a new user"
    echo "2) Modify an existing user"
    echo "3) Remove a user"
    echo "4) Set up SSH keys for a user"
    echo "5) Enforce password policy for a user"
    echo "6) Add a user to a group"
    echo "7) Exit"
    echo "----------------------------------------"
    read -p "Please select an option (1-7): " choice

    case "$choice" in
        1) create_user ;;
        2) modify_user ;;
        3) remove_user ;;
        4) setup_ssh_keys ;;
        5) enforce_password_policy ;;
        6) add_user_to_group ;;
        7) echo "Exiting the script. Goodbye!"; exit 0 ;;
        *) echo "Invalid option. Please enter a number between 1 and 7." ;;
    esac
done

