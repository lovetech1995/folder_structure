#!/bin/bash

# setup_firebase_project.sh
# Script tự động thiết lập Firebase project

# Màu sắc cho output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Biến cấu hình
PROJECT_ID=""
PROJECT_NAME="My Firebase Project"
REGION="asia-southeast1"
STORAGE_REGION="asia-southeast1"

# Hàm in thông báo
print_status() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

# Hàm kiểm tra Firebase CLI đã cài đặt chưa
check_firebase_cli() {
    if ! command -v firebase &> /dev/null; then
        print_error "Firebase CLI chưa được cài đặt"
        echo "Đang cài đặt Firebase CLI..."
        
        # Cài đặt Firebase CLI
        if command -v npm &> /dev/null; then
            sudo npm install -g firebase-tools
        else
            print_error "npm không tồn tại. Vui lòng cài đặt Node.js và npm trước"
            exit 1
        fi
        
        if ! command -v firebase &> /dev/null; then
            print_error "Không thể cài đặt Firebase CLI"
            exit 1
        fi
    fi
    print_status "Firebase CLI đã sẵn sàng"
}

# Hàm đăng nhập Firebase
login_firebase() {
    print_status "Kiểm tra trạng thái đăng nhập Firebase..."
    if firebase login --check 2>/dev/null; then
        print_status "Đã đăng nhập Firebase"
    else
        print_warning "Chưa đăng nhập Firebase"
        echo "Mở trình duyệt để đăng nhập..."
        firebase login --no-localhost
    fi
}

# Hàm tạo project mới hoặc chọn project có sẵn
setup_project() {
    print_status "Thiết lập Firebase project..."
    
    # Hiển thị danh sách project có sẵn
    echo "Danh sách Firebase projects hiện có:"
    firebase projects:list
    
    read -p "Bạn muốn tạo project mới (n) hay sử dụng project có sẵn (e)? [n/e]: " choice
    
    if [[ $choice == "e" || $choice == "E" ]]; then
        read -p "Nhập Project ID của project có sẵn: " PROJECT_ID
        firebase use $PROJECT_ID
    else
        read -p "Nhập tên project mới: " PROJECT_NAME
        read -p "Nhập Project ID (để trống để Firebase tự tạo): " custom_id
        
        if [ -z "$custom_id" ]; then
            print_status "Đang tạo project với tên: $PROJECT_NAME"
            PROJECT_ID=$(firebase projects:create $PROJECT_NAME --format=json | jq -r '.projectId')
        else
            print_status "Đang tạo project với ID: $custom_id"
            firebase projects:create $custom_id --display-name="$PROJECT_NAME"
            PROJECT_ID=$custom_id
        fi
        
        if [ -z "$PROJECT_ID" ]; then
            print_error "Không thể tạo project"
            exit 1
        fi
        
        firebase use $PROJECT_ID
    fi
    
    print_status "Project ID: $PROJECT_ID đã sẵn sàng"
}

# Hàm thiết lập Firestore
setup_firestore() {
    print_status "Thiết lập Firestore Database..."
    
    # Kiểm tra Firestore đã được bật chưa
    if firebase firestore:info 2>/dev/null | grep -q "enabled"; then
        print_status "Firestore đã được bật"
    else
        print_status "Đang bật Firestore..."
        
        read -p "Chọn chế độ Firestore (test/production) [test]: " firestore_mode
        firestore_mode=${firestore_mode:-test}
        
        read -p "Chọn region cho Firestore (us-central1/eur3/asia-southeast1) [asia-southeast1]: " fs_region
        fs_region=${fs_region:-asia-southeast1}
        
        # Tạo Firestore database
        echo "Đang tạo Firestore database..."
        if [[ $firestore_mode == "production" ]]; then
            firebase firestore:databases:create --region=$fs_region --database="(default)"
        else
            firebase firestore:databases:create --region=$fs_region --database="(default)" --mode=test
        fi
        
        # Tạo rules mặc định cho Firestore
        cat > firestore.rules << 'EOL'
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Cho phép đọc/ghi cho authenticated users
    match /{document=**} {
      allow read, write: if request.auth != null;
    }
    
    // Hoặc rules công khai (chỉ dành cho development)
    // match /{document=**} {
    //   allow read, write: if true;
    // }
  }
}
EOL
        
        print_status "Đã tạo firestore.rules"
    fi
}

# Hàm thiết lập Storage
setup_storage() {
    print_status "Thiết lập Firebase Storage..."
    
    # Kiểm tra Storage đã được bật chưa
    if gcloud services list --project=$PROJECT_ID 2>/dev/null | grep -q "firebasestorage"; then
        print_status "Firebase Storage đã được bật"
    else
        print_status "Đang bật Firebase Storage..."
        
        read -p "Chọn region cho Storage [us-central1]: " storage_region
        storage_region=${storage_region:-us-central1}
        
        # Bật Firebase Storage API
        gcloud services enable firebasestorage.googleapis.com --project=$PROJECT_ID
        
        # Tạo bucket mặc định
        firebase storage:enable
        
        # Tạo rules mặc định cho Storage
        cat > storage.rules << 'EOL'
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    // Cho phép đọc/ghi cho authenticated users
    match /{allPaths=**} {
      allow read, write: if request.auth != null;
    }
    
    // Hoặc rules công khai (chỉ dành cho development)
    // match /{allPaths=**} {
    //   allow read, write: if true;
    // }
  }
}
EOL
        
        print_status "Đã tạo storage.rules"
    fi
}

# Hàm thiết lập Authentication
setup_authentication() {
    print_status "Thiết lập Firebase Authentication..."
    
    # Kiểm tra Authentication đã được bật chưa
    if gcloud services list --project=$PROJECT_ID 2>/dev/null | grep -q "identitytoolkit"; then
        print_status "Firebase Authentication đã được bật"
    else
        print_status "Đang bật Firebase Authentication..."
        
        # Bắt đầu setup Authentication
        cat > auth_providers.json << 'EOL'
{
  "signIn": {
    "email": true,
    "phoneNumber": false,
    "anonymous": false,
    "facebook": false,
    "github": false,
    "google": true,
    "twitter": false,
    "microsoft": false,
    "apple": false
  }
}
EOL
        
        print_status "Đã tạo cấu hình auth_providers.json"
        print_warning "Vui lòng bật các provider trong Firebase Console:"
        echo "https://console.firebase.google.com/project/$PROJECT_ID/authentication/providers"
    fi
}

# Hàm tạo file cấu hình Firebase
create_firebase_config() {
    print_status "Tạo file cấu hình Firebase..."
    
    cat > firebase-config.js << EOL
// Firebase configuration for $PROJECT_NAME
const firebaseConfig = {
  apiKey: "YOUR_API_KEY",
  authDomain: "${PROJECT_ID}.firebaseapp.com",
  projectId: "${PROJECT_ID}",
  storageBucket: "${PROJECT_ID}.appspot.com",
  messagingSenderId: "YOUR_MESSAGING_SENDER_ID",
  appId: "YOUR_APP_ID",
  measurementId: "YOUR_MEASUREMENT_ID"
};

// Initialize Firebase
const app = firebase.initializeApp(firebaseConfig);
 

export { app };
EOL
    
    print_status "Đã tạo file cấu hình:"
    echo "- firebase-config.js"
    print_warning "Vui lòng cập nhật các giá trị API_KEY trong Firebase Console"
}

# Hàm hiển thị thông tin sau khi setup
show_summary() {
    print_status "=== THIẾT LẬP HOÀN TẤT ==="
    echo ""
    echo "Project ID: $PROJECT_ID"
    echo "Project Name: $PROJECT_NAME"
    echo ""
    echo "Các dịch vụ đã thiết lập:"
    echo "✓ Firestore Database"
    echo "✓ Firebase Storage"
    echo "✓ Firebase Authentication"
    echo ""
    echo "Các file đã tạo:"
    echo "- firestore.rules"
    echo "- storage.rules"
    echo "- firebase-config.js"
    echo "- .env.firebase"
    echo "- auth_providers.json"
    echo ""
    echo "CẦN THỰC HIỆN THÊM:"
    echo "1. Cập nhật web app configuration trong Firebase Console"
    echo "2. Thêm ứng dụng web trong: https://console.firebase.google.com/project/$PROJECT_ID/settings/general/web"
    echo "3. Cập nhật các giá trị API_KEY trong firebase-config.js và .env.firebase"
    echo "4. Triển khai rules: firebase deploy --only firestore:rules,storage:rules"
    echo ""
    print_status "Chúc mừng! Firebase project của bạn đã sẵn sàng."
}

setup_appcheck() {
    print_status "Thiết lập App Check..."

    # Bật App Check API
    print_status "Đang bật App Check API..."
    gcloud services enable appcheck.googleapis.com --project=$PROJECT_ID

    echo "Để thiết lập App Check, bạn cần:"
    echo "1. Đã thêm ứng dụng web trong Firebase Console và lấy App ID (20 ký tự)."
    echo "2. Đã đăng ký reCAPTCHA v3 site key (từ https://www.google.com/recaptcha/admin)"

    read -p "Bạn đã có App ID và reCAPTCHA site key chưa? (y/n): " has_keys

    if [[ $has_keys == "y" || $has_keys == "Y" ]]; then
        read -p "Nhập App ID (từ Firebase Console > Cài đặt dự án > Tổng quan > Ứng dụng của bạn): " app_id
        read -p "Nhập reCAPTCHA site key: " recaptcha_key

        if [ -n "$app_id" ] && [ -n "$recaptcha_key" ]; then
            print_status "Đang đăng ký App Check cho ứng dụng web..."
            firebase appcheck:applications:create --app=$app_id --platform=web --recaptcha-key=$recaptcha_key
            print_status "Đã đăng ký App Check."
        else
            print_error "App ID và reCAPTCHA site key không được để trống."
        fi
    else
        print_warning "Vui lòng thực hiện các bước sau:"
        echo "1. Truy cập Firebase Console: https://console.firebase.google.com/project/$PROJECT_ID/settings/general"
        echo "   - Thêm ứng dụng web (nếu chưa có) và lấy App ID."
        echo "2. Truy cập https://www.google.com/recaptcha/admin để tạo reCAPTCHA v3 key."
        echo "   - Chọn loại reCAPTCHA v3."
        echo "   - Thêm domain (nếu cần)."
        echo "3. Sau khi có App ID và reCAPTCHA key, chạy lại script hoặc chạy lệnh sau:"
        echo "   firebase appcheck:applications:create --app=<APP_ID> --platform=web --recaptcha-key=<SITE_KEY>"
        echo ""
        echo "Hoặc bạn có thể bật App Check trong Firebase Console:"
        echo "https://console.firebase.google.com/project/$PROJECT_ID/appcheck/apps"
    fi
}

# Hàm chính
main() {
    echo "=== THIẾT LẬP FIREBASE PROJECT ==="
    echo ""
    
    # Kiểm tra các dependencies
    check_firebase_cli
    
    # Đăng nhập Firebase
    login_firebase
    
    # Thiết lập project
    setup_project
    
    # Thiết lập các dịch vụ
    setup_firestore
    setup_storage
    setup_authentication
    
    # Tạo file cấu hình
    create_firebase_config
    
    # Hiển thị summary
    show_summary

        # Sau khi thiết lập các dịch vụ khác
    read -p "Bạn có muốn thiết lập App Check ngay bây giờ? (y/n): " setup_appcheck_now
    if [[ $setup_appcheck_now == "y" || $setup_appcheck_now == "Y" ]]; then
        setup_appcheck
    else
        print_warning "Bạn có thể thiết lập App Check sau trong Firebase Console."
    fi
}

# Chạy hàm chính
main "$@"