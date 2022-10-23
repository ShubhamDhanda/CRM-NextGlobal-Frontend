import 'package:crm/admin/drawer.dart';
import 'package:crm/services/remote_services.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Assets extends StatefulWidget{
  const Assets({super.key});

  @override
  State<StatefulWidget> createState() => _AssetsState();
}

class _AssetsState extends State<Assets> with TickerProviderStateMixin{
  late TabController tabController;
  var apiClient = RemoteServices();
  bool dataLoaded = false;
  final snackBar1 = SnackBar(
    content: Text('Something Went Wrong'),
    backgroundColor: Colors.red,
  );

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
    _getData();
  }

  _handleTabSelection() {
    if (tabController.indexIsChanging) {
      setState(() {});
    }
  }

  void _getData() async {
    dynamic res = await apiClient.getAllAssets();
    dynamic res2 = await apiClient.getAllSoftware();

    if(res?["success"] == true && res2?["success"] == true){

      for(var e in res["res"]){
        Map<String, dynamic> mp = {};

        mp["id"] = e["Asset_ID"];
        mp["employeeId"] = e["Employee_ID"];
        mp["employeeName"] = e["Full_Name"];
        mp["category"] = e["Asset_Category"] ?? "";
        mp["details"] = e["Hardware_Details"] ?? "";
        mp["acquiredOn"] = e["Acquired_On"]==null ? "" : DateFormat("yyyy-MM-dd").format(DateTime.parse(e["Acquired_On"]).toLocal()).toString();
        mp["purchasePrice"] = e["Purchase_Price"] ?? "";
        mp["shippedOn"] = e["Shipped_On"]==null ? "" : DateFormat("yyyy-MM-dd").format(DateTime.parse(e["Shipped_On"]).toLocal()).toString();
        mp["retiredDate"] = e["Retired_Date"]==null ? "" : DateFormat("yyyy-MM-dd").format(DateTime.parse(e["Retired_Date"]).toLocal()).toString();
        mp["attachments"] = e["Attachments"] ?? "";
        mp["notes"] = e["Notes"] ?? "";

        assets.add(mp);
      }

      for(var e in res2["res"]){
        Map<String, dynamic> mp = {};

        mp["id"] = e["Software_ID"];
        mp["software"] = e["Software"];
        mp["version"] = e["Version"] ?? "";
        mp["manufacturer"] = e["Manufacturer"] ?? "";
        mp["acquiredOn"] = e["Acquired_On"]==null ? "" : DateFormat("yyyy-MM-dd").format(DateTime.parse(e["Acquired_On"]).toLocal()).toString();
        mp["price"] = e["Price"] ?? "";
        mp["retiredDate"] = e["Retired_Date"]==null ? "" : DateFormat("yyyy-MM-dd").format(DateTime.parse(e["Retired_Date"]).toLocal()).toString();
        mp["attachments"] = e["Attachments"] ?? "";
        mp["notes"] = e["Notes"] ?? "";

        software.add(mp);
      }
    }else{
      ScaffoldMessenger.of(context).showSnackBar(snackBar1);
    }

    setState(() {
      dataLoaded = true;
    });

    await Future.delayed(Duration(seconds: 2));
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> assets = [], software = [];
  @override
  Widget build(context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text("Assets"),
          titleTextStyle: const TextStyle(color: Colors.white, fontSize: 24),
          backgroundColor: Colors.black,
        ),
        drawer: const NavDrawerWidget(
          name: '/assets',
        ),
        body: dashboard());
  }

  Widget dashboard() {
    return Container(
      color: const Color.fromRGBO(0, 0, 0, 1),
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5.0),
            child: Column(
              children: [
tabs()
              ],
            )
        )
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
                  child: const Text("Assets", textAlign: TextAlign.center,
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
                  child: const Text("Software", textAlign: TextAlign.center,
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
          height: MediaQuery.of(context).size.height-177,
          child: TabBarView(
            controller: tabController,
            children: [
              hardwares(),
              softwares()
            ],
          ),
        )
      ],
    );
  }

  Widget hardwares() {
    return Visibility(
        replacement: const Center(
          child: CircularProgressIndicator(
            color: Color.fromRGBO(134, 97, 255, 1),
          ),
        ),
        visible: dataLoaded,
        child: assets.isEmpty
            ? const Center(
          child: Text(
            "No Assets Found",
            style: TextStyle(color: Colors.white),
          ),
        )
            : ListView.builder(
          itemCount: assets.length,
          prototypeItem: hardwareCard(assets.first),
          itemBuilder: (context, index) {
            return hardwareCard(assets[index]);
          },
        ),
    );
  }

  Widget softwares() {
    return Visibility(
        replacement: const Center(
          child: CircularProgressIndicator(
            color: Color.fromRGBO(134, 97, 255, 1),
          ),
        ),
        visible: dataLoaded,
        child:
          software.isEmpty
            ? const Center(
          child: Text(
            "No Software Found",
            style: TextStyle(color: Colors.white),
          ),
        )
            : ListView.builder(
          itemCount: software.length,
          prototypeItem: softwareCard(software.first),
          itemBuilder: (context, index) {
            return softwareCard(software[index]);
          },
        ),
    );
  }

  Widget hardwareCard(Map<String, dynamic> mp) {
    return Card(
      color: const Color.fromRGBO(0, 0, 0, 0),
      child: Container(
        height: 228,
        width: MediaQuery.of(context).size.width - 20,
        alignment: Alignment.centerLeft,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: const Color.fromRGBO(41, 41, 41, 1),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Text(
                      "Asset ID : ",
                      style: TextStyle(
                          color: Color.fromRGBO(134, 97, 255, 1),
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      mp["id"].toString(),
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ],
                ),
                // GestureDetector(
                //   onTap: () =>
                //       showGeneralDialog(
                //           context: context,
                //           barrierDismissible: false,
                //           transitionDuration: Duration(milliseconds: 500),
                //           transitionBuilder:
                //               (context, animation, secondaryAnimation, child) {
                //             const begin = Offset(0.0, 1.0);
                //             const end = Offset.zero;
                //             const curve = Curves.ease;
                //
                //             var tween = Tween(begin: begin, end: end)
                //                 .chain(CurveTween(curve: curve));
                //
                //             return SlideTransition(
                //               position: animation.drive(tween),
                //               child: child,
                //             );
                //           },
                //           pageBuilder: (context, animation, secondaryAnimation) =>
                //               UpdateCompanyDialog(
                //                 mp: mp,
                //               )).then((value) {
                //         _getData();
                //         setState(() {
                //           dataLoaded = true;
                //         });
                //       }),
                //   child: Icon(
                //     Icons.edit,
                //     color: Color.fromRGBO(134, 97, 255, 1),
                //   ),
                // )
              ]
              ),
              const SizedBox(
                height: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Text(
                    "Employee : ",
                    style: TextStyle(
                        color: Color.fromRGBO(134, 97, 255, 1),
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  Flexible(child: Text(
                    mp["employeeName"],
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                    softWrap: false,
                    overflow: TextOverflow.fade,
                  ),
                    fit: FlexFit.loose,)
                ],
              ),
              const SizedBox(
                height: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Text(
                    "Category : ",
                    style: TextStyle(
                        color: Color.fromRGBO(134, 97, 255, 1),
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    mp["category"],
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ],
              ),
              const SizedBox(
                height: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Text(
                    "Details : ",
                    style: TextStyle(
                        color: Color.fromRGBO(134, 97, 255, 1),
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  Flexible(child: Text(
                    mp["details"],
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                    softWrap: false,
                    overflow: TextOverflow.fade,
                  ),
                    fit: FlexFit.loose,)
                ],
              ),
              const SizedBox(
                height: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Text(
                    "Acquired On : ",
                    style: TextStyle(
                        color: Color.fromRGBO(134, 97, 255, 1),
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    mp["acquiredOn"],
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ],
              ),
              const SizedBox(
                height: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Text(
                    "Price : ",
                    style: TextStyle(
                        color: Color.fromRGBO(134, 97, 255, 1),
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  Flexible(child: Text(
                    "\$ ${mp["purchasePrice"]}",
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                    softWrap: false,
                    overflow: TextOverflow.fade,
                  ),
                    fit: FlexFit.loose,)
                ],
              ),
              const SizedBox(
                height: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Text(
                    "Shipped On : ",
                    style: TextStyle(
                        color: Color.fromRGBO(134, 97, 255, 1),
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    mp["shippedOn"],
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ],
              ),
              const SizedBox(
                height: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Text(
                    "Retired Date : ",
                    style: TextStyle(
                        color: Color.fromRGBO(134, 97, 255, 1),
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    mp["retiredDate"],
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ],
              ),
              const SizedBox(
                height: 5,
              ),
            ],
          )
        )
      )
    );
  }

  Widget softwareCard(Map<String, dynamic> mp) {
    return Card(
        color: const Color.fromRGBO(0, 0, 0, 0),
        child: Container(
            height: 202,
            width: MediaQuery.of(context).size.width - 20,
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: const Color.fromRGBO(41, 41, 41, 1),
            ),
            child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Text(
                            "Software ID : ",
                            style: TextStyle(
                                color: Color.fromRGBO(134, 97, 255, 1),
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            mp["id"].toString(),
                            style: const TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ],
                      ),
                      // GestureDetector(
                      //   onTap: () =>
                      //       showGeneralDialog(
                      //           context: context,
                      //           barrierDismissible: false,
                      //           transitionDuration: Duration(milliseconds: 500),
                      //           transitionBuilder:
                      //               (context, animation, secondaryAnimation, child) {
                      //             const begin = Offset(0.0, 1.0);
                      //             const end = Offset.zero;
                      //             const curve = Curves.ease;
                      //
                      //             var tween = Tween(begin: begin, end: end)
                      //                 .chain(CurveTween(curve: curve));
                      //
                      //             return SlideTransition(
                      //               position: animation.drive(tween),
                      //               child: child,
                      //             );
                      //           },
                      //           pageBuilder: (context, animation, secondaryAnimation) =>
                      //               UpdateCompanyDialog(
                      //                 mp: mp,
                      //               )).then((value) {
                      //         _getData();
                      //         setState(() {
                      //           dataLoaded = true;
                      //         });
                      //       }),
                      //   child: Icon(
                      //     Icons.edit,
                      //     color: Color.fromRGBO(134, 97, 255, 1),
                      //   ),
                      // )
                    ]
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Text(
                          "Software : ",
                          style: TextStyle(
                              color: Color.fromRGBO(134, 97, 255, 1),
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                        Flexible(child: Text(
                          mp["software"],
                          style: const TextStyle(color: Colors.white, fontSize: 16),
                          softWrap: false,
                          overflow: TextOverflow.fade,
                        ),
                          fit: FlexFit.loose,)
                      ],
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Text(
                          "Version : ",
                          style: TextStyle(
                              color: Color.fromRGBO(134, 97, 255, 1),
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          mp["version"],
                          style: const TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Text(
                          "Manufacturer : ",
                          style: TextStyle(
                              color: Color.fromRGBO(134, 97, 255, 1),
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                        Flexible(child: Text(
                          mp["manufacturer"],
                          style: const TextStyle(color: Colors.white, fontSize: 16),
                          softWrap: false,
                          overflow: TextOverflow.fade,
                        ),
                          fit: FlexFit.loose,)
                      ],
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Text(
                          "Acquired On : ",
                          style: TextStyle(
                              color: Color.fromRGBO(134, 97, 255, 1),
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          mp["acquiredOn"],
                          style: const TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Text(
                          "Price : ",
                          style: TextStyle(
                              color: Color.fromRGBO(134, 97, 255, 1),
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                        Flexible(child: Text(
                          "\$ ${mp["price"]}",
                          style: const TextStyle(color: Colors.white, fontSize: 16),
                          softWrap: false,
                          overflow: TextOverflow.fade,
                        ),
                          fit: FlexFit.loose,)
                      ],
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Text(
                          "Retired Date : ",
                          style: TextStyle(
                              color: Color.fromRGBO(134, 97, 255, 1),
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          mp["retiredDate"],
                          style: const TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                  ],
                )
            )
        )
    );
  }
}