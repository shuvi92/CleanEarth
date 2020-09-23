import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:timwan/models/trash_report.dart';
import 'package:timwan/viewmodels/user_reports_view_model.dart';

class UserReportsScreen extends StatelessWidget {
  final tabs = <Tab>[
    Tab(
      text: 'Reported',
      icon: Icon(Icons.report),
    ),
    Tab(
      text: 'Cleaned',
      icon: Icon(Icons.done),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<UserReportsViewModel>.reactive(
      viewModelBuilder: () => UserReportsViewModel(),
      onModelReady: (model) => model.initilize(),
      builder: (_, model, __) {
        return DefaultTabController(
          length: tabs.length,
          child: Builder(
            builder: (context) => Scaffold(
              appBar: AppBar(
                title: Text('Reports'),
                bottom: TabBar(
                  tabs: tabs,
                ),
              ),
              body: TabBarView(
                children: <Widget>[
                  _buildListView(
                    model.isLoading,
                    model.createdReports,
                  ),
                  _buildListView(
                    model.isLoading,
                    model.cleanedReports,
                  ),
                ],
              ),
              floatingActionButton: FloatingActionButton(
                child: Icon(Icons.map),
                onPressed: () => model.navigateToReportsMapScreen(
                  DefaultTabController.of(context).index,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildListView(bool isLoading, List<TrashReport> reports) {
    if (isLoading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    if (reports == null || reports.isEmpty) {
      return Center(
        child: Text(':( You don\'t have any reports'),
      );
    }

    return ListView.builder(
      itemCount: reports.length,
      itemBuilder: (context, index) {
        return _buildListTile(reports[index]);
      },
    );
  }

  Widget _buildListTile(TrashReport report) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 10,
      ),
      onTap: () {},
      leading: CachedNetworkImage(
        imageUrl: report.imageData.imageUrl,
        progressIndicatorBuilder: (_, __, progress) =>
            CircularProgressIndicator(
          value: progress.progress,
        ),
        errorWidget: (_, __, error) => Icon(Icons.error),
      ),
      title: Wrap(
        runSpacing: 10.0,
        spacing: 10.0,
        children: <Widget>[
          for (String tag in report.tags)
            Chip(
              label: Text(tag),
              elevation: 5.0,
              backgroundColor: Colors.green,
            ),
        ],
      ),
    );
  }
}
