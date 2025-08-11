
import 'dart:ui';
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final bool useModern;

  const CustomAppBar({
    super.key,
    required this.title,
    this.actions,
    this.useModern = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    if (!useModern) {
      // Old AppBar style
      return AppBar(
        title: Text(title),
        actions: actions,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary.withOpacity(0.1),
      );
    }
    // Modern AppBar style
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: theme.shadowColor.withOpacity(0.12),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              title: Text(
                title,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                  letterSpacing: 0.5,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              actions: actions?.map((w) => Padding(
                        padding: const EdgeInsets.only(right: 4),
                        child: w,
                      )).toList(),
              centerTitle: true,
              automaticallyImplyLeading: true,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 8);
}
