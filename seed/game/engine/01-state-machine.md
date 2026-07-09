# ⚙️ State Machine & Transition Rules

## Full State Machine

```
[IDLE] → [GERMINATION] ↔ [DEBATE: FIX_SEED]
              ↓
        [ROOT_SYSTEM]   ↔ [DEBATE: SCHEMA]
              ↓
        [STEM]          ↔ [DEBATE: LOGIC]
              ↓
        [LEAVES]        ↔ [DEBATE: UI]
              ↓
        [VERIFICATION]  ↔ [DEBATE: TEST]
              ↓               ├→ [LEAVES] (fix nhỏ)
              │               ├→ [STEM] (fix logic)
              │               └→ [DEBATE: UI] (redesign)
        [FRUIT]         ↔ [DEBATE: ARTIFACT]
              ↓
        [LOG]
              ↓
        [LOOP_CHECK] → còn việc → [ROOT_SYSTEM] (loop mới)
                       → hết việc → [DONE]
```

## Transition Matrix

| From | To | Condition |
|------|----|-----------|
| IDLE | GERMINATION | Có task mới / backlog not empty |
| GERMINATION | ROOT_SYSTEM | Seed extracted, system map approved |
| ROOT_SYSTEM | STEM | Schema + rules + indexes approved |
| STEM | LEAVES | Store + hook + trigger done |
| LEAVES | VERIFICATION | UI components done |
| VERIFICATION | FRUIT | Tested, score >= 5 |
| FRUIT | LOG | Artifacts generated |
| LOG | LOOP_CHECK | Log written |
| LOOP_CHECK | ROOT_SYSTEM | Backlog not empty → loop mới |
| LOOP_CHECK | DONE | Backlog empty |

## DEBATE STATES

| State | Trigger | Description |
|-------|---------|-------------|
| DEBATE: FIX_SEED | Seed thiếu | "Bạn cung cấp thông tin?" |
| DEBATE: SCHEMA | Schema chưa rõ | "Tôi propose schema Y. Review?" |
| DEBATE: LOGIC | Logic chưa rõ | "Tôi propose flow Z. Review?" |
| DEBATE: UI | UI pattern chưa rõ | "Tôi propose UI W. Review?" |
| DEBATE: TEST | Test fail | Fix/bug/redesign? |
| DEBATE: ARTIFACT | Artifact lỗi | "Sửa thế nào?" |
