import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../tools/translation_helper.dart';
import '../../models/custom_list_type.dart';
import '../../state_management/custom_lists_provider.dart';

class AddCustomListDialog extends ConsumerStatefulWidget {
  const AddCustomListDialog({super.key});

  @override
  ConsumerState<AddCustomListDialog> createState() =>
      _AddCustomListDialogState();
}

enum _CreateMode { choose, preset, custom }

class _AddCustomListDialogState extends ConsumerState<AddCustomListDialog> {
  _CreateMode _mode = _CreateMode.choose;
  final TextEditingController _nameController = TextEditingController();
  CustomListType _customType = CustomListType.customAssignment;
  CustomListType? _presetType;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(translation(context: context, 'Create custom list')),
      content: SizedBox(width: 420, child: _buildBody(context)),
      actions: _buildActions(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    switch (_mode) {
      case _CreateMode.choose:
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.auto_awesome_mosaic_outlined),
              title: Text(translation(context: context, 'Use Preset')),
              subtitle: Text(
                translation(
                  context: context,
                  'Program, Catering, Kantin, Cleaning, Yoklama',
                ),
              ),
              onTap: () => setState(() => _mode = _CreateMode.preset),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.tune_outlined),
              title: Text(translation(context: context, 'Create Custom')),
              subtitle: Text(
                translation(
                  context: context,
                  'Name and pick type (Assignment, Schedule, Attendance, Survey, Freeform)',
                ),
              ),
              onTap: () => setState(() => _mode = _CreateMode.custom),
            ),
          ],
        );
      case _CreateMode.preset:
        final presetTypes = <CustomListType>[
          CustomListType.program,
          CustomListType.yemekcilik,
          CustomListType.kantin,
          CustomListType.temizlik,
          CustomListType.yoklama,
        ];
        _presetType ??= presetTypes.first;
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<CustomListType>(
              value: _presetType,
              decoration: InputDecoration(
                labelText: translation(context: context, 'Preset'),
              ),
              items: [
                for (final t in presetTypes)
                  DropdownMenuItem(
                    value: t,
                    child: Text(CustomListTypeRegistry.meta[t]!.displayKey),
                  ),
              ],
              onChanged: (v) => setState(() => _presetType = v),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: translation(context: context, 'Name (optional)'),
              ),
            ),
          ],
        );
      case _CreateMode.custom:
        final customTypes = <CustomListType>[
          CustomListType.customAssignment,
          CustomListType.customSchedule,
          CustomListType.customAttendance,
          CustomListType.customSurvey,
          CustomListType.customFreeform,
        ];
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: translation(context: context, 'Name'),
              ),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<CustomListType>(
              value: _customType,
              decoration: InputDecoration(
                labelText: translation(context: context, 'Type'),
              ),
              items: [
                for (final t in customTypes)
                  DropdownMenuItem(
                    value: t,
                    child: Text(CustomListTypeRegistry.meta[t]!.displayKey),
                  ),
              ],
              onChanged: (v) => setState(() => _customType = v ?? _customType),
            ),
          ],
        );
    }
  }

  List<Widget> _buildActions(BuildContext context) {
    switch (_mode) {
      case _CreateMode.choose:
        return [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(translation(context: context, 'Close')),
          ),
        ];
      case _CreateMode.preset:
        return [
          TextButton(
            onPressed: () => setState(() => _mode = _CreateMode.choose),
            child: Text(translation(context: context, 'Back')),
          ),
          ElevatedButton(
            onPressed: () async {
              if (_presetType == null) return;
              final name = _nameController.text.trim();
              final meta = CustomListTypeRegistry.meta[_presetType]!;
              await ref
                  .read(customListsServiceProvider)
                  .createList(
                    name: name.isEmpty ? meta.displayKey : name,
                    type: _presetType!,
                    initialContent: meta.buildDefaultContent(),
                  );
              if (context.mounted) Navigator.pop(context, true);
            },
            child: Text(translation(context: context, 'Create')),
          ),
        ];
      case _CreateMode.custom:
        return [
          TextButton(
            onPressed: () => setState(() => _mode = _CreateMode.choose),
            child: Text(translation(context: context, 'Back')),
          ),
          ElevatedButton(
            onPressed: () async {
              final name = _nameController.text.trim();
              if (name.isEmpty) return;
              await ref
                  .read(customListsServiceProvider)
                  .createList(
                    name: name,
                    type: _customType,
                    initialContent: CustomListTypeRegistry.meta[_customType]!
                        .buildDefaultContent(),
                  );
              if (context.mounted) Navigator.pop(context, true);
            },
            child: Text(translation(context: context, 'Create')),
          ),
        ];
    }
  }
}
