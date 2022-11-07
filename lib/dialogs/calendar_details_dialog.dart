import 'package:crm/dialogs/calendar_dialog.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class CalendarDetailsDialog extends StatefulWidget {
  CalendarDetailsDialog({super.key, required this.calendarEvent});
  CalendarEvent calendarEvent;

  @override
  State<StatefulWidget> createState() =>
      _CalendarDetailsDialogState(calendarEvent: calendarEvent);
}

class _CalendarDetailsDialogState extends State<CalendarDetailsDialog> {
  CalendarEvent calendarEvent;

  _CalendarDetailsDialogState({required this.calendarEvent});
  @override
  Widget build(context) {
    return Scaffold(
        appBar: AppBar(
          leading: GestureDetector(
            child: Icon(Icons.close),
            onTap: () => Navigator.pop(context),
          ),
          title: Text("Event Details"),
          titleTextStyle: const TextStyle(color: Colors.white, fontSize: 24),
          backgroundColor: Colors.black,
        ),
        backgroundColor: const Color.fromRGBO(41, 41, 41, 1),
        body: body());
  }

  Widget body() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
      child: ListView(
        children: [
          Center(
            child: Text(calendarEvent.subject ?? "No  Title",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 22.0,
                    fontWeight: FontWeight.bold)),
          ),
          const SizedBox(
            height: 10,
          ),
              Text(
                  "${DateFormat.MMMMEEEEd().format(calendarEvent.startTime)} ${DateFormat.jm().format(calendarEvent.startTime)}-${DateFormat.jm().format(calendarEvent.endTime)}",
                  style: TextStyle(
                    color: Color.fromRGBO(255, 255, 255, 0.5372549019607843),
                  )),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                flex: 1,
                child: Text(
                "Creator - ",
                style: TextStyle(
                    color: Color.fromRGBO(134, 97, 255, 1), fontSize: 20.0),
              ),
              ),
              Expanded(
                flex: 3,
                  child:  Text(
                    calendarEvent.creator!,
                    style: TextStyle(color: Colors.white, fontSize: 18.0),
                  )
              )
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                "Created On - ",
                style: TextStyle(
                    color: Color.fromRGBO(134, 97, 255, 1), fontSize: 20.0),
              ),
              Text(
                DateFormat.MMMMEEEEd().format(calendarEvent.created!),
                style: TextStyle(color: Color.fromRGBO(
                    255, 255, 255, 0.7607843137254902), fontSize: 17.0),
              )
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                "Attendees - ",
                style: TextStyle(
                    color: Color.fromRGBO(134, 97, 255, 1), fontSize: 20.0),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          calendarEvent.attendees == null
              ? const SizedBox()
              : Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: calendarEvent.attendees!.map<Widget>((e) {
                  return Row(
                    children: [
                      Icon(Icons.circle, color: Colors.white, size: 7.0,),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(e.toString(),
                          style: TextStyle(color: Colors.white, fontSize: 18.0)),
                    ]
                  );
                }).toList(),
              )
            ],
          ),
          const SizedBox(
            height: 30,
          ),
          calendarEvent.meetLink == null ?
              SizedBox()
              : Container(
            padding: EdgeInsets.fromLTRB(100, 0, 100, 0),
            child: ElevatedButton(onPressed: () => _launchURL(calendarEvent.meetLink!),
              style: ElevatedButton.styleFrom(primary: const Color.fromRGBO(134, 97, 255, 1)),
              child: const Text("Join Meet",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  void _launchURL(url) async {
    if (await launch(url)) {
      await canLaunch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
