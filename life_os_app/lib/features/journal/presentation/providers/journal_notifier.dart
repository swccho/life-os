import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../mood/data/models/mood_level.dart';
import '../../../../core/network/api_exception.dart';
import '../../../../core/network/api_response_parser.dart';
import '../../data/models/journal_entry_model.dart';
import 'journal_repository_provider.dart';

enum JournalLoadStatus { initial, loading, refreshing, ready, error }

class JournalStats {
  const JournalStats({
    required this.totalEntries,
    required this.thisWeekCount,
    required this.streakDays,
    this.lastEntryAt,
  });

  final int totalEntries;
  final int thisWeekCount;
  final int streakDays;
  final DateTime? lastEntryAt;
}

class JournalState {
  const JournalState({
    this.loadStatus = JournalLoadStatus.initial,
    required this.entries,
    this.errorMessage,
    this.meta,
  });

  final JournalLoadStatus loadStatus;
  final List<JournalEntryModel> entries;
  final String? errorMessage;
  final PageMeta? meta;

  bool get isLoading =>
      loadStatus == JournalLoadStatus.loading ||
      loadStatus == JournalLoadStatus.initial;

  bool get isRefreshing => loadStatus == JournalLoadStatus.refreshing;

  JournalEntryModel? entryById(String id) {
    try {
      return entries.firstWhere((e) => e.id == id);
    } catch (_) {
      return null;
    }
  }

  List<JournalEntryModel> get recentFirst {
    final list = List<JournalEntryModel>.from(entries)
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return list;
  }

  static DateTime _dateOnly(DateTime d) => DateTime(d.year, d.month, d.day);

  JournalStats statsFor(DateTime now) {
    final total = entries.length;
    if (total == 0) {
      return const JournalStats(
        totalEntries: 0,
        thisWeekCount: 0,
        streakDays: 0,
        lastEntryAt: null,
      );
    }

    final today = _dateOnly(now);
    final weekStart = today.subtract(Duration(days: today.weekday - DateTime.monday));
    var weekCount = 0;
    final daysWithEntry = <DateTime>{};
    for (final e in entries) {
      final d = _dateOnly(e.entryDate);
      daysWithEntry.add(d);
      if (!d.isBefore(weekStart)) weekCount++;
    }

    var streak = 0;
    var cursor = today;
    while (daysWithEntry.contains(cursor)) {
      streak++;
      cursor = cursor.subtract(const Duration(days: 1));
    }

    final last = recentFirst.isNotEmpty ? recentFirst.first.createdAt : null;

    return JournalStats(
      totalEntries: total,
      thisWeekCount: weekCount,
      streakDays: streak,
      lastEntryAt: last,
    );
  }

  JournalState copyWith({
    JournalLoadStatus? loadStatus,
    List<JournalEntryModel>? entries,
    String? errorMessage,
    PageMeta? meta,
    bool clearError = false,
  }) {
    return JournalState(
      loadStatus: loadStatus ?? this.loadStatus,
      entries: entries ?? this.entries,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      meta: meta ?? this.meta,
    );
  }
}

class JournalNotifier extends Notifier<JournalState> {
  @override
  JournalState build() {
    Future.microtask(load);
    return const JournalState(
      loadStatus: JournalLoadStatus.loading,
      entries: [],
    );
  }

  Future<void> load() async {
    state = state.copyWith(
      loadStatus: JournalLoadStatus.loading,
      clearError: true,
    );
    try {
      final (entries, meta) =
          await ref.read(journalRepositoryProvider).fetchEntries();
      state = state.copyWith(
        loadStatus: JournalLoadStatus.ready,
        entries: entries,
        meta: meta,
      );
    } on ApiException catch (e) {
      state = state.copyWith(
        loadStatus: JournalLoadStatus.error,
        errorMessage: e.message,
      );
    } catch (_) {
      state = state.copyWith(
        loadStatus: JournalLoadStatus.error,
        errorMessage: 'Something went wrong. Please try again.',
      );
    }
  }

  Future<void> refresh() async {
    if (state.entries.isEmpty) {
      await load();
      return;
    }
    state = state.copyWith(
      loadStatus: JournalLoadStatus.refreshing,
      clearError: true,
    );
    try {
      final (entries, meta) =
          await ref.read(journalRepositoryProvider).fetchEntries();
      state = state.copyWith(
        loadStatus: JournalLoadStatus.ready,
        entries: entries,
        meta: meta,
      );
    } on ApiException catch (e) {
      state = state.copyWith(
        loadStatus: JournalLoadStatus.ready,
        errorMessage: e.message,
      );
    } catch (_) {
      state = state.copyWith(
        loadStatus: JournalLoadStatus.ready,
        errorMessage: 'Something went wrong. Please try again.',
      );
    }
  }

  Future<String?> createEntry({
    required String title,
    required String content,
    required DateTime entryDate,
    MoodLevel? mood,
    String? tag,
  }) async {
    try {
      final created = await ref.read(journalRepositoryProvider).createEntry(
            title: title,
            content: content,
            entryDate: entryDate,
            mood: mood,
            tag: tag,
          );
      state = state.copyWith(
        entries: [created, ...state.entries],
        loadStatus: JournalLoadStatus.ready,
        clearError: true,
      );
      return null;
    } on ApiException catch (e) {
      return e.message;
    } catch (_) {
      return 'Something went wrong. Please try again.';
    }
  }

  Future<String?> deleteEntry(String id) async {
    if (state.entryById(id) == null) return 'Entry not found';
    try {
      await ref.read(journalRepositoryProvider).deleteEntry(id);
      state = state.copyWith(
        entries: [for (final e in state.entries) if (e.id != id) e],
        loadStatus: JournalLoadStatus.ready,
        clearError: true,
      );
      return null;
    } on ApiException catch (e) {
      state = state.copyWith(errorMessage: e.message);
      return e.message;
    } catch (_) {
      const msg = 'Could not delete entry.';
      state = state.copyWith(errorMessage: msg);
      return msg;
    }
  }

  void clearError() {
    state = state.copyWith(clearError: true);
  }
}

final journalNotifierProvider =
    NotifierProvider<JournalNotifier, JournalState>(JournalNotifier.new);
