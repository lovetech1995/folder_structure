# BE_CLOUD_FUNCTIONS_PROTOCOL_V5.2
# ROLE: Cloud System Master. Strict File Structure & Logic Compliance.

# 1.0 DIRECTORY_TREE (NON-NEGOTIABLE) 🚫
`textfunctions/src/`
├── `api/`: CRUD Functions (e.g., `default/email/email.check.js`).
├── `firestore/`: Triggers (default/auth). Include `ref.js`.
├── `store/`: DB Interaction Layer.
│   ├── `ref.js`: Collection/Region constants.
│   ├── `xxx.query.js`: Read-only.
│   └── `xxx.action.js`: Write-only.
├── `config/`: `config.js` | `serviceAccountKey.json`.
└── `util/`: Shared helpers (convert, generate).

# 2.0 NAMING_CONVENTION
- File: `name.module.js` (e.g., `user.update.js`).
- Folder: `lowercase-dash` (e.g., `branch-office`).
- Firestore Collection: `lowercase` (e.g., `user`).
- DB_Name: `(default)` or `admin`.

# 3.0 CODE_STRUCTURE (STRICT 100%)
# A. Header:
`const { REGION } = require("../../../store/ref");`
`const { ERROR_HTTPS } = require("../../../store/string");`
`const [TIMEOUT, MEMORY] = [120, "256MB"];`

# B. Execution Pattern (v2 onCall):
`// :::::::::::::::::::: gen2 ::::::::::::::::::://`
`exports.funcName = onCall({ region: REGION, timeoutSeconds: TIMEOUT, memory: MEMORY, enforceAppCheck: true }, (request) => {`
`  return processHtttps({ data: request.data, context: { app: request.app, auth: request.auth } });`
`});`

# C. Mandatory Function Order:
1. `// ::::::::::: required ::::::::::::::::://` -> `const processHtttps = ...` (NO async/await).
2. `// ::::::::::: validation ::::::::::::::::://` -> `const validateData = async ...`
3. `// ::::::::::: action ::::::::::::::::://` -> `const handleAction = async ...`

# D. Firestore Triggers:
`exports.sent = onDocumentCreated({ region: REGION, database: DATABASE.NAME, document: DATABASE.DOC }, async (event) => { ... });`

# 4.0 ERROR & LOGGING
- Error: `throw new functions.https.HttpsError(code, message)` via `ERROR_HTTPS`.
- Response: `{ status: 200 }` OR `{ status: 500, data: "msg" }`.
- Logger: `functions.logger.log("input", data)` | `functions.logger.error(...)`.
- NO `console.log`.

# 5.0 THE "FORBIDDEN" LIST (STRICT) ❌
- NO: Refactoring | New ESLint | ES Modules (Use CommonJS `require`).
- NO: Async/Await in `processHtttps`.
- NO: Renaming `processHtttps` (keep typo).
- NO: `AppCheck: false` | Changing `MEMORY/TIMEOUT` (unless asked).
- NO: Adding packages to `package.json` without notice.
- NO: Deleting mandatory comment headers (e.g., `// ::::::::::: action ::::::::::::::::://`).

# 6.0 EXPORT_STRATEGY (index.js)
- Every folder MUST have `index.js`.
- Export Pattern: `exports.check = require("./email.check");`
- Final Export Mapping: `firestore-default-user-create-account` -> `exports.account = onDocumentCreated(...)`.

# 7.0 BEST_PRACTICES
- SOLID/DRY: 1 function = 1 task.
- Traceability: Log every process + variable.
- Performance: Minimize cold starts | Use v2 Gen.
- Resilience: Copy nearest file format -> Update all `index.js`.