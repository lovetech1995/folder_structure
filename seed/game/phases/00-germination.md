# 🌿 Phase 0 — GERMINATION: Hấp thụ môi trường

> **Mục tiêu:** Hấp thụ "chất dinh dưỡng" từ seed files → System Map + Feature Classification.
> **Load:** `seed/` + `protocol/01-debate.md` + `templates/` (nếu cần)

## Process

```
Bước 1: ABSORB SEED
  ├── CLAUDE.md → tech stack, patterns, naming conventions, business rules
  ├── mindset.md → domain model, business flows, permission model, constraints
  └── relation.md (nếu có) → entity relationships, data flows

Bước 2: INVENTORY EXISTING
  ├── Scan .agent/schema/ — có schema chưa?
  ├── Scan root — có JSON rules chưa?
  └── Scan src/ — có code chưa?

Bước 3: DETECT GAPS
  ├── Schema thiếu → ghi backlog
  ├── Rules thiếu → ghi backlog
  └── Relation chưa rõ → debate

Bước 4: GENERATE SYSTEM MAP
  └── Bản đồ hệ thống (collections, relations, flows)

Bước 5: DEBATE SYSTEM MAP
  └── "Đây là system map. Bạn review giúp?"
```

## Seed Extraction Template

```yaml
seed_extraction:
  tech_stack:
    frontend: "..."
    state: "..."
    ui: "..."
    database: "..."
  architecture:
    layers: "..."
    naming: "..."
  domain_entities:
    - name: "entity1"
      description: "..."
  business_rules:
    - "rule 1"
  permission_model:
    - "isOwner(): ..."
```

## Checkpoint

```
✅ Hoàn thành khi:
  [ ] Seed đã extract (CLAUDE.md + mindset.md)
  [ ] System map đã generate
  [ ] System map đã debate và approve
  [ ] Inventory gaps đã xác định
  [ ] Backlog đã tạo (nếu chưa có)

❌ Seed thiếu → DEBATE: "Tôi thấy thiếu X. Bạn cung cấp?"
```
