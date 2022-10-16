import 'package:crm/admin/drawer.dart';
import 'package:crm/dialogs/calendar_dialog.dart';
import 'package:crm/services/google_calendar_services.dart';
import 'package:flutter/material.dart';

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

  @override
  void initState() {
    super.initState();
    _getData();
  }

  void _getData() async {
  }

  @override
  Widget build(context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Admin Dashboard"),
        titleTextStyle: const TextStyle(
            color: Colors.white,
            fontSize: 24
        ),
        backgroundColor: Colors.black,
      ),
      drawer: NavDrawerWidget(name: '/admin',),
      body: dashboard()
    );
  }

  Widget dashboard () {
    return Container(
      color: const Color.fromRGBO(0, 0, 0, 1),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 10.0),
        child: ListView(
          children: <Widget>[
            headerCard(),
            requests(),
            calendarCard()
          ],
        ),
      ),
    );
  }

  Widget headerCard () {
    return Card(
      color: const Color.fromRGBO(0, 0, 0, 0),
      child: Container(
          height: 70,
          width: MediaQuery.of(context).size.width-20,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            color: const Color.fromRGBO(41, 41, 41, 1),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Visibility(
                  replacement: const Icon(Icons.check_circle_outline, color: Colors.green, size: 50,),
                  visible: pendingReq!=0,
                  child: const Icon(Icons.warning_amber, color: Colors.yellow,size: 50,),
                ),
                const SizedBox(width: 10,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      pendingReq.toString(),
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                    Text(
                      " Pending Requests",
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                  ],
                )
              ],
            ),
          )
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
                          fontWeight: FontWeight.bold
                      ),
                    ),
                    DataTable(
                      columnSpacing: 5,
                        border: TableBorder(
                            horizontalInside: BorderSide(color: Color.fromRGBO(
                                255, 255, 255, 0.43529411764705883))),
                        columns: const [
                          DataColumn(label: Center(
                              child: Text(
                                "Emp ID", textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.white,))),
                          ),
                          DataColumn(label: Center(
                              widthFactor: 2.5,
                              child: Text(
                                  "Request",textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.white,))),
                          ),
                          DataColumn(label: Center(
                              child: Text(
                                  "File type",textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.white,))),
                          ),
                          DataColumn(label: Center(
                              widthFactor: 2.0,
                              child: Text(
                                  "Date",textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.white,))),
                          ),
                        ],
                        rows: reqs.map(
                                (e) =>
                                DataRow(cells: [
                                  DataCell(Center(child: Text(e[0].toString(),
                                    style: TextStyle(color: Color.fromRGBO(
                                        255, 255, 255, 0.8)),))),
                                  DataCell(Center(child: Text(e[1].toString(),
                                    style: TextStyle(color: Color.fromRGBO(
                                        255, 255, 255, 0.8)),))),
                                  DataCell(Center(child: Text(e[2].toString(),
                                    style: TextStyle(color: Color.fromRGBO(
                                        255, 255, 255, 0.8)),))),
                                  DataCell(Center(child: Text(e[3].toString(),
                                    style: TextStyle(color: Color.fromRGBO(
                                        255, 255, 255, 0.8)),))),
                                ])
                        ).toList()
                    ),
                  ],
                ),
              )
          )
      ),
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
                pageBuilder: (context, animation, secondaryAnimation) => const CalendarDialog());
          },
          child: Container(
            height: 70,
            width: MediaQuery.of(context).size.width-20,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: const Color.fromRGBO(41, 41, 41, 1),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Calendar", style: TextStyle(color: Colors.white),),
                  Icon(Icons.arrow_right_outlined, color: Colors.white,)
                ],
              ),
            ),
          ),
        )
    );
  }
}