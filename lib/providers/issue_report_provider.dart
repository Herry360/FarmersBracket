import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/issue_report_model.dart';

class IssueReportState {
  final List<IssueReport> reports;
  final bool isLoading;
  final String? error;
  IssueReportState({
    required this.reports,
    required this.isLoading,
    this.error,
  });

  IssueReportState copyWith({
    List<IssueReport>? reports,
    bool? isLoading,
    String? error,
  }) {
    return IssueReportState(
      reports: reports ?? this.reports,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class IssueReportNotifier extends StateNotifier<IssueReportState> {
  IssueReportNotifier()
      : super(IssueReportState(reports: [], isLoading: false, error: null));

  Future<void> loadReports(String userId) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      // Simulate fetching reports from a backend
      await Future.delayed(const Duration(milliseconds: 300));
      // Replace with actual fetch logic
      state = state.copyWith(reports: [], isLoading: false, error: null);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  void addReport(IssueReport report) {
    final updated = List<IssueReport>.from(state.reports)..add(report);
    state = state.copyWith(reports: updated, isLoading: false, error: null);
  }

  void submitReport(IssueReport report) {
    // Instant resolution logic for Wrong Item or Missing Item
    if (report.issueType == 'Wrong Item' ||
        report.issueType == 'Missing Item') {
      // Mock: Add credit to user's account (would update UserProvider in real app)
      // e.g., userProvider.addCredit(report.resolvedCreditAmount ?? 15.0);
    }
    addReport(report);
  }
}

final issueReportProvider =
    StateNotifierProvider<IssueReportNotifier, IssueReportState>((ref) {
  return IssueReportNotifier();
});