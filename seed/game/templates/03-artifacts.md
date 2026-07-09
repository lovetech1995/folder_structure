# 🏗️ Deployable JSON Artifacts (cho USER deploy)

## /firestore.rules.json

```json
{
  "rules": {
    "match /databases/default/documents": {
      "functions": [
        "function isAuthenticated() { return request.auth.uid != null; }",
        "function isOwner() { return request.auth.uid != null && request.auth.uid == resource.data.userId; }",
        "function willBeOwner() { return request.auth.uid != null && request.auth.uid == request.resource.data.userId; }",
        "function isOperator(per) { return request.auth.uid != null && per in request.auth.token.operators; }",
        "function isNghia() { return request.auth.uid == 'ADMIN_UID'; }",
        "function initFields(attr) { return request.resource.data.keys().hasOnly(attr); }"
      ],
      "match /{collection}/{id}": {
        "allow read": "if isAuthenticated()",
        "allow create": "if isAuthenticated() && willBeOwner() && initFields(['field1', 'createAt', 'updateAt'])",
        "allow update": "if isOwner() || isOperator('op')",
        "allow delete": "if isOwner() || isNghia()"
      }
    }
  }
}
```

## /firestore.indexes.json

```json
{
  "indexes": [
    {
      "collectionGroup": "{collection}",
      "queryScope": "COLLECTION",
      "fields": [
        { "fieldPath": "status", "order": "ASCENDING" },
        { "fieldPath": "createAt", "order": "DESCENDING" }
      ]
    }
  ],
  "fieldOverrides": []
}
```

## /storage.rules.json

```json
{
  "rules": {
    "match /b/{bucket}/o": {
      "match /{allPaths=**}": {
        "allow read": "if request.auth != null",
        "allow write": "if request.auth != null && request.resource.size < 10 * 1024 * 1024"
      },
      "match /public/{allPaths=**}": {
        "allow read": "if true",
        "allow write": "if request.auth != null && request.auth.uid != null"
      }
    }
  }
}
```

> **Lưu ý:** Seed generate → **USER deploy** bằng `firebase deploy --only firestore:rules`
