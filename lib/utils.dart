import 'package:timwan/models/reports_stats.dart';
import 'package:timwan/models/trash_report.dart';

ReportsStats calculateStats(List<TrashReport> reports) {
  ReportsStats newStats = ReportsStats(cleaned: 0, reported: 0);
  if (reports != null) {
    for (var report in reports) {
      if (report.cleanerUid != null && report.cleanerUid.isNotEmpty) {
        newStats.cleaned++;
      }
      newStats.reported++;
    }
  }
  return newStats;
}
