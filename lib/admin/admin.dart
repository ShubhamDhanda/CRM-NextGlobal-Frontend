import 'package:crm/admin/drawer.dart';
import 'package:crm/dialogs/add_task_dialog.dart';
import 'package:crm/dialogs/calendar_dialog.dart';
import 'package:crm/dialogs/update_tasks.dart';
import 'package:crm/services/google_calendar_services.dart';
import 'package:crm/services/remote_services.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AdminHome extends StatefulWidget {
  const AdminHome({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _AdminHome();
}

class _AdminHome extends State<AdminHome> {
  int pendingReq = 0;
  var reqs = [
    [1, "Sales by Employee ID 1", "PDF", "2020-8-24"],
    [1, "Sales by Employee ID 1", "PDF", "2020-8-24"],
    [1, "Sales by Employee ID 1", "PDF", "2020-8-24"],
    [1, "Sales by Employee ID 1", "PDF", "2020-8-24"],
    [1, "Sales by Employee ID 1", "PDF", "2020-8-24"],
  ];
  RemoteServices apiClient = RemoteServices();
  bool dataLoaded = false;
  List<Map<String, dynamic>> todo = [];

  final snackBar1 = const SnackBar(
    content: Text('Something Went Wrong'),
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

      dynamic res = await apiClient.getTasksById();

      todo.clear();

      for (var i = 0; i < res["res"].length; i++) {
        var e = res["res"][i];
        Map<String, dynamic> mp = {};

        mp["id"] = e["Task_ID"].toString();
        mp["title"] = e["Title"];
        mp["status"] = e["Status"] ?? "";
        mp["completed"] = e["Percent_Completed"] ?? "0";
        mp["description"] = e["Description"] ?? "";
        mp["startDate"] = e["Start_Date"] == null
            ? ""
            : DateFormat("yyyy-MM-dd")
                .format(DateTime.parse(e["Start_Date"]).toLocal())
                .toString();
        mp["dueDate"] = e["Due_Date"] == null
            ? ""
            : DateFormat("yyyy-MM-dd")
                .format(DateTime.parse(e["Due_Date"]).toLocal())
                .toString();
        mp["attachments"] = e["Attachments"] ?? "";
        mp["priority"] = e["Priority"].toString();

        todo.add(mp);
      }
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
          title: const Text("Admin Dashboard"),
          titleTextStyle: const TextStyle(color: Colors.white, fontSize: 24),
          backgroundColor: Colors.black,
        ),
        drawer: const NavDrawerWidget(
          name: '/admin',
        ),
        body: dashboard());
  }

  Widget dashboard() {
    return Container(
      // constraints: BoxConstraints(
      //   maxWidth: MediaQuery
      //       .of(context)
      //       .size
      //       .width,
      //   maxHeight: MediaQuery
      //       .of(context)
      //       .size
      //       .height,
      // ),
      // decoration: BoxDecoration(
      //   gradient: LinearGradient(
      //     colors: [
      //       Colors.blue[800]!,
      //       Colors.blue[400]!,
      //     ],
      //     begin: Alignment.topLeft,
      //     end: Alignment.centerRight,
      //   ),
      // ),
      color: const Color.fromRGBO(0, 0, 0, 1),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 10.0),
        child: ListView(
          children: <Widget>[
            headerCard(),
            myFocus(),
            requests(),
            calendarCard()
          ],
        ),
      ),
    );
  }

  Widget headerCard() {
    return Card(
      color: const Color.fromRGBO(0, 0, 0, 0),
      child: Container(
          height: 70,
          width: MediaQuery.of(context).size.width - 20,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            color: const Color.fromRGBO(41, 41, 41, 1),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Visibility(
                  replacement: const Icon(
                    Icons.check_circle_outline,
                    color: Colors.green,
                    size: 50,
                  ),
                  visible: pendingReq != 0,
                  child: const Icon(
                    Icons.warning_amber,
                    color: Colors.yellow,
                    size: 50,
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      pendingReq.toString(),
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                    const Text(
                      " Pending Requests",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                )
              ],
            ),
          )),
    );
  }

  Widget myFocus() {
    return Card(
      color: const Color.fromRGBO(0, 0, 0, 0),
      child: Container(
        height: 300,
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: const Color.fromRGBO(41, 41, 41, 1),
        ),
        child: ListView(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
null,
                    color: Color.fromRGBO(134, 97, 255, 1),
                  ),
                const Flexible(
                    fit: FlexFit.tight,
                    flex: 3,
                    child: Text(
                      "My Focus",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    )),
                GestureDetector(
                      onTap: () {
                        showGeneralDialog(
                            context: context,
                            barrierDismissible: false,
                            transitionDuration: Duration(milliseconds: 500),
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
                            pageBuilder: (context, animation, secondaryAnimation) => const AddTaskDialog()).then((value) {
                              if(value! == true){
                                _getData();
                              }
                        });
                      },
                      child: const Icon(
                        Icons.add,
                        color: Color.fromRGBO(134, 97, 255, 1),
                      ),
                    )
              ],
            ),
            todo.isEmpty
                ? Container(
                    padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                    child: const Text(
                      "No Work Assigned to You",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Color.fromRGBO(
                              255, 255, 255, 0.43529411764705883),
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                  )
                : DataTable(
                    columnSpacing: 20,
                    border: const TableBorder(
                        horizontalInside: BorderSide(
                            color: Color.fromRGBO(
                                255, 255, 255, 0.43529411764705883))),
                    columns: const [
                      DataColumn(
                          label: Text("Title",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                              ))),
                      DataColumn(
                          label: Text("Priority",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                              ))),
                      DataColumn(
                          label: Text("Completed",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                              ))),
                      DataColumn(
                          label: Text("Deadline",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                              ))),
                      DataColumn(
                          label: Text("",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                              ))),
                    ],
                    rows: todo
                        .map((e) => DataRow(cells: [
                              DataCell(Center(
                                child: Text(
                                  e["title"].toString(),
                                  style: const TextStyle(
                                      color:
                                          Color.fromRGBO(255, 255, 255, 0.8)),
                                ),
                              )),
                              DataCell(Center(
                                child: Text(
                                  e["priority"],
                                  style: const TextStyle(
                                      color:
                                          Color.fromRGBO(255, 255, 255, 0.8)),
                                ),
                              )),
                              DataCell(Center(
                                child: Text(
                                  "${e["completed"].toString()} %",
                                  style: const TextStyle(
                                      color:
                                          Color.fromRGBO(255, 255, 255, 0.8)),
                                ),
                              )),
                              DataCell(Center(
                                child: Text(
                                  e["dueDate"],
                                  style: const TextStyle(
                                      color:
                                          Color.fromRGBO(255, 255, 255, 0.8)),
                                ),
                              )),
                              DataCell(GestureDetector(
                                onTap: () {
                                  showDialog(
                                          context: context,
                                          builder: (_) =>
                                              UpdateTasksDialog(mp: e))
                                      .then((value) {
                                    if (value != null && value == true) {
                                      _getData();
                                    }
                                  });
                                },
                                child: const Center(
                                  child: Icon(
                                    Icons.arrow_circle_right,
                                    color: Colors.white,
                                  ),
                                ),
                              )),
                            ]))
                        .toList()),
          ],
        ),
      ),
    );
  }

  Widget requests() {
    return Card(
      color: const Color.fromRGBO(0, 0, 0, 0),
      child: Container(
          height: 330,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            color: const Color.fromRGBO(41, 41, 41, 1),
          ),
          child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                child: Column(
                  children: <Widget>[
                    const Text(
                      "Recent Requests",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                    DataTable(
                        columnSpacing: 5,
                        border: const TableBorder(
                            horizontalInside: BorderSide(
                                color: Color.fromRGBO(
                                    255, 255, 255, 0.43529411764705883))),
                        columns: const [
                          DataColumn(
                            label: Center(
                                child: Text("Emp ID",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.white,
                                    ))),
                          ),
                          DataColumn(
                            label: Center(
                                widthFactor: 2.5,
                                child: Text("Request",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.white,
                                    ))),
                          ),
                          DataColumn(
                            label: Center(
                                child: Text("File type",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.white,
                                    ))),
                          ),
                          DataColumn(
                            label: Center(
                                widthFactor: 2.0,
                                child: Text("Date",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.white,
                                    ))),
                          ),
                        ],
                        rows: reqs
                            .map((e) => DataRow(cells: [
                                  DataCell(Center(
                                      child: Text(
                                    e[0].toString(),
                                    style: const TextStyle(
                                        color:
                                            Color.fromRGBO(255, 255, 255, 0.8)),
                                  ))),
                                  DataCell(Center(
                                      child: Text(
                                    e[1].toString(),
                                    style: const TextStyle(
                                        color:
                                            Color.fromRGBO(255, 255, 255, 0.8)),
                                  ))),
                                  DataCell(Center(
                                      child: Text(
                                    e[2].toString(),
                                    style: const TextStyle(
                                        color:
                                            Color.fromRGBO(255, 255, 255, 0.8)),
                                  ))),
                                  DataCell(Center(
                                      child: Text(
                                    e[3].toString(),
                                    style: const TextStyle(
                                        color:
                                            Color.fromRGBO(255, 255, 255, 0.8)),
                                  ))),
                                ]))
                            .toList()),
                  ],
                ),
              ))),
    );
  }

  Widget calendarCard() {
    return Card(
        color: const Color.fromRGBO(0, 0, 0, 0),
        child: GestureDetector(
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
                    const CalendarDialog());
          },
          child: Container(
            height: 70,
            width: MediaQuery.of(context).size.width - 20,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: const Color.fromRGBO(41, 41, 41, 1),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Calendar",
                    style: TextStyle(color: Colors.white),
                  ),
                  const Icon(
                    Icons.arrow_right_outlined,
                    color: Colors.white,
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
