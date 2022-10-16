import 'package:crm/dialogs/add_employee_dialog.dart';
import 'package:crm/dialogs/add_people.dart';
import 'package:crm/dialogs/add_ship_sup_dialog.dart';
import 'package:crm/dialogs/dialog.dart';
import 'package:crm/dialogs/final_dialog.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ManagerDashboard extends StatefulWidget{
  const ManagerDashboard({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ManagerDashboardState();
}

class _ManagerDashboardState extends State<ManagerDashboard> with TickerProviderStateMixin {
  var projects = [
    ["Project A", "2022-07-24", "2022-09-30"],
    ["Project B", "2022-07-24", "2022-09-30"],
    ["Project C", "2022-07-24", "2022-09-30"],
    ["Project D", "2022-07-24", "2022-09-30"],
    ["Project E", "2022-07-24", "2022-09-30"],
  ];
  late List<_ChartData> productData = [
    _ChartData('CHN', 12),
    _ChartData('GER', 15),
    _ChartData('RUS', 30),
    _ChartData('BRZ', 6.4),
    _ChartData('IND', 14)
  ];
  var orders = [
    [1, 1, 1, 1],
    [2, 2, 2, 2],
    [3, 3, 3, 3],
    [4, 4, 4, 4],
    [4, 4, 4, 4],
    [4, 4, 4, 4],
    [4, 4, 4, 4]
  ];
  var sales = [
    _ChartData('CHN', 12),
    _ChartData('GER', 15),
    _ChartData('RUS', 30),
    _ChartData('BRZ', 6.4),
    _ChartData('IND', 14)
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
              const Center(child: Text("Managers Dashboard")),
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
          titleTextStyle: const TextStyle(
              color: Colors.white,
              fontSize: 24
          ),
          backgroundColor: Colors.black,
        ),
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
            project(),
            products(),
            ordersShipped(),
            quarterlySales(),
            tabs()
          ],
        ),
      ),
    );
  }

  Widget project() {
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
                      "Ongoing Projects",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                    DataTable(
                        columnSpacing: 35,
                        border: TableBorder(
                            horizontalInside: BorderSide(color: Color.fromRGBO(
                                255, 255, 255, 0.43529411764705883))),
                        columns: const [
                          DataColumn(label: Text(
                              "Project Name", textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.white,))),
                          DataColumn(label: Text(
                              "Begin Date", textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.white,))),
                          DataColumn(label: Text(
                              "Deadline", textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.white,))),
                        ],
                        rows: projects.map(
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

  Widget products() {
    return Card(
      color: const Color.fromRGBO(0, 0, 0, 0),
      child: Container(
          height: 350,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            color: const Color.fromRGBO(41, 41, 41, 1),
          ),
          child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Text("Top 5 purchased products", textAlign: TextAlign.center , style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20,)),
                  SfCartesianChart(
                      primaryXAxis: CategoryAxis(),
                      primaryYAxis: NumericAxis(minimum: 0, maximum: 100, interval: 10),
                      series: <ChartSeries<_ChartData, String>>[
                        ColumnSeries<_ChartData, String>(
                            dataSource: productData,
                            xValueMapper: (_ChartData data, _) => data.x,
                            yValueMapper: (_ChartData data, _) => data.y,
                            name: 'Gold',
                            color: Color.fromRGBO(134, 97, 255, 1))
                      ])
                ],
              )
          )
      ),
    );
  }

  Widget ordersShipped() {
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
                      "Orders to be Shipped",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                    DataTable(
                        border: const TableBorder(
                            horizontalInside: BorderSide(color: Color.fromRGBO(
                                255, 255, 255, 0.43529411764705883))),
                        columnSpacing: 15,
                        columns: const [
                          DataColumn(label: Text(
                              "Order ID", textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.white,))),
                          DataColumn(label: Text(
                              "Order Date", textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.white,))),
                          DataColumn(label: Text(
                              "Shipper ID", textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.white,))),
                          DataColumn(label: Text(
                              "Customer ID", textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.white,))),
                        ],
                        rows: orders.map(
                                (e) =>
                                DataRow(cells: [
                                  DataCell(Center(child: Text(e[0].toString(),
                                    style: const TextStyle(color: Color.fromRGBO(
                                        255, 255, 255, 0.8)),))),
                                  DataCell(Center(child: Text(e[1].toString(),
                                    style: const TextStyle(color: Color.fromRGBO(
                                        255, 255, 255, 0.8)),))),
                                  DataCell(Center(child: Text(e[2].toString(),
                                    style: const TextStyle(color: Color.fromRGBO(
                                        255, 255, 255, 0.8)),))),
                                  DataCell(Center(child: Text(e[3].toString(),
                                    style: const TextStyle(color: Color.fromRGBO(
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

  Widget quarterlySales() {
    return Card(
      color: const Color.fromRGBO(0, 0, 0, 0),
      child: Container(
          height: 350,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            color: const Color.fromRGBO(41, 41, 41, 1),
          ),
          child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text("Top 5 Employees by Sales",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      )),
                  SfCartesianChart(
                      primaryXAxis: CategoryAxis(),
                      primaryYAxis:
                      NumericAxis(minimum: 0, maximum: 100, interval: 10),
                      series: <ChartSeries<_ChartData, String>>[
                        ColumnSeries<_ChartData, String>(
                            dataSource: sales,
                            xValueMapper: (_ChartData data, _) => data.x,
                            yValueMapper: (_ChartData data, _) => data.y,
                            name: 'Gold',
                            color: Color.fromRGBO(134, 97, 255, 1))
                      ])
                ],
              ))),
    );
  }

  Widget tabs() {
    return Column(
      children: [
        TabBar(
          controller: tabController,
          unselectedLabelColor: const Color.fromRGBO(41, 41, 41, 0.5),
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
                    border: Border.all(color: const Color.fromRGBO(134, 97, 255, 1), width: 1),
                  ),
                  child: const Text("Requests", textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                )
            ),
            Tab(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      border: Border.all(color: const Color.fromRGBO(134, 97, 255, 1), width: 1)
                  ),
                  child: const Text("Forms", textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                )
            ),
          ],
        ),
        SizedBox(
          width: double.maxFinite,
          height: 408,
          child: TabBarView(
            controller: tabController,
            children: [
              requests(),
              forms()
            ],
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
              requestCard(text: "Request All Projects",
                  onClick: () => onRequest(0)),
              requestCard(text: "Request All Sales",
                  onClick: () => onRequest(1)),
              requestCard(text: "Request Inventory",
                  onClick: () => onRequest(2)),
              requestCard(text: "Request All Employees",
                  onClick: () => onRequest(3)),
              requestCard(text: "Sales by Customer",
                  onClick: () => onRequest(4)),
              requestCard(text: "Sales by Employee",
                  onClick: () => onRequest(5)),
              requestCard(text: "Sales by State",
                  onClick: () => onRequest(6)),
              requestCard(text: "Request Engineers",
                  onClick: () => onRequest(7)),
              requestCard(text: "Request Shippers",
                  onClick: () => onRequest(8)),
              requestCard(text: "Request Suppliers",
                  onClick: () => onRequest(9)),
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
              formCard(text: "Add Employee",
                  onClick: () => onForm(0)),
              formCard(text: "Add Shipper",
                  onClick: () => onForm(1)),
              formCard(text: "Add Supplier",
                  onClick: () => onForm(1)),
            ],
          ),
        ),
      ),
    );
  }

  Widget formCard({
    required String text,
    required VoidCallback onClick
  }) {
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
                  const Icon(Icons.circle, color: Colors.white, size: 10,),
                  Padding(padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                    child: Text(text, style: const TextStyle(
                        color: Colors.white, fontSize: 16)),)
                ],
              ),
              const Icon(Icons.arrow_forward, color: Colors.white,)
            ],
          ),
        )
    );
  }

  Widget requestCard({
    required String text,
    required VoidCallback onClick
  }) {
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
                  const Icon(Icons.circle, color: Colors.white, size: 10,),
                  Padding(padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                    child: Text(text, style: const TextStyle(
                        color: Colors.white, fontSize: 16)),)
                ],
              ),
              const Icon(Icons.arrow_forward, color: Colors.white,)
            ],
          ),
        )
    );
  }

  void onForm(int index) {
    switch (index) {
      case 0:
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
            pageBuilder: (context, animation, secondaryAnimation) => const AddEmployeeDialog());
        break;
      case 1:
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
            pageBuilder: (context, animation, secondaryAnimation) => const AddShipSupDialog(hint : "Shipper"));
        break;
      case 2:
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
            pageBuilder: (context, animation, secondaryAnimation) => const AddShipSupDialog(hint : "Supplier"));
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
        showDialog(context: context, builder: (_) => const DialogWidget(hint: "Customer ID", type: TextInputType.text));
        break;
      case 5:
        showDialog(context: context, builder: (_) => const DialogWidget(hint: "Employee ID", type: TextInputType.text));
        break;
      case 6:
        showDialog(context: context, builder: (_) => const DialogWidget(hint: "State", type: TextInputType.text));
        break;
      case 7:
        showDialog(context: context, builder: (_) => const FinalDialogWidget());
        break;
      case 8:
        showDialog(context: context, builder: (_) => const FinalDialogWidget());
        break;
      case 9:
        showDialog(context: context, builder: (_) => const FinalDialogWidget());
        break;
    }
  }
}

class _ChartData {
  _ChartData(this.x, this.y);

  final String x;
  final double y;
}