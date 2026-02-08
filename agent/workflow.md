---
name: Quy trình làm việc
description: Quy trình làm việc bắt buộc để tất cả AI đều có nhiệm vụ bám sát quy trình này, không đi lan man.
---

# Mô Tả Quy Trình

Khi team nhận được một yêu cầu, hãy phân tích và triển khai yêu cầu theo quy trình sau:

## Team Roles & Responsibilities

| Role                              | Skill File                                            | Responsibilities                                                       | Output                               |
| --------------------------------- | ----------------------------------------------------- | ---------------------------------------------------------------------- | ------------------------------------ |
| **Team Lead**                     | `agent/skills/team-lead/SKILL.md`                     | Phân tích yêu cầu, tạo action list, thiết kế database schema           | `agent/log/plan_[domain]_[date].md`  |
| **Frontend UI**                   | `agent/skills/frontend-ui/SKILL.md`                   | Thiết kế UI mockup với HTML/CSS/Tailwind (static)                      | `agent/ui/plan_[domain]_[date].html` |
| **Frontend Senior Analysis**      | `agent/skills/frontend-senior-analysis/SKILL.md`      | Convert HTML mockup sang React components                              | `src/screen/` hoặc `src/component/`  |
| **Senior Firebase Operation**     | `agent/skills/senior-firebase-operation/SKILL.md`     | Tạo Redux module (action/reducer/selector/type) + Firebase integration | `src/store/[domain]/[module]/`       |
| **Senior Front End Architecture** | `agent/skills/senior-front-end-architecture/SKILL.md` | Tạo custom hooks (action/flow) kết nối UI với Redux                    | `src/hook/[domain]/`                 |

---

## Sequential Workflow Steps

### Step 1: Team Lead - Requirement Analysis

**Input:** User requirement description

**Process:**

1. Phân tích yêu cầu (goal, scope, screens involved)
2. Xác định workflow (có cần UI không? Có cần database không?)
3. Thiết kế database schema (nếu cần)
4. Tạo action list chi tiết cho từng role
5. Estimate timeline

**Output:** `agent/log/plan_[domain]_[date].md` với:

- Requirement analysis
- Action list (tasks cho team)
- Database schema
- Timeline

**Quality Gate:** ✅ All tasks clearly defined với priority và dependencies

---

### Step 2: Frontend UI Designer - Create Mockup (Optional)

**Skip if:** UI already exists hoặc minor change

**Input:** User requirements, design brief từ Team Lead

**Process:**

1. Tạo HTML/CSS/TailwindCSS static mockup
2. Apply premium aesthetics (gradients, shadows, glassmorphism)
3. Ensure responsive (mobile, tablet, desktop)
4. Document interactive elements

**Output:** `agent/ui/plan_[domain]_[date].html`

**Quality Gate:** ✅ Mockup is responsive, modern, và matches requirements

---

### Step 3: Frontend Senior Analysis - React Conversion

**Input:** HTML mockup từ Step 2 (hoặc existing UI reference)

**Process:**

1. Analyze HTML structure
2. Determine component placement (`screen/` vs `component/`)
3. Convert to React với section headers (VAR, STATE, REDUX, etc.)
4. Apply TailwindCSS, integrate Ant Design
5. Add comments cho Redux selectors/actions needed

**Output:**

- `src/screen/[NN_Name]/[name].js` for screens
- `src/component/[category]/[name].js` for reusable components

**Quality Gate:** ✅ Component structure correct, responsive, no JSX errors

---

### Step 4: Senior Firebase Operation - Redux Module (If Needed)

**Skip if:** No database/state management needed

**Input:** Database schema từ Team Lead, data requirements từ Frontend Senior Analysis

**Process:**

1. Create Redux module folder: `src/store/[domain]/[module]/`
2. Create type file (`*.type.js`) với UPPER_SNAKE_CASE constants
3. Create reducer (`*.reducer.js`) với pure switch-case
4. Create selectors (`*.selector.js`)
5. Create actions (`*.action.js`) với Firebase operations:
   - onSnapshot for real-time listeners
   - Cloud functions calls
   - Local state actions
6. Use `.then().catch()` error handling (NO try-catch)

**Output:** Complete Redux module (4 files)

**Quality Gate:** ✅ All CRUD operations implemented, queries optimized, listeners managed

---

### Step 5: Senior Front End Architecture - Custom Hooks

**Input:** Redux actions/selectors từ Step 4, UI interaction requirements

**Process:**

1. Create action hooks (`useAction*`) for user interactions:
   - Form submissions
   - Button clicks
   - Modal open/close
2. Create flow hooks (`useFlow*`) for state transitions:
   - Status changes
   - Multi-step flows
3. Integrate with Redux (useDispatch, useSelector)
4. Handle loading states, error messages
5. Optimize performance (correct useEffect deps)

**Output:** `src/hook/[domain]/use_[type]_[name].js`

**Quality Gate:** ✅ No unnecessary re-renders, error handling implemented, user-friendly messages

---

### Step 6: Integration & Verification

**Responsibility:** Senior Front End Architecture (với support từ Team Lead)

**Process:**

1. Connect hooks to UI components
2. Test all user flows:
   - Happy path (success)
   - Error cases
   - Loading states
   - Edge cases
3. Verify responsive design
4. Check performance (no re-render issues)
5. Verify Firebase costs (query optimization)

**Quality Gate:** ✅ All flows tested, no console errors, responsive works, performance verified

---

## Common Scenarios

### Scenario A: New Feature with Full Stack

**Example:** "Add Task Management feature"

**Workflow:**

1. **Team Lead** → Analysis, database schema, action list
2. **Frontend UI** → Create task list, detail, create/edit mockups
3. **Frontend Senior Analysis** → Convert to React screens
4. **Senior Firebase Operation** → Create `src/store/task/task/*.js` Redux module
5. **Senior Front End Architecture** → Create `useActionTask`, `useFlowTask` hooks
6. **Integration** → Connect and test

**Files Created:**

- `agent/log/plan_task_2026-02-08.md`
- `agent/ui/plan_task_2026-02-08.html`
- `src/screen/05_Task/task_list.js`, `task_detail.js`
- `src/store/task/task/*.js` (4 files)
- `src/hook/task/use_action_task.js`

---

### Scenario B: Modify Existing Feature

**Example:** "Add merge transcript to bailiff detail"

**Workflow:**

1. **Team Lead** → Analyze existing code, plan modifications
2. **Frontend UI** → Skip (minor UI change)
3. **Frontend Senior Analysis** → Create new component `detail_preview.js`
4. **Senior Firebase Operation** → Add `setDraftBailiffMerge` to existing Redux module
5. **Senior Front End Architecture** → Create `useActionDraftMergeSave` hook
6. **Integration** → Add component to detail screen, connect hook

**Files Modified/Created:**

- Modified: `src/store/bailiff/draft/bailiff/draft_bailiff.action.js`
- Created: `src/screen/03_Bailiff/02_Detail/component/detail_preview.js`
- Created: `src/hook/draft/dialog/useActionDraftMerge.js`

---

### Scenario C: UI-Only Update

**Example:** "Update login page button styles"

**Workflow:**

1. **Team Lead** → Quick analysis (no action list needed for minor change)
2. **Frontend Senior Analysis** → Direct edit to `src/screen/01_Login/login_screen.js`
3. **Test** → Verify responsive, no breaks

**Files Modified:**

- Modified: `src/screen/01_Login/login_screen.js` (TailwindCSS classes updated)

---

### Scenario D: Database Schema Change

**Example:** "Add new field 'priority' to bailiff documents"

**Workflow:**

1. **Team Lead** → Design schema change, migration plan
2. **Senior Firebase Operation** → Update Redux action/reducer/selector for new field
3. **Senior Front End Architecture** → Update hooks if needed
4. **Frontend Senior Analysis** → Update UI to display/edit new field
5. **Test** → Verify backward compatibility

**Considerations:**

- Migration strategy for existing documents
- Index updates if query patterns change
- Cost implications

---

## BEST PRACTICES (Bắt Buộc)

### Code Standards

- ✅ **Team fullstack phải code theo đúng nguyên tắc của dự án** (`agent/template.md`). Tất cả các nguyên tắc nằm trong file này.
- ✅ **Tuân thủ DRY và SOLID**: Don't Repeat Yourself, SOLID principles
- ✅ **CLEAN và CLEAR code**: Code phải dễ đọc, dễ hiểu

### Performance Priority

- ✅ **Best Performance** (Speed cho Ứng dụng là tối ưu):
  - TUYỆT ĐỐI HẠN CHẾ RERENDER NHẤT CÓ THỂ
  - KHÔNG QUERY, TRIGGER MẤT KIỂM SOÁT
  - LUÔN KIỂM SOÁT useEffect (hạn chế xài useEffect trong rerender component nếu điều đó không cần thiết)
- ✅ **Reuse Components**: Ưu tiên sử dụng hook và reusable Component trong folder `component/` và `hook/`
- ✅ **Firebase Cost Optimization**:
  - onSnapshot chỉ setup 1 lần ở root screen
  - Batching writes khi có nhiều operations
  - Sử dụng query filters thay vì filter trong code

### Communication & Protocol

- ✅ **Khi không chắc chắn**: Bắt buộc phải hỏi lại, KHÔNG được tự ý làm KHÁC hoặc tự vận hành
- ✅ **Không xoá files**: Team KHÔNG ĐƯỢC XOÁ bất cứ file nào trong suốt quá trình thực thi
- ✅ **Document changes**: Luôn document những thay đổi quan trọng
- ✅ **Follow workflow**: Tuân thủ quy trình, không skip steps unless explicitly approved

### Quality Gates (Checkpoints)

**Before Moving to Next Step:**

- [ ] Code follows `template.md` standards
- [ ] Section headers in correct order
- [ ] Naming conventions correct
- [ ] No prohibited patterns (try-catch, class components, etc.)
- [ ] Performance optimized
- [ ] Responsive tested
- [ ] No console errors

### Error Prevention

**❌ NEVER:**

- Introduce new architecture without approval
- Refactor without explicit request
- Rename files/folders arbitrarily
- Add new libraries without approval
- Use TypeScript (project is JavaScript only)
- Use class components (functional only)
- Use try-catch for Firebase (use `.then().catch()`)
- Skip testing
- Delete files

**✅ ALWAYS:**

- Search existing code for similar patterns FIRST
- Copy closest matching example
- Change only minimum required logic
- Test on multiple devices/screen sizes
- Verify Firebase query costs
- Clean up listeners on unmount
- Handle loading/error states

---

## Success Metrics

**A feature is considered COMPLETE when:**

1. ✅ **Functionality**: All requirements met, tested, working
2. ✅ **Performance**: No unnecessary re-renders, optimized queries
3. ✅ **UX**: Loading states, error handling, responsive design
4. ✅ **Code Quality**: Follows `template.md`, clean, documented
5. ✅ **No Regressions**: Existing features still work
6. ✅ **Team Handoff**: Documentation for others to understand changes

---

**END OF WORKFLOW**

_Teamwork makes the dream work. Follow the process, deliver quality._
