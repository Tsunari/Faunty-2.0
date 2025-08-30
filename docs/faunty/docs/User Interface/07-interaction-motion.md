# Interaction & Motion

Micro-interactions to standardize:
- Toast/Snackbar: short confirmation messages (2000-3500ms), appear at bottom, accessible announcement.
- Pull-to-refresh: for lists that stream Firestore updates, offer manual refresh as a fallback.
- Item swipe: use for dismiss or quick actions with clear undo (snackbar with undo)

Motion guidance:
- Standard duration: 150ms (fast), 300ms (default), 450ms (complex)
- Easing: use ease-out for entering, ease-in for exit; prefer cubic-bezier matching platform defaults where possible.

When to animate:
- State transitions (loading -> content) should animate to reduce perceived latency.
- Avoid heavy animations for lists with real-time updates; prefer subtle cross-fades.
