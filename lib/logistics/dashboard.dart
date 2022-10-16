import 'package:crm/dialogs/dialog.dart';
import 'package:crm/dialogs/final_dialog.dart';
import 'package:crm/dialogs/invoice_dialog.dart';
import 'package:crm/dialogs/new_order_dialog.dart';
import 'package:crm/services/remote_services.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LogisticsDashboard extends StatefulWidget {
  const LogisticsDashboard({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _LogisticsDashboardState();

}

class _LogisticsDashboardState extends State<LogisticsDashboard> with TickerProviderStateMixin {
  var headNumArr = [0, 0, 0, 0];
  var headStrArr = [
    "New Orders",
    "Invoiced Orders",
    "Shipped Orders",
    "Closed Orders"
  ];
  var orders = [

  ];
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
    dynamic res = await apiClient.getLogisticsDashboard();

    if(res?["success"] == true){
      print(res);

      headNumArr[0] = res["newOrders"];
      headNumArr[1] = res["invoiceOrders"];
      headNumArr[2] = res["shippedOrders"];
      headNumArr[3] = res["closedOrders"];

      for(var i=0;i<res["res"].length;i++) {
        var e = res["res"][i];
        var cur = [];

        cur.add(e["Order_ID"]);
        if(e["Order_Date"] != null && e["Order_Date"] != ""){
          DateTime parseDate = DateFormat("yyyy-MM-dd").parse(e["Order_Date"].toString().substring(0, 10));
          cur.add(DateFormat("dd-MM-yyyy").format(parseDate).toString());
        }
        cur.addAll([e["Shipper_ID"] ?? "", e["Ship_Name"] ?? ""]);

        orders.add(cur);
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
              const Center(child: Text("Logistics Dashboard")),
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
              fontSize: 22
          ),
          backgroundColor: Colors.black,
        ),
        body: dashboard()
    );
  }

  Widget dashboard() {
    return Container(
      color: const Color.fromRGBO(0, 0, 0, 1),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 10.0),
        child: Visibility(
          replacement: const Center(
            child: CircularProgressIndicator(
              color: Color.fromRGBO(134, 97, 255, 1),
            ),
          ),
          visible: dataLoaded,
          child: ListView(
            children: <Widget>[
              header(),
              myFocus(),
              //Divider(color: Color.fromRGBO(255, 255, 255, 0.19607843137254902), thickness: 1, indent: 10,),
              tabs()
            ],
          ),
        ),
      ),
    );
  }

  Widget header() {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                ),
              ),
              Text(
                headStrArr[index].toString(),
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold
                ),
              ),
            ],
          )
      ),
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
                      "Orders to be Shipped",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                    SingleChildScrollView(
                      child: FittedBox(
                        child: DataTable(
                            border: const TableBorder(
                                horizontalInside: BorderSide(color: Color.fromRGBO(
                                    255, 255, 255, 0.43529411764705883))),
                            columnSpacing: 15,
                            columns:
                            const [
                              DataColumn(label: Text(
                                  "Order ID", textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.white,))),
                              DataColumn(label: Text(
                                  "Order Date", textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.white,))),
                              DataColumn(label: Text(
                                  "Shipper ID", textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.white,))),
                              DataColumn(
                                label: Center(
                                    widthFactor: 3.5,
                                child:  Text(
                                    "Name", textAlign: TextAlign.center,
                                    style: TextStyle(color: Colors.white,))),
                              ),
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
                      ),
                    ),
                  ],
                ),
              )
          )
      ),
    );
  }

  Widget tabs() {
    return Column(
      children: [
        Container(
          child: TabBar(
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
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
        ),
        Container(
          width: double.maxFinite,
          height: 328,
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
              formCard(text: "Generate Invoice", onClick: () => onForm(0)),
              formCard(text: "New Order", onClick: () => onForm(1)),
              formCard(text: "Update Order", onClick: () => onForm(2)),
              formCard(text: "Close Order", onClick: () => onForm(3)),
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
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              requestCard(text: "Request All Orders", onClick: () => onRequest(0)),
              requestCard(text: "Request Details By Order ID", onClick: () => onRequest(1)),
              requestCard(text: "Request Orders by Employee ID", onClick: () => onRequest(2)),
              requestCard(text: "Request Orders by Customer ID", onClick: () => onRequest(3)),
              requestCard(text: "Request Orders by Date", onClick: () => onRequest(4)),
              requestCard(text: "Request Orders by State", onClick: () => onRequest(5)),
              requestCard(text: "Request Orders by Status", onClick: () => onRequest(6)),
              requestCard(text: "Inventory Levels", onClick: () => onRequest(7)),
            ],
          ),
        ),
      ),
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
            pageBuilder: (context, animation, secondaryAnimation) => const InvoiceDialog());
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
            pageBuilder: (context, animation, secondaryAnimation) => const NewOrderDialog());
        break;

      case 2:
        showDialog(context: context, builder: (_) => const DialogWidget(hint: "Order ID", type: TextInputType.number,));
        break;
      case 3:
        showDialog(context: context, builder: (_) => const DialogWidget(hint: "Order ID", type: TextInputType.number,));
        break;
    }
  }

  void onRequest(int index) {
    switch (index) {
      case 0:
        showDialog(context: context, builder: (_) => const FinalDialogWidget());
        break;
      case 1:
        showDialog(context: context, builder: (_) => const DialogWidget(hint: "Order ID", type: TextInputType.number,));
        break;
      case 2:
        showDialog(context: context, builder: (_) => const DialogWidget(hint: "Employee ID", type: TextInputType.number,));
        break;
      case 3:
        showDialog(context: context, builder: (_) => const DialogWidget(hint: "Customer ID", type: TextInputType.number,));
        break;
      case 4:
        showDialog(context: context, builder: (_) => const DialogWidget(hint: "Date", type: TextInputType.datetime,));
        break;
      case 5:
        showDialog(context: context, builder: (_) => const DialogWidget(hint: "State", type: TextInputType.text,));
        break;
      case 6:
        showDialog(context: context, builder: (_) => const DialogWidget(hint: "Status", type: TextInputType.number,));
        break;
      case 7:
        showDialog(context: context, builder: (_) => const FinalDialogWidget());
        break;
    }
  }
}