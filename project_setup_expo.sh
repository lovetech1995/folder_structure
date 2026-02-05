#!/bin/bash

# 1. Kiểm tra tham số đầu vào
if [ -z "$1" ]; then
  echo "------------------------------------------------"
  echo "LỖI: Bạn chưa nhập tên dự án Expo!"
  echo "Cách dùng đúng: bash $0 <ten-du-an>"
  echo "Ví dụ: bash $0 my-mobile-app"
  echo "------------------------------------------------"
  exit 1
fi

PROJECT_NAME=$1

echo "--------------------------------------------------"
echo "Bắt đầu tạo dự án Expo: $PROJECT_NAME"
echo "--------------------------------------------------"

# 2. Khởi tạo dự án Expo (Sử dụng template mặc định - Blank)
# Bạn có thể đổi --template blank thành tabs nếu muốn có sẵn Navigation
npx create-expo-app $PROJECT_NAME --template blank

if [ ! -d "$PROJECT_NAME" ]; then
    echo "Lỗi: Không thể tạo dự án Expo."
    exit 1
fi

cd $PROJECT_NAME

# 3. Cài đặt các thư viện cốt lõi (Tương tự bản React Web của bạn)
echo "Đang cài đặt thư viện hệ sinh thái..."
# Lưu ý: expo install giúp đảm bảo phiên bản thư viện tương thích với Expo SDK
npx expo install @reduxjs/toolkit react-redux axios moment react-router-dom lodash numeral react-countdown firebase

# Cài đặt Icons (Expo đã có sẵn @expo/vector-icons, nhưng mình cài thêm react-icons nếu bạn quen dùng)
npx expo install react-icons

# 4. Cài đặt Tailwind CSS cho React Native (NativeWind v4)
echo "Đang cấu hình Tailwind CSS (NativeWind)..."
npm install nativewind@latest tailwindcss@3 react-native-reanimated react-native-safe-area-context
npx tailwindcss init

# 5. Cấu hình cấu trúc thư mục cơ bản
mkdir -p src/components src/redux src/screens src/utils src/assets

echo "--------------------------------------------------"
echo "Dự án $PROJECT_NAME đã sẵn sàng!"
echo "Cách chạy: cd $PROJECT_NAME && npx expo start"
echo "--------------------------------------------------"