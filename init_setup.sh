#!/bin/bash

PROJECT_NAME="my_assistance"

# --- PHẦN 1: Chạy script setup project ---
echo "------------------------------------------------"
echo "Bắt đầu chạy script setup project..."
echo "------------------------------------------------"

# Tải và thực thi script project_setup.sh từ GitHub
curl -sSL https://raw.githubusercontent.com/lovetech1995/folder_structure/refs/heads/main/project_setup.sh | bash -s -- "$PROJECT_NAME"


# Kiểm tra xem script trước đó có chạy thành công không
if [ $? -eq 0 ]; then
    echo "------------------------------------------------"
    echo "Hoàn thành setup project!"
else
    echo "Có lỗi xảy ra trong quá trình setup project."
fi

echo ""

# --- PHẦN 2: Hỏi cài đặt GEMINI.md ---
read -p "Bạn có muốn cài đặt gemini.md vào thư mục agent/ không? (y/n): " choice

case "$choice" in 
  y|Y ) 
    echo "Đang khởi tạo thư mục agent và tải GEMINI.md..."
    
    # Tạo thư mục agent nếu chưa có
    mkdir -p $PROJECT_NAME/agent
    
    # Tải file từ GitHub và lưu vào agent/GEMINI.md
    # Lưu ý: Tôi dùng option -o để đổi tên từ .GEMINI.md thành GEMINI.md cho dễ nhìn
    curl -sSL https://raw.githubusercontent.com/lovetech1995/folder_structure/refs/heads/main/agent/.GEMINI.md -o $PROJECT_NAME/agent/GEMINI.md
    
    if [ $? -eq 0 ]; then
        echo "Tải thành công! File lưu tại: agent/GEMINI.md"
    else
        echo "Lỗi: Không thể tải file GEMINI.md. Vui lòng kiểm tra lại kết nối mạng hoặc link."
    fi
    ;;
  n|N ) 
    echo "Bỏ qua cài đặt GEMINI.md."
    ;;
  * ) 
    echo "Lựa chọn không hợp lệ. Kết thúc script."
    ;;
esac

echo "------------------------------------------------"
echo "Tất cả các tác vụ đã hoàn tất!"