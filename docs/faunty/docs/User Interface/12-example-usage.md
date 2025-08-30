# Example usage (copyable spec)

Component: `PrimaryButton`

- Props:
	- label: String (required)
	- onPressed: Function (required)
	- isLoading: Boolean (default: false)
	- size: small | medium | large
- Default: label="Save", isLoading=false
- Accessibility: expose `semanticLabel` and announce loading state

Contract (2–3 bullets):
- Inputs: label, onPressed, isLoading
- Outputs: onPressed invoked when tapped, no-op when isLoading or disabled
- Errors: validation should be handled by parent; button only reflects disabled state

Test cases:
- Primary: enabled, label visible, onPressed called once
- Loading: spinner visible, onPressed not called
- Disabled: appropriate style and no interaction
