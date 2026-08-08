## Vòng đời phát triển thống nhất (có kiểm soát token, giai đoạn, template)

### Bước 0: Khởi tạo dự án (làm 1 lần)

- **Anchor** (quy chuẩn công nghệ, coding convention, security, performance) được lưu.
- **Template Library** được sinh tự động từ Anchor (ví dụ: template React component, API route, test case Gherkin). Bạn duyệt bộ template này, sau đó AI chỉ được phép sử dụng chúng (và đề xuất cải tiến khi có bằng chứng).
- **Project State** khởi tạo với `currentPhase: "initialization"`, `tokenUsedTotal: 0`, `budgetPerFeature: 200K tokens` (có thể điều chỉnh).

---

### Vòng đời cho mỗi tính năng (lặp lại)

#### Bước 1: Phân tích nhu cầu → Tính năng

- AI phân tích yêu cầu, đề xuất danh sách tính năng MVP.
- **Quản lý giai đoạn**: State chuyển sang `phase: "analysis"`.
- **Quản lý token**: AI ước tính token cần cho toàn bộ tính năng (dựa trên độ phức tạp). Bạn xem estimate và phê duyệt ngân sách token (có thể điều chỉnh). Nếu estimate vượt ngân sách, AI phải cắt bớt phạm vi hoặc chia nhỏ.

#### Bước 2: Tính năng → Test case (bước then chốt)

- AI sinh test case phủ đầy đủ, dùng **template test case** đã duyệt (cấu trúc Given/When/Then, kèm loại test: unit/integration/e2e).
- Bạn xem xét, bổ sung, duyệt. **Đây là hợp đồng chất lượng.**
- **Quản lý token**: Mỗi test case được gán token cost khi AI tạo. Tổng token cho bước này được log vào state.
- **Template**: Nếu AI thấy cần một dạng test case mới, nó đề xuất template, bạn duyệt rồi thêm vào thư viện.

#### Bước 3: Thiết kế kỹ thuật từ test case

- AI thiết kế schema, API, component tree dựa trên test case.
- **Quản lý giai đoạn**: State chuyển `phase: "design"`.
- **Template**: AI áp dụng template có sẵn (VD: template Prisma schema, API route handler). Nếu thiếu, tự đề xuất.
- **Quản lý token**: AI báo cáo token dùng cho thiết kế, so sánh với estimate ban đầu. Nếu vượt quá 20% budget, hệ thống cảnh báo bạn.

#### Bước 4: Triển khai & tối ưu (code, gắn kết)

- AI viết migration, API, hooks, components.
- Sau mỗi mảnh code, AI tự chạy **test case tương ứng** (dùng test runner). Nếu fail → tự sửa (Self-Refine) trong giới hạn token cho phép (có thể set loop limit).
- **Quản lý giai đoạn**: State chuyển `phase: "implementation"`.
- **Quản lý token**: Mỗi lần sửa lỗi, AI log token và nguyên nhân. Bạn có thể thấy lịch sử “tiêu token cho bug X”.
- **Template**: Mọi code sinh ra phải tuân theo template (file structure, naming, code style). AI tự kiểm tra bằng linter được cấu hình sẵn.

#### Bước 5: Vòng lặp hoàn thiện (bảo mật, hiệu năng, UX)

- AI tự scan bảo mật, performance, accessibility → tạo thêm test case cải tiến.
- **Quản lý giai đoạn**: State chuyển `phase: "polishing"`.
- **Token**: Bước này tốn token nhất, bạn có thể đặt budget riêng (ví dụ: 30% tổng budget).
- **Template**: AI ghi nhận các pattern tối ưu thành công (ví dụ: “lazy load cho modal”) → đề xuất lưu thành template mới cho dự án. Bạn duyệt, template đó sẽ được dùng cho các tính năng sau.

#### Bước 6 (bổ sung): Cập nhật trạng thái & học

- Sau khi tính năng đạt yêu cầu, AI cập nhật **Project State**:
  - `completedFeatures.push({name, tokenUsed, testPassRate, perfScore})`
  - `currentPhase` quay về `"ready"` để nhận tính năng mới.
- AI cập nhật **Template Library**: thêm template mới, cải tiến template cũ dựa trên kinh nghiệm (nếu có reward cao).
- AI tổng kết **Token Report**: tổng token đã dùng, trung bình mỗi test case, mỗi component → giúp bạn ước lượng chính xác hơn cho các tính năng sau.

---

## Bảng điều khiển dành cho bạn (Tester)

Bạn không cần đọc code, chỉ cần nhìn vào một file **Project State** (có thể hiển thị qua dashboard đơn giản) gồm:

| Thuộc tính                  | Ý nghĩa                                                           |
| --------------------------- | ----------------------------------------------------------------- |
| `currentPhase`              | Đang ở phase nào (analysis / design / implementation / polishing) |
| `activeFeature`             | Tên tính năng đang làm                                            |
| `tokenBudget` / `tokenUsed` | Ngân sách token còn lại cho tính năng                             |
| `testCoverage`              | Tỉ lệ test pass                                                   |
| `lastTemplateUpdate`        | Lần cuối template được cải thiện                                  |
| `riskAlerts`                | Cảnh báo nếu token vượt ngưỡng, test fail liên tục                |

Bạn có thể ra lệnh: “Pause, tăng budget”, hoặc “Duyệt template mới”, hoặc “Chuyển sang tính năng khác” – tất cả thông qua cập nhật file state này.

---

## Bản chất mới: Kiểm soát mà không vi mô quản lý

1. **Token không còn là hộp đen**: AI phải dự toán, báo cáo, bạn duyệt – giống như quản lý ngân sách thật. Điều này ngăn AI “đốt” token vô tội vạ.
2. **Giai đoạn dự án được hiển thị rõ ràng**: Bạn biết chính xác AI đang ở đâu, không phải hỏi “đến đâu rồi”. Nếu cần, bạn có thể nhảy vào điều chỉnh.
3. **Template là “kinh nghiệm đóng gói”**: Thay vì viết skill file, bạn để AI tự rút ra template từ thành công và được bạn phê duyệt. Template giúp AI đi nhanh hơn, nhất quán hơn, và giảm token vì không phải suy nghĩ lại từ đầu.

Với vòng đời này, bạn thực sự trở thành **Tester kiêm Giám đốc dự án**, còn AI là một đội ngũ vừa biết code, vừa biết quản lý ngân sách, vừa biết tự cải tiến công cụ làm việc. Và tất cả đều dựa trên một nguyên lý duy nhất: **Chất lượng được định nghĩa bởi test case, hiệu quả được đo bằng token, sự tiến bộ được ghi nhận bằng template sống.**
