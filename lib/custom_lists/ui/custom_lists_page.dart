import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../components/custom_app_bar.dart';
import '../../components/role_gate.dart';
import '../../models/user_roles.dart';
import '../../components/custom_snackbar.dart';
import '../../tools/translation_helper.dart';
import '../models/custom_list_model.dart';
import '../models/custom_list_type.dart';
import '../state_management/custom_lists_provider.dart';
import 'custom_list_registry.dart';
import 'dialogs/add_custom_list_dialog.dart';
import 'dialogs/template_selection_dialog.dart';
import '../../components/custom_confirm_dialog.dart';

class CustomListsPage extends ConsumerStatefulWidget {
  const CustomListsPage({super.key});

  @override
  ConsumerState<CustomListsPage> createState() => _CustomListsPageState();
}

class _CustomListsPageState extends ConsumerState<CustomListsPage>
    with TickerProviderStateMixin {
  TabController? _controller;
  int _tabsLen = 0;
  bool _editMode = false;

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final listsAsync = ref.watch(customListsProvider);
    return Scaffold(
      appBar: CustomAppBar(
        title: translation(context: context, 'Custom Lists'),
        actions: [
          IconButton(
            tooltip: _editMode
                ? translation(context: context, 'View')
                : translation(context: context, 'Edit'),
            icon: Icon(
              _editMode ? Icons.visibility_outlined : Icons.edit_outlined,
            ),
            onPressed: () => setState(() => _editMode = !_editMode),
          ),
          PopupMenuButton<String>(
            tooltip: translation(context: context, 'More'),
            onSelected: (value) async {
              final lists =
                  listsAsync.asData?.value ?? const <CustomListModel>[];
              final idx = _controller?.index ?? 0;
              final list = lists.isEmpty ? null : lists[idx];
              if (list == null && value != 'add') return;
              switch (value) {
                case 'templates':
                  if (list != null &&
                      CustomListTypeRegistry
                          .meta[list.type]!
                          .supportsTemplates) {
                    await showDialog(
                      context: context,
                      builder: (_) => TemplateSelectionDialog(
                        type: list.type,
                        listId: list.id,
                      ),
                    );
                  }
                  break;
                case 'delete':
                  if (list == null) break;
                  final confirm = await showDeleteDialog(
                    context: context,
                    thingToDelete: list.name,
                  );
                  if (confirm == true) {
                    await ref
                        .read(customListsServiceProvider)
                        .deleteList(list.id);
                    if (context.mounted) {
                      showCustomSnackBar(
                        context,
                        translation(context: context, 'List deleted'),
                      );
                    }
                  }
                  break;
                case 'add':
                  final created = await showDialog<bool>(
                    context: context,
                    builder: (context) => const AddCustomListDialog(),
                  );
                  if (created == true && context.mounted) {
                    showCustomSnackBar(
                      context,
                      translation(context: context, 'List created'),
                    );
                  }
                  break;
              }
            },
            itemBuilder: (context) {
              final lists =
                  listsAsync.asData?.value ?? const <CustomListModel>[];
              final idx = _controller?.index ?? 0;
              final list = lists.isEmpty ? null : lists[idx];
              final supportsTemplates =
                  list != null &&
                  CustomListTypeRegistry.meta[list.type]!.supportsTemplates;
              return [
                PopupMenuItem(
                  value: 'add',
                  child: Row(
                    children: [
                      const Icon(Icons.add),
                      const SizedBox(width: 8),
                      Text(translation(context: context, 'Add list')),
                    ],
                  ),
                ),
                if (supportsTemplates)
                  PopupMenuItem(
                    value: 'templates',
                    child: Row(
                      children: [
                        const Icon(Icons.folder_copy_outlined),
                        const SizedBox(width: 8),
                        Text(translation(context: context, 'Templates')),
                      ],
                    ),
                  ),
                const PopupMenuDivider(),
                if (list != null)
                  PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        const Icon(
                          Icons.delete_outline,
                          color: Colors.redAccent,
                        ),
                        const SizedBox(width: 8),
                        Text(translation(context: context, 'Delete list')),
                      ],
                    ),
                  ),
              ];
            },
          ),
        ],
      ),
      body: listsAsync.when(
        data: (lists) {
          if (_controller == null || _tabsLen != lists.length) {
            _controller?.dispose();
            _controller = TabController(
              length: lists.isEmpty ? 1 : lists.length,
              vsync: this,
            );
            _tabsLen = lists.length;
          }
          if (lists.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(translation(context: context, 'No custom lists yet.')),
                  const SizedBox(height: 8),
                  ElevatedButton.icon(
                    onPressed: () async {
                      final created = await showDialog<bool>(
                        context: context,
                        builder: (context) => const AddCustomListDialog(),
                      );
                      if (created == true && context.mounted) {
                        showCustomSnackBar(
                          context,
                          translation(context: context, 'List created'),
                        );
                      }
                    },
                    icon: const Icon(Icons.add),
                    label: Text(translation(context: context, 'Create')),
                  ),
                ],
              ),
            );
          }
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Center(
                  child: TabBar(
                    controller: _controller,
                    isScrollable: true,
                    tabAlignment: TabAlignment.center,
                    labelPadding: const EdgeInsets.symmetric(horizontal: 16.0),
                    dividerColor: Colors.transparent,
                    indicatorSize: TabBarIndicatorSize.label,
                    tabs: [for (final l in lists) Tab(text: l.name)],
                  ),
                ),
              ),
              Expanded(
                child: TabBarView(
                  controller: _controller,
                  children: [
                    for (final l in lists)
                      RoleGate(
                        minRole: UserRole.hoca,
                        fallback: _CustomListTab(list: l, editMode: false),
                        child: _CustomListTab(list: l, editMode: _editMode),
                      ),
                  ],
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text(e.toString())),
      ),
    );
  }
}

class _CustomListTab extends ConsumerWidget {
  final CustomListModel list;
  final bool editMode;
  const _CustomListTab({required this.list, required this.editMode});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final contentAsync = ref.watch(customListContentProvider(list.id));
    return contentAsync.when(
      data: (content) {
        final viewerBuilder = CustomListWidgetRegistry.viewerFor(list.type);
        final editorBuilder = CustomListWidgetRegistry.editorFor(list.type);
        if (!editMode) return viewerBuilder(context, list.id, content);
        return editorBuilder(context, list.id, content, (updated) async {
          await ref
              .read(customListsServiceProvider)
              .setListContent(list.id, updated);
          if (context.mounted) showCustomSnackBar(context, translation(context: context, 'Saved'));
        });
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, st) => Center(child: Text(e.toString())),
    );
  }
}
