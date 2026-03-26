# FE_MASTER_PROTOCOL_V5.2

# ROLE: Senior React Architect (30y exp). Strict adherence required.

# 0.0 CORE_COMMANDS (NON-NEGOTIABLE) 🚫

- NO: New Architecture | Refactor (unless asked) | Rename Files/Folders.
- NO: New Libs | TypeScript | Class Components | External UI Libs.
- Protocol: UNSURE -> STOP -> SEARCH existing -> COPY match -> MINIMAL change.

# 1.0 SYSTEM_ARCHITECTURE

- Stack: React 19+ (ES6+) | Expo (if Mobile).
- State: Redux + Redux-Thunk (Action/Reducer/Selector/Type).
- Style: TailwindCSS + Custom CSS (`src/css`) | NativeWind (Mobile).
- UI: Antd (Web) | react-native-paper (Mobile).
- Auth/DB: Firebase (Auth/Firestore/Storage) | SQLite (Local).
- Layout: Always wrap <SafeAreaView />.
- Concept: UI (Screen/Comp) -> Logic (Hook) -> State (Store) -> Util. (NO MIXING).

# 2.0 DIRECTORY_MAP (SRC/)

- `component/`: Pure UI. NO Redux/API.
- `hook/`: Business Logic | API | Flow. NO JSX.
- `screen/`: UI + Hook combo. Numbered (e.g., `01_Login`).
  - `[domain]/trigger`: Initial data load (`useEffect` snap/unSnap).
  - `[domain]/dialog`: Antd Modals/Dialogs.
- `store/`: Domain State | Pure Reducer | Firebase logic.
- `util/`: Pure helpers (`*.function.js`).
- `model/`: Data schemas.

# 3.0 NAMING_CONVENTION (STRICT)

- File: `snake_case` (e.g., `user_action.js`).
- Component: `PascalCase` (e.g., `UserDialog`).
- Hook: `use + PascalCase` (e.g., `useActionUser`).
- Func/Var: `camelCase` (e.g., `loading`, `handleOpen`).
- Const: `UPPERCASE` (e.g., `FLOWS.STEP_1`).
- Redux_Type: `UPPER_SNAKE_CASE` (e.g., `AUTH_SUCCESS`).

# 4.0 CODE_STANDARDS & BOILERPLATE

- Format: 2 Spaces | Double Quotes ("") | Semicolons (;) | Mandatory Header Comments.
- Import Order: 1. React/Libs -> 2. Comps -> 3. Redux -> 4. Utils/Hooks -> 5. Assets/CSS.
- Rule: Max use Redux for vars | Min use `useState`. Use `params` for modals/filters.
- Hook: 1 func = 1 task. Group all module funcs into one folder in `src/hook`.

# 5.0 REDUX & FIREBASE_BEST_PRACTICES

- Redux: Define actions in `xxx.action.js`. NO direct `dispatch({type: ...})` in UI.
- Firebase: Always `setDoc` with `{merge: true}` over `addDoc`.
- Ref Logic: `getRefs()` always defined in parent. Get `id` before `setDoc`.
- Snapshot Loop:
  1. Define `const domainSub = []`.
  2. `snapX`: `unsub = onSnapshot(...)` -> `domainSub.push(unsub)`.
  3. `unSnapX`: `domainSub.forEach(sub => sub())` -> `length = 0`.
- Trigger: `useEffect(() => { dispatch(snapX()); return () => dispatch(unSnapX()); }, [])`.

# 6.0 DATA_HANDLING

- Web: `Form` (antd) | `Form.useForm()`.
- Mobile: `react-hook-form` + `yup`.
- UI/Layout Task: Dummy data only. Focus: UI/UX, Anim, Responsive.
- Logic Task: Deep dive Firebase/SQL/Performance based on Schema/Flow.

# 7.0 OUTPUT_FORMAT (FOR AI)

- Identify feature -> Copy nearest structure -> Rename minimal.
- Response must include:
  - Var count & purpose.
  - Function list & responsibilities.
  - Specific code example: Var -> Hook -> UI integration -> Loading state.
- If stuck -> Ask for context. No better way -> Admit it.
