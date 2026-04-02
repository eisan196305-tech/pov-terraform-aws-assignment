#!/bin/bash
set -e

# 1. Install dependencies
apt-get update -y
apt-get install -y unzip curl

# 2. Download counting binary
curl -L https://github.com/hashicorp/demo-consul-101/releases/download/v0.0.5/counting-service_linux_amd64.zip \
     -o /tmp/counting-service.zip

# 3. Unzip and move binary
cd /tmp
unzip -o counting-service.zip
mv /tmp/counting-service_linux_amd64 /usr/local/bin/counting-service
chmod +x /usr/local/bin/counting-service

# 4. Create systemd service
cat > /etc/systemd/system/counting.service << 'EOF'
[Unit]
Description=Counting Service
After=network.target

[Service]
Environment=PORT=9001
ExecStart=/usr/local/bin/counting-service
Restart=always
User=root

[Install]
WantedBy=multi-user.target
EOF

# 5. Start service
systemctl daemon-reload
systemctl enable counting.service
systemctl start counting.service