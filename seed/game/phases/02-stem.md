# 🌱 Phase 2 — STEM: Business Logic

> **Mục tiêu:** Xây dựng logic nghiệp vụ cho 1 feature.
> **Load:** `phases/01-root-system.md` (schema reference) + `protocol/01-debate.md` + `templates/01-blueprint.md`

## Components

```
STEM (1 feature)
├── 🏪 STORE (Redux)
│     ├── action.js      — Thunks, Firebase calls
│     ├── reducer.js     — State transitions
│     ├── selector.js    — Memoized selectors
│     └── type.js        — Constants
│
├── 🪝 HOOK
│     ├── useAction[Domain].js   — User actions (CRUD)
│     └── useFlow[Domain].js     — State flow (wizard, steps)
│
├── 🔄 TRIGGER
│     └── trigger_[domain].js    — Initial data load (snapshot listener)
│
└── 🔗 DATA FLOW DIAGRAM
      └── User → Hook → Action → Firebase → Reducer → UI
```

## Feature Implementation Flow

```
1. XÁC ĐỊNH FEATURE (từ backlog)
2. PHÂN TÍCH DATA FLOW → sequence diagram
3. IDENTIFY FILES → store → hook → trigger → UI
4. DEBATE IMPLEMENTATION → cost + pattern
5. IMPLEMENT → từng file theo thứ tự
6. REVIEW → naming, pattern, comments
```

## Debate Points

| Topic | Question | Impact |
|-------|----------|--------|
| Data ownership | Ai sở hữu data? User hay System? | Rules, permissions |
| Sync strategy | Cần offline sync không? | isSync flag |
| Validation | Client, server, hay cả 2? | Cost $$$ |
| Error handling | User thấy gì khi error? | UX quality |
| Performance | Realtime hay load 1 lần? | Snapshot vs getDoc |

## Checkpoint

```
✅ Hoàn thành khi:
  [ ] Store layer hoàn chỉnh (action/reducer/selector/type)
  [ ] Hook layer hoàn chỉnh (useAction/useFlow)
  [ ] Trigger init hoàn chỉnh (nếu cần)
  [ ] Data flow đã vẽ và approve
  [ ] Mọi business decision đã debate
  [ ] Cost analysis đã update
```
