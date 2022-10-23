import 'dart:convert';

import 'package:crm/admin/drawer.dart';
import 'package:crm/dialogs/add_ship_sup_dialog.dart';
import 'package:crm/dialogs/filter_customer_dialog.dart';
import 'package:crm/dialogs/update_customer.dart';
import 'package:crm/services/remote_services.dart';
import 'package:flutter/material.dart';

class Customers extends StatefulWidget {
  const Customers({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _CustomersState();
}

class _CustomersState extends State<Customers> {
  var apiClient = RemoteServices();
  bool dataLoaded = false;
  TextEditingController searchController = TextEditingController();
  final snackBar1 = SnackBar(
    content: Text('Something Went Wrong'),
    backgroundColor: Colors.red,
  );

  List<Map<String, dynamic>> customers = [];
  List<Map<String, dynamic>> filtered = [];
  List<Map<String, dynamic>> search = [];
  List<String> cat = [];

  @override
  void initState() {
    super.initState();
    _getData();
  }

  void _getData() async {
    setState(() {
      dataLoaded = false;
    });
    dynamic res = await apiClient.getAllCustomers();

    customers.clear();
    search.clear();
    filtered.clear();

    if (res?["success"] == true) {
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
    } else {
        ScaffoldMessenger.of(context).showSnackBar(snackBar1);
    }

    search.addAll(customers);
    filtered.addAll(customers);

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
        if(e["firstName"].toString().toLowerCase().contains(text.toLowerCase()) || e["lastName"].toString().toLowerCase().contains(text.toLowerCase()) || (e["firstName"] + " " + e["lastName"]).toString().toLowerCase().contains(text.toLowerCase()) || (int.tryParse(text)!=null && e["id"] == int.parse(text))  || e["company"].toString().toLowerCase().contains(text.toLowerCase())){
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
          title: Text("Clients"),
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
                    child: search.isEmpty
                        ? const Center(
                      child: Text(
                        "No Clients Found",
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                        :
                    Expanded(child: ListView.builder(
                      itemCount: search.length,
                      prototypeItem: ListCard(search.first),
                      itemBuilder: (context, index) {
                        return ListCard(search[index]);
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
        // controller: searchController,
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
              pageBuilder: (context, animation, secondaryAnimation) => FilterCustomerDialog(cat: cat)
          ).then((value) {
            value ?? [];
            filtered.clear();
            cat = value as List<String>;
            if(cat.isEmpty){
              filtered.addAll(customers);
            }else{
              customers.forEach((e) {
                if(cat.contains(e["category"])){
                  filtered.add(e);
                }
              });
            }

            _onSearchChanged(searchController.text);
          });
        },
        child: Padding(
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
                          pageBuilder: (context, animation, secondaryAnimation) => updateCustomerDialog(mp: mp,)
                      ).then((value) {
                        if(value! == true) {
                          _getData();
                        }
                      })
                    ,
                    child: Icon(
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
}
