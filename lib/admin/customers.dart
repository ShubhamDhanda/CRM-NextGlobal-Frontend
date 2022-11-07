import 'dart:async';
import 'dart:convert';

import 'package:crm/admin/drawer.dart';
import 'package:crm/dialogs/add_ship_sup_dialog.dart';
import 'package:crm/dialogs/filter_customer_dialog.dart';
import 'package:crm/dialogs/update_customer.dart';
import 'package:crm/services/remote_services.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Customers extends StatefulWidget {
  const Customers({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _CustomersState();
}

class _CustomersState extends State<Customers> {
  var apiClient = RemoteServices();
  TextEditingController searchController = TextEditingController();
  bool dataLoaded = false;
  final snackBar1 = const SnackBar(
    content: Text('Something Went Wrong'),
    backgroundColor: Colors.red,
  );

  List<Map<String, dynamic>> customers = [];
  List<String> cat = [];
  late ScrollController _scrollController;
  bool _isLastPage = false;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      var nextPageTrigger = 0.8 * _scrollController.position.maxScrollExtent;
      if (_scrollController.position.pixels > nextPageTrigger && !_isLastPage) {
        if(searchController.text=="") {
          _getData();
        }else{
          _getSearchData(searchController.text);
        }
      }
    });

    _getData();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _getData() async {
    try{
      setState(() {
        dataLoaded = false;
      });
      dynamic res;
      if(cat.isEmpty) {
         res = await apiClient.getAllCustomers(customers.length);
      }else{
        List<String> filter = [];
        cat.forEach((e) => filter.add("'$e'"));
        res = await apiClient.filterCustomers(customers.length, filter.join(', '));
      }

      if (res["success"] == true) {
        if(res["res"].length==0 || res["res"].length%3!=0){
          _isLastPage = true;
        }
        for(var i=0;i<res["res"].length;i++){
          var e = res["res"][i];
          Map<String, dynamic> mp = {};

          mp["id"] = e["ID"];
          mp["companyId"] = e["Company_ID"];
          mp["salutation"] = e["Salutation"] ?? "";
          mp["lastName"] = e["Last_Name"] ?? "";
          mp["firstName"] = e["First_Name"];
          mp["emailPersonal"] = e["Email_Personal"] ?? "";
          mp["emailWork"] = e["Email_Work"] ?? "";
          mp["jobTitle"] = e["Job_Title"] ?? "";
          mp["business"] = e["Business_Phone"] ?? "";
          mp["mobile"] = e["Mobile_Phone_Personal"] ?? "";
          mp["address"] = e["Address"] ?? "";
          mp["city"] = e["City"] ?? "";
          mp["province"] = e["Province"] ?? "";
          mp["zip"] = e["ZIP"] ?? "";
          mp["country"] = e["Country"] ?? "";
          mp["notes"] = e["Notes"] ?? "";
          mp["attachments"] = e["Attachments"] ?? "";

          mp["birthday"] = e["Birthday"] ?? "";
          mp["anniversary"] = e["Anniversary"] ?? "";
          mp["sports"] = e["Sports"] ?? "";
          mp["activities"] = e["Activities"] ?? "";
          mp["beverage"] = e["Beverage"] ?? "";
          mp["Alcohol"] = e["Alcohol"] ?? "";
          mp["travelDestination"] = e["Travel_Destination"] ?? "";
          mp["spouseName"] = e["Spouse_Name"] ?? "";
          mp["children"] = e["Children"] ?? "";
          mp["tvShow"] = e["TV_Show"] ?? "";
          mp["movies"] = e["Movies"] ?? "";
          mp["actor"] = e["Actor"] ?? "";
          mp["dislikes"] = e["Dislikes"] ?? "";

          mp["companyName"] = e["Company_Name"];
          mp["category"] = e["Category"];
          customers.add(mp);
        }
      }
    } catch(e) {
      ScaffoldMessenger.of(context).showSnackBar(snackBar1);
    } finally{
      setState(() {
        dataLoaded = true;
      });

      await Future.delayed(const Duration(seconds: 2));
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
    }
  }

  void _getSearchData (String text) async {
    try{
      setState(() {
        dataLoaded = false;
      });

      dynamic res;
      if(cat.isEmpty) {
        res = await apiClient.searchCustomers(customers.length, text);
      }else{
        List<String> filter = [];
        cat.forEach((e) => filter.add("'$e'"));
        res = await apiClient.searchFilterCustomers(customers.length, text, filter.join(', '));
      }

      if (res["success"] == true) {
        if(res["res"].length==0 || res["res"].length%3!=0){
          _isLastPage = true;
        }
        for(var i=0;i<res["res"].length;i++){
          var e = res["res"][i];
          Map<String, dynamic> mp = {};

          mp["id"] = e["ID"];
          mp["companyId"] = e["Company_ID"];
          mp["salutation"] = e["Salutation"] ?? "";
          mp["lastName"] = e["Last_Name"] ?? "";
          mp["firstName"] = e["First_Name"];
          mp["emailPersonal"] = e["Email_Personal"] ?? "";
          mp["emailWork"] = e["Email_Work"] ?? "";
          mp["jobTitle"] = e["Job_Title"] ?? "";
          mp["business"] = e["Business_Phone"] ?? "";
          mp["mobile"] = e["Mobile_Phone_Personal"] ?? "";
          mp["address"] = e["Address"] ?? "";
          mp["city"] = e["City"] ?? "";
          mp["province"] = e["Province"] ?? "";
          mp["zip"] = e["ZIP"] ?? "";
          mp["country"] = e["Country"] ?? "";
          mp["notes"] = e["Notes"] ?? "";
          mp["attachments"] = e["Attachments"] ?? "";

          mp["birthday"] = e["Birthday"] ?? "";
          mp["anniversary"] = e["Anniversary"] ?? "";
          mp["sports"] = e["Sports"] ?? "";
          mp["activities"] = e["Activities"] ?? "";
          mp["beverage"] = e["Beverage"] ?? "";
          mp["Alcohol"] = e["Alcohol"] ?? "";
          mp["travelDestination"] = e["Travel_Destination"] ?? "";
          mp["spouseName"] = e["Spouse_Name"] ?? "";
          mp["children"] = e["Children"] ?? "";
          mp["tvShow"] = e["TV_Show"] ?? "";
          mp["movies"] = e["Movies"] ?? "";
          mp["actor"] = e["Actor"] ?? "";
          mp["dislikes"] = e["Dislikes"] ?? "";

          mp["companyName"] = e["Company_Name"];
          mp["category"] = e["Category"];
          customers.add(mp);
        }
      }
    } catch(e) {
      ScaffoldMessenger.of(context).showSnackBar(snackBar1);
    } finally{
      setState(() {
        dataLoaded = true;
      });

      await Future.delayed(const Duration(seconds: 2));
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
    }
  }

  void _onSearchChanged(String text) async {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      setState(() {
        dataLoaded = false;
      });

      _isLastPage = false;
      customers.clear();

      if(text.isEmpty){
        _getData();
      }else{
        _getSearchData(text);
      }

      setState(() {
        dataLoaded = true;
      });
    });
  }

  @override
  Widget build(context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Clients"),
          titleTextStyle: const TextStyle(color: Colors.white, fontSize: 24),
          backgroundColor: Colors.black,
        ),
        drawer: const NavDrawerWidget(
          name: '/customers',
        ),
        body: dashboard());
  }

  Widget dashboard() {
    return Container(
        color: const Color.fromRGBO(0, 0, 0, 1),
        child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 5.0),
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
                    child: customers.isEmpty
                        ? const Center(
                      child: Text(
                        "No Clients Found",
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                        :
                    Expanded(child: ListView.builder(
                      itemCount: customers.length+(_isLastPage ? 0 : 1),
                      prototypeItem: ListCard(customers.first),
                      controller: _scrollController,
                      itemBuilder: (context, index) {
                        if(index==customers.length){
                          return Card(
                            color: const Color.fromRGBO(0, 0, 0, 0),
                            child: Container(
                              height: 280,
                              width: MediaQuery.of(context).size.width - 20,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                color: const Color.fromRGBO(41, 41, 41, 1),
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                              child: const Center(
                                child: CircularProgressIndicator(
                                  color: Color.fromRGBO(134, 97, 255, 1),
                                ),
                              ),
                            ),
                          );
                        }else {
                          return ListCard(customers[index]);
                        }
                      },
                    ),
                    )
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
        onChanged: _onSearchChanged,
        controller: searchController,
        // controller: searchController,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.search, color: Colors.white,),
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
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
      child: ElevatedButton(
        onPressed: () {
          showGeneralDialog(
              context: context,
              barrierDismissible: false,
              transitionDuration: const Duration(milliseconds: 500),
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
              pageBuilder: (context, animation, secondaryAnimation) => FilterCustomerDialog(cat: cat)
          ).then((value) {
            value as List<String>;
            if(!areListsEqual(cat, value)){

            }else{
              print(value);
              customers.clear();
              _isLastPage = false;
              cat = value;
              if(searchController.text == ""){
                _getData();
              }else{
                _getSearchData(searchController.text);
              }
            }
          });
        },
        child: const Padding(
          padding: EdgeInsets.all(10.0),
          child: Icon(Icons.filter_alt),
        ),
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(const Color.fromRGBO(134, 97, 255, 1)),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(40.0),
              )
          )
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Text(
                        "Client ID : ",
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
                  GestureDetector(
                    onTap: () =>
                      showGeneralDialog(
                          context: context,
                          barrierDismissible: false,
                          transitionDuration: const Duration(milliseconds: 500),
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
                          pageBuilder: (context, animation, secondaryAnimation) => updateCustomerDialog(mp: mp,)
                      ).then((value) {
                        if(value! == true) {
                          _getData();
                        }
                      })
                    ,
                    child: const Icon(
                      Icons.edit,
                      color: Color.fromRGBO(134, 97, 255, 1),
                    ),
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Text(
                    "Name : ",
                    style: TextStyle(
                        color: Color.fromRGBO(134, 97, 255, 1),
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  Flexible(fit: FlexFit.loose,child: Text(
                    "${mp["salutation"]=="None" ? "" : "${mp["salutation"]} "}${mp["firstName"]}${mp["lastName"]=="" ? "" : " ${mp["lastName"]}"}",
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
                    "Company : ",
                    style: TextStyle(
                        color: Color.fromRGBO(134, 97, 255, 1),
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  Flexible(
                    fit: FlexFit.loose,
                    child: Text(
                      mp["companyName"],
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                      softWrap: false,
                      overflow: TextOverflow.fade,
                    ),
                  )
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
                    "Email : ",
                    style: TextStyle(
                        color: Color.fromRGBO(134, 97, 255, 1),
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  Flexible(
                    fit: FlexFit.loose,
                    child: Text(
                    mp["emailPersonal"],
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
                    "Job Title : ",
                    style: TextStyle(
                        color: Color.fromRGBO(134, 97, 255, 1),
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  Flexible(
                    fit: FlexFit.loose,
                      child: Text(
                        mp["jobTitle"],
                        style: const TextStyle(color: Colors.white, fontSize: 16),
                        softWrap: false,
                        overflow: TextOverflow.fade,
                      ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool areListsEqual(List<String> list1, List<String> list2) {
    if(list1.length!=list2.length) {
      return false;
    }
    for(int i=0;i<list1.length;i++) {
      if(list1[i]!=list2[i]) {
        return false;
      }
    }
    return true;
  }
}