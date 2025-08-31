# User Interface — Overview

This page provides a compact overview of the Faunty user interface documentation and links to the individual sections.

Brief: Faunty's UI is real-time first (Firestore + Riverpod), component-based (`lib/components/`) and page-oriented (`lib/pages/`). This directory helps designers and developers quickly find guidelines, design tokens, and reusable components.

## Table of Contents

- [Design Principles](02-design-principles.md)
- [Related artefacts](03-related-artefacts.md)
- [Tokens (colors, spacing, typography)](04-tokens.md)
- [Screen spec](06-screen-spec.md)
- [Responsive & platform notes](09-responsive-platform.md)

## How to use

- Designers: attach Figma frame links and export assets to the relevant section (see `03-related-artefacts` and `10-assets`).
- Developers: implement UI in `lib/components/` and pages in `lib/pages/`; link the implementation path in the component or screen doc.
- Owners: update `13-notes-changelog.md` when tokens or components change.

Where implemented in the repo:

- Reusable UI: `lib/components/`
- Pages / screens: `lib/pages/`
- State & streams: `lib/state_management/`, `lib/firestore/`

