# Memory Learning

## SQL Database Initialization Pattern

- Luôn sử dụng một biến redux (ví dụ: `sqlInitDone`) để theo dõi trạng thái khởi tạo của database.
- Sử dụng component `TriggerSQL` để thực hiện `initDatabase` và cập nhật `sqlInitDone`.
- Các component khác cần dữ liệu từ SQL (ví dụ: `TriggerUser`) nên đợi `sqlInitDone` bằng `true` trước khi gọi action lấy dữ liệu.
- Cấu trúc thư mục trigger: `src/pages/00_Router/02_Nav/trigger/component/`.
- Cấu trúc reducer cho SQL: `src/store/sql/[domain]/`.

## Local Image Handling (Avatar/Binary)

- Không lưu trực tiếp binary data vào SQL để đảm bảo performance.
- Sử dụng `expo-file-system` để copy ảnh từ URI tạm (picker) vào `FileSystem.documentDirectory`.
- Lưu đường dẫn (path) local vào database.
- Kiểm tra tiền tố `FileSystem.documentDirectory` để tránh copy trùng lặp nếu ảnh đã được lưu rồi.

## Form Refactoring & Validation Pattern

- Chia nhỏ các form lớn thành các sub-component (ví dụ: `form_avatar.js`, `form_public_profile.js`).
- Sử dụng `react-hook-form` và `yup` để quản lý validation tập trung.
- Tạo custom hook `useAction[Domain]` (ví dụ: `useActionUser`) để gom nhóm logic form, validation, và gọi redux actions.
- Truyền `control` và `errors` từ hook vào các sub-component để sử dụng với `Controller`.
- Sử dụng `FormItem` component chung để đồng nhất giao diện và hiển thị lỗi.

## SQL Data Mapping Pattern

- Khi chuyển đổi từ Firebase/Cloud store sang SQLite (`op-sqlite`), cần thực hiện chuyển đổi kiểu dữ liệu:
  - **Boolean**: Chuyển thành `INTEGER` (0 hoặc 1).
  - **Object/Array**: Chuyển thành `JSON.stringify(object)` để lưu vào trường `TEXT`.
  - **Firestore Timestamp**: Chuyển thành `new Date().toISOString()` cho trường `DATETIME` hoặc `TEXT`.
  - **ID**: Sử dụng `Crypto.randomUUID()` từ `expo-crypto` khi tạo bản ghi SQL mới nếu không có ID từ server.
- Luôn kiểm tra `MODELS` trong `src/store/sql/model.js` để đảm bảo mapping đúng các trường dữ liệu theo Schema SQLite đã định nghĩa.

## CẤU TRÚC HÀM TRONG REDUX.

- Các hàm dispatch thì tách riêng ra so với các hàm firebase và SQL.
