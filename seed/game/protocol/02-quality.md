# 📊 Quality Matrix — Enterprise-grade Checklist

> Mỗi blueprint phải pass Quality Matrix trước khi approve.

## The Matrix

| Dimension | Checklist | Weight | Fail |
|-----------|-----------|--------|------|
| **🔒 Security** | [ ] Không allow all authenticated <br> [ ] initFields() đủ fields <br> [ ] isOwner/isOperator phân biệt rõ <br> [ ] Storage rules không public nếu không cần | 🔴 Critical | ❌ Block |
| **💰 Cost (ZERO-COST)** | [ ] 0 extra read cho mọi danh sách <br> [ ] 0 extra write cho mọi update <br> [ ] 0 aggregation query <br> [ ] Denormalized counts <br> [ ] Limit documents (max 500, ưu tiên 20-100) <br> [ ] Snapshot listener có unsubscribe <br> [ ] 0-cost alternative đã cân nhắc? <br> [ ] Total < **$0.50/tháng** cho 1000 users | 🔴 Critical | ❌ Block |
| **⚡ Performance** | [ ] Index cho mọi query pattern <br> [ ] Snapshot listener cleanup <br> [ ] Pagination <br> [ ] Cache strategy | 🟡 High | ⚠️ Warning |
| **🎨 UX** | [ ] Loading state (Spin/Skeleton) <br> [ ] Error state <br> [ ] Empty state <br> [ ] Responsive | 🟡 High | ⚠️ Warning |
| **🧹 Code Quality** | [ ] Naming convention đúng <br> [ ] Import order đúng <br> [ ] Comment đầy đủ <br> [ ] Không console.log, không TODO | 🟢 Normal | ⚠️ Warning |
| **📐 Architecture** | [ ] Đúng pattern (component/hook/store/util) <br> [ ] Không trộn layers <br> [ ] Redux dispatch pattern đúng | 🔴 Critical | ❌ Block |
| **🧪 Reliability** | [ ] Error handling cho mọi Firebase call <br> [ ] Callback pattern <br> [ ] Validation trước write <br> [ ] Optimistic UI (nếu cần) | 🟡 High | ⚠️ Warning |

## Cách dùng

```
TRƯỚC KHI APPROVE blueprint:
  → Chạy từng item
  → FAIL Critical → DEBATE, sửa, không approve
  → WARNING High → Ghi log, có thể approve nếu đã debate
```
