#!/bin/bash

echo "🔹 نصب پیش‌نیازهای پروژه در حال انجام است..."

# بروزرسانی مخازن و نصب PHP + افزونه‌های مورد نیاز
sudo apt update
sudo apt install -y php php-cli php-mbstring php-curl php-xml php-mysql unzip

# نصب Composer (مدیریت وابستگی‌های PHP)
curl -sS https://getcomposer.org/installer | php
sudo mv composer.phar /usr/local/bin/composer

# کلون کردن پروژه (در صورتی که هنوز کلون نشده باشد)
if [ ! -d "telegram-bot" ]; then
    git clone https://github.com/YOUR_GITHUB_USERNAME/YOUR_REPOSITORY.git telegram-bot
fi

# ورود به پوشه پروژه
cd telegram-bot

# نصب وابستگی‌های پروژه
composer install

echo "✅ نصب پیش‌نیازها با موفقیت انجام شد!"

# درخواست اطلاعات ربات از کاربر
echo "🛠️ حالا توکن ربات تلگرام رو وارد کن:"
read BOT_TOKEN

echo "🛠️ حالا آیدی عددی ادمین رو وارد کن:"
read ADMIN_ID

# ذخیره اطلاعات در فایل config.php
echo "<?php
define('BOT_TOKEN', '$BOT_TOKEN');
define('ADMIN_ID', $ADMIN_ID);
" > ./config/config.php

echo "✅ تنظیمات انجام شد! حالا می‌تونی ربات رو اجرا کنی."
