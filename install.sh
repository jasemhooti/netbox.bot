#!/bin/bash
set -e

# رنگ بندی ترمینال
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${YELLOW}
   ███╗   ██╗███████╗████████╗██████╗  ██████╗ ██╗  ██╗
   ████╗  ██║██╔════╝╚══██╔══╝██╔══██╗██╔═══██╗╚██╗██╔╝
   ██╔██╗ ██║█████╗     ██║   ██████╔╝██║   ██║ ╚███╔╝ 
   ██║╚██╗██║██╔══╝     ██║   ██╔══██╗██║   ██║ ██╔██╗ 
   ██║ ╚████║███████╗   ██║   ██║  ██║╚██████╔╝██╔╝ ██╗
   ╚═╝  ╚═══╝╚══════╝   ╚═╝   ╚═╝  ╚═╝ ╚═════╝ ╚═╝  ╚═╝
${NC}"

# مرحله ۱: آپدیت سیستم
echo -e "${GREEN}🔄 به روزرسانی سیستم...${NC}"
sudo apt update -y
sudo apt upgrade -y

# مرحله ۲: نصب پیش نیازها
echo -e "${GREEN}📦 نصب وابستگی ها...${NC}"
sudo apt install -y curl git mysql-server nodejs npm

# مرحله ۳: تنظیمات MySQL
echo -e "${GREEN}🔧 تنظیم دیتابیس...${NC}"
sudo mysql -e "CREATE DATABASE IF NOT EXISTS netbox;"
sudo mysql -e "CREATE USER IF NOT EXISTS 'netbox'@'localhost' IDENTIFIED BY 'Netbox@1234';"
sudo mysql -e "GRANT ALL PRIVILEGES ON netbox.* TO 'netbox'@'localhost';"
sudo mysql -e "FLUSH PRIVILEGES;"

# مرحله ۴: دانلود پروژه
# مرحله ۴: دانلود پروژه با SSH
echo -e "${GREEN}📥 دانلود سورس کد...${NC}"
git clone git@github.com:jasemhooti/netbox-bot.git /opt/netbox
cd /opt/netbox

echo "🚀 نصب وابستگی ها..."
npm install

echo "🎉 اجرای ربات!"
npm start

# مرحله ۵: تنظیم فایل محیطی
echo -e "${GREEN}⚙️ ایجاد فایل تنظیمات...${NC}"
sudo cat <<EOL > .env
BOT_TOKEN=YOUR_BOT_TOKEN
DB_HOST=localhost
DB_USER=netbox
DB_PASS=Netbox@1234
DB_NAME=netbox
JWT_SECRET=$(openssl rand -hex 32)
XUI_PANEL_URL=http://localhost:54321
XUI_USERNAME=admin
XUI_PASSWORD=admin
PORT=3000
TZ=Asia/Tehran
EOL

# مرحله ۶: نصب پکیج ها
echo -e "${GREEN}🚀 نصب وابستگی های Node.js...${NC}"
sudo npm install

# مرحله ۷: نصب PM2 برای اجرای دائمی
echo -e "${GREEN}⚡ نصب PM2...${NC}"
sudo npm install -g pm2

# مرحله ۸: اجرای برنامه
echo -e "${GREEN}🎉 راه اندازی سرویس...${NC}"
sudo pm2 start app.js --name "netbox-panel"
sudo pm2 start bot/bot.js --name "netbox-bot"
sudo pm2 save
sudo pm2 startup

echo -e "${GREEN}
✅ نصب با موفقیت انجام شد!
🔗 پنل مدیریت: http://$(curl -s ifconfig.me):3000
${NC}"

echo -e "${YELLOW}
⚠️ نکات مهم:
1. در فایل /opt/netbox/.env مقدار BOT_TOKEN را تنظیم کنید
2. دستورات مدیریتی:
   - مشاهده لاگ: pm2 logs
   - ریستارت: pm2 restart all
   - وضعیت سرویس: pm2 list
${NC}"

