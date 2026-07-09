# 🍃 Phase 3 — LEAVES: UI/UX

> **Mục tiêu:** Xây dựng UI/UX cho 1 feature — component hierarchy, state binding.
> **Load:** `phases/02-stem.md` (logic reference)

## Components

```
LEAVES (1 feature)
├── 🖥️ SCREEN           — Full page / route
├── 🧩 COMPONENT         — Reusable UI blocks
├── 💬 DIALOG            — Modal interactions
└── 🔗 UI STATE BINDING  — Component → Hook → Store → Firebase
```

## UI Principles

```yaml
ui_principles:
  - "Dùng Antd components (Table, Modal, Form, Button)"
  - "Dùng TailwindCSS cho spacing, responsive"
  - "Row/Col cho layout (Antd Grid)"
  - "Form.useForm() cho form management"
  - "Dùng search params cho modal state"
  - "Loading state: Spin/Skeleton từ Antd"
  - "Error state: message.error() + fallback"
  - "Empty state: Empty component từ Antd"
  - "Responsive: useBreakpoint() từ Antd"
```

## UI ↔ Logic Binding

```
Component (UI)
  ├── useSelector(dataSelector)     ← Redux
  ├── useAction[Domain]()           ← action handler
  └── useEffect(dispatch(snap()))   ← trigger load
```

## Checkpoint

```
✅ Hoàn thành khi:
  [ ] Screen/Component đã tạo
  [ ] Dialog đã tạo (nếu cần)
  [ ] UI state binding đúng pattern
  [ ] Loading/Error/Empty states đã xử lý
  [ ] Responsive đã kiểm tra
```
