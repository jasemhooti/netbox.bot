#!/bin/bash

# تنظیمات
REPO_URL="https://github.com/jasemhooti/vpn-telegram-bot.git"
INSTALL_DIR="/opt/vpn-telegram-bot"

# بررسی دسترسی root
if [ "$EUID" -ne 0 ]; then
  echo "لطفاً این اسکریپت را با دسترسی root اجرا کنید."
  exit 1
fi

# بروزرسانی سیستم
echo "بروزرسانی سیستم..."
apt update -y
apt upgrade -y

# نصب پیش‌نیازها
echo "نصب پیش‌نیازها..."
apt install -y php-cli php-mysql php-curl php-json php-mbstring composer mysql-server git

# ایجاد دایرکتوری نصب
echo "ایجاد دایرکتوری نصب..."
mkdir -p $INSTALL_DIR
cd $INSTALL_DIR

# کلون ریپازیتوری
echo "دریافت کدهای پروژه..."
git clone $REPO_URL .

# نصب وابستگی‌های Composer
echo "نصب وابستگی‌های Composer..."
composer install --no-dev --optimize-autoloader

# تنظیم دیتابیس
echo "تنظیم دیتابیس..."
mysql -e "CREATE DATABASE IF NOT EXISTS vpn_bot;"
mysql -e "CREATE USER IF NOT EXISTS 'vpn_user'@'localhost' IDENTIFIED BY 'secure_password';"
mysql -e "GRANT ALL PRIVILEGES ON vpn_bot.* TO 'vpn_user'@'localhost';"
mysql -e "FLUSH PRIVILEGES;"

# ایجاد فایل .env
echo "ایجاد فایل .env..."
if [ ! -f ".env" ]; then
  cp .env.example .env
  sed -i "s/BOT_TOKEN=your_bot_token/BOT_TOKEN=$BOT_TOKEN/" .env
  sed -i "s/ADMIN_ID=your_admin_id/ADMIN_ID=$ADMIN_ID/" .env
  sed -i "s/DB_HOST=localhost/DB_HOST=localhost/" .env
  sed -i "s/DB_DATABASE=vpn_bot/DB_DATABASE=vpn_bot/" .env
  sed -i "s/DB_USERNAME=vpn_user/DB_USERNAME=vpn_user/" .env
  sed -i "s/DB_PASSWORD=secure_password/DB_PASSWORD=secure_password/" .env
  sed -i "s/XUI_API_KEY=your_xui_api_key/XUI_API_KEY=$XUI_API_KEY/" .env
  sed -i "s/XUI_PANEL_URL=https:\/\/your-xui-panel.com/XUI_PANEL_URL=$XUI_PANEL_URL/" .env
fi

# اجرای migrations
echo "اجرای migrations..."
php artisan migrate --force

# تنظیم وب هوک تلگرام
echo "تنظیم وب هوک تلگرام..."
TELEGRAM_API_URL="https://api.telegram.org/bot$BOT_TOKEN/setWebhook"
WEBHOOK_URL="https://yourdomain.com/bot.php"
curl -s -X POST "$TELEGRAM_API_URL" -d "url=$WEBHOOK_URL"

# ایجاد سرویس systemd
echo "ایجاد سرویس systemd..."
cat > /etc/systemd/system/vpn-bot.service <<EOL
[Unit]
Description=VPN Telegram Bot
After=network.target

[Service]
User=root
WorkingDirectory=$INSTALL_DIR
ExecStart=/usr/bin/php $INSTALL_DIR/bot.php
Restart=always

[Install]
WantedBy=multi-user.target
EOL

# راه‌اندازی سرویس
echo "راه‌اندازی سرویس..."
systemctl daemon-reload
systemctl enable vpn-bot
systemctl start vpn-bot

echo "نصب با موفقیت انجام شد!"
echo "ربات شما در حال اجرا است. برای بررسی وضعیت سرویس از دستور زیر استفاده کنید:"
echo "systemctl status vpn-bot"
