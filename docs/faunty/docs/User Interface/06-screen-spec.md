# Screen spec

This document defines the key screens in Faunty (listed in the Bavbar), their purpose, layout and data sources.

## Home / Dashboard
- ### Route: `/team/:placeId/dashboard` (conceptual; actual routing is in `main.dart` and navigation widgets)
- ### Entrance: 
  Navbar, starting the app.
- ### Primary goals:
  1. Show ther most important items (current cleaning place, quick acces to kantin, program, ...)
  2. Provide quick access to main features (cleaning, kantin, program, ...)
- ### Layout:
  - AppBar / custom app bar (`lib/components/custom_app_bar.dart`)
  - Primary content area: list  of cards & quick actions
  - Bottom navigation: main app navigation (`lib/components/navigation_bar.dart`)
- ### Data source:
  - Firestore: `places/{placeId}/kantin`, `places/{placeId}/program`, `user_list/{userUID}`
  - Providers: see `lib/state_management/` for user and place providers


## Communication / Messages
- ### Route: `/team/:placeId/communication` (conceptual; routing in `main.dart` and navigation widgets)
- ### Implementation reference:
  - Page file: `lib/pages/communication/communication_page.dart`
  - Main widget: `CommunicationPage` (uses `TabPage`)
  - Tab index provider: `communicationTabIndexProvider` (`lib/pages/communication/communication_page.dart`)
- ### Tabs (as implemented in code):
  1. Messenger 
  2. Announcements 
  3. Surveys 
  4. Permissions 
  5. Suggestion Box 
  6. Forum 
- ### Entrance: 
  Navbar (Messages tab)
- ### Primary goals:
  1. Behold all kind of pages wich enable communication between users, even of diffrent roles and even communication between diffretent places (yurds)
  2. Completly negate the need of external communication apps like WhatsApp, Telegram, Email, ...
- ### Layout:
  - AppBar / custom app bar (`lib/components/custom_app_bar.dart`) with Search/Filter
  - Tab container: `TabPage` — each tab renders its page widget
  - Thread list / detail and composer expected in Messenger tab (not yet implemented)
  - Surveys tab: `lib/pages/communication/survey_page.dart` (see file for implemented behavior)
- ### Data source:
  - Firestore: `places/{placeId}/messages` (threads) and `places/{placeId}/messages/{threadId}/messages`
  - Providers: expected `lib/state_management/message_provider.dart` (stream + local cache) — check repo to add if missing
  - Required params/payload: `{ placeId: string, threadId?: string }`
  - Provide `semanticLabel` for send, attach and thread items
  - Ensure message bubbles have readable contrast and proper roles
  - Tap target >=48dp, keyboard accessibility for composer
  - Announce incoming messages for screen readers where appropriate

## Tracking / Main Lists
- ### Route: `/team/:placeId/tracking` (conceptual; routing in `main.dart` and navigation widgets)
- ### Entrance: Navbar (Tracking tab), deep links to specific list filters, cross-links from tasks/notifications
- ### Purpose / Primary goals:
  1. Surface all active items that require user action across domains (kantin debt, Attendance)
  2. Provide clear filters & quick actions to resolve or assign items
- ### Tabs (as implemented in code):
  1. Statistics 
  2. Attendance  
  3. Custom list tracking
  4. Kantin
- ### Data sources & providers:
  - Firestore collections: e.g. `places/{placeId}/{domain}` (kantin, cleaning, program, tracking) — canonical mapping depends on domain
  - Suggested provider: `lib/state_management/tracking_provider.dart` (streams + paginated fetch + local cache)
  - Expected params: `{ placeId: string, filter?: string, assigneeId?: string, status?: string, pageCursor?: string }`
- ### Layout:
  - AppBar / custom app bar (`lib/components/custom_app_bar.dart`) 
  - Tab container: `TabPage` — each tab renders its page widget

## Lists
- ### Route: `/team/:placeId/:domain` (conceptual; routing in `main.dart` and navigation widgets)
- ### Entrance: 
  From Navbar
- ### Purpose / Primary goals: 
  1. Show all lists wich dont need any special user interaction (like tracking, communication, ...)
- ### Tabs:
  1. Cleaning
  2. Catering
  3. POrgram
  4. Custom lists and the option to add custom lists
- ### Layout:
  - AppBar / custom app bar (`lib/components/custom_app_bar.dart`) with optional search/filter controls.
  - Page header: title + optional summary (count badges for the list)
  - Primary content: vertical list of items using a shared `list_item_tile` component (title, subtitle/meta, status, action icons)
  - Empty state: illustration + contextual CTA (create / import / refresh)  
- ### Data sources & providers:
  - Firestore collections (per domain): `places/{placeId}/{domain}` — domain examples: `kantin`, `cleaning`, `program`, `attendance`, `feedback`
  - Document subcollections when required: e.g. `places/{placeId}/program/{programId}/attendees`
  - Suggested providers:
    - Domain list provider pattern: `lib/state_management/<domain>_list_provider.dart` (StreamProvider/StateNotifier with pagination and basic filters)
    - Shared helpers: `lib/state_management/list_helpers.dart` for pagination cursors, merges, and offline queue
  - Expected query params: `{ placeId: string, domain: string, filter?: string, assigneeId?: string, status?: string, pageCursor?: string }`
  - Caching & offline: use local cache (hive/shared_preferences) or Firestore persistence; queue mutations when offline and reconcile on reconnect
  - Security: enforce Firestore rules to filter unauthorized documents; deny client-side access to filtered fields and show contextual messaging

## More 
- ### Route: `/team/:placeId/more` (conceptual; routing in `main.dart` and navigation widgets)
- ### Implementation reference:
  - Page file: `lib/pages/more/more_page.dart`
  - Main widget: `MorePage` (uses `ListView` with role gated items)
  - Key providers used: `lib/state_management/user_provider.dart`, `lib/state_management/globals_provider.dart`
- ### Entrance: 
  - Navbar (More tab)
- ### Primary goals:
  1. Gives Acces to all pages wich can not be categorized in the other tabs of the Navbar
  2. Provide acces to functions wich are not not based on the main workflow of Faunty (like settings, about, help, feedback,...)
- ### Items (as implemented / listed):
  - Logo / hero (tap for debug logout)
  - Registration Mode toggle (RoleGate: Hoca) — uses `GlobalsFirestoreService`
  - Account — `lib/pages/more/account_page.dart`
  - Users — `lib/pages/more/users_page.dart` (role gated)
  - Language selector — `lib/components/language_dropdown.dart`
  - Tools — (placeholder)
  - Settings — `lib/pages/more/settings_page.dart`
  - About — `lib/pages/more/about_page.dart`
  - Feedback, Help (placeholders)
- ### Layout / Structure:
  - Vertical `ListView` with sections separated by `Divider()`
  - Hero/logo centered at top (use `Hero(tag: 'logo')`)
  - Role-gated blocks (use `RoleGate` component for admin items)
  - Each item is a `ListTile` with icon (uses `Theme.of(context).colorScheme.primary`)
- ### Data sources & providers:
  - Globals: `GlobalsFirestoreService` (e.g., `registrationMode` field)
  - User info: `user_provider.dart` (current user, role, placeId)
  - Local preferences: language selection may use local persistence or i18n helpers
  - Suggested: audit actions with analytics for critical toggles (registration mode)

  

