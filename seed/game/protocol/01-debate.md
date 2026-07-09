# 🗣️ Human-in-loop Debate Protocol

> Cốt lõi của Seed Loop. Không AI tự quyết định — propose → challenge → defend → approve.

## Debate Card Format

```
┌────────────────────────────────────────────────────────────────┐
│ 🗣️ DEBATE CARD #<số>                                          │
│────────────────────────────────────────────────────────────────│
│ 📌 CHỦ ĐỀ: {tên quyết định}                                   │
│                                                               │
│ ─── PROPOSE (AI) ───                                          │
│ Tôi đề xuất: {giải pháp}                                      │
│ Lý do: {luận điểm kỹ thuật, dẫn chứng từ seed}                │
│ Chi phí ước tính: {reads/writes, storage, complexity}         │
│                                                               │
│ ─── CHALLENGE (Human) ───                                     │
│ {câu hỏi / phản biện / lo ngại}                              │
│                                                               │
│ ─── DEFEND / REVISE (AI) ───                                  │
│ {giải thích thêm, hoặc đề xuất revision}                      │
│                                                               │
│ ─── RESOLUTION ───                                             │
│ ✅ APPROVED / ❌ REJECTED / 🔄 REVISE & RE-DEBATE              │
└────────────────────────────────────────────────────────────────┘
```

## Khi nào debate?

| Tình huống | Mức | Ví dụ |
|------------|-----|-------|
| Schema design decision | ✅ Luôn | "1 collection hay 2?" |
| Security rule trade-off | ✅ Luôn | "User xem tất cả hay chỉ của mình?" |
| Index strategy | ✅ Luôn | "Index cho query pattern nào?" |
| Architecture pattern | ✅ Luôn | "Subcollection vs root collection?" |
| Cost > $0.50/tháng | ✅ Luôn | "Query scan 1000 docs — cách rẻ hơn?" |
| UI/UX flow | ⚠️ Khuyến khích | "Flow này intuitive chưa?" |
| Implementation detail | ❌ Không cần | "Tên biến camelCase?" |

## 3 Debate Levels

```
Level 1: LIGHT — "Đề xuất X. Đồng ý không?" → ✅/❌
Level 2: STRUCTURED — "Có 2 cách A và B. Tôi propose A vì..." → phân tích + chọn
Level 3: DEEP — Schema/kiến trúc toàn bộ module → debate từng phần
```

## AI's Role

```
AI PHẢI:
  ✓ Trình bày rõ ràng, có cấu trúc
  ✓ Trích dẫn nguồn từ seed
  ✓ Phân tích ít nhất 2 options
  ✓ Đưa cost analysis
  ✓ Sẵn sàng defend hoặc revise
  ✓ Ghi resolution vào log

AI KHÔNG ĐƯỢC:
  ✗ Tự quyết định không debate
  ✗ Bỏ qua concern của human
  ✗ Đưa giải pháp không alternative
  ✗ Quên ghi log decision
```

## Resolution Actions

```
✅ APPROVED → Tiếp tục, ghi decision vào log
❌ REJECTED → Hỏi hướng khác, propose lại
🔄 REVISE → Sửa theo feedback → re-debate
⏸️ DEFER → Ghi backlog, xử lý sau
```
