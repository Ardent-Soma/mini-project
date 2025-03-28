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
    sudo fdisk /dev/$disk
}

# Function to format a partition
format_partition() {
    lsblk
    read -p "Enter partition name (e.g., sdb1): " partition
    read -p "Enter filesystem type (ext4, xfs, etc.): " fstype
    sudo mkfs -t $fstype /dev/$partition
    echo "Partition formatted successfully."
}

# Function to mount a partition
mount_partition() {
    lsblk
    read -p "Enter partition name (e.g., sdb1): " partition
    read -p "Enter mount point (e.g., /mnt/mydrive): " mountpoint
    sudo mkdir -p $mountpoint
    sudo mount /dev/$partition $mountpoint
    echo "Partition mounted at $mountpoint."
}

# Function to unmount a partition
unmount_partition() {
    df -h
    read -p "Enter mount point to unmount (e.g., /mnt/mydrive): " mountpoint
    sudo umount $mountpoint
    echo "Partition unmounted."
}

# Function to display disk usage
show_disk_usage() {
    df -h
}

# Main menu function
main_menu() {
    while true; do
        echo "\nFile System Management Menu"
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

