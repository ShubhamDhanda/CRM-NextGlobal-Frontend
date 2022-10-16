import 'package:crm/dialogs/add_people.dart';
import 'package:crm/dialogs/dialog.dart';
import 'package:crm/dialogs/final_dialog.dart';
import 'package:crm/dialogs/new_purchase_dialog.dart';
import 'package:crm/services/remote_services.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class SupplierDashboard extends StatefulWidget {
  const SupplierDashboard({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SupplierDashboard();
}

class _SupplierDashboard extends State<SupplierDashboard>
    with TickerProviderStateMixin {
  var headNumArr = [0, 0, 0, 0];
  var headStrArr = [
    "New Purchases",
    "Submitted Purchases",
    "Approved Purchases",
    "Closed Purchases"
  ];
  var orders = [];
  List<_ChartData> data = [];
  late TabController tabController;
  var apiClient = RemoteServices();
  bool dataLoaded = false;

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
    dynamic res = await apiClient.getSupplierDashboard();

    if (res?["success"] == true) {
      print(res["res"][2]);

      headNumArr[0] = res["res"][0][0]["New_Purchases"] ?? 0;
      headNumArr[1] = res["res"][0][0]["Submitted_Purchases"] ?? 0;
      headNumArr[2] = res["res"][0][0]["Approved_Purchases"] ?? 0;
      headNumArr[3] = res["res"][0][0]["Closed_Purchases"] ?? 0;

      for (var i = 0; i < res["res"][1].length; i++) {
        var e = res["res"][1][i];
        var cur = [];

        cur.add(e["Purchase_Order_ID"]);
        if (e["Submitted_Date"] != null && e["Submitted_Date"] != "") {
          DateTime parseDate = DateFormat("yyyy-MM-dd")
              .parse(e["Submitted_Date"].toString().substring(0, 10));
          cur.add(DateFormat("dd-MM-yyyy").format(parseDate).toString());
        }

        cur.addAll([e["Supplier_ID"], e["Employee_Name"]]);
        orders.add(cur);
      }

      var chart = res["res"][2];
      for (var i = 0; i < chart.length; i++) {
        data.add(_ChartData(chart[i]["Product_Code"].toString(),
            double.parse((chart[i]["Total_Cost"] / 1000).toString())));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(snackBar1);
    }

    setState(() {
      dataLoaded = true;
    });

    await Future.delayed(Duration(seconds: 2));
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
  }

  @override
  Widget build(context) {
    tabController = TabController(length: 2, vsync: this);

    return Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Center(child: Text("Suppliers Dashboard")),
              GestureDetector(
                onTap: () async {
                  final SharedPreferences prefs =
                      await SharedPreferences.getInstance();
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
          titleTextStyle: const TextStyle(color: Colors.white, fontSize: 20),
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
          children: <Widget>[header(), myFocus(), inventoryTop(), tabs()],
        ),
      ),
    );
  }

  Widget header() {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            headerCard(0),
            headerCard(1),
            headerCard(2),
            headerCard(3)
          ],
        ),
      ],
    );
  }

  Widget headerCard(int index) {
    return Card(
      color: const Color.fromRGBO(0, 0, 0, 0),
      child: Container(
          height: 70,
          width: 87.5,
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
                    fontWeight: FontWeight.bold),
              ),
              Text(
                headStrArr[index].toString(),
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 8,
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
                  "Product Transactions",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
                SingleChildScrollView(
                  child: FittedBox(
                    child: DataTable(
                        border: TableBorder(
                            horizontalInside: BorderSide(
                                color: Color.fromRGBO(
                                    255, 255, 255, 0.43529411764705883))),
                        columnSpacing: 15,
                        columns: const [
                          DataColumn(
                              label: Text("Purchase ID",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                  ))),
                          DataColumn(
                              label: Text("Purchase Date",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                  ))),
                          DataColumn(
                              label: Text("Supplier ID",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                  ))),
                          DataColumn(
                              label: Text("Created By",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                  ))),
                        ],
                        rows: orders
                            .map((e) => DataRow(cells: [
                                  DataCell(Center(
                                      child: Text(
                                    e[0].toString(),
                                    style: TextStyle(
                                        color:
                                            Color.fromRGBO(255, 255, 255, 0.8)),
                                  ))),
                                  DataCell(Center(
                                      child: Text(
                                    e[1].toString(),
                                    style: TextStyle(
                                        color:
                                            Color.fromRGBO(255, 255, 255, 0.8)),
                                  ))),
                                  DataCell(Center(
                                      child: Text(
                                    e[2].toString(),
                                    style: TextStyle(
                                        color:
                                            Color.fromRGBO(255, 255, 255, 0.8)),
                                  ))),
                                  DataCell(Center(
                                      child: Text(
                                    e[3].toString(),
                                    style: TextStyle(
                                        color:
                                            Color.fromRGBO(255, 255, 255, 0.8)),
                                  ))),
                                ]))
                            .toList()),
                  ),
                ),
              ],
            ),
          ))),
    );
  }

  Widget inventoryTop() {
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
                  const Text("Top 5 purchased products",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      )),
                  SfCartesianChart(
                      primaryXAxis: CategoryAxis(
                          title: AxisTitle(
                              text: "Product Code",
                              textStyle: TextStyle(
                                  color: Colors.white, fontSize: 12))),
                      primaryYAxis: NumericAxis(
                          minimum: 0,
                          maximum: 100,
                          interval: 10,
                          title: AxisTitle(
                              text: "Total Cost(*1000\$)",
                              textStyle: TextStyle(
                                  color: Colors.white, fontSize: 12))),
                      series: <ChartSeries<_ChartData, String>>[
                        ColumnSeries<_ChartData, String>(
                            dataSource: data,
                            xValueMapper: (_ChartData data, _) => data.x,
                            yValueMapper: (_ChartData data, _) => data.y,
                            name: 'Product Code',
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
          height: 300,
          child: TabBarView(
            controller: tabController,
            children: [requests(), forms()],
          ),
        )
      ],
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
              formCard(text: "New Purchase", onClick: () => onForm(0)),
              formCard(text: "Approve Purchase", onClick: () => onForm(1)),
              formCard(text: "Close Purchase", onClick: () => onForm(2)),
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
              requestCard(
                  text: "Request All Purchase Details",
                  onClick: () => onRequest(0)),
              requestCard(
                  text: "Request Purchase Details By Purchase ID",
                  onClick: () => onRequest(1)),
              requestCard(
                  text: "Request Purchase Details by Product ID",
                  onClick: () => onRequest(2)),
              requestCard(
                  text: "Request Purchase Details by Supplier ID",
                  onClick: () => onRequest(3)),
              requestCard(
                  text: "Request Purchase Details by Creator ID",
                  onClick: () => onRequest(4)),
              requestCard(
                  text: "Request Purchase Details by Approved ID",
                  onClick: () => onRequest(5)),
              requestCard(
                  text: "Request Purchase Details by Date",
                  onClick: () => onRequest(6)),
            ],
          ),
        ),
      ),
    );
  }

  Widget requestCard({required String text, required VoidCallback onClick}) {
    return GestureDetector(
        onTap: onClick,
        child: Padding(
          padding: EdgeInsets.fromLTRB(8, 8, 8, 8),
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
                    padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
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
        showGeneralDialog(
            context: context,
            barrierDismissible: false,
            transitionDuration: Duration(milliseconds: 500),
            transitionBuilder: (context, animation, secondaryAnimation, child) {
              const begin = Offset(0.0, 1.0);
              const end = Offset.zero;
              const curve = Curves.ease;

              var tween =
                  Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

              return SlideTransition(
                position: animation.drive(tween),
                child: child,
              );
            },
            pageBuilder: (context, animation, secondaryAnimation) =>
                const NewPurchaseDialog());
        break;
      case 1:
        showDialog(
            context: context,
            builder: (_) => const DialogWidget(
                  hint: "Purchase ID",
                  type: TextInputType.text,
                ));
        break;
      case 2:
        showDialog(
            context: context,
            builder: (_) => const DialogWidget(
                  hint: "Purchase ID",
                  type: TextInputType.text,
                ));
        break;
    }
  }

  void onRequest(int index) {
    switch (index) {
      case 0:
        showDialog(context: context, builder: (_) => const FinalDialogWidget());
        break;
      case 1:
        showDialog(
            context: context,
            builder: (_) => const DialogWidget(
                  hint: "Purchase ID",
                  type: TextInputType.text,
                ));
        break;
      case 2:
        showDialog(
            context: context,
            builder: (_) => const DialogWidget(
                  hint: "Product ID",
                  type: TextInputType.text,
                ));
        break;
      case 3:
        showDialog(
            context: context,
            builder: (_) => const DialogWidget(
                  hint: "Supplier ID",
                  type: TextInputType.text,
                ));
        break;
      case 4:
        showDialog(
            context: context,
            builder: (_) => const DialogWidget(
                  hint: "Creator ID",
                  type: TextInputType.text,
                ));
        break;
      case 5:
        showDialog(
            context: context,
            builder: (_) => const DialogWidget(
                  hint: "Approval ID",
                  type: TextInputType.text,
                ));
        break;
      case 6:
        showDialog(
            context: context,
            builder: (_) => const DialogWidget(
                  hint: "Date",
                  type: TextInputType.datetime,
                ));
        break;
    }
  }
}

class _ChartData {
  _ChartData(this.x, this.y);

  final String x;
  final double y;
}
