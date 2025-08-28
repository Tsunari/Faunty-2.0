# Implementation checklist

- [ ] Design approved by product and PM
- [ ] Figma frames + asset exports attached to the ticket
- [ ] Component implemented under `lib/components/` with clear API and docs
- [ ] Widget tests added in `test/` covering happy path and at least one edge case
- [ ] Integration with providers: Riverpod providers updated if new streams/queries are required
- [ ] Lint and analyze: `flutter analyze` passes
- [ ] Accessibility checks done (contrast, screen reader)

Deployment notes:
- For web deploys, follow `release.ps1` and check `firebase.json` hosting config.
