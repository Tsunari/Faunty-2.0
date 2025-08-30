# Design Philosophy
## Fundamentals
### Simplicity
- We want Faunty to be as simple as possible to appeal to a wide user base.
- We want Faunty to be a real alternative to other proven concepts (e.g. a list on a blackboard).
- We want common tasks to be discoverable and completable in as few steps as possible.
### Customizability
- Faunty should be able to satisfy a variety of use cases.
- Optimally, a user base should not have to use another medium (e.g., paper, Excel) to fill gaps.
- Admins should be able to configure the app to their needs without developer support.
### Intuitiveness
- Faunty sholuld be usable withoiut any tutorial or prior experience.
- The Ui should follow common mobile and web app conventions. so users feel at home.

## When to apply and when not to apply / trade-offs
- Obviusly, useability sholuld not be sacrifced for the sake of simplicitiy or customizabilty.
- The fundamentals should be used in every ascpect of the app, even into the smallest details.
- To achive a simple and intuitive Ui, we try to keep the app koherent and avoid custom solutions whereever possible.

## Implementation notes
### Components to reuse
We use components whenever possible: (e.g. `Dialogs`, `Card`, `Chip` — `lib/components/...` path)
### Accessibility considerations
- Contrast and reability.
- Autofocus and QOL features to keyboard inputs.
- Template, save, load for most features.
- If neccesary, multiple views.

