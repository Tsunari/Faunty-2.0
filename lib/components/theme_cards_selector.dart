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
    return SizedBox(
      height: 175,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: NotificationListener<ScrollNotification>(
          onNotification: (_) => true,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            physics: const ClampingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
            itemCount: themePresets.length,
            separatorBuilder: (_, __) => const SizedBox(width: 20),
            itemBuilder: (context, i) {
              final preset = themePresets[i];
              final isSelected = i == selectedIndex;
              return GestureDetector(
                onTap: () {
                  ref.read(themePresetProvider.notifier).setPreset(i);
                },
                child: Container(
                  width: 90,
                  height: 150,
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
                  decoration: BoxDecoration(
                    color: preset.seedColor.withOpacity(0.10),
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(
                      color: isSelected ? preset.borderColor : Colors.transparent,
                      width: isSelected ? 3 : 1,
                    ),
                    boxShadow: isSelected
                        ? [BoxShadow(color: preset.borderColor.withOpacity(0.25), blurRadius: 10, offset: Offset(0, 2))]
                        : [],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Stack(
                            children: [
                              Positioned(
                                top: 12,
                                left: 12,
                                right: 12,
                                child: Container(
                                  height: 22,
                                  decoration: BoxDecoration(
                                    color: preset.seedColor,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 12,
                                left: 12,
                                right: 12,
                                child: Container(
                                  height: 34,
                                  decoration: BoxDecoration(
                                    color: preset.seedColor.withOpacity(0.5),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 28,
                        child: Center(
                          child: Text(
                            preset.name,
                            style: TextStyle(
                              fontSize: 15,
                              color: isSelected ? preset.borderColor : Theme.of(context).colorScheme.onSurface,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
