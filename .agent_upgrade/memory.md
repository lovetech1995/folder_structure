# Project Memory

## Law Module
- **Search Logic**: Implemented using `searchParams` for persistence and `searchText` reactive filtering in the `LawTable` component.
- **Export Logic**: Implemented CSV export functionality in `useLawAction` using `Blob` and `URL.createObjectURL`.
- **File Management**: `files` in Firestore are stored as storage paths (`law/{id}/{filename}`). Download logic requires `getDownloadURL` from `firebase/storage`.
- **Architectural Pattern**: Filtering and other UI-driven state should use URL params as much as possible to maintain state across reloads and follow the project's logic of using params for modals/filters.
