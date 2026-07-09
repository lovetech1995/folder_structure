# 🧪 Phase 3.5 — VERIFICATION: Test & Experience

> **Mục tiêu:** User test trực tiếp từng tính năng vừa build. Ghi experience vào log.
> **Triết lý:** Code xong chưa test = chưa xong. Experience là thước đo cuối cùng.

## Testing Flow

```
BUILD xong → AI propose test scenario
  → USER test trên môi trường thật
    │
    ├── ✅ FEATURE OK → Ghi experience → qua FRUIT
    ├── ⚠️ CÓ VẤN ĐỀ → Ghi bug/friction
    │     → Debate: fix ngay hay backlog?
    └── ❌ SAI EXPECTATION → Debate lại design → sửa blueprint
```

## Experience Collection

```
🧪 EXPERIENCE CARD — {feature_name}

EXPERIENCE:
  "Cảm giác: {user's words}"
  "Thích: {what user liked}"
  "Không thích: {what user disliked}"

BUGS FOUND:
  - {bug 1}
  - {bug 2}

FRICTION POINTS:
  - {friction 1}
  - {friction 2}

PERFORMANCE FEELING: {nhanh / chậm / okay}
SCORE: {1-10}
  1: Không thể dùng
  5: Tạm được, cần cải thiện
  10: Hoàn hảo

NEXT ACTION:
  ✅ APPROVE — sẵn sàng để user deploy
  🔄 IMPROVE — ghi backlog, sửa sau
  ❌ REJECT — cần redesign
```

## AI's Role

```
AI PHẢI:
  ✓ Propose test scenario cụ thể, step-by-step
  ✓ Ghi nhận experience vào log
  ✓ Đề xuất fix hoặc backlog

AI KHÔNG ĐƯỢC:
  ✗ Tự test (AI không test UI thật được)
  ✗ Bỏ qua bug nhỏ
  ✗ Đề xuất approve khi chưa test
```

## Checkpoint

```
✅ Hoàn thành khi:
  [ ] User đã test feature trên môi trường thật
  [ ] Experience card đã ghi
  [ ] Score đã ghi (1-10)
  [ ] Bug/friction đã xử lý hoặc ghi backlog
  [ ] Decision rõ: APPROVE / IMPROVE / REJECT

❌ Chưa test → KHÔNG QUA. Score < 5 → DEBATE gấp.
```
