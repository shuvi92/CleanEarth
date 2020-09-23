import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:stacked/stacked.dart';
import 'package:timwan/ui/widgets/event_location_tile.dart';
import 'package:timwan/ui/widgets/loading_button.dart';
import 'package:timwan/viewmodels/create_event_view_model.dart';

class CreateEventScreen extends StatelessWidget {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<CreateEventViewModel>.reactive(
      viewModelBuilder: () => CreateEventViewModel(),
      onModelReady: (model) async {
        await model.initialize();
      },
      builder: (context, model, child) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: Text(
              'Create Event',
              style: TextStyle(color: Colors.black),
            ),
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            iconTheme: IconThemeData(
              color: Colors.black,
            ),
          ),
          body: _buildBody(context, model),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, CreateEventViewModel model) {
    if (model.isLoading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    return ListView(
      padding: const EdgeInsets.only(
        left: 30,
        right: 30,
      ),
      children: <Widget>[
        TextField(
          decoration: InputDecoration(
            labelText: "Title",
          ),
          controller: titleController,
        ),
        TextField(
          decoration: InputDecoration(
            labelText: "Description",
          ),
          controller: descriptionController,
          keyboardType: TextInputType.multiline,
          maxLines: null,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Text('Start Time: '),
            FlatButton(
              onPressed: () {
                DatePicker.showDateTimePicker(context,
                    currentTime: DateTime.now(),
                    minTime: DateTime.now(),
                    onConfirm: (date) => model.setTime(true, date));
              },
              child: Text(_getDateTimeString(model.startTime)),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Text('End Time: '),
            FlatButton(
              onPressed: () {
                DatePicker.showDateTimePicker(context,
                    currentTime: DateTime.now(),
                    minTime: model.startTime,
                    onConfirm: (date) => model.setTime(false, date));
              },
              child: Text(_getDateTimeString(model.endTime)),
            ),
          ],
        ),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Text(
            'Location',
            style: TextStyle(
              fontSize: 18,
            ),
          ),
        ),
        SizedBox(
          height: 200,
          child: EventLocationTile(
            latitude: model.position?.latitude ?? 31,
            longitude: model.position?.longitude ?? -100,
            radius: model.radius,
          ),
        ),
        InkWell(
          onTap: model.navigateToLocationSelection,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: <Widget>[
                Icon(Icons.arrow_forward),
                Text('Select New Location'),
              ],
            ),
          ),
        ),
        Divider(
          height: 24,
        ),
        LoadingButton(
          title: "Submit",
          isLoading: model.isLoading,
          onPressed: () async {
            model.createEvent(
              title: titleController.text,
              description: descriptionController.text,
            );
          },
        ),
        SizedBox(
          height: 25,
        )
      ],
    );
  }

  String _getDateTimeString(DateTime dt) {
    return DateFormat.yMEd().add_jm().format(dt);
  }
}
