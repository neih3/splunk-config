#!/bin/bash

# Dừng dịch vụ Splunk Forwarder (nếu đang chạy)
if pgrep -u splunkfwd splunkd >/dev/null; then
    echo "Dừng tiến trình Splunk Forwarder..."
    sudo -u splunkfwd /opt/splunkforwarder/bin/splunk stop
    sleep 5
fi

# Đảm bảo không còn tiến trình splunk nào chạy dưới user splunkfwd
if pgrep -u splunkfwd splunkd >/dev/null; then
    echo "Phát hiện tiến trình Splunk vẫn còn, tiến hành kill..."
    sudo pkill -u splunkfwd splunkd
    sleep 2
fi

# Xác nhận lại lần cuối
if pgrep -u splunkfwd splunkd >/dev/null; then
    echo "Cảnh báo: Một số tiến trình Splunk vẫn chưa dừng!"
else
    echo "Tất cả tiến trình Splunk đã dừng."
fi

# Gỡ cài đặt gói
sudo dpkg -r splunkforwarder

# Xóa thư mục cài đặt (nếu muốn)
sudo rm -rf /opt/splunkforwarder

# Xóa user splunkfwd (nếu không dùng nữa)
sudo userdel -r splunkfwd

echo "Đã gỡ cài đặt Splunk Universal Forwarder."