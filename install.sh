#!/bin/bash
set -e

# رنگ های ترمینال
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${YELLOW}📦 Starting NetBox Bot Installation...${NC}"

# نصب پیش نیازها
echo -e "${GREEN}Updating system packages...${NC}"
sudo apt-get update -y
sudo apt-get upgrade -y

echo -e "${GREEN}Installing dependencies...${NC}"
sudo apt-get install -y curl git mysql-server nodejs npm

# تنظیم دیتابیس MySQL
echo -e "${GREEN}Configuring MySQL database...${NC}"
sudo mysql -e "CREATE DATABASE IF NOT EXISTS netbox;"
sudo mysql -e "CREATE USER 'netbox_user'@'localhost' IDENTIFIED BY 'NetboxPass123!';"
sudo mysql -e "GRANT ALL PRIVILEGES ON netbox.* TO 'netbox_user'@'localhost';"
sudo mysql -e "FLUSH PRIVILEGES;"

# دانلود پروژه
echo -e "${GREEN}Downloading NetBox Bot...${NC}"
git clone https://github.com/YOUR_USERNAME/netbox-bot.git /opt/netbox
cd /opt/netbox

# تنظیم فایل محیطی
echo -e "${GREEN}Creating environment file...${NC}"
cat <<EOL > .env
BOT_TOKEN=YOUR_BOT_TOKEN
DB_HOST=localhost
DB_USER=netbox_user
DB_PASS=NetboxPass123!
DB_NAME=netbox
JWT_SECRET=$(openssl rand -hex 32)
XUI_PANEL_URL=http://localhost:54321
XUI_USERNAME=admin
XUI_PASSWORD=admin
PORT=3000
TZ=Asia/Tehran
EOL

# نصب وابستگی ها
echo -e "${GREEN}Installing Node.js dependencies...${NC}"
npm install

# اجرای دائمی با PM2
echo -e "${GREEN}Setting up PM2 process manager...${NC}"
sudo npm install -g pm2
pm2 start app.js --name "netbox-panel"
pm2 start bot/bot.js --name "netbox-bot"
pm2 save
pm2 startup

echo -e "${GREEN}✅ Installation Complete!${NC}"
echo -e "${YELLOW}Admin Panel: http://$(curl -s ifconfig.me):3000${NC}"
echo -e "${YELLOW}Don't forget to:"
echo -e "1. Configure X-UI panel"
echo -e "2. Set your Telegram bot token in .env file${NC}"
