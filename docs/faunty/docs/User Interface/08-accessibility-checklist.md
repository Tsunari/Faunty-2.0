# Accessibility checklist

Checklist for UI changes in Faunty:
- Contrast: text and actionable elements meet WCAG AA at minimum; key CTAs meet AAA where feasible.
- Tap targets: interactive controls >= 44x44 dp on mobile.
- Semantic roles: ensure screen readers get meaningful labels (`Semantics` widget in Flutter).
- Focus order: logical tab order for keyboard navigation on web and desktop.
- Announcements: success/errors/toasts should be announced to assistive tech.
- Form labels: every input uses explicit label text and error messaging.

Testing:
- Use accessibility scanner tools and manual screen reader testing (TalkBack, VoiceOver) for critical flows.
