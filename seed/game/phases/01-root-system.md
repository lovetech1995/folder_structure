# 🌳 Phase 1 — ROOT SYSTEM: Nền tảng

> **Mục tiêu:** Schema, security rules, indexes, relations, cost analysis.
> **Load:** `phases/00-germination.md` (kết quả) + `protocol/01-debate.md` + `templates/03-artifacts.md`

## Components

```
ROOT SYSTEM
├── 📐 SCHEMA           — Collection/Table definitions
├── 🔒 SECURITY RULES    — Firestore + Storage rules → JSON artifacts
├── 📊 INDEXES           — Composite indexes → JSON artifacts
├── 🔗 RELATIONS         — Entity relationships
├── 📡 DATA FLOW          — Read/Write patterns
└── 💰 COST ANALYSIS      — Reads/Writes per operation
```

## Schema Generation (từ seed)

```yaml
schema_generation:
  input: "Domain entities từ mindset.md + tech constraints từ CLAUDE.md"
  process: |
    1. Identify entities từ mindset.md
    2. Xác định fields dựa trên business rules
    3. Xác định relationships
    4. Apply conventions từ CLAUDE.md
    5. Generate schema cho từng collection
    6. Generate indexes cho từng query pattern
    7. DEBATE với human
  rules:
    - "Mỗi entity = 1 root collection"
    - "Mỗi collection có id, createAt, updateAt"
    - "Denormalize counts để tránh aggregation queries"
```

## Security Rules Generation

- Với mỗi collection: xác định ai đọc/tạo/sửa/xoá
- Sinh initFields() từ schema
- Sinh rules → JSON artifact

## Indexes Generation

- Mỗi query pattern → 1 composite index
- Tránh index không cần thiết (tốn write cost)
- Output → `firestore.indexes.json`

## Zero-Cost Analysis

```
💰 ZERO-COST ANALYSIS: {collection_name}

| Operation | Reads | Writes | Frequency | Monthly Cost | Tối ưu hơn? |
|-----------|-------|--------|-----------|-------------|-------------|

ZERO-COST CHECKLIST:
  [ ] Cache local để 0 read?
  [ ] Batch writes để giảm số writes?
  [ ] Denormalize để tránh read thêm collection khác?
  [ ] Soft delete (flag) thay vì delete doc?
  [ ] Limit page size (20 thay vì 100)?
  [ ] getDoc thay vì onSnapshot?
  [ ] Index coverage tối ưu?

⚠️ > $0.50/tháng → DEBATE. ❌ > $5/tháng → BLOCK.
```

## Checkpoint

```
✅ Hoàn thành khi:
  [ ] Schema generate/review + approve
  [ ] Security rules → JSON artifact
  [ ] Indexes → JSON artifact
  [ ] Cost analysis cho mọi operation
  [ ] Đã debate và approve
```
