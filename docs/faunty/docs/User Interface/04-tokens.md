# Tokens (colors, spacing, typography)

## Themes and Color Palettes
Faunty uses themes and color palettes to ensure a consistent and visually appealing user interface. Themes allow users to switch between different visual styles, while color palettes define the specific colors used across the application.

### Themes
1. **System Theme**
   - Adapts to the user's system settings (light or dark mode).
   - Default option for new users.

2. **Light Theme**
   - Optimized for bright environments.
   - Provides high visibility and a clean look.

3. **Dark Theme**
   - Optimized for low-light environments.
   - Reduces eye strain and provides a modern aesthetic.

### Color Palettes
1. **Dynamic Palette**
   - **Primary Color**: #607D8B (Blue Grey)
   - **Surface Color**: #CFD8DC
   - **Muted Color**: #B0BEC5
   - **Success Color**: #4CAF50
   - **Warning Color**: #FFC107
   - **Danger Color**: #F44336

2. **Green Apple Palette**
   - **Primary Color**: #69F0AE (Green Accent)
   - **Surface Color**: #E8F5E9
   - **Muted Color**: #A5D6A7
   - **Success Color**: #00E676
   - **Warning Color**: #FFEB3B
   - **Danger Color**: #D32F2F

3. **Lavender Palette**
   - **Primary Color**: #E040FB (Purple Accent)
   - **Surface Color**: #F3E5F5
   - **Muted Color**: #CE93D8
   - **Success Color**: #AB47BC
   - **Warning Color**: #FF80AB
   - **Danger Color**: #C2185B

4. **Rose Palette**
   - **Primary Color**: #FF4081 (Pink Accent)
   - **Surface Color**: #FCE4EC
   - **Muted Color**: #F48FB1
   - **Success Color**: #F06292
   - **Warning Color**: #FF5252
   - **Danger Color**: #D81B60

5. **Sunset Palette**
   - **Primary Color**: #FF7043 (Deep Orange Accent)
   - **Surface Color**: #FBE9E7
   - **Muted Color**: #FFAB91
   - **Success Color**: #FF5722
   - **Warning Color**: #FF9800
   - **Danger Color**: #BF360C

6. **Ocean Palette**
    - **Primary Color**: #40C4FF (Light Blue Accent)
    - **Surface Color**: #E1F5FE
    - **Muted Color**: #81D4FA
    - **Success Color**: #29B6F6
    - **Warning Color**: #FFCA28
    - **Danger Color**: #D32F2F

7. **Mint Palette**
    - **Primary Color**: #64FFDA (Teal Accent)
    - **Surface Color**: #E0F2F1
    - **Muted Color**: #80CBC4
    - **Success Color**: #26A69A
    - **Warning Color**: #FFD740
    - **Danger Color**: #C62828

8. **Berry Palette**
    - **Primary Color**: #FF5252 (Red Accent)
    - **Surface Color**: #FFEBEE
    - **Muted Color**: #EF9A9A
    - **Success Color**: #E57373
    - **Warning Color**: #FF7043
    - **Danger Color**: #B71C1C

9. **Sky Palette**
    - **Primary Color**: #00BCD4 (Cyan)
    - **Surface Color**: #E0F7FA
    - **Muted Color**: #4DD0E1
    - **Success Color**: #00ACC1
    - **Warning Color**: #FFB300
    - **Danger Color**: #D50000

10. **Sand Palette**
    - **Primary Color**: #FFC107 (Amber)
    - **Surface Color**: #FFF8E1
    - **Muted Color**: #FFD54F
    - **Success Color**: #FFB300
    - **Warning Color**: #FF6F00
    - **Danger Color**: #E65100

11. **Monochrome Palette**
    - **Primary Color**: #000000 (Black)
    - **Surface Color**: #FFFFFF (White)
    - **Muted Color**: #9E9E9E
    - **Success Color**: #757575
    - **Warning Color**: #BDBDBD
    - **Danger Color**: #212121

### Notes
- Themes are managed using Riverpod (`themeProvider`) and can be toggled via the `ThemeSelector` component.
- Color palettes are defined in the shared theme files under `lib/themes`.
- Ensure all themes and palettes meet WCAG AA contrast standards for accessibility.
- Test components with each theme and palette to verify consistent behavior and appearance.
