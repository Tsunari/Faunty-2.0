---
sidebar_position: 6
---

# Firestore

Firestore collections follow this structure:

- `places/{placeId}/{domain}` — domain collections such as `kantin`, `cleaning`, `catering`, `program`.
- `user_list/{userUID}` — user-specific data fields.

Each domain has a service in `lib/firestore/` implementing CRUD and domain logic. Example: `kantin_firestore_service.dart`.

Best practices:

- Keep queries and mapping logic in the service class.
- Return domain models from services; map documents to models in a single place.
