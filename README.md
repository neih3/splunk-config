# Splunk Config Deployment Guide

## 1. Điều kiện để sử dụng cấu hình này

- **Copy đúng file:**
  - Copy từng file `.conf` vào đúng thư mục cấu hình của Splunk trên từng máy:
    - Splunk Enterprise: `/opt/splunk/etc/system/local/`
    - Universal Forwarder: `/opt/splunkforwarder/etc/system/local/`
    - Hoặc thư mục app tương ứng nếu dùng deployment server/app.
- **Chỉnh sửa giá trị thực tế:**
  - Thay các giá trị placeholder trong file cấu hình:
    - `<cluster-master-ip>`, `<deployer-ip>`, `<search-head-ip>`, `<deployment-server-ip>`: IP hoặc hostname thực tế
    - `YOUR_CLUSTER_KEY`, `YOUR_SHC_KEY`: Chuỗi key thực tế bạn dùng cho cluster/shcluster
    - Các port (8089, 9997, ...) phải mở đúng như sơ đồ mạng
- **Restart Splunk:**
  - **Chỉ restart Splunk trên node mà bạn vừa copy hoặc chỉnh sửa file cấu hình.**
  - Sau khi copy và chỉnh sửa, restart Splunk trên từng node tương ứng:
    - `sudo /opt/splunk/bin/splunk restart` (cho Splunk Enterprise)
    - hoặc `sudo /opt/splunkforwarder/bin/splunk restart` (cho Universal Forwarder)
  - **Không cần restart toàn bộ hệ thống, chỉ restart node có thay đổi cấu hình.**

## 1.1. Ví dụ: Đặt file cấu hình ở đâu?

| File cấu hình                                                                        | Đặt ở node nào                                                | Khi nào cần restart node này?                           |
| ------------------------------------------------------------------------------------ | ------------------------------------------------------------- | ------------------------------------------------------- |
| `cluster-master/server.conf`, `cluster-master/indexes.conf`                          | Cluster Master                                                | Sau khi copy/chỉnh sửa file này trên Cluster Master     |
| `indexer/server.conf`, `indexer/inputs.conf`, `indexer/indexes.conf`                 | Indexer (indexer1, indexer2, ...)                             | Sau khi copy/chỉnh sửa file này trên từng Indexer       |
| `search-head/server.conf`, `search-head/outputs.conf`                                | Search Head (search-head1, search-head2, ...)                 | Sau khi copy/chỉnh sửa file này trên từng Search Head   |
| `deployer/server.conf`                                                               | Deployer                                                      | Sau khi copy/chỉnh sửa file này trên Deployer           |
| `deployment-server/server.conf`                                                      | Deployment Server                                             | Sau khi copy/chỉnh sửa file này trên Deployment Server  |
| `deployment-server/deployment-apps/forwarder-app/inputs.conf`, `outputs.conf`        | Thư mục app trên Deployment Server (triển khai cho Forwarder) | Sau khi chỉnh sửa app, restart Forwarder nhận app này   |
| `forwarder/inputs.conf`, `forwarder/outputs.conf`, `forwarder/deploymentclient.conf` | Universal Forwarder (forwarder1, forwarder2, ...)             | Sau khi copy/chỉnh sửa file này trên từng Forwarder     |
| `sc4s/outputs.conf`                                                                  | SC4S (Syslog Collector for Splunk)                            | Sau khi copy/chỉnh sửa file này trên SC4S               |
| `cloud/aws-indexer/server.conf`, ...                                                 | Indexer ở các site cloud (AWS, GCP, Azure)                    | Sau khi copy/chỉnh sửa file này trên từng Indexer cloud |

**Lưu ý:**

- Mỗi node chỉ cần copy đúng file cấu hình tương ứng với vai trò của mình.
- **Chỉ restart Splunk trên node có thay đổi cấu hình.**
- Không copy toàn bộ folder vào tất cả các node.

## 2. Cách kiểm tra và xử lý lỗi

### 2.1. Kiểm tra trạng thái dịch vụ

- Kiểm tra Splunk đã chạy chưa:
  - `sudo /opt/splunk/bin/splunk status`
- Kiểm tra log lỗi:
  - `tail -f /opt/splunk/var/log/splunk/splunkd.log`

### 2.2. Một số lỗi thường gặp và cách xử lý

| Lỗi thường gặp                      | Nguyên nhân                                | Cách xử lý                                       |
| ----------------------------------- | ------------------------------------------ | ------------------------------------------------ |
| Cannot connect to master            | Sai IP/port hoặc pass4SymmKey              | Kiểm tra lại IP, port, key trong `server.conf`   |
| License expired                     | Chưa khai báo license hoặc license hết hạn | Nạp lại license trên Cluster Master              |
| Indexer không join được cluster     | Sai key hoặc master_uri                    | Kiểm tra lại key và master_uri                   |
| Forwarder không gửi được log        | Sai outputs.conf hoặc port chưa mở         | Kiểm tra outputs.conf, mở port 9997 trên indexer |
| Search Head không join được cluster | Sai shcluster key hoặc fetch_url           | Kiểm tra lại key và URL                          |

### 2.3. Các bước xử lý chung

1. Đọc kỹ log `/opt/splunk/var/log/splunk/splunkd.log` để xác định lỗi cụ thể
2. Kiểm tra lại file cấu hình vừa chỉnh sửa
3. Đảm bảo các node có thể ping/telnet tới nhau qua các port cần thiết
4. Sửa lại cấu hình, restart lại dịch vụ

## 3. Liên hệ hỗ trợ

- Nếu không tự xử lý được, gửi log lỗi và file cấu hình lên nhóm kỹ thuật hoặc liên hệ Splunk Support.
