# 🔍 Seed Inventory Check

> Checklist khởi tạo dự án. Chạy khi bắt đầu dự án MỚI.

## Inventory Checklist

```
🔍 SEED INVENTORY CHECK
─────────────────────────

[ ] CLAUDE.md — có chưa? (nếu chưa → hỏi user về tech stack, patterns)
[ ] mindset.md — có chưa? (nếu chưa → hỏi user về domain, business rules)
[ ] Schema files — có chưa? (nếu chưa → Phase 1 sẽ generate từ seed)
[ ] Rules files — có chưa? (nếu chưa → Phase 1 sẽ generate)
[ ] relation.md — có chưa? (nếu chưa → Phase 1 sẽ generate)
[ ] task.md — có chưa? (có task cụ thể hay đang bootstrap?)

→ Nếu CHỈ CÓ CLAUDE.md + mindset.md → Seed mode: generate everything.
→ Nếu CÓ task.md → Feature mode: focus on 1 feature per loop.
```

## Đầu vào / Đầu ra

```
ĐẦU VÀO (tối thiểu):
  ├── CLAUDE.md (bắt buộc — nếu thiếu → hỏi user tạo)
  └── mindset.md (bắt buộc — nếu thiếu → hỏi user tạo)

ĐẦU VÀO (nếu có):
  ├── task.md / yêu cầu chat
  ├── .agent/schema/*.md
  ├── relation.md
  └── Log lịch sử .agent/game/loop/*.log.md

ĐẦU RA MỖI LOOP:
  ├── 1 Blueprint (.agent/game/blueprint/{id}.blueprint.md)
  │     ├── Schema (collection + fields)
  │     ├── Security Rules (Firestore + Storage)
  │     ├── Indexes (composite + single-field)
  │     ├── Relations & Data Flow
  │     ├── Implementation Plan (file-by-file)
  │     └── Cost Analysis (reads/writes per operation)
  │
  ├── Deployable JSON Artifacts (nếu Phase 4 — user deploy)
  │     ├── /firestore.rules.json (root)
  │     ├── /firestore.indexes.json (root)
  │     └── /storage.rules.json (root)
  │
  ├── Code changes (nếu Phase 2-3)
  └── 1 Log Entry (.agent/game/loop/{id}.log.md)
```
