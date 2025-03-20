#!/bin/bash
# تغییر دسترسی و اجرای bot.sh
chmod +x $INSTALL_DIR/bot.sh
$INSTALL_DIR/bot.sh

# تنظیمات
REPO_URL="https://github.com/jasemhooti/netbox.git"
INSTALL_DIR="/opt/netbox"

# بررسی دسترسی root
if [ "$EUID" -ne 0 ]; then
  echo "لطفاً این اسکریپت را با دسترسی root اجرا کنید."
  exit 1
fi

# دریافت اطلاعات از کاربر
read -p "لطفاً توکن ربات تلگرام را وارد کنید: " BOT_TOKEN
read -p "لطفاً آیدی عددی ادمین را وارد کنید: " ADMIN_ID
read -p "لطفاً نام کاربری دیتابیس را وارد کنید: " DB_USER
read -p "لطفاً رمز عبور دیتابیس را وارد کنید: " DB_PASS
read -p "لطفاً آدرس دامنه خود را وارد کنید (مثال: https://example.com): " DOMAIN_URL

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
mysql -e "CREATE DATABASE IF NOT EXISTS netbox_db;"
mysql -e "CREATE USER IF NOT EXISTS '$DB_USER'@'localhost' IDENTIFIED BY '$DB_PASS';"
mysql -e "GRANT ALL PRIVILEGES ON netbox_db.* TO '$DB_USER'@'localhost';"
mysql -e "FLUSH PRIVILEGES;"

# ایجاد فایل .env
echo "ایجاد فایل .env..."
cat > .env <<EOL
BOT_TOKEN=$BOT_TOKEN
ADMIN_ID=$ADMIN_ID
DB_HOST=localhost
DB_DATABASE=netbox_db
DB_USERNAME=$DB_USER
DB_PASSWORD=$DB_PASS
DOMAIN_URL=$DOMAIN_URL
EOL

# اجرای migrations
echo "اجرای migrations..."
php artisan migrate --force

# تنظیم وب هوک تلگرام
echo "تنظیم وب هوک تلگرام..."
TELEGRAM_API_URL="https://api.telegram.org/bot$BOT_TOKEN/setWebhook"
WEBHOOK_URL="$DOMAIN_URL/bot.php"
curl -s -X POST "$TELEGRAM_API_URL" -d "url=$WEBHOOK_URL"

# ایجاد سرویس systemd
echo "ایجاد سرویس systemd..."
cat > /etc/systemd/system/netbox.service <<EOL
[Unit]
Description=NetBox Telegram Bot
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
systemctl enable netbox
systemctl start netbox

echo "نصب با موفقیت انجام شد!"
echo "ربات شما در حال اجرا است. برای بررسی وضعیت سرویس از دستور زیر استفاده کنید:"
echo "systemctl status netbox"
