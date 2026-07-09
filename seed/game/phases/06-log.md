# 📝 Phase 5 — LOG: Ghi nhận & Evolution

> **Mục tiêu:** Ghi lại toàn bộ hành trình — decisions, debates, changes.
> **Load:** `templates/02-log.md` (template)

## Log Structure

Mỗi log entry là structured document. Xem template đầy đủ tại `templates/02-log.md`.

## Evolution Rules

```yaml
evolution_rules:
  - rule: "MỖI QUYẾT ĐỊNH ĐỀU CÓ LÝ DO"
    note: "Ghi cả propose và challenge"

  - rule: "MỖI THAY ĐỔI ĐỀU CÓ TRACE"
    note: "File, schema, rules thay đổi — đều log"

  - rule: "BACKLOG LÀ LIVING DOCUMENT"
    note: "Thêm feature mới, update priority"

  - rule: "PERIODIC HEALTH CHECK (mỗi 10 loops)"
    note: "Schema thiếu index? Rule cần update? Collection unused?"
```

## Checkpoint

```
✅ Hoàn thành khi:
  [ ] Log entry đã ghi
  [ ] Mọi decision đã có resolution
  [ ] Experience card đã ghi (nếu có test)
  [ ] Cost impact đã update
```
