#!/bin/bash

# Update and install dependencies
echo "Updating system and installing dependencies..."
sudo apt update
sudo apt install -y apache2 php libapache2-mod-php curl git

# Install Composer (if needed for PHP dependencies)
echo "Installing Composer..."
curl -sS https://getcomposer.org/installer | php
sudo mv composer.phar /usr/local/bin/composer

# Clone the repository (netbox.bot)
echo "Cloning the bot repository..."
cd /var/www/html
sudo git clone https://github.com/yourusername/netbox.bot.git

# Set permissions
echo "Setting permissions..."
sudo chown -R www-data:www-data /var/www/html/netbox.bot

# Ask for Telegram Bot Token
echo "Please enter your Telegram Bot Token:"
read BOT_TOKEN

# Ask for Telegram Admin ID
echo "Please enter your Telegram Admin ID:"
read ADMIN_ID

# Save the token and admin ID into a config file
echo "Saving configuration..."
echo "BOT_TOKEN=$BOT_TOKEN" > /var/www/html/netbox.bot/config.env
echo "ADMIN_ID=$ADMIN_ID" >> /var/www/html/netbox.bot/config.env

# Restart Apache
echo "Restarting Apache..."
sudo systemctl restart apache2

echo "Installation completed successfully!"
