#!/bin/bash


echo "enter your preferred username"
read -p "preferred username:" username
sudo useradd -m "$username"
sudo passwd "$username"

echo "user '$username' with password created successfully"

#check if the username is an admin
if [ "$username" = "admin" ]; then
    sudo usermod -aG sudo "$username"
    echo "sudo permission given to '$username' successfully"
fi


