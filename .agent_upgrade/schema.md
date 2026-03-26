# DB_SINGLE_SOURCE_OF_TRUTH

# STACK: Firebase Firestore & Storage

## VISUAL (Mermaid):

erDiagram
    LAW {
        string id PK "Firestore Document ID"
        string code "Document number (Số ký hiệu)"
        string title "Document title (Tiêu đề văn bản)"
        string type "Document type (Luật, Quyết Định, Nghị Định, Thông Tư)"
        string publisher "Issuing body (Đơn vị ban hành)"
        timestamp publishAt "Date of issuance (Ngày ban hành)"
        array files "Storage paths (law/{lawId}/{filename})"
        boolean active "Status (True: Visible, False: Hidden)"
        integer doctype "Type mapping: 0, 1, 2, 3"
    }

## DEFINITIONS:

- Tables: [law (collection)]
- Relations: [law documents store files metadata as an array of storage paths]
- Indices: [code, title, type, active, publishAt]
