import 'package:flutter/widgets.dart';
import '../models/custom_list_type.dart';
import 'editors/assignment_editor.dart';
import 'viewers/assignment_viewer.dart';
import 'editors/schedule_editor.dart';
import 'viewers/schedule_viewer.dart';
import 'editors/attendance_editor.dart';
import 'viewers/attendance_viewer.dart';
import 'editors/survey_editor.dart';
import 'viewers/survey_viewer.dart';
import '../../pages/program/program_page.dart';
// For Yemekcilik and Kantin, import their pages
import '../../pages/catering/catering.dart';
import '../../pages/more/kantin_page.dart';
import '../../pages/cleaning/cleaning.dart';

typedef ListViewerBuilder =
    Widget Function(
      BuildContext context,
      String listId,
      Map<String, dynamic> content,
    );
typedef ListEditorBuilder =
    Widget Function(
      BuildContext context,
      String listId,
      Map<String, dynamic> content,
      void Function(Map<String, dynamic> updated) onSave,
    );

class CustomListWidgetRegistry {
  static ListViewerBuilder viewerFor(CustomListType type) {
    final meta = CustomListTypeRegistry.meta[type]!;
    if (meta.isPreset) {
      // Return a builder embedding the existing page widgets
      return (context, listId, content) {
        switch (type) {
          case CustomListType.program:
            return const ProgramPage();
          case CustomListType.yemekcilik:
            return const CateringPage();
          case CustomListType.kantin:
            return const KantinPage();
          case CustomListType.temizlik:
            return const CleaningPage();
          default:
            break;
        }
        return AssignmentViewer(listId: listId, content: content);
      };
    }
    switch (meta.pattern) {
      case CustomListPattern.assignment:
        return (context, listId, content) =>
            AssignmentViewer(listId: listId, content: content);
      case CustomListPattern.schedule:
        return (context, listId, content) =>
            ScheduleViewer(listId: listId, content: content);
      case CustomListPattern.attendance:
        return (context, listId, content) =>
            AttendanceViewer(listId: listId, content: content);
      case CustomListPattern.survey:
        return (context, listId, content) =>
            SurveyViewer(listId: listId, content: content);
      case CustomListPattern.freeform:
        return (context, listId, content) => AssignmentViewer(
          listId: listId,
          content: content,
        ); // fallback for now
    }
  }

  static ListEditorBuilder editorFor(CustomListType type) {
    final meta = CustomListTypeRegistry.meta[type]!;
    if (meta.isPreset) {
      // Preset pages manage their own editing UX; provide a read-only viewer or empty editor area
      return (context, listId, content, onSave) =>
          viewerFor(type)(context, listId, content);
    }
    switch (meta.pattern) {
      case CustomListPattern.assignment:
        return (context, listId, content, onSave) => AssignmentEditor(
          listId: listId,
          initialContent: content,
          onSave: onSave,
        );
      case CustomListPattern.schedule:
        return (context, listId, content, onSave) => ScheduleEditor(
          listId: listId,
          initialContent: content,
          onSave: onSave,
        );
      case CustomListPattern.attendance:
        return (context, listId, content, onSave) => AttendanceEditor(
          listId: listId,
          initialContent: content,
          onSave: onSave,
        );
      case CustomListPattern.survey:
        return (context, listId, content, onSave) => SurveyEditor(
          listId: listId,
          initialContent: content,
          onSave: onSave,
        );
      case CustomListPattern.freeform:
        return (context, listId, content, onSave) => AssignmentEditor(
          listId: listId,
          initialContent: content,
          onSave: onSave,
        ); // fallback for now
    }
  }
}
