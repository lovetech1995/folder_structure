# 🌱 Seed Philosophy — Tư duy nền tảng

> Loop là một **hạt giống**. Từ hạt giống (CLAUDE.md + mindset.md), nó tự sinh sôi ra mọi thứ: schema, security rules, indexes, business logic, UI/UX — tất cả ở chất lượng production.
>
> **Seed chỉ phát triển SOFTWARE.** Deploy, DevOps, database ops là user nắm.

## Ẩn dụ: Hạt giống

```
🌱 SEED (đầu vào)
 │
 │  CLAUDE.md           = DNA cốt lõi (nguyên tắc, tech stack, patterns)
 │  mindset.md          = DNA nghiệp vụ (domain rules, business logic)
 │  (task.md / chat)    = Ánh sáng mặt trời (năng lượng, hướng phát triển)
 │
 ├── 🌿 GERMINATION     = Hấp thụ, phân tích môi trường
 ├── 🌳 ROOT SYSTEM     = Nền tảng vững chắc (schema, rules, indexes)
 ├── 🌱 STEM            = Logic nghiệp vụ (store, hook, action)
 ├── 🍃 LEAVES          = UI/UX (component, screen, dialog)
 ├── 🧪 VERIFICATION    = User test + Experience
 └── 🍎 FRUIT           = JSON artifacts (→ USER deploy)
```

## Nguyên tắc vàng

| # | Nguyên tắc | Mô tả |
|---|-----------|-------|
| 1 | **🌱 SEED FIRST** | Mọi output đều bắt nguồn từ seed. Nếu seed thiếu → hỏi, không tự suy diễn. |
| 2 | **🍎 ARTIFACTS FOR USER** | Mọi blueprint tạo JSON artifacts sẵn sàng để **USER deploy**. Seed không chạy deploy. |
| 3 | **🗣️ DEBATE BEFORE DECIDE** | Propose → Human challenge → AI defend/revise → Human approve. |
| 4 | **🧩 ONE BLUEPRINT PER LOOP** | Mỗi loop = 1 vấn đề. Phát sinh → backlog. |
| 5 | **📝 LOG OR IT DIDN'T HAPPEN** | Mỗi loop xong → ghi log ngay. |
| 6 | **🔄 EVOLVE, DON'T REWRITE** | Không xoá, không rewrite. Luôn mở rộng. |
| 7 | **💸 ZERO-COST OBSESSION** | Mọi read/write phải tối ưu đến cent cuối. |
| 8 | **🧪 HUMAN TEST AFTER EVERY BLUEPRINT** | Mỗi feature xong → user test, ghi experience. |

## Phân định rõ: Seed làm gì?

| Seed làm | User làm |
|----------|----------|
| Generate schema | Deploy Firestore indexes |
| Generate security rules | Chạy `firebase deploy` |
| Generate JSON artifacts | Tương tác Firebase Console |
| Viết code (store, hook, UI) | Quản lý database |
| Thiết kế kiến trúc | DevOps, CI/CD |
| Tạo blueprint + log | Review, approve, test |
