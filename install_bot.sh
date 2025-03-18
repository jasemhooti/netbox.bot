#!/bin/bash

# Update and install required packages
sudo apt-get update
sudo apt-get install -y php-cli php-curl git unzip

# Install Composer (if needed for dependencies)
if ! command -v composer &> /dev/null
then
    echo "Installing Composer..."
    php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
    php composer-setup.php --install-dir=/usr/local/bin --filename=composer
    php -r "unlink('composer-setup.php');"
fi

# Clone your bot repository
echo "Cloning bot repository..."
git clone https://github.com/yourusername/your-repo.git /var/www/telegram-bot
cd /var/www/telegram-bot

# Install PHP dependencies (if you have a composer.json file)
if [ -f "composer.json" ]; then
    echo "Installing PHP dependencies..."
    composer install --no-dev --optimize-autoloader
fi

# Set permissions
sudo chown -R www-data:www-data /var/www/telegram-bot
sudo chmod -R 755 /var/www/telegram-bot

# Configure webhook
read -p "Enter your bot token: " bot_token
read -p "Enter your server domain (e.g., https://yourserver.com): " server_domain

webhook_url="$server_domain/bot.php"
curl -F "url=$webhook_url" https://api.telegram.org/bot$bot_token/setWebhook

# Create a systemd service to run the bot
echo "Creating systemd service..."
sudo bash -c 'cat > /etc/systemd/system/telegram-bot.service <<EOF
[Unit]
Description=Telegram Bot Service
After=network.target

[Service]
User=www-data
Group=www-data
WorkingDirectory=/var/www/telegram-bot
ExecStart=/usr/bin/php /var/www/telegram-bot/bot.php
Restart=always

[Install]
WantedBy=multi-user.target
EOF'

# Reload systemd and start the bot service
sudo systemctl daemon-reload
sudo systemctl start telegram-bot
sudo systemctl enable telegram-bot

echo "Bot installation completed! Your bot is now running."
