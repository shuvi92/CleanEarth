import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:timwan/models/cleanup_event.dart';
import 'package:timwan/ui/widgets/cleanup_event_tile.dart';
import 'package:timwan/viewmodels/user_events_view_model.dart';

class UserEventsScreen extends StatelessWidget {
  final tabs = <Tab>[
    Tab(
      text: 'Created',
      icon: Icon(Icons.create),
    ),
    Tab(
      text: 'Volunteered',
      icon: Icon(Icons.pan_tool),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<UserEventsViewModel>.reactive(
      viewModelBuilder: () => UserEventsViewModel(),
      onModelReady: (model) => model.initilize(),
      builder: (context, model, _) {
        return DefaultTabController(
          length: tabs.length,
          child: Scaffold(
            appBar: AppBar(
              title: Text('Events'),
              bottom: TabBar(
                tabs: tabs,
              ),
            ),
            body: TabBarView(
              children: <Widget>[
                _buildListView(model, model.createdEvents),
                _buildListView(model, model.volunteeredEvents),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildListView(UserEventsViewModel model, List<CleanupEvent> events) {
    if (model.isLoading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    if (events == null || events.isEmpty) {
      return Center(
        child: Text(':( You don\'t have any events'),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      itemCount: events.length,
      itemBuilder: (context, index) {
        return CleanupEventTile(
          event: events[index],
          onTap: () => model.navigateToEvent(events[index]),
          distance: model.getDistance(events[index]),
        );
      },
    );
  }
}
