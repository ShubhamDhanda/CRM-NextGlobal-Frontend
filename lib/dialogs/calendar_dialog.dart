import 'package:crm/dialogs/calendar_details_dialog.dart';
import 'package:crm/dialogs/calendar_event_dialog.dart';
import 'package:googleapis/admob/v1.dart';
import 'package:googleapis/calendar/v3.dart' as gcs;
import 'package:crm/services/google_calendar_services.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class  CalendarDialog extends StatefulWidget{
  const CalendarDialog({super.key});

  @override
  State<StatefulWidget> createState() => _CalendarDialogState();
}

class _CalendarDialogState extends State<CalendarDialog> {
  GoogleCalendar googleCalendar = GoogleCalendar();
  _DataSource appointments = _DataSource(<CalendarEvent>[]);
  bool dataLoaded = false;

  @override
  void initState() {
    super.initState();
    _getData();
  }

  void _getData() async {
    setState(() {
      dataLoaded = false;
    });
    //googleCalendar.listGoogleDriveFiles();

    googleCalendar.getGoogleEventsData().then((value) {
      List<CalendarEvent> apps = [];

      value.forEach((e) {
        if(e.start!.dateTime == null || e.end!.dateTime == null) return;
        
        apps.add(
            CalendarEvent(
                startTime: DateTime.parse(e.start!.dateTime!.toString()).toLocal(),
                endTime: DateTime.parse(e.end!.dateTime!.toString()).toLocal(),
                color: const Color.fromRGBO(134, 97, 255, 1),
                subject: e.summary ?? "",
              eventId: e.id,
              meetLink: e.hangoutLink,
              created: e.created!.toLocal(),
              creator: e.creator!.email,
              attendees: e.attendees?.map<String>((val) {
                return val.email!;
              }).toList(),

            )
        );
      });
      appointments = _DataSource(apps);

      setState(() {
        dataLoaded = true;
      });
    });
  }

  @override
  Widget build(context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          child: const Icon(Icons.close),
          onTap: () => Navigator.pop(context),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("Your Calendar"),
            GestureDetector(
              onTap: () {
                showGeneralDialog(
                    context: context,
                    barrierDismissible: false,
                    transitionDuration: const Duration(milliseconds: 500),
                    transitionBuilder: (context, animation, secondaryAnimation, child) {
                      const begin = Offset(0.0, 1.0);
                      const end = Offset.zero;
                      const curve = Curves.ease;

                      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

                      return SlideTransition(
                        position: animation.drive(tween),
                        child: child,
                      );
                    },
                    pageBuilder: (context, animation, secondaryAnimation) => const CalendarEventDialog()).then((value) {
                      if(value == true){
                        _getData();
                      }
                }
                );

              },
              child: const Icon(Icons.add, color: Color.fromRGBO(134, 97, 255, 1)),
            )
          ],
        ) ,
        titleTextStyle: const TextStyle(
            color: Colors.white,
            fontSize: 24
        ),
        backgroundColor: Colors.black,
      ),
      backgroundColor: const Color.fromRGBO(41, 41, 41, 1),
      body: Visibility(
        replacement: const Center(
          child: CircularProgressIndicator(
            color: Color.fromRGBO(134, 97, 255, 1),
          ),
        ),
        visible: dataLoaded,
        child: body(),
      ),
    );
  }

  Widget body() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
      child: SfCalendar(
        dataSource: appointments,
        view: CalendarView.week,
        todayHighlightColor: const Color.fromRGBO(134, 97, 255, 1),
        todayTextStyle: const TextStyle(color: Colors.white),
        cellBorderColor: Colors.white,
        headerStyle: const CalendarHeaderStyle(textStyle: TextStyle(color: Colors.white, fontSize: 20.0)),
        headerDateFormat: 'yMMMMd',
        viewHeaderStyle: const ViewHeaderStyle(
          dayTextStyle: TextStyle(color: Colors.white),
            dateTextStyle: TextStyle(color: Colors.white)
        ),
        timeSlotViewSettings: const TimeSlotViewSettings(
          timeTextStyle:
          TextStyle(color: Colors.white),
        ),
        onTap: (calendarTapDetails) {
          if(calendarTapDetails.appointments!.length != null){
            showGeneralDialog(
                context: context,
                barrierDismissible: false,
                transitionDuration: const Duration(milliseconds: 500),
                transitionBuilder: (context, animation, secondaryAnimation, child) {
                  const begin = Offset(0.0, 1.0);
                  const end = Offset.zero;
                  const curve = Curves.ease;

                  var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

                  return SlideTransition(
                    position: animation.drive(tween),
                    child: child,
                  );
                },
                pageBuilder: (context, animation, secondaryAnimation) => CalendarDetailsDialog( calendarEvent: calendarTapDetails.appointments![0],));

          }
        },
        ),
    );
  }
}

class CalendarEvent extends Appointment{
  CalendarEvent({required super.startTime, required super.endTime, super.subject, super.color,  this.eventId,  this.meetLink,  this.created,  this.creator,  this.attendees});
  String? eventId, meetLink, creator;
  DateTime? created;
  List<String>? attendees;
}
class _DataSource extends CalendarDataSource {
  _DataSource(List<CalendarEvent> source) {
    appointments = source;
  }
}
