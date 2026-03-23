import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/api_exception.dart';
import '../../data/models/dashboard_summary_model.dart';
import 'dashboard_repository_provider.dart';

enum DashboardLoadStatus { initial, loading, refreshing, ready, error }

class DashboardState {
  const DashboardState({
    this.loadStatus = DashboardLoadStatus.initial,
    this.summary,
    this.errorMessage,
  });

  final DashboardLoadStatus loadStatus;
  final DashboardSummary? summary;
  final String? errorMessage;

  bool get isLoading =>
      loadStatus == DashboardLoadStatus.loading ||
      loadStatus == DashboardLoadStatus.initial;

  DashboardState copyWith({
    DashboardLoadStatus? loadStatus,
    DashboardSummary? summary,
    String? errorMessage,
    bool clearError = false,
  }) {
    return DashboardState(
      loadStatus: loadStatus ?? this.loadStatus,
      summary: summary ?? this.summary,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}

class DashboardNotifier extends Notifier<DashboardState> {
  @override
  DashboardState build() {
    Future.microtask(load);
    return const DashboardState(loadStatus: DashboardLoadStatus.loading);
  }

  Future<void> load() async {
    state = state.copyWith(
      loadStatus: DashboardLoadStatus.loading,
      clearError: true,
    );
    try {
      final summary =
          await ref.read(dashboardRepositoryProvider).fetchSummary();
      state = state.copyWith(
        loadStatus: DashboardLoadStatus.ready,
        summary: summary,
      );
    } on ApiException catch (e) {
      state = state.copyWith(
        loadStatus: DashboardLoadStatus.error,
        errorMessage: e.message,
      );
    } catch (_) {
      state = state.copyWith(
        loadStatus: DashboardLoadStatus.error,
        errorMessage: 'Something went wrong. Please try again.',
      );
    }
  }

  Future<void> refresh() async {
    state = state.copyWith(
      loadStatus: DashboardLoadStatus.refreshing,
      clearError: true,
    );
    try {
      final summary =
          await ref.read(dashboardRepositoryProvider).fetchSummary();
      state = state.copyWith(
        loadStatus: DashboardLoadStatus.ready,
        summary: summary,
      );
    } on ApiException catch (e) {
      state = state.copyWith(
        loadStatus: DashboardLoadStatus.ready,
        errorMessage: e.message,
      );
    } catch (_) {
      state = state.copyWith(
        loadStatus: DashboardLoadStatus.ready,
        errorMessage: 'Something went wrong. Please try again.',
      );
    }
  }
}

final dashboardNotifierProvider =
    NotifierProvider<DashboardNotifier, DashboardState>(DashboardNotifier.new);
