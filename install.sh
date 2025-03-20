#!/bin/bash

echo "Installing dependencies..."

# نصب PHP و Composer
sudo apt update
sudo apt install php php-cli php-mbstring php-curl php-xml php-mysql -y
curl -sS https://getcomposer.org/installer | php
sudo mv composer.phar /usr/local/bin/composer

# نصب کتابخانه‌های PHP
composer install

echo "Enter your Telegram Bot token:"
read BOT_TOKEN

echo "Enter your admin user ID (numeric):"
read ADMIN_ID

# ذخیره تنظیمات در config.php
echo "<?php
define('BOT_TOKEN', '$BOT_TOKEN');
define('ADMIN_ID', $ADMIN_ID);
" > ./config/config.php

echo "Installation complete!"
