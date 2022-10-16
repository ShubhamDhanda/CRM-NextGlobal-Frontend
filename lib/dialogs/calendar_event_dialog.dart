import 'package:crm/services/google_calendar_services.dart';
import 'package:crm/services/remote_services.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:googleapis/admob/v1.dart';
import 'package:intl/intl.dart';

class CalendarEventDialog extends StatefulWidget {
  const CalendarEventDialog({super.key});

  @override
  State<StatefulWidget> createState() => _CalendarEventDialogDialog();
}

const List<String> titles = [
  "Project Meeting",
  "Proposal Meeting",
  "Client Meeting"
];

class _CalendarEventDialogDialog extends State<CalendarEventDialog> {
  TextEditingController title = TextEditingController();
  TextEditingController project = TextEditingController();
  TextEditingController comments = TextEditingController();
  TextEditingController description = TextEditingController();
  TextEditingController date = TextEditingController();
  TextEditingController startTime = TextEditingController();
  TextEditingController endTime = TextEditingController();

  var apiClient = RemoteServices();
  GoogleCalendar googleCalendar = GoogleCalendar();
  bool loading = false;
  List<String> list = [], clientList = [];
  List<String> employees = [], clients = [];
  Map<String, String> empMap = {}, clientMap = {};
  List<String> projects = [];

  final snackBar1 = const SnackBar(
    content: Text('Meet Added Successfully'),
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

  @override
  void initState() {
    super.initState();

    _getData();
  }

  void _getData() async {
    dynamic res = await apiClient.getAllEmployeeNames();
    dynamic res2 = await apiClient.getAllProjectNames();
    dynamic res3 = await apiClient.getAllCustomerNames();

    if(res?["success"] == true && res2?["success"] && res3?["success"]){
      for(var e in res["res"]){
        employees.add(e["Full_Name"]);
        empMap[e["Full_Name"]] = e["Email"];
      }

      for(var e in res3["res"]){
        if(e["Email"] != null && e["Email"] != "") {
          clients.add(e["Full_Name"]);
          clientMap[e["Full_Name"]] = e["Email"];
        }
      }

      for(var e in res2["res"]){
        if(e["Project_Name"] != null) {
          projects.add(e["Project_Name"]);
        }
      }
    }else{
      ScaffoldMessenger.of(context).showSnackBar(snackBar2);
    }

    await Future.delayed(const Duration(seconds: 2));
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
  }

  void postData() async {
    if(validate() == true){
      var start = DateTime.parse("${date.text} ${DateFormat.jm().parse(startTime.text).toString().split(" ")[1]}");
      var end = DateTime.parse("${date.text} ${DateFormat.jm().parse(endTime.text).toString().split(" ")[1]}");
      googleCalendar.createEvent(title.text, project.text, comments.text, description.text, start, end, list).then((res) {
        if(res=="confirmed"){
          ScaffoldMessenger.of(context).showSnackBar(snackBar1);
          Navigator.pop(context, "Changed");
        }else{
          ScaffoldMessenger.of(context).showSnackBar(snackBar2);
        }
      });
    }else{
      ScaffoldMessenger.of(context).showSnackBar(snackBar3);
    }

    await Future.delayed(const Duration(seconds: 2));
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
  }

  bool validate() {
    if(title.text == "" || project.text == "" || date.text == "" || startTime.text == "" || endTime.text == "" || DateTime.parse(date.text).isBefore(DateTime.now()) || DateFormat.jm().parse(startTime.text).isAfter(DateFormat.jm().parse(endTime.text))) {
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
              title.text = suggestion==null ? "" : suggestion.toString();
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

              for (var e in titles) {
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
                controller: title,
                decoration: const InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white)),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white)),
                    hintText: "Title*",
                    hintStyle: TextStyle(color: Color.fromRGBO(255, 255, 255, 0.5))
                )
            ),
          ),
          const SizedBox(height: 20,),
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
            keyboardType: TextInputType.multiline,
            controller: description,
            decoration: const InputDecoration(
                enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                hintText: "Description",
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
          DropdownSearch<String>.multiSelection(
            items: employees,
            dropdownButtonProps: const DropdownButtonProps(
                color: Color.fromRGBO(255, 255, 255, 0.3)
            ),
            dropdownDecoratorProps: const DropDownDecoratorProps(
                dropdownSearchDecoration: InputDecoration(
                    enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                    focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                    hintText: "Employees",
                    hintStyle: TextStyle(color: Color.fromRGBO(255, 255, 255, 0.5))
                )
            ),
            popupProps: const PopupPropsMultiSelection.dialog(
                showSelectedItems: true,
                showSearchBox: true,
            ),
            onChanged: (value) {
              list.clear();
              value.forEach((e) {
                  list.add(empMap[e]!);
              }
              );
            },
          ),
          const SizedBox(height: 20,),
          DropdownSearch<String>.multiSelection(
            items: clients,
            dropdownButtonProps: const DropdownButtonProps(
                color: Color.fromRGBO(255, 255, 255, 0.3)
            ),
            dropdownDecoratorProps: const DropDownDecoratorProps(
                dropdownSearchDecoration: InputDecoration(
                    enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                    focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                    hintText: "Clients",
                    hintStyle: TextStyle(color: Color.fromRGBO(255, 255, 255, 0.5))
                )
            ),
            popupProps: const PopupPropsMultiSelection.dialog(
                showSelectedItems: true,
                showSearchBox: true
            ),
            onChanged: (value) {
              clientList.clear();
              value.forEach((e) {
                clientList.add(clientMap[e]!);
              }
              );
            },
          ),
          const SizedBox(height: 20,),
          Container(
            padding: const EdgeInsets.fromLTRB(100, 0, 100, 0),
            child: ElevatedButton(
              onPressed: () => postData(),
              style: ElevatedButton.styleFrom(primary: const Color.fromRGBO(134, 97, 255, 1)),
              child: const Text("Create Event",
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
