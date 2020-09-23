import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:timwan/models/cleanup_event.dart';

class CleanupEventTile extends StatelessWidget {
  final CleanupEvent event;
  final String distance;
  final Function onTap;

  const CleanupEventTile({
    Key key,
    @required this.event,
    @required this.onTap,
    this.distance = 'unknown',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                event.title,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                "- ${event.owner.fullName}",
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                event.description,
                style: TextStyle(
                  fontWeight: FontWeight.w300,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: <Widget>[
                  Icon(Icons.calendar_today),
                  SizedBox(
                    width: 3,
                  ),
                  Text(_getDateTimeString()),
                  Spacer(),
                  Icon(Icons.location_on),
                  SizedBox(
                    width: 2,
                  ),
                  Text("$distance miles away"),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getDateTimeString() {
    String start = DateFormat.MMMd().format(event.startTime);
    String end = DateFormat.MMMd().format(event.endTime);

    return "$start - $end";
  }
}
