#!/bin/bash
echo "✅ Installing NetBox Bot..."
sudo apt update
sudo apt install -y git
git clone https://github.com/jasemhooti/netbox-bot.git /opt/netbox
cd /opt/netbox
npm install
npm start
