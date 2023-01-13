import 'package:crm/admin/drawer.dart';
import 'package:crm/dialogs/filter_company_dialog.dart';
import 'package:crm/dialogs/update_company_dialog.dart';
import 'package:crm/services/remote_services.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';

import '../dialogs/filter_competitor_dialog.dart';
import '../dialogs/update_competitor_dialog.dart';
import '../dialogs/update_inventory_dialog.dart';

class Inventory extends StatefulWidget{
  const Inventory({super.key});

  @override
  State<StatefulWidget> createState() => _InventoryState();
}

class _InventoryState extends State<Inventory>{
  TextEditingController companyController = TextEditingController();
  TextEditingController category = TextEditingController();
  TextEditingController product = TextEditingController();
  TextEditingController approxSales = TextEditingController();
  TextEditingController geographicalCoverage = TextEditingController();
  TextEditingController distributedBy = TextEditingController();
  TextEditingController keyPersonnel = TextEditingController();
  TextEditingController searchController = TextEditingController();

  var apiClient = RemoteServices();
  bool dataLoaded = false,filtersLoaded= false;
  final snackBar1 = const SnackBar(
    content: Text('Something Went Wrong'),
    backgroundColor: Colors.red,
  );

  List<Map<String, dynamic>> inventories = [];
  // List<String> inventories = [];
  List<Map<String, dynamic>> filtered = [];
  List<Map<String, dynamic>> search = [];
  List<String> cat = [],selectedCat = [];

  @override
  void initState() {
    super.initState();
    _getData();
    _getFilters();
  }

  void _getData() async {
    try {
      setState(() {
        dataLoaded = false;
      });
      dynamic res = await apiClient.getAllInventory();
      inventories.clear();
      search.clear();
      filtered.clear();

      if (res?["success"] == true) {
        for (var i = 0; i < res["res"].length; i++) {
          var e = res["res"][i];

          Map<String, dynamic> mp = {};
          mp["inventoryId"] =
          e["Inventory_ID"] == null ? "" : e["Inventory_ID"].toString();
          mp["transactionType"] =
          e["Type_Name"] == null ? "" : e["Type_Name"].toString();
          print(mp["transactionType"]);
          mp["transactionCreatedDate"] = e["Transaction_Created_Date"] == null
              ? ""
              : e["Transaction_Created_Date"];
          mp["transactionModifiedDate"] = e["Transaction_Modified_Date"] == null
              ? ""
              : e["Transaction_Modified_Date"];
          // print(e["Product_Name"]);
          // print(e["Product_Code"]);
          String name = e["Product_Name"] + " " + e["Product_Code"].toString();
          print(name);
          mp["productId"] = name;
          // mp["productId"] = "";
          mp["quantity"] =
          e["Quantity"] == null ? "" : e["Quantity"].toString();
          mp["orderId"] = e["Order_ID"] == null ? "" : e["Order_ID"].toString();
          mp["comments"] =
          e["Comments"] == null ? "" : e["Comments"].toString();
          inventories.add(mp);
        }

        search.addAll(inventories);
        filtered.addAll(inventories);
      } else {
        throw "Negative";
      }
    }catch(e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(snackBar1);
    } finally {
      setState(() {
        dataLoaded = true;
      });

      await Future.delayed(Duration(seconds: 2));
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
    }
  }

  void _getFilters() async {
    try{
      setState(() {
        filtersLoaded = false;
      });

      dynamic res = await apiClient.getTransactionTypes();

      for(var e in res["res"]){
        cat.add(e["Type_Name"]);
      }

    } catch(e) {
      ScaffoldMessenger.of(context).showSnackBar(snackBar1);
    } finally{
      setState(() {
        filtersLoaded = true;
      });

      await Future.delayed(const Duration(seconds: 2));
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
        if(e["productId"].toString().toLowerCase().startsWith(text.toLowerCase())){
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
          title: Text("Inventory"),
          titleTextStyle: const TextStyle(color: Colors.white, fontSize: 24),
          backgroundColor: Colors.black,
        ),
        drawer: const NavDrawerWidget(
          name: '/inventory',
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
                        "No Inventory Found",
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
          controller: searchController,
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
              pageBuilder: (context, animation, secondaryAnimation) => FilterCompetitorDialog(cat: cat,prevCat: selectedCat)
          ).then((value) {
            Map<String, List<String>> mp = value as Map<String, List<String>>;
            selectedCat = mp["Categories"]??[];
            filtered.clear();
            if(selectedCat.isEmpty){
              filtered.addAll(inventories);
            }else{
              inventories.forEach((e) {
                if(selectedCat.contains(e["transactionType"])){
                  filtered.add(e);
                }
              });
            }

            _onSearchChanged(searchController.text);
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
        height: 180,
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
                      "Inventory ID : ",
                      style: TextStyle(
                          color: Color.fromRGBO(134, 97, 255, 1),
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      mp["inventoryId"].toString(),
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
                              updateInventoryDialog(
                                mp: mp,
                              )).then((value) {
                        if(value! == true){
                          _getData();
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
                    "Transaction Type : ",
                    style: TextStyle(
                        color: Color.fromRGBO(134, 97, 255, 1),
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  Flexible(fit: FlexFit.loose,child: Text(
                    mp["transactionType"],
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
              //       "Transaction Created Date : ",
              //       style: TextStyle(
              //           color: Color.fromRGBO(134, 97, 255, 1),
              //           fontSize: 18,
              //           fontWeight: FontWeight.bold),
              //     ),
              //     Text(
              //       mp["transactionCreatedDate"],
              //       style: const TextStyle(color: Colors.white, fontSize: 18),
              //     ),
              //   ],
              // ),
              // const SizedBox(
              //   height: 5,
              // ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Text(
                    "Product : ",
                    style: TextStyle(
                        color: Color.fromRGBO(134, 97, 255, 1),
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  Flexible(fit: FlexFit.loose,child: Text(
                    mp["productId"],
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
                    "Quantity : ",
                    style: TextStyle(
                        color: Color.fromRGBO(134, 97, 255, 1),
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  Flexible(fit: FlexFit.loose,child: Text(
                    mp["quantity"],
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
                    "Order ID: ",
                    style: TextStyle(
                        color: Color.fromRGBO(134, 97, 255, 1),
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  Flexible(fit: FlexFit.loose,child: Text(
                    mp["orderId"],
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
                    "Comments : ",
                    style: TextStyle(
                        color: Color.fromRGBO(134, 97, 255, 1),
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  Flexible(fit: FlexFit.loose,child: Text(
                    mp["comments"],
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                    softWrap: false,
                    overflow: TextOverflow.fade,
                  ),)
                ],
              ),
              const SizedBox(
                height: 5,
              ),
            ],
          ),
        ),
      ),
    );
  }
}