import 'package:flutter/foundation.dart';
import 'custom_list_type.dart';

@immutable
class CustomListModel {
  final String id;
  final String name;
  final CustomListType type;
  final String createdBy;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isPinnedAsWidget; // local UI may ignore; kept for potential future
  final Map<String, dynamic>
  settings; // per-type config (e.g., categories, labels)

  const CustomListModel({
    required this.id,
    required this.name,
    required this.type,
    required this.createdBy,
    required this.createdAt,
    required this.updatedAt,
    required this.isPinnedAsWidget,
    required this.settings,
  });

  CustomListModel copyWith({
    String? id,
    String? name,
    CustomListType? type,
    String? createdBy,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isPinnedAsWidget,
    Map<String, dynamic>? settings,
  }) {
    return CustomListModel(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isPinnedAsWidget: isPinnedAsWidget ?? this.isPinnedAsWidget,
      settings: settings ?? this.settings,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'type': describeEnum(type),
      'createdBy': createdBy,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt.millisecondsSinceEpoch,
      'isPinnedAsWidget': isPinnedAsWidget,
      'settings': settings,
    };
  }

  static CustomListModel fromFirestore(String id, Map<String, dynamic> data) {
    final typeStr = data['type'] as String? ?? 'program';
    final type = CustomListType.values.firstWhere(
      (e) => describeEnum(e) == typeStr,
      orElse: () => CustomListType.program,
    );
    return CustomListModel(
      id: id,
      name: data['name'] as String? ?? 'Unnamed',
      type: type,
      createdBy: data['createdBy'] as String? ?? '',
      createdAt: DateTime.fromMillisecondsSinceEpoch(
        (data['createdAt'] as num?)?.toInt() ?? 0,
      ),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(
        (data['updatedAt'] as num?)?.toInt() ?? 0,
      ),
      isPinnedAsWidget: data['isPinnedAsWidget'] as bool? ?? false,
      settings: Map<String, dynamic>.from(data['settings'] as Map? ?? const {}),
    );
  }
}
