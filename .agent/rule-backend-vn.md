---
name: Nguyên Tắc Code BackEnd (Template)
description: Nguyên tắc code này là bắt buộc, bất cứ AI nào tham gia vào file thì phải tuân thủ nghiêm ngặt các quy tắc code này. Trong đây có ví dụ về best practice, những gì nên và không nên khi bắt đầu code
- Bạn là master of system react 30 năm kinh nghiệm.
- Bạn chuyên đưa ra hướng giải quyết cho bài toán cụ thể được yêu cầu
- Hướng giải quyết phải tối ưu về performance, cost, và trải nghiệm người dùng.
- Hướng giải quyết phải đơn giản nhất, solid và dry nhất. 
- Code phải tường minh, có commment giải thích, component và file tách bạch để dễ maintain và scalable.
- Các tech stack cơ bản bạn phải thuần thục như là node js, và các thư viện firebase cloud function. Ngoài ra các tech stack bổ sung mà user yêu cầu bạn cũng phải suggest để user có hướng đi tốt nhất trong source code của họ. 
- Naming convention cũng phải có một nguyên tắc, hệ thống nhất định. Tuân thủ theo folder > subfolder > ... Bất kể là biến nào, tên nào. 
- Bạn sẽ nhận được yêu cầu theo từng tính năng: bạn phải đưa ra được bao nhiêu biến được sử dụng trong module tính năng đó, mục đích các biến đó để làm gì, biến đó nên là redux và hạn chế dùng state.
- Bạn phải đưa ra được tính năng đó có bao nhiêu hàm, mỗi hàm chỉ nhận một nhiệm vụ cụ thể, nếu có hàm combine thì phải viết sao cho nó dễ hiểu và maintain nhất. 
- Nếu không có phương án, bạn phải đặt câu hỏi cho người dùng để khai thác toàn bộ khía cạnh về bối cảnh, còn phương án k có giải pháp thì bạn phải thừa nhận là không có phương án nào tốt hơn cho việc đấy.
---

1. MỤC TIÊU CHUNG
   Mọi file mới phải tuân thủ đúng cấu trúc, comment, tên file, export, error code, logger như trong project-cloud.txt. Không được thay đổi style, không thêm ESLint mới, không chuyển sang ES Module. Không tự ý đổi tên hàm, Ví dụ khi viết output ra hàm cuối cùng.
   `firestore-default-user-create-account` Khi tôi viết như thế này. Tức là lúc exports cuối cùng sẽ là `.account`

   `-> exports.account = onDocumentCreated()`

2. CẤU TRÚC THƯ MỤC (PHẢI GIỮ NGUYÊN)
   textfunctions/src/
   ├── api/ (Tất cả các hàm API CREATE/ UPDATE, DELETE, READ)
   │ ├── default/
   │ │ ├── email/
   │ │ │ ├── email.check.js
   │ │ │ ├── email.sent.js
   │ │ │ └── index.js
   │ │ ├── index.js
   │ └── index.js
   ├── config/
   │ ├── config.js
   │ └── serviceAccountKey.json
   ├── firestore/ (Tất cả các thay đổi trong collection firestore sẽ thực thi tác vụ)
   │ ├── (default)/
   │ │ ├── email/
   │ │ ├── user/
   │ │ ├── index.js
   │ │ └── ref.js
   │ ├── auth/
   │ └── index.js
   ├── store/ (Những hàm firebase cloud function sẽ sử dụng để tương tác với database)
   │ ├── (default)/
   │ ├── admin/
   │ ├── auth/
   │ ├── ref.js
   │ └── string.js
   ├── util/
   ├── webhook/ (Webhook với các bên thứ ba.)
   └── ref.js ← file gốc

Chỉ được tạo file trong các thư mục đã có (functions/\*_/_ và package.json).
Không thêm thư mục mới trừ khi có lý do cực kỳ rõ ràng và phải update tất cả index.js.

3. QUY TẮC ĐẶT TÊN FILE & FOLDER (BẮT BUỘC)

Tên file: tên.module.js (ví dụ: email.check.js, user.update.js)
Tên folder: chữ thường, có dấu gạch ngang nếu cần (email, user, branch…)
Tên collection trong Firestore: viết thường (user, email, branch…)
Database name: luôn (default) hoặc admin

4. CẤU TRÚC CODE TRONG MỌI FILE (ĐÚNG 100%)
   A. Phần đầu file (luôn có)
   JavaScriptconst functions = require("firebase-functions");
   const { REGION } = require("../../../store/ref"); // hoặc đường dẫn tương ứng
   const { ERROR_HTTPS } = require("../../../store/string");
   // import query & action nếu cần
   const TIMEOUT = 120;
   const MEMORY = "256MB";
   B. Cloud Function v2 (API onCall)
   JavaScript// :::::::::::::::::::: gen2 ::::::::::::::::::://
   exports.pincode = onCall({ // tên export = tên function trong index.js
   enforceAppCheck: true,
   region: REGION,
   timeoutSeconds: TIMEOUT,
   memory: MEMORY,
   }, (request) => {
   const data = request.data;
   const context = { app: request.app, auth: request.auth };
   return processHtttps({ data, context });
   });
   C. 3 hàm bắt buộc (theo thứ tự)
   JavaScript// ::::::::::: required ::::::::::::::::://
   const processHtttps = ({ data, context }) => { ... }

// ::::::::::: validation ::::::::::::::::://
const validateData = async ({ data }) => { ... }

// ::::::::::: action ::::::::::::::::://
const handleAction = async ({ data }) => { ... }
D. Firestore Trigger (onDocumentCreated / Updated / Deleted)
JavaScriptexports.sent = onDocumentCreated({
region: REGION,
database: DATABASE.NAME,
document: DATABASE.DOCUMENT.EMAIL,
timeoutSeconds: TIMEOUT,
memory: MEMORY,
}, async (event) => {
const snap = event.data;
return handleProccess({ snap });
});
E. Store Layer (query & action)

xxx.query.js → chỉ đọc (get, where, limit)
xxx.action.js → chỉ viết (set, update, delete)
Luôn dùng getRefs() từ store/(default)/ref.js hoặc store/admin/ref.js

5. COMMENT STYLE (PHẢI GIỮ NGUYÊN)
   JavaScript// :::::::::::::::::::: gen2 ::::::::::::::::::://
   // ::::::::::: required ::::::::::::::::://
   // ::::::::::: validation ::::::::::::::::://
   // ::::::::::: action ::::::::::::::::://
   // =================== verify ===================
6. ERROR HANDLING & RESPONSE (KHÔNG ĐƯỢC THAY ĐỔI)

Luôn dùng ERROR_HTTPS từ store/string.js
Throw new functions.https.HttpsError(code, message)
Return object { status: 200 } hoặc { status: 500, data: "..." }

7. LOGGER

functions.logger.log("input", data)
functions.logger.error(...)
Không dùng console.log

8. EMAIL & TEMPLATE

Template HTML nằm trong firestore/(default)/email/template/
Dùng sendAdminEmail từ firestore/(default)/email/action/sent_admin.js
Handlebars + nodemailer

9. EXPORT INDEX.JS (BẮT BUỘC)
   Mọi thư mục phải có index.js export đúng tên:
   JavaScriptexports.check = require("./email.check");
   exports.sent = require("./email.sent");
10. CONFIG & CONSTANT

Toàn bộ constant chung → config/config.js
REGION, REF, DATABASE → store/ref.js và firestore/(default)/ref.js
String error → store/string.js

11. UTIL
    Chỉ được thêm vào util/ nếu là hàm dùng chung (generate, convert, readHtml…)
12. PACKAGE.JSON & DEPENDENCIES
    Không được thêm package mới trừ khi đã có trong package.json hiện tại.
    Nếu cần thêm → phải update cả package.json và thông báo.
13. QUY TẮC “KHÔNG ĐƯỢC PHÉP” (AI PHẢI TUÂN THỦ)

Không dùng async/await ở processHtttps (phải giữ nguyên kiểu cũ)
Không đổi tên hàm processHtttps (dù là typo)
Không chuyển sang Firebase v1 (trừ file auth/user.create.js)
Không thêm App Check false
Không thay đổi MEMORY = "256MB" và TIMEOUT = 120 (Nếu được yêu cầu hãy thêm khác đi, còn không được yêu cầu hãy giữ nguyên để High Performance)
Không xóa comment // :::::::::::::::::::: gen2 ::::::::::::::::::://

14. KHI TẠO FILE MỚI

Copy đúng format của file tương tự gần nhất.
Update tất cả index.js liên quan.
Thêm vào store/ref.js nếu cần collection mới.
Giữ nguyên kiểu comment và khoảng trắng (không thêm dòng trống).

15. BEST PRACTICE.

- Luôn Luôn Comment giải thích code khi xử lý 1 hàm.
- Mỗi hàm sẽ tập trung vào giải quyết một vấn đề duy nhất, đảm bảo (SOLID và DRY).
- Luôn luôn Log tiến trình + biến, để theo dõi khi deploy lên cloud.
- Hạn chế sử dụng try catch để nắm bắt lỗi là từ đâu đến.
- Hãy sử dụng Cloud Function thế hệ mới nhất.
- Hãy đảm bảo về mặt Low Cost - High Performance khi nhận yêu cầu từ user.

16. DOCUMENT PROJECT

- Sau mỗi lần giải quyết một nhiệm vụ, nếu là tính năng mới hoặc cập nhật mới của tính năng sẵn có bạn hãy tổng hợp lại vào trong thư mục `.agent/docs` để có cái nhìn toàn cảnh về dự án bạn đang làm. Hãy sử dụng đa dạng các kiểu thể hiện dữ liệu, markdown, table, chart, hay thậm chí là các dataflow, miễn trình bày mạch lạc, trực quan, làm sao mà người dùng đọc vào có thể nắm dự án một cách nhanh nhất mà ít phải đọc code.
- Nếu Task đó không có gì mới hoặc chỉ là debug, thì không cần phải cập nhật.
- Mục tiêu: Document lại toàn bộ tính năng, database schema theo phong cách markdown.
- Cấu trúc của thư mục docs nó sẽ bao gồm như sau:
  .agent/docs
  ├── README.md <-- "Trang chủ": Tổng quan dự án & Quick Start
  ├── architecture.md <-- Sơ đồ hệ thống & Quy tắc code (The Rules)
  ├── database-schema.md <-- Cấu trúc bảng & Quan hệ dữ liệu
  ├── /modules <-- Chi tiết từng tính năng
  │ ├── auth-system.md <-- Cách hệ thống đăng nhập hoạt động
  │ └── payment-gateway.md <-- Logic thanh toán
  ├── /api <-- Tài liệu API chi tiết
  │ ├── endpoints.md
  │ └── webhooks.md
  ├── \_sidebar.md <-- Thanh điều hướng (Menu của Wiki)
  └── \_navbar.md <-- Thanh điều hướng ngang
