import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../components/custom_snackbar.dart';
import '../../../tools/translation_helper.dart';
import '../../models/custom_list_type.dart';
import '../../state_management/custom_lists_provider.dart';

class TemplateSelectionDialog extends ConsumerStatefulWidget {
  final CustomListType type;
  final String listId;
  const TemplateSelectionDialog({
    super.key,
    required this.type,
    required this.listId,
  });

  @override
  ConsumerState<TemplateSelectionDialog> createState() =>
      _TemplateSelectionDialogState();
}

class _TemplateSelectionDialogState
    extends ConsumerState<TemplateSelectionDialog> {
  String? _selected;

  @override
  Widget build(BuildContext context) {
    final templatesAsync = ref.watch(customListTemplatesProvider(widget.type));
    return AlertDialog(
      title: Text(translation(context: context, 'Templates')),
      content: SizedBox(
        width: 420,
        height: 360,
        child: templatesAsync.when(
          data: (templates) {
            if (templates.isEmpty) {
              return Center(
                child: Text(
                  translation(context: context, 'No templates found'),
                ),
              );
            }
            final names = templates.keys.toList()..sort();
            _selected ??= names.first;
            return Column(
              children: [
                DropdownButtonFormField<String>(
                  value: _selected,
                  items: [
                    for (final n in names)
                      DropdownMenuItem(value: n, child: Text(n)),
                  ],
                  onChanged: (v) => setState(() => _selected = v),
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: SingleChildScrollView(
                    child: Text(templates[_selected]!.toString()),
                  ),
                ),
              ],
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, st) => Center(child: Text(e.toString())),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(translation(context: context, 'Close')),
        ),
        TextButton(
          onPressed: () async {
            final name = await _promptName(context);
            if (name == null || name.trim().isEmpty) return;
            final content = await ref
                .read(customListsServiceProvider)
                .watchListContent(widget.listId)
                .first;
            await ref
                .read(customListsServiceProvider)
                .setTemplate(widget.type, name.trim(), content);
            if (context.mounted) {
              showCustomSnackBar(
                context,
                translation(context: context, 'Template saved'),
              );
            }
          },
          child: Text(
            translation(context: context, 'Save current as template'),
          ),
        ),
        ElevatedButton(
          onPressed: () async {
            if (_selected == null) return;
            final templates = await ref
                .read(customListsServiceProvider)
                .getTemplates(widget.type);
            final content = templates[_selected];
            if (content == null) return;
            await ref
                .read(customListsServiceProvider)
                .setListContent(widget.listId, content);
            if (context.mounted) {
              showCustomSnackBar(
                context,
                translation(context: context, 'Template loaded'),
              );
            }
          },
          child: Text(translation(context: context, 'Load')),
        ),
      ],
    );
  }

  Future<String?> _promptName(BuildContext context) async {
    final controller = TextEditingController();
    return showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(translation(context: context, 'Template name')),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: 'name'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(translation(context: context, 'Cancel')),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, controller.text.trim()),
            child: Text(translation(context: context, 'Save')),
          ),
        ],
      ),
    );
  }
}
