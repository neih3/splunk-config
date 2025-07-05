# Đường dẫn cài đặt Splunk
SPLUNK_DIR="/opt/splunk"
SPLUNK_USER="splunk"
SPLUNK_GROUP="splunk"
SPLUNK_PASSWORD="VIN@02025SIEM!@#$"

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
