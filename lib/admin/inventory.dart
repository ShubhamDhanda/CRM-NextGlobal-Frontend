import 'package:crm/admin/drawer.dart';
import 'package:crm/dialogs/filter_company_dialog.dart';
import 'package:crm/dialogs/update_company_dialog.dart';
import 'package:crm/services/remote_services.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';

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

  var apiClient = RemoteServices();
  bool dataLoaded = false;
  final snackBar1 = const SnackBar(
    content: Text('Something Went Wrong'),
    backgroundColor: Colors.red,
  );

  List<Map<String, dynamic>> inventories = [];
  // List<String> inventories = [];
  List<Map<String, dynamic>> filtered = [];
  List<Map<String, dynamic>> search = [];
  List<String> cat = [];

  @override
  void initState() {
    super.initState();
    _getData();
  }

  void _getData() async {
    dynamic res = await apiClient.getAllInventory();
    inventories.clear();
    search.clear();
    filtered.clear();

    if(res?["success"] == true){
      for (var i = 0; i < res["res"].length; i++) {
        var e = res["res"][i];

        Map<String, dynamic> mp = {};
        mp["inventoryId"] = e["Inventory_ID"]==.toString();
        mp["company"] = e["Company"].toString();
        mp["category"] = e["Category"];
        mp["product"] = e["Product"] ?? "";
        mp["approxSales"] = e["Approx_Sales"].toString();
        mp["geographicalCoverage"] = e["Geographical_Coverage"].toString();
        mp["keyPersonnel"] = e["KeyPersonnel"];
        mp["distributedBy"] = e["DistributedBy"] ?? "";
        inventories.add(mp);
      }

      search.addAll(inventories);
      filtered.addAll(inventories);
    }else {
      ScaffoldMessenger.of(context).showSnackBar(snackBar1);
    }
    setState(() {
      dataLoaded = true;
    });

    await Future.delayed(Duration(seconds: 2));
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
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
        if(e["name"].toString().toLowerCase().startsWith(text.toLowerCase())){
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
              filtered.addAll(competitors);
            }else{
              competitors.forEach((e) {
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
        height: 280,
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
                      "Company ID : ",
                      style: TextStyle(
                          color: Color.fromRGBO(134, 97, 255, 1),
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      mp["id"].toString(),
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
                    "Company Name : ",
                    style: TextStyle(
                        color: Color.fromRGBO(134, 97, 255, 1),
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  Flexible(fit: FlexFit.loose,child: Text(
                    mp["name"],
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
                    "Category : ",
                    style: TextStyle(
                        color: Color.fromRGBO(134, 97, 255, 1),
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    mp["category"],
                    style: const TextStyle(color: Colors.white, fontSize: 18),
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
                    "Address : ",
                    style: TextStyle(
                        color: Color.fromRGBO(134, 97, 255, 1),
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  Flexible(fit: FlexFit.loose,child: Text(
                    mp["address"],
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
                    "City : ",
                    style: TextStyle(
                        color: Color.fromRGBO(134, 97, 255, 1),
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  Flexible(fit: FlexFit.loose,child: Text(
                    mp["city"],
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
                    "Province : ",
                    style: TextStyle(
                        color: Color.fromRGBO(134, 97, 255, 1),
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  Flexible(fit: FlexFit.loose,child: Text(
                    mp["province"],
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
                    "Country : ",
                    style: TextStyle(
                        color: Color.fromRGBO(134, 97, 255, 1),
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  Flexible(fit: FlexFit.loose,child: Text(
                    mp["country"],
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
                    "Phone : ",
                    style: TextStyle(
                        color: Color.fromRGBO(134, 97, 255, 1),
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  Flexible(fit: FlexFit.loose,child: Text(
                    mp["businessPhone"],
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
                    "Email : ",
                    style: TextStyle(
                        color: Color.fromRGBO(134, 97, 255, 1),
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  Flexible(fit: FlexFit.loose,child: Text(
                    mp["email"],
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
                    "Webpage : ",
                    style: TextStyle(
                        color: Color.fromRGBO(134, 97, 255, 1),
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  Flexible(fit: FlexFit.loose,child: Text(
                    mp["webpage"],
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                    softWrap: false,
                    overflow: TextOverflow.fade,
                  ),)
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}