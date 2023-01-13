import 'package:crm/admin/drawer.dart';
import 'package:crm/dialogs/filter_company_dialog.dart';
import 'package:crm/dialogs/update_company_dialog.dart';
import 'package:crm/services/remote_services.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';

import '../dialogs/update_competitor_dialog.dart';
import '../dialogs/update_product_dialog.dart';
import '../dialogs/update_takeoff_dialog.dart';

class Mining extends StatefulWidget{
  const Mining({super.key});

  @override
  State<StatefulWidget> createState() => _MiningState();
}

class _MiningState extends State<Mining>{
  TextEditingController companyController = TextEditingController();
  TextEditingController category = TextEditingController();
  TextEditingController product = TextEditingController();
  TextEditingController approxSales = TextEditingController();
  TextEditingController geographicalCoverage = TextEditingController();
  TextEditingController distributedBy = TextEditingController();
  TextEditingController keyPersonnel = TextEditingController();

  var apiClient = RemoteServices();
  bool dataLoaded = false;
  final snackBar1 = const SnackBar(
    content: Text('Something Went Wrong'),
    backgroundColor: Colors.red,
  );

  List<Map<String, dynamic>> data = [];
  List<Map<String, dynamic>> filtered = [];
  List<Map<String, dynamic>> search = [];
  List<String> cat = [];

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
      dynamic res = await apiClient.getAllDataMining();
      data.clear();
      search.clear();
      filtered.clear();

      if (res?["success"] == true) {
        for (var i = 0; i < res["res"].length; i++) {
          var e = res["res"][i];

          Map<String, dynamic> mp = {};
          mp["dataId"] =
          e["Data_ID"] == null ? "" : e["Data_ID"].toString();
          mp["productsName"] =
          e["Products_ID"] == null ? "" : e["Products_ID"] ?? "";
          mp["salesPerson"] =
          e["Sales"] = e["Sales"] ?? "";
          mp["action"] =
          e["Action"] = e["Action"] ?? "";
          mp["manager"] =
          e["Manage"] == null ? "" : e["Manage"] ?? "";
          mp["generalContractor"] =
          e["Gen_Contractor"] == null ? "" : e["Gen_Contractor"] ?? "";
          mp["contractor"] =
          e["Contract"] == null ? "" : e["Contract"] ?? "";
          mp["projectSource"] =
          e["Project_Source"] == null ? "" : e["Project_Source"] ?? "";
          mp["projectName"] =
          e["Project_Name"] == null ? "" : e["Project_Name"] ?? "";
          mp["takeoffId"] =
          e["Takeoff_ID"] == null ? "" : e["Takeoff_ID"].toString();
          mp["projectValue"] =
          e["Project_Value"] == null ? "" : e["Project_Value"].toString();

          data.add(mp);
        }

        search.addAll(data);
        filtered.addAll(data);
      }
    } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(snackBar1);
    } finally {
    setState(() {
    dataLoaded = true;
    });

    await Future.delayed(Duration(seconds: 2));
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    }
  }

  void _onSearchChanged(String text) async {
    setState(() {
      dataLoaded = false;
    });
    search.clear();

    if(text.isEmpty){
      search.addAll(filtered);
    }else{
      filtered.forEach((e) {
        if(e["projectName"].toString().toLowerCase().startsWith(text.toLowerCase())){
          search.add(e);
        }
      });
    }

    setState(() {
      dataLoaded = true;
    });
  }

  @override
  Widget build(context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Data Mining"),
          titleTextStyle: const TextStyle(color: Colors.white, fontSize: 24),
          backgroundColor: Colors.black,
        ),
        drawer: const NavDrawerWidget(
          name: '/mining',
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

                Container(
                    width: MediaQuery.of(context).size.width-10,
                    child:Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        searchBar(),
                        filterButton()
                      ],
                    )
                ),
                Visibility(
                    replacement: const Center(
                      child: CircularProgressIndicator(
                        color: Color.fromRGBO(134, 97, 255, 1),
                      ),
                    ),
                    visible: dataLoaded,
                    child: search.isEmpty
                        ? const Center(
                      child: Text(
                        "No Data Mining Found",
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                        : Expanded(child: ListView.builder(
                      itemCount: search.length,
                      prototypeItem: ListCard(search.first),
                      itemBuilder: (context, index) {
                        return ListCard(search[index]);
                      },
                    ),)
                )
              ],
            )
        )
    );
  }

  Widget searchBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
      width: 300,
      child: TextField(
          cursorColor: Colors.white,
          // controller: searchController,
          onChanged: _onSearchChanged,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.search, color: Colors.white,),
            hintText: "Search",
            hintStyle: const TextStyle(color: Color.fromRGBO(255, 255, 255, 0.5)),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(40.0),
                borderSide: const BorderSide(color: Colors.white)
            ),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(40.0),
                borderSide: const BorderSide(color: Colors.white)
            ),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(40.0),
                borderSide: const BorderSide(color: Colors.white)
            ),
          )
      ),
    );
  }

  Widget filterButton() {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
      child: ElevatedButton(
        onPressed: () {
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
              pageBuilder: (context, animation, secondaryAnimation) => FilterCompanyDialog(cat: cat)
          ).then((value) {

            filtered.clear();
            cat = value as List<String>;
            if(cat.isEmpty){
              filtered.addAll(data);
            }else{
              data.forEach((e) {
                if(cat.contains(e["category"])){
                  filtered.add(e);
                }
              });
            }

            // _onSearchChanged(searchController.text);
          });
        },
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(const Color.fromRGBO(134, 97, 255, 1)),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40.0),
                )
            )
        ),
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Icon(Icons.filter_alt),
        ),
      ),
    );
  }

  Widget ListCard(Map<String, dynamic> mp) {
    return Card(
      color: const Color.fromRGBO(0, 0, 0, 0),
      child: Container(
        height: 155,
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
                      "Data ID : ",
                      style: TextStyle(
                          color: Color.fromRGBO(134, 97, 255, 1),
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      mp["dataId"].toString(),
                      style: const TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () =>
                      showGeneralDialog(
                          context: context,
                          barrierDismissible: false,
                          transitionDuration: Duration(milliseconds: 500),
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
                              UpdateTakeoffDialog(
                                mp: mp,
                              )).then((value) {
                        if(value! ==true){
                          setState(() {
                            dataLoaded = false;
                          });
                          _getData();
                          setState(() {
                            dataLoaded = true;
                          });
                        }
                      }),
                  child: Icon(
                    Icons.edit,
                    color: Color.fromRGBO(134, 97, 255, 1),
                  ),
                )
              ]),
              const SizedBox(
                height: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Text(
                    "Project Name : ",
                    style: TextStyle(
                        color: Color.fromRGBO(134, 97, 255, 1),
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  Flexible(fit: FlexFit.loose,child: Text(
                    mp["projectName"],
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                    softWrap: false,
                    overflow: TextOverflow.fade,
                  ),)
                ],
              ),
              const SizedBox(
                height: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Text(
                    "Products : ",
                    style: TextStyle(
                        color: Color.fromRGBO(134, 97, 255, 1),
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  Flexible(fit: FlexFit.loose,child: Text(
                    mp["productsName"],
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                    softWrap: false,
                    overflow: TextOverflow.fade,
                  ),)
                ],
              ),
              const SizedBox(
                height: 5,
              ),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.start,
              //   children: [
              //     const Text(
              //       "Action : ",
              //       style: TextStyle(
              //           color: Color.fromRGBO(134, 97, 255, 1),
              //           fontSize: 18,
              //           fontWeight: FontWeight.bold),
              //     ),
              //     Flexible(fit: FlexFit.loose,child: Text(
              //       mp["action"],
              //       style: const TextStyle(color: Colors.white, fontSize: 16),
              //       softWrap: false,
              //       overflow: TextOverflow.fade,
              //     ),)
              //   ],
              // ),
              // const SizedBox(
              //   height: 5,
              // ),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.start,
              //   children: [
              //     const Text(
              //       "Sales Person : ",
              //       style: TextStyle(
              //           color: Color.fromRGBO(134, 97, 255, 1),
              //           fontSize: 18,
              //           fontWeight: FontWeight.bold),
              //     ),
              //     Text(
              //       mp["salesPerson"],
              //       style: const TextStyle(color: Colors.white, fontSize: 18),
              //     ),
              //   ],
              // ),
              // const SizedBox(
              //   height: 5,
              // ),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.start,
              //   children: [
              //     const Text(
              //       "Manager : ",
              //       style: TextStyle(
              //           color: Color.fromRGBO(134, 97, 255, 1),
              //           fontSize: 18,
              //           fontWeight: FontWeight.bold),
              //     ),
              //     Flexible(fit: FlexFit.loose,child: Text(
              //       mp["manager"],
              //       style: const TextStyle(color: Colors.white, fontSize: 16),
              //       softWrap: false,
              //       overflow: TextOverflow.fade,
              //     ),)
              //   ],
              // ),
              // const SizedBox(
              //   height: 5,
              // ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Text(
                    "General Contractor : ",
                    style: TextStyle(
                        color: Color.fromRGBO(134, 97, 255, 1),
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  Flexible(fit: FlexFit.loose,child: Text(
                    mp["generalContractor"],
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                    softWrap: false,
                    overflow: TextOverflow.fade,
                  ),)
                ],
              ),
              const SizedBox(
                height: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Text(
                    "Contractor : ",
                    style: TextStyle(
                        color: Color.fromRGBO(134, 97, 255, 1),
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  Flexible(fit: FlexFit.loose,child: Text(
                    mp["contractor"],
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                    softWrap: false,
                    overflow: TextOverflow.fade,
                  ),)
                ],
              ),
              const SizedBox(
                height: 5,
              ),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.start,
              //   children: [
              //     const Text(
              //       "Project Source : ",
              //       style: TextStyle(
              //           color: Color.fromRGBO(134, 97, 255, 1),
              //           fontSize: 18,
              //           fontWeight: FontWeight.bold),
              //     ),
              //     Flexible(fit: FlexFit.loose,child: Text(
              //       mp["projectSource"],
              //       style: const TextStyle(color: Colors.white, fontSize: 16),
              //       softWrap: false,
              //       overflow: TextOverflow.fade,
              //     ),)
              //   ],
              // ),
              // const SizedBox(
              //   height: 5,
              // ),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.start,
              //   children: [
              //     const Text(
              //       "Project Value : ",
              //       style: TextStyle(
              //           color: Color.fromRGBO(134, 97, 255, 1),
              //           fontSize: 18,
              //           fontWeight: FontWeight.bold),
              //     ),
              //     Flexible(fit: FlexFit.loose,child: Text(
              //       mp["projectValue"],
              //       style: const TextStyle(color: Colors.white, fontSize: 16),
              //       softWrap: false,
              //       overflow: TextOverflow.fade,
              //     ),)
              //   ],
              // ),
              // const SizedBox(
              //   height: 5,
              // ),


            ],
          ),
        ),
      ),
    );
  }
}