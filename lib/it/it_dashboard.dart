import 'package:crm/dialogs/final_dialog.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../dialogs/dialog.dart';

class ItDashboard extends StatefulWidget {
  const ItDashboard({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ItDashboardState();
}

class _ItDashboardState extends State<ItDashboard>
    with TickerProviderStateMixin {
  var headNumArr = [25, 10, 0];
  var headStrArr = [
    "Submitted Requests",
    "Approved Requests",
    "Closed Requests"
  ];
  var req = [
    [1, "Software", "MS Office"],
    [1, "Software", "MS Office"],
    [1, "Software", "MS Office"],
    [1, "Software", "MS Office"],
    [1, "Software", "MS Office"],
  ];
  late TabController tabController;

  @override
  Widget build(context) {
    tabController = TabController(length: 2, vsync: this);

    return Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Center(child: Text("IT Dashboard")),
              GestureDetector(
                onTap: () async {
                  final SharedPreferences prefs = await SharedPreferences.getInstance();
                  prefs.clear();
                  Navigator.pushReplacementNamed(context, "/login");
                },
                child: const Icon(
                  Icons.logout,
                  color: Color.fromRGBO(134, 97, 255, 1),
                  size: 30,
                ),
              ),
            ],
          ),
          titleTextStyle: const TextStyle(color: Colors.white, fontSize: 30),
          backgroundColor: Colors.black,
        ),
        body: dashboard());
  }

  Widget dashboard() {
    return Container(
      color: const Color.fromRGBO(0, 0, 0, 1),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 10.0),
        child: ListView(
          children: <Widget>[
            header(),
            myFocus(),
            //Divider(color: Color.fromRGBO(255, 255, 255, 0.19607843137254902), thickness: 1, indent: 10,),
            tabs()
          ],
        ),
      ),
    );
  }

  Widget header() {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[headerCard(0), headerCard(1), headerCard(2)],
        ),
      ],
    );
  }

  Widget headerCard(int index) {
    return Card(
      color: const Color.fromRGBO(0, 0, 0, 0),
      child: Container(
          height: 70,
          width: 118,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            color: const Color.fromRGBO(41, 41, 41, 1),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                headNumArr[index].toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
              Text(
                headStrArr[index].toString(),
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold),
              ),
            ],
          )),
    );
  }

  Widget myFocus() {
    return Card(
      color: const Color.fromRGBO(0, 0, 0, 0),
      child: Container(
          height: 300,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            color: const Color.fromRGBO(41, 41, 41, 1),
          ),
          child: SingleChildScrollView(
              child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                const Text(
                  "IT Requests",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
                DataTable(
                    border: const TableBorder(
                        horizontalInside: BorderSide(
                            color: Color.fromRGBO(
                                255, 255, 255, 0.43529411764705883))),
                    columnSpacing: 30,
                    columns: const [
                      DataColumn(
                          label: Text("Employee ID",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                              ))),
                      DataColumn(
                          label: Text("Request Type",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                              ))),
                      DataColumn(
                          label: Text("Request",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                              ))),
                    ],
                    rows: req
                        .map((e) => DataRow(cells: [
                              DataCell(Center(
                                  child: Text(
                                e[0].toString(),
                                style: const TextStyle(
                                    color: Color.fromRGBO(255, 255, 255, 0.8)),
                              ))),
                              DataCell(Center(
                                  child: Text(
                                e[1].toString(),
                                style: const TextStyle(
                                    color: Color.fromRGBO(255, 255, 255, 0.8)),
                              ))),
                              DataCell(Center(
                                  child: Text(
                                e[2].toString(),
                                style: const TextStyle(
                                    color: Color.fromRGBO(255, 255, 255, 0.8)),
                              ))),
                            ]))
                        .toList()),
              ],
            ),
          ))),
    );
  }

  Widget tabs() {
    return Column(
      children: [
        TabBar(
          controller: tabController,
          indicatorSize: TabBarIndicatorSize.label,
          indicator: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              color: const Color.fromRGBO(134, 97, 255, 1)),
          tabs: [
            Tab(
                child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                border: Border.all(
                    color: const Color.fromRGBO(134, 97, 255, 1), width: 1),
              ),
              child: const Text(
                "Requests",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
            )),
            Tab(
                child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  border: Border.all(
                      color: const Color.fromRGBO(134, 97, 255, 1), width: 1)),
              child: const Text(
                "Forms",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
            )),
          ],
        ),
        SizedBox(
          width: double.maxFinite,
          height: 210,
          child: TabBarView(
            controller: tabController,
            children: [requests(), forms()],
          ),
        )
      ],
    );
  }

  Widget requests() {
    return Card(
      color: const Color.fromRGBO(0, 0, 0, 0),
      child: Container(
        alignment: Alignment.center,
        width: MediaQuery.of(context).size.width - 20,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: const Color.fromRGBO(41, 41, 41, 1),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              requestCard(text: "All Requests", onClick: () => onRequest(0)),
              requestCard(text: "All Software Requests", onClick: () => onRequest(1)),
              requestCard(text: "All Hardware Requests", onClick: () => onRequest(2)),
              requestCard(text: "Pending Requests", onClick: () => onRequest(3)),
              requestCard(text: "Closed Requests", onClick: () => onRequest(4)),
            ],
          ),
        ),
      ),
    );
  }

  Widget forms() {
    return Card(
      color: const Color.fromRGBO(0, 0, 0, 0),
      child: Container(
        alignment: Alignment.center,
        width: MediaQuery.of(context).size.width - 20,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: const Color.fromRGBO(41, 41, 41, 1),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              formCard(text: "New Request", onClick: () => onForm(0)),
              formCard(text: "Approve Request", onClick: () => onForm(1)),
              formCard(text: "Close Request", onClick: () => onForm(2)),
            ],
          ),
        ),
      ),
    );
  }

  Widget formCard({required String text, required VoidCallback onClick}) {
    return GestureDetector(
        onTap: onClick,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.circle,
                    color: Colors.white,
                    size: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                    child: Text(text,
                        style:
                            const TextStyle(color: Colors.white, fontSize: 16)),
                  )
                ],
              ),
              const Icon(
                Icons.arrow_forward,
                color: Colors.white,
              )
            ],
          ),
        ));
  }

  Widget requestCard({required String text, required VoidCallback onClick}) {
    return GestureDetector(
        onTap: onClick,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.circle,
                    color: Colors.white,
                    size: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                    child: Text(text,
                        style:
                            const TextStyle(color: Colors.white, fontSize: 16)),
                  )
                ],
              ),
              const Icon(
                Icons.arrow_forward,
                color: Colors.white,
              )
            ],
          ),
        ));
  }

  void onForm(int index) {
    switch (index) {
      case 0:

        break;
      case 1:
        showDialog(context: context, builder: (_) => const DialogWidget(hint: "Request ID", type: TextInputType.number));
        break;
      case 2:
        showDialog(context: context, builder: (_) => const DialogWidget(hint: "Request ID", type: TextInputType.number));
        break;
    }
  }

  void onRequest(int index) {
    switch (index) {
      case 0:
        showDialog(context: context, builder: (_) => const FinalDialogWidget());
        break;
      case 1:
        showDialog(context: context, builder: (_) => const FinalDialogWidget());
        break;
      case 2:
        showDialog(context: context, builder: (_) => const FinalDialogWidget());
        break;
      case 3:
        showDialog(context: context, builder: (_) => const FinalDialogWidget());
        break;
      case 4:
        showDialog(context: context, builder: (_) => const FinalDialogWidget());
        break;
    }
  }
}
