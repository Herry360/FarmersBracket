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
}

class IssueReportNotifier extends StateNotifier<IssueReportState> {
  void submitReport(IssueReport report) {
    // Instant resolution logic for Wrong Item or Missing Item
    if (report.issueType == 'Wrong Item' ||
        report.issueType == 'Missing Item') {
      // Mock: Add credit to user's account (would update UserProvider in real app)
      // e.g., userProvider.addCredit(report.resolvedCreditAmount ?? 15.0);
    }
    addReport(report);
  }

  IssueReportNotifier()
    : super(IssueReportState(reports: [], isLoading: false, error: null));

  Future<void> loadReports(String userId) async {
    state = IssueReportState(
      reports: state.reports,
      isLoading: true,
      error: null,
    );
    await Future.delayed(const Duration(milliseconds: 300));
    state = IssueReportState(reports: [], isLoading: false, error: null);
  }

  void addReport(IssueReport report) {
    final updated = List<IssueReport>.from(state.reports)..add(report);
    state = IssueReportState(reports: updated, isLoading: false, error: null);
  }
}

final issueReportProvider =
    StateNotifierProvider<IssueReportNotifier, IssueReportState>((ref) {
      return IssueReportNotifier();
    });
