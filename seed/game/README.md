# 🌱 SEED LOOP v2 — Modular Architecture

> **Tuyên ngôn:** Loop là một **hạt giống**. Từ hạt giống (CLAUDE.md + mindset.md), nó tự sinh sôi ra schema, rules, indexes, business logic, UI/UX.
>
> **Seed chỉ phát triển SOFTWARE.** Deploy, DevOps, database ops là **user nắm**.
>
> **Cơ chế:** Human-in-loop debate. AI propose → Human challenge → AI defend/revise → Human approve.

---

## 🗂️ Cấu trúc modules

| Module | File | Khi nào load |
|--------|------|-------------|
| 🌱 **Seed** | `seed/01-philosophy.md` | GERMINATION — 1 lần đầu |
| 🌱 **Seed** | `seed/02-commandments.md` | Tham chiếu khi cần |
| 🌱 **Seed** | `seed/03-inventory.md` | GERMINATION — check đầu vào |
| 🗣️ **Protocol** | `protocol/01-debate.md` | Khi cần debate |
| 📊 **Protocol** | `protocol/02-quality.md` | Khi quality check |
| 🌿 **Phase 0** | `phases/00-germination.md` | `state.currentPhase = GERMINATION` |
| 🌳 **Phase 1** | `phases/01-root-system.md` | `state.currentPhase = ROOT_SYSTEM` |
| 🌱 **Phase 2** | `phases/02-stem.md` | `state.currentPhase = STEM` |
| 🍃 **Phase 3** | `phases/03-leaves.md` | `state.currentPhase = LEAVES` |
| 🧪 **Phase 3.5** | `phases/04-verification.md` | `state.currentPhase = VERIFICATION` |
| 🍎 **Phase 4** | `phases/05-fruit.md` | `state.currentPhase = FRUIT` |
| 📝 **Phase 5** | `phases/06-log.md` | `state.currentPhase = LOG` |
| 📐 **Templates** | `templates/01-blueprint.md` | Khi tạo blueprint |
| 📐 **Templates** | `templates/02-log.md` | Khi tạo log |
| 📐 **Templates** | `templates/03-artifacts.md` | Khi tạo JSON artifacts |
| 📐 **Templates** | `templates/04-debate-card.md` | Khi debate |
| 📐 **Templates** | `templates/05-experience-card.md` | Khi test |
| ⚙️ **Engine** | `engine/01-state-machine.md` | Khi transition |
| 📚 **Examples** | `examples/01-bootstrap.md` | Tham chiếu |

## 🚀 Cách chạy

```yaml
1. Đọc state.json → biết currentPhase
2. Load phase tương ứng từ phases/
3. Load protocol nếu cần debate
4. Load template nếu cần tạo output
5. Kết thúc → update state.json
```

## Phân định Seed vs User

| Seed (AI) làm | User làm |
|---------------|----------|
| Generate schema, rules, indexes | Deploy lên Firebase |
| Viết code (store, hook, UI) | DevOps, CI/CD |
| Tạo JSON artifacts | Chạy `firebase deploy` |
| Thiết kế kiến trúc | Quản lý database |
| Tạo blueprint + log | Review, approve, test |
