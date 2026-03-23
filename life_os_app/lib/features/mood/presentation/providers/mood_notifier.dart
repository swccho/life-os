import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/api_exception.dart';
import '../../../../core/network/api_response_parser.dart';
import '../../data/models/mood_level.dart';
import '../../data/models/mood_log_entry_model.dart';
import 'mood_repository_provider.dart';

enum MoodLoadStatus { initial, loading, refreshing, ready, error }

/// One slot per calendar day for the week preview (most recent log that day).
class MoodDaySlot {
  const MoodDaySlot({
    required this.day,
    this.log,
  });

  final DateTime day;
  final MoodLogEntryModel? log;
}

class MoodState {
  const MoodState({
    this.loadStatus = MoodLoadStatus.initial,
    required this.logs,
    this.errorMessage,
    this.meta,
  });

  final MoodLoadStatus loadStatus;
  final List<MoodLogEntryModel> logs;
  final String? errorMessage;
  final PageMeta? meta;

  bool get isLoading =>
      loadStatus == MoodLoadStatus.loading ||
      loadStatus == MoodLoadStatus.initial;

  static DateTime _dateOnly(DateTime d) => DateTime(d.year, d.month, d.day);

  static bool _sameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  MoodLogEntryModel? todayLog(DateTime now) {
    final today = _dateOnly(now);
    MoodLogEntryModel? best;
    for (final log in logs) {
      if (!_sameDay(log.loggedAt, today)) continue;
      if (best == null || log.loggedAt.isAfter(best.loggedAt)) {
        best = log;
      }
    }
    return best;
  }

  List<MoodDaySlot> weekPreview(DateTime now) {
    final today = _dateOnly(now);
    final slots = <MoodDaySlot>[];
    for (var i = 6; i >= 0; i--) {
      final day = today.subtract(Duration(days: i));
      MoodLogEntryModel? pick;
      for (final log in logs) {
        if (!_sameDay(log.loggedAt, day)) continue;
        if (pick == null || log.loggedAt.isAfter(pick.loggedAt)) {
          pick = log;
        }
      }
      slots.add(MoodDaySlot(day: day, log: pick));
    }
    return slots;
  }

  List<MoodLogEntryModel> get recentFirst {
    final list = List<MoodLogEntryModel>.from(logs)
      ..sort((a, b) => b.loggedAt.compareTo(a.loggedAt));
    return list;
  }

  MoodState copyWith({
    MoodLoadStatus? loadStatus,
    List<MoodLogEntryModel>? logs,
    String? errorMessage,
    PageMeta? meta,
    bool clearError = false,
  }) {
    return MoodState(
      loadStatus: loadStatus ?? this.loadStatus,
      logs: logs ?? this.logs,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      meta: meta ?? this.meta,
    );
  }
}

class MoodNotifier extends Notifier<MoodState> {
  @override
  MoodState build() {
    Future.microtask(load);
    return const MoodState(
      loadStatus: MoodLoadStatus.loading,
      logs: [],
    );
  }

  Future<void> load() async {
    state = state.copyWith(
      loadStatus: MoodLoadStatus.loading,
      clearError: true,
    );
    try {
      final (logs, meta) = await ref.read(moodRepositoryProvider).fetchLogs();
      state = state.copyWith(
        loadStatus: MoodLoadStatus.ready,
        logs: logs,
        meta: meta,
      );
    } on ApiException catch (e) {
      state = state.copyWith(
        loadStatus: MoodLoadStatus.error,
        errorMessage: e.message,
      );
    } catch (_) {
      state = state.copyWith(
        loadStatus: MoodLoadStatus.error,
        errorMessage: 'Something went wrong. Please try again.',
      );
    }
  }

  Future<void> refresh() async {
    if (state.logs.isEmpty) {
      await load();
      return;
    }
    state = state.copyWith(
      loadStatus: MoodLoadStatus.refreshing,
      clearError: true,
    );
    try {
      final (logs, meta) = await ref.read(moodRepositoryProvider).fetchLogs();
      state = state.copyWith(
        loadStatus: MoodLoadStatus.ready,
        logs: logs,
        meta: meta,
      );
    } on ApiException catch (e) {
      state = state.copyWith(
        loadStatus: MoodLoadStatus.ready,
        errorMessage: e.message,
      );
    } catch (_) {
      state = state.copyWith(
        loadStatus: MoodLoadStatus.ready,
        errorMessage: 'Something went wrong. Please try again.',
      );
    }
  }

  Future<String?> logToday(MoodLevel mood, String? note) async {
    final now = DateTime.now();
    final day = DateTime(now.year, now.month, now.day);
    try {
      final entry = await ref.read(moodRepositoryProvider).logToday(
            mood: mood,
            note: note,
            now: now,
          );
      final next = <MoodLogEntryModel>[
        for (final log in state.logs)
          if (!_sameCalendarDay(log.loggedAt, day)) log,
        entry,
      ];
      state = state.copyWith(
        logs: next,
        loadStatus: MoodLoadStatus.ready,
        clearError: true,
      );
      return null;
    } on ApiException catch (e) {
      return e.message;
    } catch (_) {
      return 'Something went wrong. Please try again.';
    }
  }

  static bool _sameCalendarDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  Future<String?> deleteEntry(String id) async {
    final exists = state.logs.any((l) => l.id == id);
    if (!exists) return 'Entry not found';
    try {
      await ref.read(moodRepositoryProvider).deleteEntry(id);
      state = state.copyWith(
        logs: [for (final l in state.logs) if (l.id != id) l],
        loadStatus: MoodLoadStatus.ready,
        clearError: true,
      );
      return null;
    } on ApiException catch (e) {
      state = state.copyWith(errorMessage: e.message);
      return e.message;
    } catch (_) {
      const msg = 'Could not delete mood entry.';
      state = state.copyWith(errorMessage: msg);
      return msg;
    }
  }

  void clearError() {
    state = state.copyWith(clearError: true);
  }
}

final moodNotifierProvider =
    NotifierProvider<MoodNotifier, MoodState>(MoodNotifier.new);
