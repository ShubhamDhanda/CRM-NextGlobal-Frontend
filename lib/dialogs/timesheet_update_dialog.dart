import 'package:crm/dialogs/timesheet_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:intl/intl.dart';
import '../services/remote_services.dart';

class TimeSheetUpdateDialog extends StatefulWidget{
  TimeSheetUpdateDialog({super.key, required this.calendarEvent});
  CalendarEvent calendarEvent;

  @override
  State<StatefulWidget> createState() => _TimeSheetUpdateDialogState(calendarEvent: calendarEvent);
}

class _TimeSheetUpdateDialogState extends State<TimeSheetUpdateDialog> {
  TextEditingController project = TextEditingController();
  TextEditingController comments = TextEditingController();
  TextEditingController date = TextEditingController();
  TextEditingController startTime = TextEditingController();
  TextEditingController endTime = TextEditingController();

  var apiClient = RemoteServices();
  bool loading = false;
  List<String> projects = [];
  Map<String, int> idMap = {};

  final snackBar1 = const SnackBar(
    content: Text('Time Sheet Updated!'),
    backgroundColor: Colors.green,
  );

  final snackBar2 = const SnackBar(
    content: Text('Something Went Wrong!'),
    backgroundColor: Colors.red,
  );
  final snackBar3 = const SnackBar(
    content: Text('Validation went Wrong!'),
    backgroundColor: Colors.red,
  );

  CalendarEvent calendarEvent;

  _TimeSheetUpdateDialogState({required this.calendarEvent}) {
    comments.text = calendarEvent.comments ?? "";
    project.text = calendarEvent.subject;
    date.text = DateFormat("yyyy-MM-dd").format(calendarEvent.startTime);
    startTime.text = DateFormat.jm().format(calendarEvent.startTime);
    endTime.text = DateFormat.jm().format(calendarEvent.endTime);
  }

  @override
  void initState() {
    super.initState();

    _getData();
  }

  void _getData() async {
    dynamic res = await apiClient.getAllProjectNames();

    if(res?["success"] == true){
      for(var e in res["res"]){
        if(e["Project_Name"] != null && e["Project_ID"] != null){
          projects.add(e["Project_Name"]);
          idMap[e["Project_Name"]] = e["Project_ID"];
        }
      }
    }
  }

  void postData() {

  }

  bool validate() {
    if(project.text == "" || date.text == "" || startTime.text == "" || endTime.text == ""){
      return false;
    }
    return true;
  }

  @override
  Widget build(context) {
    return Scaffold(
        appBar: AppBar(
          leading: GestureDetector(
            child: const Icon(Icons.close),
            onTap: () => Navigator.pop(context, "Not Changed"),
          ),
          title: const Text("Add Event"),
          titleTextStyle: const TextStyle(color: Colors.white, fontSize: 24),
          backgroundColor: Colors.black,
        ),
        backgroundColor: const Color.fromRGBO(41, 41, 41, 1),
        body: body());
  }

  Widget body() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
      child: ListView(
        children: [
          TypeAheadFormField(
            onSuggestionSelected: (suggestion) {
              project.text = suggestion==null ? "" : suggestion.toString();
            },
            itemBuilder: (context, suggestion) {
              return ListTile(
                title: Text(suggestion==null ? "" : suggestion.toString(), style: const TextStyle(color: Colors.white),),
                tileColor: Colors.black,
              );
            },
            transitionBuilder: (context, suggestionsBox, controller) {
              return suggestionsBox;
            },
            suggestionsCallback: (pattern) {
              var curList = [];

              for (var e in projects) {
                if(e.toString().toLowerCase().startsWith(pattern.toLowerCase())){
                  curList.add(e);
                }
              }

              return curList;
            },
            textFieldConfiguration: TextFieldConfiguration(
                cursorColor: Colors.white,
                style: const TextStyle(color: Colors.white),
                keyboardType: TextInputType.text,
                controller: project,
                decoration: const InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white)),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white)),
                    hintText: "Project*",
                    hintStyle: TextStyle(color: Color.fromRGBO(255, 255, 255, 0.5))
                )
            ),
          ),
          const SizedBox(height: 20,),
          TextField(
            cursorColor: Colors.white,
            style: const TextStyle(color: Colors.white),
            keyboardType: TextInputType.text,
            controller: comments,
            decoration: const InputDecoration(
                enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                hintText: "Your Comments",
                hintStyle: TextStyle(color: Color.fromRGBO(255, 255, 255, 0.5))
            ),
          ),
          const SizedBox(height: 20,),
          TextField(
            cursorColor: Colors.white,
            style: const TextStyle(color: Colors.white),
            keyboardType: TextInputType.datetime,
            readOnly: true,
            onTap: () async {
              showDatePicker(
                  context: context,
                  initialDate: date.text == ""
                      ? DateTime.now()
                      : DateTime.parse(date.text),
                  firstDate: DateTime(
                      2000), //DateTime.now() - not to allow to choose before today.
                  lastDate: DateTime(2101),
                  builder: (context, child) {
                    return Theme(
                      data: ThemeData.dark().copyWith(
                        colorScheme: const ColorScheme.dark(
                          onPrimary: Colors.white,
                          surface: Colors.black,
                          onSurface: Colors.white,
                        ),
                        dialogBackgroundColor:
                        const Color.fromRGBO(41, 41, 41, 1),
                      ),
                      child: child!,
                    );
                  }).then((value) {
                setState(() {
                  date.text = value != null
                      ? DateFormat('yyyy-MM-dd').format(value)
                      : date.text;
                });
              });
            },
            controller: date,
            decoration: const InputDecoration(
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white)),
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white)),
                hintText: "Date",
                hintStyle:
                TextStyle(color: Color.fromRGBO(255, 255, 255, 0.5))),
          ),
          const SizedBox(height: 20,),
          Row(
            children: [
              Expanded(
                flex: 5,
                child: TextField(
                  cursorColor: Colors.white,
                  style: const TextStyle(color: Colors.white),
                  keyboardType: TextInputType.datetime,
                  readOnly: true,
                  onTap: () async {
                    showTimePicker(
                        context: context,
                        initialTime: startTime.text == ""
                            ? TimeOfDay.now()
                            : TimeOfDay.fromDateTime(DateFormat.jm().parse(startTime.text)),
                        builder: (context, child) {
                          return Theme(
                            data: ThemeData.dark().copyWith(
                              colorScheme: const ColorScheme.dark(
                                onPrimary: Colors.white,
                                surface: Colors.black,
                                onSurface: Colors.white,
                              ),
                              dialogBackgroundColor:
                              const Color.fromRGBO(41, 41, 41, 1),
                            ),
                            child: child!,
                          );
                        }).then((value) {
                      setState(() {
                        startTime.text = value != null ? value.format(context) : startTime.text;
                      });
                    });
                  },
                  controller: startTime,
                  decoration: const InputDecoration(
                      enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white)),
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white)),
                      hintText: "Start Time",
                      hintStyle:
                      TextStyle(color: Color.fromRGBO(255, 255, 255, 0.5))),
                ),
              ),
              const SizedBox(
                width: 20.0,
              ),
              Expanded(
                flex: 5,
                child: TextField(
                  cursorColor: Colors.white,
                  style: const TextStyle(color: Colors.white),
                  keyboardType: TextInputType.datetime,
                  readOnly: true,
                  onTap: () async {
                    showTimePicker(
                        context: context,
                        initialTime: endTime.text == ""
                            ? TimeOfDay.now()
                            : TimeOfDay.fromDateTime(DateFormat.jm().parse(endTime.text)),
                        builder: (context, child) {
                          return Theme(
                            data: ThemeData.dark().copyWith(
                              colorScheme: const ColorScheme.dark(
                                onPrimary: Colors.white,
                                surface: Colors.black,
                                onSurface: Colors.white,
                              ),
                              dialogBackgroundColor:
                              const Color.fromRGBO(41, 41, 41, 1),
                            ),
                            child: child!,
                          );
                        }).then((value) {
                      setState(() {
                        endTime.text = value != null ? value.format(context) : endTime.text;
                      });
                    });
                  },
                  controller: endTime,
                  decoration: const InputDecoration(
                      enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white)),
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white)),
                      hintText: "End Time",
                      hintStyle:
                      TextStyle(color: Color.fromRGBO(255, 255, 255, 0.5))),
                ),
              )
            ],
          ),
          const SizedBox(height: 20,),
          Container(
            padding: const EdgeInsets.fromLTRB(100, 0, 100, 0),
            child: ElevatedButton(
              onPressed: () => postData(),
              style: ElevatedButton.styleFrom(primary: const Color.fromRGBO(134, 97, 255, 1)),
              child: const Text("Add Work",
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
}