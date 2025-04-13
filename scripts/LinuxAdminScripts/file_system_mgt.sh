#!/bin/bash

# Function to list available disks
list_disks() {
    echo "Available Disks:"
    lsblk -d -o NAME,SIZE,TYPE | grep disk
}

# Function to create a new partition
create_partition() {
    list_disks
    read -p "Enter disk name (e.g., sdb): " disk
    
    # Validate disk exists
    if [[ ! -b "/dev/$disk" ]]; then
        echo "Error: Disk /dev/$disk does not exist!"
        return 1
    fi
    
    # Confirm partitioning
    read -p "WARNING: Partitioning disk /dev/$disk may result in DATA LOSS. Continue? (y/n): " confirm
    if [[ "$confirm" != "y" && "$confirm" != "Y" ]]; then
        echo "Operation cancelled."
        return 1
    fi
    
    sudo fdisk "/dev/$disk"
}

# Function to format a partition
format_partition() {
    lsblk
    read -p "Enter partition name (e.g., sdb1): " partition
    
    # Validate partition exists
    if [[ ! -b "/dev/$partition" ]]; then
        echo "Error: Partition /dev/$partition does not exist!"
        return 1
    fi
    
    read -p "Enter filesystem type (ext4, xfs, etc.): " fstype
    
    # Confirm formatting
    read -p "WARNING: Formatting /dev/$partition will ERASE ALL DATA. Continue? (y/n): " confirm
    if [[ "$confirm" != "y" && "$confirm" != "Y" ]]; then
        echo "Operation cancelled."
        return 1
    fi
    
    if sudo mkfs -t "$fstype" "/dev/$partition"; then
        echo "Partition formatted successfully."
    else
        echo "Failed to format partition."
    fi
}

# Function to mount a partition
mount_partition() {
    lsblk
    read -p "Enter partition name (e.g., sdb1): " partition
    
    # Validate partition exists
    if [[ ! -b "/dev/$partition" ]]; then
        echo "Error: Partition /dev/$partition does not exist!"
        return 1
    fi
    
    read -p "Enter mount point (e.g., /mnt/mydrive): " mountpoint
    
    # Create mountpoint if needed
    if sudo mkdir -p "$mountpoint"; then
        if sudo mount "/dev/$partition" "$mountpoint"; then
            echo "Partition mounted at $mountpoint."
        else
            echo "Failed to mount partition."
        fi
    else
        echo "Failed to create mount point."
    fi
}

# Function to unmount a partition
unmount_partition() {
    df -h
    read -p "Enter mount point to unmount (e.g., /mnt/mydrive): " mountpoint
    
    # Check if mountpoint is valid
    if ! grep -q "$mountpoint" /proc/mounts; then
        echo "Error: $mountpoint is not a valid mount point!"
        return 1
    fi
    
    if sudo umount "$mountpoint"; then
        echo "Partition unmounted."
    else
        echo "Failed to unmount partition."
    fi
}

# Function to display disk usage
show_disk_usage() {
    df -h
}

# Main menu function
main_menu() {
    while true; do
        echo -e "\nFile System Management Menu"
        echo "1) List available disks"
        echo "2) Create a new partition"
        echo "3) Format a partition"
        echo "4) Mount a partition"
        echo "5) Unmount a partition"
        echo "6) Show disk usage"
        echo "7) Exit"
        read -p "Choose an option: " choice
        case $choice in
            1) list_disks ;;
            2) create_partition ;;
            3) format_partition ;;
            4) mount_partition ;;
            5) unmount_partition ;;
            6) show_disk_usage ;;
            7) echo "Exiting..."; exit 0 ;;
            *) echo "Invalid option, please try again." ;;
        esac
    done
}

# Run the main menu
main_menu
