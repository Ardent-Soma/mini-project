#!bin/bash

#to enable and check status of ufw (ufw means uncompliacted firewall)
sudo systemctl enable ufw
sudo systemctl start ufw
sudo systemctl status ufw

#to enable and check status of cron (cron is for scheduling tasks)
sudo systemctl enable cron
sudo systemctl start cron 
sudo systemctl status cron


#to enable and check status of nginx (a web server)
sudo systemctl enable nginx
sudo systemctl start nginx 
sudo systemctl status nginx

