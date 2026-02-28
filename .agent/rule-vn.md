---
name: Nguyên Tắc Code (Template)
description: Nguyên tắc code này là bắt buộc, bất cứ AI nào tham gia vào file thì phải tuân thủ nghiêm ngặt các quy tắc code này. Trong đây có ví dụ về best practice, những gì nên và không nên khi bắt đầu code
---

---

## 0.0 HƯỚNG DẪN CỐT LÕI (TUÂN THỦ)

**QUAN TRỌNG:** Dự án này tuân theo một kiến trúc **NGHIÊM NGẶT**. Bạn **PHẢI** tuân theo các quy tắc này một cách chính xác.

### 0.1 CẤM ĐÀM PHÁN KHÔNG THỂ THƯƠNG LƯỢNG 🚫

- **KHÔNG** Giới thiệu Kiến trúc Mới.
- **KHÔNG** Refactoring trừ khi được yêu cầu rõ ràng.
- **KHÔNG** Đổi tên file hoặc thư mục.
- **KHÔNG** Thư viện Mới (không có sự phê duyệt rõ ràng).
- **KHÔNG** Chuyển đổi sang TypeScript.
- **KHÔNG** Component Lớp (Chỉ Component Hàm).
- **KHÔNG** Thư viện UI Bên Ngoài (Sử dụng hệ thống tùy chỉnh hiện có + Antd/Tailwind).

### 0.2 GIAO THỨC "KHI KHÔNG CHẮC CHẮN"

1.  **DỪNG LẠI.**
2.  **TÌM KIẾM** code hiện có.
3.  **SAO CHÉP** ví dụ phù hợp nhất gần nhất (Xem Mẫu bên dưới).
4.  **THAY ĐỔI** chỉ logic tối thiểu cần thiết.

---

## 1.0 KIẾN TRÚC HỆ THỐNG

### 1.1 NGĂN XẾP CÔNG NGHỆ

- **Nền tảng Cốt lõi**: React 19+ (JavaScript ES6+). (Thay bằng React Native nếu là Expo)
- **Quản lý Trạng thái**: Redux (Tùy chỉnh: Action / Reducer / Selector / Type), Redux-Thunk.
- **Phong cách**: TailwindCSS + CSS Tùy chỉnh (`src/css`). (Thay bằng NativeWind nếu là Expo)
- **Component UI**: Ant Design (antd) + Component Tùy chỉnh (Mới nhất). (Thay bằng react-native-paper nếu là Expo)
- **Định tuyến**: React-Router-DOM. (Thay bằng react-native-navigation nếu là Expo)
- **Xác thực**: Firebase.
- **Database**: Firebase Firestore kèm rules cho các loại record tập thể. SQLlite cho các loại record cá nhân.
- **Storage**: Firebase Storage kèm rules.
- **Bố cục**: Luôn sử dụng <SafeAreaView /> để bọc bên ngoài
- **Tiện ích**: Lodash, Numeral.

### 1.2 LUỒNG KHÁI NIỆM

**UI (Màn hình/Component) → Logic (Hook) → Trạng thái (Store) → Tiện ích (Util)**
_Quy tắc: Không bao giờ trộn lẫn các lớp._

### 1.3 BẢN ĐỒ THƯ MỤC (SRC/)

| Đường dẫn    | Loại           | Trách nhiệm                                                       |
| :----------- | :------------- | :---------------------------------------------------------------- |
| `component/` | **UI**         | Các khối UI có thể tái sử dụng. **KHÔNG** Redux, **KHÔNG** API.   |
| `hook/`      | **Logic**      | Logic kinh doanh, Luồng, Gọi API. **KHÔNG** JSX.                  |
| `screen/`    | **Trang**      | Các bố cục kết hợp Component + Hook. Được đánh số (`01_Login`).   |
| `store/`     | **Trạng thái** | Trạng thái cụ thể miền. Reducer thuần túy. Kết hợp logic firebase |
| `util/`      | **Trợ giúp**   | Các hàm thuần túy. `*.function.js`.                               |
| `config/`    | **Cấu hình**   | Các khóa toàn cục, hằng số.                                       |
| `asset/`     | **Tĩnh**       | Hình ảnh, Lottie, PDFs.                                           |
| `model/`     | **Mô hình**    | Các schema dữ liệu.                                               |

---

## 2.0 TIÊU CHUẨN KỸ THUẬT

### 2.1 QUY ƯỚC ĐẶT TÊN (NGHIÊM NGẶT)

| Thực thể            | Trường hợp/Định dạng | Ví dụ                                    |
| :------------------ | :------------------- | :--------------------------------------- |
| **File**            | snake_case           | `form_input.js`, `use_action_default.js` |
| **Component**       | PascalCase           | `BailiffUpload`, `DialogPayment`         |
| **Hook**            | use + PascalCase     | `useAction[Domain]`, `useFlow[Domain]`   |
| **Hàm**             | camelCase            | `handleUpdate`, `createQr`               |
| **Biến**            | camelCase            | `loading`, `userInfo`                    |
| **Hằng số**         | UPPERCASE            | `FLOWS.DEPOSIT`                          |
| **Loại Redux**      | UPPER_SNAKE_CASE     | `USER_LOGIN_SUCCESS`                     |
| **Hành động Redux** | camelCase            | `bailliff_job.action.js`                 |

### 2.2 PHONG CÁCH CODE & ĐỊNH DẠNG

- **Thụt lề**: 2 Khoảng trắng. (Không tab).
- **Chuỗi**: Dấu ngoặc kép (`""`).
- **Dấu chấm phẩy**: Luôn sử dụng (`;`).
- **Cấu trúc**: Dòng trống giữa tất cả các phần logic.
- **Phần**: **BẮT BUỘC** tiêu đề comment cho tất cả các file (xem Mẫu).

### 2.3 THỨ TỰ IMPORT

1.  React / Thư viện Bên thứ ba
2.  Component Cục bộ
3.  Redux (Hành động / Selector)
4.  Tiện ích / Hook / Cấu hình
5.  Tài sản / CSS

---

## 3.0 MẪU TRIỂN KHAI (MẪU)

### 3.1 TIÊU CHUẨN COMPONENT (`src/component` hoặc `src/screen/.../component`)

**Quy tắc:** Chỉ UI. Không logic nặng.

```javascript
import React, { useState, useEffect } from "react";
import { Button, Row, Col } from "antd";
// Import cục bộ
import SomeComponent from "component/some_component";
import useSomeHook from "hook/useSomeHook";
import { someSelector } from "store/some.selector";
import "./style.css";

const MyComponent = (props) => {
  // -------------------------- BIẾN --------------------------
  const someVar = "value";

  // -------------------------- TRẠNG THÁI --------------------------
  const [loading, setLoading] = useState(false);

  // -------------------------- REDUX --------------------------
  const someData = useSelector(someSelector);

  // -------------------------- HÀM --------------------------
  const handleSomething = () => {
    // Logic chỉ UI
  };

  // -------------------------- HIỆU ỨNG --------------------------
  useEffect(() => {
    // Tác dụng phụ UI
  }, []);

  // -------------------------- RENDER --------------------------
  const renderItem = () => {
    return <div>Item</div>;
  };

  // -------------------------- CHÍNH --------------------------
  return <div>{renderItem()}</div>;
};

export default MyComponent;
```

## TIÊU CHUẨN COMPONENT - Trong Component có folder đặc thù như

- `src/screen/[domain]/trigger`: đây là nơi chứa các useEffect load lần đầu để lấy dữ liệu.
  ví dụ:

```javascript
export const TriggerInit = () => {
  // -------------------------- VAR ----------------------------
  // -------------------------- STATE --------------------------
  // -------------------------- REDUX --------------------------
  const dispatch = useDispatch();
  // -------------------------- USE EFFECT ---------------------

  // hàm lấy dữ liệu một lần.
  useEffect(() => {
    dispatch(snapDataFromFirebase());
    return () => dispatch(unSnapDataFromFirebase());
  }, [dispatch]);
  // -------------------------- RETURN --------------------------
  return <></>;
};
export default TriggerInit;
```

- `src/screen/[domain]/dialog`: Đây là nơi chứa các modal antd để tương tác với dữ liệu hoặc visualize dữ liệu.
  ví dụ:

```javascript
const MyDialog = () => {
  // -------------------------- VAR -----------------------------
  const { loading, handleForward, handleCancel } = useDraftBailiffForward();

  // -------------------------- STATE ---------------------------
  // -------------------------- REDUX ---------------------------
  const open = useSelector(draftBailiffOpenForwardSelector);
  // -------------------------- FUNCTION ------------------------
  // -------------------------- EFFECT --------------------------
  // -------------------------- DATA FUNCTION -------------------
  // -------------------------- RENDER --------------------------
  // -------------------------- MAIN ----------------------------
  return (
    <Modal
      open={open}
      onCancel={() => handleCancel()}
      title="Title của modal này."
      footer={null}
      centered
    >
      <Row gutter={[0, 10]}>....</Row>
    </Modal>
  );
};
export default MyDialog;
```

## 3.2 TIÊU CHUẨN HOOK - HÀNH ĐỘNG (src/hook)

Quy tắc: Xử lý hành động người dùng, Gọi API, Gửi form.

```javascript
JavaScriptimport { message } from "antd";
import { useState } from "react";
import { useDispatch } from "react-redux";
import { useSearchParams } from "react-router-dom";
// Import cục bộ (hành động, selector, tiện ích)

const useActionDefault = () => {
  // -------------------------- BIẾN -----------------------------
  const [_, setSearchParams] = useSearchParams();

  // -------------------------- TRẠNG THÁI ---------------------------
  const [loading, setLoading] = useState(false);

  // -------------------------- REDUX ---------------------------
  const dispatch = useDispatch();

  // -------------------------- HÀM ------------------------
  const handleOpen = () => {
    setSearchParams({ viewOpenAccount: true });
  };

  const handleClose = (form) => {
    setSearchParams({});
    form?.resetFields();
  };

  const handleSubmit = (form) => {
    // Xác thực & Logic Dispatch
    setLoading(true);
    // dispatch(action(payload, callback...))
  };

  // -------------------------- HIỆU ỨNG --------------------------
  // -------------------------- HÀM DỮ LIỆU -------------------
  // -------------------------- RENDER --------------------------
  // -------------------------- CHÍNH ----------------------------
  return { handleOpen, handleClose, handleSubmit, loading };
};
export default useActionDefault;
```

3.3 TIÊU CHUẨN HOOK - LUỒNG (src/hook)
Quy tắc: Xử lý chuyển tiếp trạng thái, logic trạng thái, enums, kiểm soát luồng, thay đổi biến.

```javascript
JavaScriptimport { useEffect, useState } from "react";
import { useSelector } from "react-redux";
// Selector

export const FLOWS = {
  STEP_1: "step_1",
  STEP_2: "step_2",
};

export const useFlowDefault = () => {
  // -------------------------- BIẾN -----------------------------
  // -------------------------- TRẠNG THÁI ---------------------------
  const [flow, setFlow] = useState(FLOWS.STEP_1);

  // -------------------------- REDUX ---------------------------
  const data = useSelector(someSelector);
  const status = data?.status;

  // -------------------------- HÀM ------------------------
  // -------------------------- HIỆU ỨNG --------------------------
  useEffect(() => {
    if (status === "done") setFlow(FLOWS.STEP_2);
  }, [status]);

  // -------------------------- HÀM DỮ LIỆU -------------------
  // -------------------------- RENDER --------------------------
  // -------------------------- CHÍNH ----------------------------
  return { flow };
};
```

## 4.0 LUỒNG CÔNG VIỆC & QUY TRÌNH

### 4.1 THÊM TÍNH NĂNG

Xác định vị trí: Tìm tính năng hiện có gần nhất.
Sao chép: Sao chép cấu trúc (Thư mục/File).
Đổi tên: Đổi tên tối thiểu để phù hợp ngữ cảnh tính năng mới.
Logic: Chỉ sửa đổi logic cụ thể.

### 4.2 QUẢN LÝ MÀN HÌNH

Đánh số: 00_Nav, 01_Login... (Giữ thứ tự sắp xếp).
Phạm vi:
routePrivate.js: Các màn hình đã xác thực. (Chỉ chứa những Screen sau khi đăng nhập, user phải logged mới xem được)
routePublish.js: Các màn hình công khai. (Publish cho tất cả các user, cho nên user nào cũng xem được)

Component: Phải nằm trong thư mục con component/ nếu cụ thể cho màn hình.

### 4.3 TRẠNG THÁI (REDUX)

Thư mục: src/store/[domain]/[module]/.
File:
_.action.js: Thunks, Gọi API.
_.reducer.js: Switch-Case thuần túy.
_.selector.js: Các lựa chọn được ghi nhớ.
_.type.js: Định nghĩa hằng số.

## 5.0 ĐẶC TẢ HỆ THỐNG THIẾT KẾ

### 5.1 THẨM MỸ ƯU TIÊN (Chọn theo Yêu cầu Người dùng)

Xu hướng: Glassmorphism, Bento Grid, Neumorphism.
Công nghệ: Cyberpunk, Chế độ Tối, Holographic.
Cổ điển: Tối giản, Phẳng, Material.

### 5.2 BỐ CỤC & PHẢN HỒI

Lưới: Antd Row / Col.
Khoảng cách/Phản hồi: TailwindCSS (ví dụ, p-4, md:flex).
Trợ giúp: Hook useResponsive.

### 5.3 THỰC HÀNH TỐT NHẤT

Render Có Điều Kiện:JavaScript// ĐÚNG

```javascript
const renderButton = () => {
  if (!visible) return null;
  return <example>{label}</example>;
};
return <example>{renderButton()}</example>;
```

Comment: Giải thích code. Sạch sẽ và Rõ ràng.

### 6 CÁC STUDY CASE TỐT NHẤT.

- Hạn chế sử dụng useState, sử dụng biến redux để tuỳ biến.
- Sử dụng params để load modal hoặc các tính năng nhiều biến như filter.
- Chỉ sử dụng useEffect 1 lần cho các trường hợp initital load dữ liệu, snapshot listener từ các hàm lấy dữ liệu. truyền dữ liệu và biến redux (Để tiết kiệm kinh phí).
- Cách tốt nhất dể SOLID và DRY là viết từng hàm với một mục đích cụ thể. và comment giải thích công dụng của hàm đấy.
- Mỗi tính năng hãy đưa tất cả các hàm của nó vào 1 folder riêng biệt trong folder `src/hook` (Một nơi duy nhất để quản lý). Sau đó gọi các hàm trong hook ra UI để sử dụng.

# KẾT THÚC HƯỚNG DẪN.

Vi phạm các tiêu chuẩn này sẽ dẫn đến kiến trúc bị hỏng. Duy trì kỷ luật.
