import 'package:flutter/material.dart';
import 'package:timwan/models/reports_stats.dart';

class ReportsStatsCard extends StatelessWidget {
  final ReportsStats stats;

  const ReportsStatsCard({
    Key key,
    @required this.stats,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int cleaned = stats?.cleaned ?? 0;
    int reported = stats?.reported ?? 0;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          // margin: const EdgeInsets.all(12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Container(
                height: 100,
                width: 150,
                child: Card(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        cleaned.toString(),
                        style: TextStyle(fontSize: 24),
                      ),
                      Text('cleaned up'),
                    ],
                  ),
                ),
              ),
              Container(
                height: 100,
                width: 150,
                child: Card(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        reported.toString(),
                        style: TextStyle(fontSize: 24),
                      ),
                      Text('total reports')
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
