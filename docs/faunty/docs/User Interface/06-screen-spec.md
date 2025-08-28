# Screen spec

Example: Team Dashboard

- Route: /team/:placeId/dashboard (conceptual; actual routing is in `main.dart` and navigation widgets)
- Entrance: main navigation, deep links, shared invites
- Primary goals:
	1. Show today's important items (shifts, kantin debt, scheduled programs)
	2. Provide quick actions to resolve items (assign, settle, message)
- Layout:
	- AppBar / custom app bar (`lib/components/custom_app_bar.dart`)
	- Primary content area: cards & lists
	- Bottom navigation: main app navigation (home, tasks, profile)
- Scrolling & responsiveness:
	- Use single-axis scroll per screen; convert to multi-column grid on wide screens
	- Keep important actions in sticky header or FAB on mobile
- Data sources:
	- Firestore: `places/{placeId}/kantin`, `places/{placeId}/program`, `user_list/{userUID}`
	- Providers: see `lib/state_management/` for user and place providers
- Edge cases:
	- Empty state: show onboarding card with CTA
	- Offline mode: show cached data with prominent offline indicator
	- Permission denied: show contextual explanation and contact owner CTA
