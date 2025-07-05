#!/bin/bash

# Đường dẫn cài đặt Splunk
SPLUNK_DIR="/opt/splunk"
SPLUNK_USER="splunk"
SPLUNK_GROUP="splunk"
SPLUNK_PASSWORD="VIN@02025SIEM!@#$"
SPLUNK_DEB="splunk-9.4.3-237ebbd22314-linux-amd64.deb"
SPLUNK_URL="https://download.splunk.com/products/splunk/releases/9.4.3/linux/$SPLUNK_DEB"

echo "=== Tải về Splunk gói cài đặt .deb ==="
wget -O $SPLUNK_DEB "$SPLUNK_URL"

echo "=== Cài đặt Splunk bằng dpkg ==="
dpkg -i $SPLUNK_DEB

echo "=== Cấp quyền cho thư mục Splunk ==="
chown -R $SPLUNK_USER:$SPLUNK_GROUP $SPLUNK_DIR

echo "=== Khởi động lần đầu để chấp nhận license và đặt mật khẩu ==="
$SPLUNK_DIR/bin/splunk start --accept-license --seed-passwd "$SPLUNK_PASSWORD"

echo "=== Dừng Splunk lại để thiết lập boot-start ==="
$SPLUNK_DIR/bin/splunk stop

echo "=== Thiết lập Splunk khởi động cùng hệ thống ==="
$SPLUNK_DIR/bin/splunk enable boot-start --user $SPLUNK_USER

echo "=== Khởi động lại Splunk ==="
$SPLUNK_DIR/bin/splunk start

echo "=== Cài đặt hoàn tất ==="