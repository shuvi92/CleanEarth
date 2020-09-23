import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:timwan/viewmodels/user_details_view_model.dart';

class UserDetailsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<UserDetailsViewModel>.reactive(
      viewModelBuilder: () => UserDetailsViewModel(),
      builder: (context, model, _) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            iconTheme: IconThemeData(
              color: Colors.black,
            ),
          ),
          backgroundColor: Colors.white,
          body: ListView(
            padding: const EdgeInsets.only(
              top: 30,
              left: 30,
              right: 30,
            ),
            children: <Widget>[
              Text(
                'Hello, ${model.user?.fullName}',
                style: TextStyle(fontSize: 24),
              ),
              if (!model.isAnonymous())
                ListTile(
                  leading: Icon(Icons.add_circle),
                  title: Text('Create Event'),
                  onTap: model.navigateToCreateEvent,
                ),
              ListTile(
                leading: Icon(Icons.report),
                title: Text('View Your Reports'),
                onTap: model.navigateToUserReportsScreen,
              ),
              ListTile(
                leading: Icon(Icons.event),
                title: Text('View Your Events'),
                onTap: model.navigateToUserEventsScreen,
              ),
              ListTile(
                leading: Icon(Icons.exit_to_app),
                title: Text('Sign Out'),
                enabled: !model.isLoading,
                onTap: model.signOut,
              )
            ],
          ),
        );
      },
    );
  }
}
