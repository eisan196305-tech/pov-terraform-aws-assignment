#!/bin/bash
set -e

# 1. Install dependencies
apt-get update -y
apt-get install -y unzip curl

# 2. Download dashboard binary
curl -L https://github.com/hashicorp/demo-consul-101/releases/download/v0.0.5/dashboard-service_linux_amd64.zip \
     -o /tmp/dashboard-service.zip

# 3. Unzip and move binary
cd /tmp
unzip -o dashboard-service.zip
mv /tmp/dashboard-service_linux_amd64 /usr/local/bin/dashboard-service
chmod +x /usr/local/bin/dashboard-service

# 4. Create systemd service
cat > /etc/systemd/system/dashboard.service << EOF
[Unit]
Description=Dashboard Service
After=network.target

[Service]
Environment=PORT=9002
Environment=COUNTING_SERVICE_URL=http://${counting_private_ip}:9001
ExecStartPre=/bin/bash -c 'until curl -sf http://${counting_private_ip}:9001; do sleep 3; done'
ExecStart=/usr/local/bin/dashboard-service
Restart=always
User=root

[Install]
WantedBy=multi-user.target
EOF

# 5. Start service
systemctl daemon-reload
systemctl enable dashboard.service
systemctl start dashboard.service