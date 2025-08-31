# Responsive & platform notes
This document outlines the responsive design priorities and testing guidelines for Faunty, since the project is primarily developed and tested as a web application with a smartphone-first focus.

Key points
- Primary target: smartphone users (mobile web). Design, QA and bug fixes prioritise the phone experience.
- Debugging baseline: assume a minimum viewport width of 375px. Make sure core flows, navigation and content fit and are usable at that width.
- Secondary targets: tablet and desktop are supported where practical, but they are lower priority and should not block releases.

Guidance for developers and QA
- Keep touch-first ergonomics in mind: hit targets, spacing and scroll behaviour should work on touch devices.
- Ensure readable font sizes and avoid horizontal scrolling. Prefer vertical stacking over complex multi-column layouts at this size.
- For web-specific affordances (hover, keyboard focus), implement them where convenient but do not rely on them for core flows that must work on phones.
- Collapse side navigation into a bottom navigation or drawer on small screens. Reserve multi-column grids and dense layouts for wider viewports.
- Accessibility: keep keyboard navigation and focus order logical; provide visible focus styles for keyboard users on web.

