import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../tools/theme_local_storage_helper.dart';

// Define your color schemes
final themePresets = [
  ThemePreset(name: 'Default', seedColor: Colors.green, borderColor: Colors.green),
  ThemePreset(name: 'Dynamic', seedColor: Colors.blueGrey, borderColor: Colors.blueGrey),
  ThemePreset(name: 'Green Apple', seedColor: Colors.greenAccent, borderColor: Colors.greenAccent),
  ThemePreset(name: 'Lavender', seedColor: Colors.purpleAccent, borderColor: Colors.purpleAccent),
  ThemePreset(name: 'Rose', seedColor: Colors.pinkAccent, borderColor: Colors.pinkAccent),
  ThemePreset(name: 'Sunset', seedColor: Colors.deepOrangeAccent, borderColor: Colors.deepOrangeAccent),
  ThemePreset(name: 'Ocean', seedColor: Colors.lightBlueAccent, borderColor: Colors.lightBlueAccent),
  ThemePreset(name: 'Mint', seedColor: Colors.tealAccent, borderColor: Colors.tealAccent),
  ThemePreset(name: 'Berry', seedColor: Colors.redAccent, borderColor: Colors.red),
  ThemePreset(name: 'Sky', seedColor: Colors.cyan, borderColor: Colors.indigo),
  ThemePreset(name: 'Sand', seedColor: Colors.amber, borderColor: Colors.brown),
  ThemePreset(name: 'Monochrome', seedColor: Colors.black, borderColor: Colors.white),
];

class ThemePreset {
  final String name;
  final Color seedColor;
  final Color borderColor;
  const ThemePreset({required this.name, required this.seedColor, required this.borderColor});
}

final themePresetProvider = StateNotifierProvider<ThemePresetNotifier, int>((ref) => ThemePresetNotifier());

class ThemePresetNotifier extends StateNotifier<int> {
  ThemePresetNotifier() : super(0) {
    _loadPreset();
  }

  Future<void> _loadPreset() async {
    final idx = await ThemeLocalStorageHelper.getThemePresetIndex();
    if (idx != null && idx >= 0 && idx < themePresets.length) {
      state = idx;
    }
  }

  Future<void> setPreset(int idx) async {
    state = idx;
    await ThemeLocalStorageHelper.setThemePresetIndex(idx);
  }
}

class ThemeCardsSelector extends ConsumerWidget {
  final Color borderColor;
  const ThemeCardsSelector({super.key, required this.borderColor});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = ref.watch(themePresetProvider);
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = constraints.maxWidth;
        final cardWidth = (screenWidth - 48) / 3.5; // ~3.5 cards visible
        final cardHeight = cardWidth * 1.5;
        return SizedBox(
          height: cardHeight + 30,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: NotificationListener<ScrollNotification>(
              onNotification: (_) => true,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                physics: const ClampingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                itemCount: themePresets.length,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (context, i) {
                  final preset = themePresets[i];
                  final isSelected = i == selectedIndex;
                  return Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          ref.read(themePresetProvider.notifier).setPreset(i);
                        },
                        child: Stack(
                          children: [
                            Container(
                              width: cardWidth,
                              height: cardHeight,
                              decoration: BoxDecoration(
                                color: preset.seedColor.withOpacity(0.10),
                                borderRadius: BorderRadius.circular(cardWidth * 0.18),
                                border: Border.all(
                                  color: isSelected ? preset.borderColor : Colors.transparent,
                                  width: isSelected ? 3 : 1,
                                ),
                                boxShadow: isSelected
                                    ? [BoxShadow(color: preset.borderColor.withOpacity(0.22), blurRadius: 12, offset: Offset(0, 2))]
                                    : [],
                              ),
                              child: Container(
                                margin: EdgeInsets.all(cardWidth * 0.04),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.background,
                                  borderRadius: BorderRadius.circular(cardWidth * 0.14),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(top: cardWidth * 0.13, bottom: cardWidth * 0.07),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Stack(
                                            children: [
                                              Container(
                                                width: cardWidth * 0.16,
                                                height: cardWidth * 0.16,
                                                decoration: BoxDecoration(
                                                  color: preset.seedColor,
                                                  borderRadius: BorderRadius.circular(cardWidth * 0.045),
                                                  border: Border.all(color: Colors.black12, width: 1),
                                                ),
                                              ),
                                              if (isSelected)
                                                Positioned.fill(
                                                  child: Center(
                                                    child: Icon(
                                                      Icons.check,
                                                      size: cardWidth * 0.11,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                            ],
                                          ),
                                          SizedBox(width: cardWidth * 0.045),
                                          Container(
                                            width: cardWidth * 0.16,
                                            height: cardWidth * 0.16,
                                            decoration: BoxDecoration(
                                              color: preset.seedColor.withOpacity(0.7),
                                              borderRadius: BorderRadius.circular(cardWidth * 0.045),
                                              border: Border.all(color: Colors.black12, width: 1),
                                            ),
                                          ),
                                          SizedBox(width: cardWidth * 0.045),
                                          Container(
                                            width: cardWidth * 0.16,
                                            height: cardWidth * 0.16,
                                            decoration: BoxDecoration(
                                              color: preset.borderColor,
                                              borderRadius: BorderRadius.circular(cardWidth * 0.045),
                                              border: Border.all(color: Colors.black12, width: 1),
                                            ),
                                          ),
                                          SizedBox(width: cardWidth * 0.045),
                                          Container(
                                            width: cardWidth * 0.16,
                                            height: cardWidth * 0.16,
                                            decoration: BoxDecoration(
                                              color: preset.seedColor.withOpacity(0.3),
                                              borderRadius: BorderRadius.circular(cardWidth * 0.045),
                                              border: Border.all(color: Colors.black12, width: 1),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Stack(
                                        children: [
                                          Positioned(
                                            top: cardWidth * 0.13,
                                            left: cardWidth * 0.13,
                                            right: cardWidth * 0.13,
                                            child: Container(
                                              height: cardHeight * 0.24,
                                              decoration: BoxDecoration(
                                                color: preset.seedColor,
                                                borderRadius: BorderRadius.circular(cardWidth * 0.11),
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            bottom: cardWidth * 0.13,
                                            left: cardWidth * 0.13,
                                            right: cardWidth * 0.13,
                                            child: Container(
                                              height: cardHeight * 0.38,
                                              decoration: BoxDecoration(
                                                color: preset.seedColor.withOpacity(0.5),
                                                borderRadius: BorderRadius.circular(cardWidth * 0.11),
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            top: cardWidth * 0.08,
                                            left: cardWidth * 0.27,
                                            right: cardWidth * 0.27,
                                            child: Container(
                                              height: cardHeight * 0.06,
                                              decoration: BoxDecoration(
                                                color: Colors.grey.withOpacity(0.13),
                                                borderRadius: BorderRadius.circular(cardWidth * 0.055),
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            bottom: cardWidth * 0.08,
                                            left: cardWidth * 0.27,
                                            right: cardWidth * 0.27,
                                            child: Container(
                                              height: cardHeight * 0.06,
                                              decoration: BoxDecoration(
                                                color: Colors.grey.withOpacity(0.13),
                                                borderRadius: BorderRadius.circular(cardWidth * 0.055),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        height: cardHeight * 0.09,
                        width: cardWidth,
                        child: Center(
                          child: Text(
                            preset.name,
                            style: TextStyle(
                              fontSize: cardWidth * 0.10,
                              color: isSelected ? preset.borderColor : Theme.of(context).colorScheme.onSurface,
                              fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          )
        );
      },
    );
  }
}
