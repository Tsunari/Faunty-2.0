import 'package:flutter/foundation.dart';

/// High-level patterns describing the data shape and UX of a custom list.
/// Concrete list types map to one of these patterns.
enum CustomListPattern {
  assignment, // e.g., Temizlik, Imam Müezzin, Nöbetci, Rollen/Hizmet, Çamaşırhane, Dış Hizmet
  schedule, // e.g., Program, Hatim, Users↔Time/Place, Time↔Event
  attendance, // e.g., Yoklama
  survey, // e.g., Umfragen
  freeform, // reserved for future use
}

/// All supported list types in the app.
enum CustomListType {
  temizlik,
  yemekcilik,
  program,
  umfragen,
  kantin,
  hatim,
  yoklama,
  imamMuezzin,
  camasirhane,
  nobetci,
  rollenHizmet,
  disHizmet,
  userTimePlace,
  timeEvent,
  // Generic, user-created types
  customAssignment,
  customSchedule,
  customAttendance,
  customSurvey,
  customFreeform,
}

/// Metadata for each `CustomListType`.
@immutable
class CustomListTypeMeta {
  final String key; // stable key for Firestore folders (no spaces, ASCII)
  final String displayKey; // i18n key for UI
  final CustomListPattern pattern;
  final Map<String, dynamic> Function() buildDefaultContent;
  final bool supportsTemplates; // whether Templates action is available
  final bool
  isPreset; // if true, render via existing feature page instead of generic editors

  const CustomListTypeMeta({
    required this.key,
    required this.displayKey,
    required this.pattern,
    required this.buildDefaultContent,
    this.supportsTemplates = false,
    this.isPreset = false,
  });
}

/// Registry describing how each list type behaves and what default content looks like.
class CustomListTypeRegistry {
  static const Map<CustomListType, CustomListTypeMeta> meta = {
    CustomListType.temizlik: CustomListTypeMeta(
      key: 'temizlik',
      displayKey: 'Temizlik',
      pattern: CustomListPattern.assignment,
      buildDefaultContent: _defaultAssignment,
      isPreset: true,
    ),
    CustomListType.yemekcilik: CustomListTypeMeta(
      key: 'yemekcilik',
      displayKey: 'Yemekcilik',
      pattern: CustomListPattern.assignment,
      buildDefaultContent: _defaultAssignment,
      isPreset: true,
    ),
    CustomListType.program: CustomListTypeMeta(
      key: 'program',
      displayKey: 'Program',
      pattern: CustomListPattern.schedule,
      buildDefaultContent: _defaultSchedule,
      isPreset: true,
    ),
    CustomListType.umfragen: CustomListTypeMeta(
      key: 'umfragen',
      displayKey: 'Umfragen',
      pattern: CustomListPattern.survey,
      buildDefaultContent: _defaultSurvey,
      supportsTemplates: true,
    ),
    CustomListType.kantin: CustomListTypeMeta(
      key: 'kantin',
      displayKey: 'Kantin',
      pattern: CustomListPattern.assignment,
      buildDefaultContent: _defaultAssignment,
      isPreset: true,
    ),
    CustomListType.hatim: CustomListTypeMeta(
      key: 'hatim',
      displayKey: 'Hatim',
      pattern: CustomListPattern.schedule,
      buildDefaultContent: _defaultSchedule,
      supportsTemplates: true,
    ),
    CustomListType.yoklama: CustomListTypeMeta(
      key: 'yoklama',
      displayKey: 'Yoklama',
      pattern: CustomListPattern.attendance,
      buildDefaultContent: _defaultAttendance,
    ),
    CustomListType.imamMuezzin: CustomListTypeMeta(
      key: 'imam_muezzin',
      displayKey: 'Imam Müezzin',
      pattern: CustomListPattern.assignment,
      buildDefaultContent: _defaultAssignment,
    ),
    CustomListType.camasirhane: CustomListTypeMeta(
      key: 'camasirhane',
      displayKey: 'Çamaşırhane',
      pattern: CustomListPattern.assignment,
      buildDefaultContent: _defaultAssignment,
    ),
    CustomListType.nobetci: CustomListTypeMeta(
      key: 'nobetci',
      displayKey: 'Nöbetci',
      pattern: CustomListPattern.assignment,
      buildDefaultContent: _defaultAssignment,
    ),
    CustomListType.rollenHizmet: CustomListTypeMeta(
      key: 'rollen_hizmet',
      displayKey: 'Rollen/Hizmet',
      pattern: CustomListPattern.assignment,
      buildDefaultContent: _defaultAssignment,
    ),
    CustomListType.disHizmet: CustomListTypeMeta(
      key: 'dis_hizmet',
      displayKey: 'Dış Hizmet',
      pattern: CustomListPattern.assignment,
      buildDefaultContent: _defaultAssignment,
    ),
    CustomListType.userTimePlace: CustomListTypeMeta(
      key: 'user_time_place',
      displayKey: 'Users mapped to Time/Place',
      pattern: CustomListPattern.schedule,
      buildDefaultContent: _defaultSchedule,
    ),
    CustomListType.timeEvent: CustomListTypeMeta(
      key: 'time_event',
      displayKey: 'Time mapped Event',
      pattern: CustomListPattern.schedule,
      buildDefaultContent: _defaultSchedule,
    ),
    // Generic user-created types
    CustomListType.customAssignment: CustomListTypeMeta(
      key: 'custom_assignment',
      displayKey: 'Assignment',
      pattern: CustomListPattern.assignment,
      buildDefaultContent: _defaultAssignment,
    ),
    CustomListType.customSchedule: CustomListTypeMeta(
      key: 'custom_schedule',
      displayKey: 'Schedule',
      pattern: CustomListPattern.schedule,
      buildDefaultContent: _defaultSchedule,
    ),
    CustomListType.customAttendance: CustomListTypeMeta(
      key: 'custom_attendance',
      displayKey: 'Attendance',
      pattern: CustomListPattern.attendance,
      buildDefaultContent: _defaultAttendance,
    ),
    CustomListType.customSurvey: CustomListTypeMeta(
      key: 'custom_survey',
      displayKey: 'Survey',
      pattern: CustomListPattern.survey,
      buildDefaultContent: _defaultSurvey,
    ),
    CustomListType.customFreeform: CustomListTypeMeta(
      key: 'custom_freeform',
      displayKey: 'Freeform',
      pattern: CustomListPattern.freeform,
      buildDefaultContent: _defaultAssignment,
    ),
  };

  static Map<String, dynamic> _defaultAssignment() => {
    'categories': <String, dynamic>{},
  };

  static Map<String, dynamic> _defaultSchedule() => {
    'weekProgram': {
      for (final day in const [
        'Monday',
        'Tuesday',
        'Wednesday',
        'Thursday',
        'Friday',
        'Saturday',
        'Sunday',
      ])
        day: <Map<String, dynamic>>[],
    },
  };

  static Map<String, dynamic> _defaultAttendance() => {
    'attendance':
        <String, dynamic>{}, // yyyy-MM-dd -> {present: [], absent: []}
    'roster': <String>[],
  };

  static Map<String, dynamic> _defaultSurvey() => {
    'questions':
        <
          String,
          dynamic
        >{}, // qId -> {question, options: [], responses: {uid: index}}
  };
}
