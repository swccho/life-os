import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _kAccent = 'lifeos_accent_preset';
const _kSystemTheme = 'lifeos_use_system_theme';
const _kNotifications = 'lifeos_notifications_ui';
const _kHabitReminder = 'lifeos_habit_reminder_ui';
const _kJournalReminder = 'lifeos_journal_reminder_ui';
const _kDefaultTaskView = 'lifeos_default_task_view';

/// Curated accent presets (seed colors for [AppTheme.dark]).
const List<Color> kAccentPresets = [
  Color(0xFF22D3EE),
  Color(0xFF8B5CF6),
  Color(0xFFF472B6),
  Color(0xFF34D399),
  Color(0xFFFBBF24),
];

class SettingsData {
  const SettingsData({
    this.accentPresetIndex = 0,
    this.useSystemTheme = false,
    this.notificationsEnabled = true,
    this.habitRemindersEnabled = false,
    this.journalRemindersEnabled = false,
    this.defaultTaskViewIndex = 0,
  });

  final int accentPresetIndex;
  final bool useSystemTheme;
  final bool notificationsEnabled;
  final bool habitRemindersEnabled;
  final bool journalRemindersEnabled;
  /// 0 = All tasks, 1 = Today
  final int defaultTaskViewIndex;

  Color get accentColor =>
      kAccentPresets[accentPresetIndex.clamp(0, kAccentPresets.length - 1)];

  SettingsData copyWith({
    int? accentPresetIndex,
    bool? useSystemTheme,
    bool? notificationsEnabled,
    bool? habitRemindersEnabled,
    bool? journalRemindersEnabled,
    int? defaultTaskViewIndex,
  }) {
    return SettingsData(
      accentPresetIndex: accentPresetIndex ?? this.accentPresetIndex,
      useSystemTheme: useSystemTheme ?? this.useSystemTheme,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      habitRemindersEnabled:
          habitRemindersEnabled ?? this.habitRemindersEnabled,
      journalRemindersEnabled:
          journalRemindersEnabled ?? this.journalRemindersEnabled,
      defaultTaskViewIndex:
          defaultTaskViewIndex ?? this.defaultTaskViewIndex,
    );
  }
}

class SettingsNotifier extends AsyncNotifier<SettingsData> {
  @override
  Future<SettingsData> build() async {
    final p = await SharedPreferences.getInstance();
    return _read(p);
  }

  SettingsData _read(SharedPreferences p) {
    return SettingsData(
      accentPresetIndex: p.getInt(_kAccent) ?? 0,
      useSystemTheme: p.getBool(_kSystemTheme) ?? false,
      notificationsEnabled: p.getBool(_kNotifications) ?? true,
      habitRemindersEnabled: p.getBool(_kHabitReminder) ?? false,
      journalRemindersEnabled: p.getBool(_kJournalReminder) ?? false,
      defaultTaskViewIndex: p.getInt(_kDefaultTaskView) ?? 0,
    );
  }

  Future<void> _persist(SettingsData next) async {
    final p = await SharedPreferences.getInstance();
    await p.setInt(_kAccent, next.accentPresetIndex);
    await p.setBool(_kSystemTheme, next.useSystemTheme);
    await p.setBool(_kNotifications, next.notificationsEnabled);
    await p.setBool(_kHabitReminder, next.habitRemindersEnabled);
    await p.setBool(_kJournalReminder, next.journalRemindersEnabled);
    await p.setInt(_kDefaultTaskView, next.defaultTaskViewIndex);
    state = AsyncData(next);
  }

  Future<void> setAccentPreset(int index) async {
    final cur = state.value ?? const SettingsData();
    await _persist(cur.copyWith(accentPresetIndex: index));
  }

  Future<void> setUseSystemTheme(bool v) async {
    final cur = state.value ?? const SettingsData();
    await _persist(cur.copyWith(useSystemTheme: v));
  }

  Future<void> setNotificationsEnabled(bool v) async {
    final cur = state.value ?? const SettingsData();
    await _persist(cur.copyWith(notificationsEnabled: v));
  }

  Future<void> setHabitRemindersEnabled(bool v) async {
    final cur = state.value ?? const SettingsData();
    await _persist(cur.copyWith(habitRemindersEnabled: v));
  }

  Future<void> setJournalRemindersEnabled(bool v) async {
    final cur = state.value ?? const SettingsData();
    await _persist(cur.copyWith(journalRemindersEnabled: v));
  }

  Future<void> setDefaultTaskViewIndex(int v) async {
    final cur = state.value ?? const SettingsData();
    await _persist(cur.copyWith(defaultTaskViewIndex: v.clamp(0, 1)));
  }
}

final settingsNotifierProvider =
    AsyncNotifierProvider<SettingsNotifier, SettingsData>(SettingsNotifier.new);
