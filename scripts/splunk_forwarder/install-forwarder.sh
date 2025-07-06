#!/bin/bash

# Đường dẫn và thông tin cài đặt Splunk Universal Forwarder
SPLUNKFWD_DIR="/opt/splunkforwarder"
SPLUNKFWD_USER="splunkfwd"
SPLUNKFWD_GROUP="splunkfwd"
SPLUNKFWD_PASSWORD="VIN@02025SIEM!@#$"
SPLUNKFWD_DEB="splunkforwarder-9.4.3-237ebbd22314-linux-amd64.deb"
SPLUNKFWD_URL="https://download.splunk.com/products/universalforwarder/releases/9.4.3/linux/$SPLUNKFWD_DEB"

echo "=== Tải về Splunk Universal Forwarder gói cài đặt .deb ==="
wget -O $SPLUNKFWD_DEB "$SPLUNKFWD_URL"

echo "=== Cài đặt Splunk Universal Forwarder bằng dpkg ==="
dpkg -i $SPLUNKFWD_DEB

echo "=== Cấp quyền cho thư mục Splunk Forwarder ==="
chown -R $SPLUNKFWD_USER:$SPLUNKFWD_GROUP $SPLUNKFWD_DIR

echo "=== Khởi động lần đầu để chấp nhận license và đặt mật khẩu ==="
sudo -u $SPLUNKFWD_USER $SPLUNKFWD_DIR/bin/splunk start --accept-license --seed-passwd "$SPLUNKFWD_PASSWORD"

echo "=== Dừng Splunk Forwarder lại để thiết lập boot-start ==="
sudo -u $SPLUNKFWD_USER $SPLUNKFWD_DIR/bin/splunk stop

echo "=== Thiết lập Splunk Forwarder khởi động cùng hệ thống ==="
$SPLUNKFWD_DIR/bin/splunk enable boot-start --user $SPLUNKFWD_USER

echo "=== Khởi động lại Splunk Forwarder ==="
sudo -u $SPLUNKFWD_USER $SPLUNKFWD_DIR/bin/splunk start

echo "=== Cài đặt Splunk Universal Forwarder hoàn tất ==="