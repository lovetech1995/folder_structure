# 📝 Log Entry v2 Template

```markdown
---
id: log_{date}_{time}
date: {YYYY-MM-DD HH:mm}
blueprint: ".agent/game/blueprint/{id}.blueprint.md"
module: "{module}"
type: "{schema | rule | feature | fix | deploy}"
status: "{done | partial | blocked}"
loop_number: {n}
approval: "{approved | pending | rejected}"
---

## 📝 TÓM TẮT
{2-3 câu mô tả loop này làm gì, kết quả ra sao}

---

## 🗣️ DEBATES TRONG LOOP
| # | Topic | Propose | Challenge | Resolution |

## 📂 FILE CHANGES
### Created | File | Purpose |
### Modified | File | Change |

## 🗃️ SCHEMA CHANGES
- **Collection {name}:** thêm field {field}

## 🔒 RULES / INDEXES CHANGES
- **firestore.rules.json:** thêm match /{collection}/{id}
- **firestore.indexes.json:** thêm index [...]

## 💰 COST IMPACT
- **Trước:** ~$X/tháng → **Sau:** ~$Y/tháng

## 💡 KEY DECISIONS
- **Decision:** ... **Rationale:** ... **Approved by:** ...

## 🧪 EXPERIENCE (User Test)
### Test Summary | Tester | Môi trường | Ngày test |
### Experience Card
```
EXPERIENCE:
  "Cảm giác: {user's words}"
  "Thích: ..."
  "Không thích: ..."
BUGS FOUND: ...
FRICTION POINTS: ...
PERFORMANCE FEELING: {nhanh / chậm / okay}
SCORE: {1-10}
```
### Test Result: ✅ APPROVED / 🔄 IMPROVE / ❌ REJECT

---

## ⏭️ NEXT STEPS
- [ ] {task 1} (priority: 🔴/🟡/🟢)
```
