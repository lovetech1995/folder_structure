# 🍎 Phase 4 — FRUIT: JSON Artifacts (cho USER deploy)

> **Mục tiêu:** Kết tinh blueprint thành JSON artifacts ở root project.
> **Seed CHỈ generate — USER deploy.** Seed không chạy Firebase CLI.

## Components

```
FRUIT (cuối mỗi loop)
├── /firestore.rules.json           ← Firestore Security Rules (USER deploy)
├── /firestore.indexes.json         ← Firestore Composite Indexes (USER deploy)
├── /storage.rules.json             ← Firebase Storage Rules (USER deploy)
└── /.agent/schema/                 ← Schema docs update
```

## Artifact Generation

```yaml
firestore_rules:
  output: "/firestore.rules.json"
  format: JSON (tương thích Firebase CLI)
  note: "USER deploy: firebase deploy --only firestore:rules"

firestore_indexes:
  output: "/firestore.indexes.json"
  format: JSON { indexes: [...], fieldOverrides: [...] }
  note: "USER deploy: firebase deploy --only firestore:indexes"

storage_rules:
  output: "/storage.rules.json"
  format: JSON
  note: "USER deploy: firebase deploy --only storage:rules"
```

## Artifact Debate

```
- Tất cả collections đã có rules chưa?
- Mỗi query pattern đã có index chưa? (cost: extra index = extra writes)
- Rules có quá permissive không?
- initFields() khớp với schema không?
- Storage rules có hợp lý không?
```

## Deploy Checklist (USER thực hiện)

```
🚀 DEPLOY CHECKLIST (USER)
[ ] firestore.rules.json đã generate?
[ ] firestore.indexes.json đã generate?
[ ] storage.rules.json đã generate?
[ ] USER chạy: firebase deploy --only firestore:rules --dry-run
[ ] USER chạy: firebase deploy --only firestore:indexes --dry-run
[ ] USER review rules permissions
[ ] USER review indexes

→ USER quyết định deploy hay không.
```

## Checkpoint

```
✅ Hoàn thành khi:
  [ ] /firestore.rules.json generated
  [ ] /firestore.indexes.json generated
  [ ] /storage.rules.json generated
  [ ] Schema docs updated
  [ ] Artifacts đã debate và approve
```
