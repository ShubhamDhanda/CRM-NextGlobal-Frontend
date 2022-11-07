import 'package:crm/dialogs/calendar_details_dialog.dart';
import 'package:crm/dialogs/timesheet_new_dialog.dart';
import 'package:crm/dialogs/timesheet_update_dialog.dart';
import 'package:crm/services/remote_services.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class TimeSheetDialog extends StatefulWidget {
  const TimeSheetDialog({super.key});

  @override
  State<StatefulWidget> createState() => _TimeSheetDialogState();
}

class _TimeSheetDialogState extends State<TimeSheetDialog> {
  _DataSource timesheet = _DataSource(<CalendarEvent>[]);
  bool dataLoaded = false;
  var apiClient = RemoteServices();

  final snackBar1 = const SnackBar(
    content: Text('Something Went Wrong!'),
    backgroundColor: Colors.red,
  );

  @override
  void initState() {
    super.initState();
    _getData();
  }

  void _getData() async {
    try {
      setState(() {
        dataLoaded = false;
      });

      dynamic res = await apiClient.getAllTimesheet();
      print(res);
      List<CalendarEvent> apps = [];

      for (var e in res["res"]) {
        apps.add(CalendarEvent(
            startTime: DateFormat("yyyy-MM-dd HH:mm:ss").parse(
                '${DateFormat("yyyy-MM-dd").format(DateTime.parse(e["Date"]).toLocal())} ${e["Start_Time"]}'),
            endTime: DateFormat("yyyy-MM-dd HH:mm:ss").parse(
                '${DateFormat("yyyy-MM-dd").format(DateTime.parse(e["Date"]).toLocal())} ${e["End_Time"]}'),
            subject: e["Project_Name"],
            color: const Color.fromRGBO(134, 97, 255, 1),
            comments: e["Comments"] ?? ""));
      }

      timesheet = _DataSource(apps);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(snackBar1);
    } finally {
      setState(() {
        dataLoaded = true;
      });

      await Future.delayed(const Duration(seconds: 2));
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
    }
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
            const Text("Your Time Sheet"),
            GestureDetector(
              onTap: () {
                showGeneralDialog(
                    context: context,
                    barrierDismissible: false,
                    transitionDuration: const Duration(milliseconds: 500),
                    transitionBuilder:
                        (context, animation, secondaryAnimation, child) {
                      const begin = Offset(0.0, 1.0);
                      const end = Offset.zero;
                      const curve = Curves.ease;

                      var tween = Tween(begin: begin, end: end)
                          .chain(CurveTween(curve: curve));

                      return SlideTransition(
                        position: animation.drive(tween),
                        child: child,
                      );
                    },
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        const TimeSheetNewDialog()).then((value) {
                  if (value! == true) {
                    _getData();
                  }
                });
              },
              child:
                  const Icon(Icons.add, color: Color.fromRGBO(134, 97, 255, 1)),
            )
          ],
        ),
        titleTextStyle: const TextStyle(color: Colors.white, fontSize: 24),
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
        dataSource: timesheet,
        view: CalendarView.week,
        todayHighlightColor: const Color.fromRGBO(134, 97, 255, 1),
        todayTextStyle: const TextStyle(color: Colors.white),
        cellBorderColor: Colors.white,
        headerStyle: const CalendarHeaderStyle(
            textStyle: TextStyle(color: Colors.white, fontSize: 20.0)),
        headerDateFormat: 'yMMMMd',
        viewHeaderStyle: const ViewHeaderStyle(
            dayTextStyle: TextStyle(color: Colors.white),
            dateTextStyle: TextStyle(color: Colors.white)),
        timeSlotViewSettings: const TimeSlotViewSettings(
          timeTextStyle: TextStyle(color: Colors.white),
        ),
        onTap: (calendarTapDetails) {
          if (calendarTapDetails.appointments!.length != null) {
            showGeneralDialog(
                context: context,
                barrierDismissible: false,
                transitionDuration: const Duration(milliseconds: 500),
                transitionBuilder:
                    (context, animation, secondaryAnimation, child) {
                  const begin = Offset(0.0, 1.0);
                  const end = Offset.zero;
                  const curve = Curves.ease;

                  var tween = Tween(begin: begin, end: end)
                      .chain(CurveTween(curve: curve));

                  return SlideTransition(
                    position: animation.drive(tween),
                    child: child,
                  );
                },
                pageBuilder: (context, animation, secondaryAnimation) =>
                    TimeSheetUpdateDialog(
                      calendarEvent: calendarTapDetails.appointments![0],
                    )).then((value) {
              if (value! == true) {
                _getData();
              }
            });
          }
        },
      ),
    );
  }
}

class CalendarEvent extends Appointment {
  CalendarEvent(
      {required super.startTime,
      required super.endTime,
      super.subject,
      super.color,
      this.comments});
  String? comments;
}

class _DataSource extends CalendarDataSource {
  _DataSource(List<CalendarEvent> source) {
    super.appointments = source;
  }
}
