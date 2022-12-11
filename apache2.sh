#!/bin/bash

sudo apt-get update && sudo apt -y install apache2
sudo sed -i 's/Listen 80/Listen 8080/g' /etc/apache2/ports.conf
sudo systemctl restart apache2 && sudo service apache2 restart

echo '<!doctype html><html><body><h1>Hello You Successfully was able to run a webserver on GCP with Terraform!</h1></body></html>' | sudo tee /var/www/html/index.html
