---
sidebar_position: 7
---

# Components

This page documents reusable UI components and where to find them.

Location: `lib/components/`

Common components and purpose:

- `custom_app_bar.dart` — consistent app bar used across pages.
- `custom_chip.dart` — selectable chips used in filters and tags.
- `custom_snackbar.dart` — centralized snackbar helper (`showCustomSnackBar`).
- `navigation_bar.dart` — main bottom navigation used on mobile.

When adding a component:

- Keep the widget API minimal and well-typed.
- Use `Theme.of(context)` for colors to respect app theming.
- Add simple doc comments and, if helpful, a small example in this docs folder.
