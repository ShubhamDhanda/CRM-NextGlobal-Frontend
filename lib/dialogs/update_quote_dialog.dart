import 'package:crm/dialogs/add_employee_dialog.dart';
import 'package:crm/dialogs/add_people.dart';
import 'package:crm/services/constants.dart';
import 'package:crm/services/remote_services.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:intl/intl.dart';

import 'add_product_dialog.dart';
import 'add_takeoff_dialog.dart';

class updateQuoteDialog extends StatefulWidget {
  final Map<String, dynamic> mp;
  const updateQuoteDialog({Key? key, required this.mp}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _updateQuoteDialogState(mp: mp);
}

const List<String> Status = <String>["Go", "NoGo", "Review"];

class _updateQuoteDialogState extends State<updateQuoteDialog> {
  late Map<String, dynamic> mp;
  TextEditingController projectController = TextEditingController();
  TextEditingController total = TextEditingController();
  TextEditingController client = TextEditingController();
  TextEditingController clientEmail = TextEditingController();



  final snackBar1 = const SnackBar(
    content: Text('Please fill all the Required fields!'),
    backgroundColor: Colors.red,
  );

  final snackBar3 = const SnackBar(
    content: Text('Quote Updated Successfully'),
    backgroundColor: Colors.green,
  );

  final snackBar4 = const SnackBar(
    content: Text('Something Went Wrong!'),
    backgroundColor: Colors.red,
  );

  var apiClient = RemoteServices();
  bool loading = false;
  List<String> employees = [], clients = [], projects = [],selectedClients = [];
  Map<String, String> empMap = {}, clientMap = {};
  List<String> list = [], clientList = [];
  Map<String,int> projectsMap ={},takeoffMap = {};

  _updateQuoteDialogState({required this.mp}) {
    projectController.text = mp["projectName"];
    client.text = mp["client"];
    total.text = mp["total"];
    selectedClients = client.text.split(",");
    if(client.text=="")selectedClients.clear();
  }

  @override
  void initState() {
    super.initState();

    _getData();
  }

  void _getData() async {
    try {
      setState(() {
        loading = true;
      });
      dynamic res = await apiClient.getAllDataMining();
      dynamic res3 = await apiClient.getAllCustomerNames();
      for (var e in res["res"]) {
        projects.add(e["Project_Name"]);
        projectsMap[e["Project_Name"]] = e["Data_ID"];
        takeoffMap[e["Project_Name"]] = e["Takeoff_ID"];
      }
      for (var e in res3["res"]) {
        if (e["Email_Work"] != null && e["Email_Work"] != "") {
          clients.add(e["Full_Name"]);
          clientMap[e["Full_Name"]] = e["Email_Work"];
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(snackBar1);
    } finally {
      setState(() {
        loading = false;
      });

      await Future.delayed(const Duration(seconds: 2));
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
    }
  }

  void postData() async {
    try {
      setState(() {
        loading = true;
      });

      if (validate() == true) {
        dynamic res = await apiClient.updateQuote(
            mp["quoteId"],projectsMap[projectController.text], client.text, clientEmail.text,
            total.text);
        if (res?["success"] == true) {
          Navigator.pop(context,true);
          ScaffoldMessenger.of(context).showSnackBar(snackBar3);
        } else {
          throw "Negative";
        }
      }
      else{
        ScaffoldMessenger.of(context).showSnackBar(snackBar3);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(snackBar4);
    } finally {
      setState(() {
        loading = false;
      });

      await Future.delayed(const Duration(seconds: 2));
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
    }
  }

  void _getProjectData() async {
    try {
      setState(() {
        loading = true;
      });
      double price = 0;
      total.text = 0.toString();
      dynamic res1 = await apiClient.getAllTakeoffItems(
          takeoffMap[projectController.text]);
      for (var e in res1["res"]) {
        Map<String, dynamic> mp = {};
        mp["productCategory"] = e["Product_Category"] ?? "";
        mp["productMaterial"] = e["Product_Material"] ?? "";
        mp["productSubcategory"] = e["Product_Subcategory"] ?? "";
        mp["productCode"] = e["Product_Code"] ?? "";
        mp["proposedProduct"] = e["Proposed_Product"] ?? "";
        mp["unit"] = e["Unit"] ?? "";
        mp["price"] = e["Price"] ?? "";
        print(mp["price"]);
        mp["quantity"] = e["Quantity"] ?? "";
        print(mp["quantity"]);
        print(1);
        mp["productName"] = e["Product_Name"] ?? "";
        mp["specifiedProduct"] = e["Specified_Product"] ?? "";
        String name = e["Product_Name"] + " " + e["Product_Code"].toString();
        if (mp["quantity"] != null && mp["quantity"] != '') {
          double a = double.parse(mp["quantity"]);
          double b = double.parse(mp["price"]);
          // price += int.parse(mp["quantity"])*int.parse(mp["price"]);
          price += a * b;
        }
      }
      total.text = price.toString();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(snackBar1);
    } finally {
      setState(() {
        loading = false;
      });

      await Future.delayed(const Duration(seconds: 2));
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
    }
  }

  bool validate() {
    if (projectController.text == "") {
      ScaffoldMessenger.of(context).showSnackBar(snackBar1);
      return false;
    }
    return true;
  }

  @override
  Widget build(context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          child: const Icon(Icons.close),
          onTap: () => Navigator.pop(context),
        ),
        title: const Text("Update Quote"),
        titleTextStyle: const TextStyle(
            color: Colors.white,
            fontSize: 24
        ),
        backgroundColor: Colors.black,
      ),
      backgroundColor: const Color.fromRGBO(41, 41, 41, 1),
      body: Visibility(
        replacement: const Center(
          child: CircularProgressIndicator(
            color: Color.fromRGBO(134, 97, 255, 1),
          ),
        ),
        visible: !loading,
        child: form(),
      ),
    );
  }

  Widget form() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
      child: ListView(
        children: [
          TypeAheadFormField(
            onSuggestionSelected: (suggestion) {
              if (suggestion != null) {
                if (suggestion.toString() == "+ Add New Project") {
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
                      const AddTakeoffDialog()).then((value) {
                    if (value! == true) {
                      _getData();
                    }
                  });
                } else {
                  projectController.text = suggestion.toString();
                  _getProjectData();
                  // companyId = companyMap[companyName.text];
                }
              }
              // companyController.text = suggestion==null ? "" : suggestion.toString();
              // companyId = employeeMap[companyController.text];
            },
            itemBuilder: (context, suggestion) {
              return ListTile(
                title: Text(suggestion == null ? "" : suggestion.toString(),
                  style: const TextStyle(color: Colors.white),),
                tileColor: Colors.black,
              );
            },
            transitionBuilder: (context, suggestionsBox, controller) {
              return suggestionsBox;
            },
            suggestionsCallback: (pattern) {
              var curList = ["+ Add New Project"];


              for (var e in projects) {
                if (e.toString().toLowerCase().startsWith(
                    pattern.toLowerCase())) {
                  curList.add(e);
                }
              }

              return curList;
            },
            textFieldConfiguration: TextFieldConfiguration(
                cursorColor: Colors.white,
                style: const TextStyle(color: Colors.white),
                keyboardType: TextInputType.text,
                controller: projectController,
                decoration: const InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white)),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white)),
                    hintText: "Project Name*",
                    hintStyle: TextStyle(
                        color: Color.fromRGBO(255, 255, 255, 0.5))
                )
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          DropdownSearch<String>.multiSelection(
            items: clients,
            selectedItems: selectedClients,
            dropdownButtonProps: const DropdownButtonProps(
                color: Color.fromRGBO(255, 255, 255, 0.5)
            ),
            dropdownDecoratorProps: const DropDownDecoratorProps(
                baseStyle: TextStyle(color: Colors.black),
                dropdownSearchDecoration: InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white)),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white)),
                    hintText: "Clients",
                    hintStyle: TextStyle(
                        color: Color.fromRGBO(255, 255, 255, 0.5))
                )
            ),
            // popupProps: const PopupPropsMultiSelection.dialog(
            //     showSelectedItems: true,
            //     showSearchBox: true,
            //     // dialogProps: DialogProps(
            //     //   backgroundColor: Colors.black,
            //     // )
            // ),
            popupProps: const PopupPropsMultiSelection.menu(
                showSelectedItems: true,
                showSearchBox: true,
                searchFieldProps: TextFieldProps(
                    decoration: InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white)),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white)),
                        hintText: "Clients",
                        hintStyle: TextStyle(
                            color: Color.fromRGBO(0, 0, 0, 0.3))
                    )
                ),
                menuProps: MenuProps(
                  backgroundColor: Colors.white,
                )
            ),
            onChanged: (value) {
              selectedClients = value;
              selectedClients.sort((a, b) =>
                  a.toString().compareTo(b.toString()));
              clientList.clear();
              value.forEach((e) {
                clientList.add(clientMap[e]!);
              }
              );
              client.text = selectedClients.join(",");
              // print(selectedClients);
              // print(client.text);
              clientEmail.text = clientList.join(",");
            },
          ),
          const SizedBox(height: 30,),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Text(
                "               Total Price: ",
                style: TextStyle(
                    color: Color.fromRGBO(134, 97, 255, 1),
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                total.text,
                style: const TextStyle(color: Colors.white, fontSize: 18),
              ),
            ],
          ),
          const SizedBox(height: 20,),


          // DropdownSearch<String>.multiSelection(
          //   items: distributors,
          //   dropdownButtonProps: const DropdownButtonProps(
          //     color: Color.fromRGBO(255, 255, 255, 0.3)
          //   ),
          //   dropdownDecoratorProps: const DropDownDecoratorProps(
          //     dropdownSearchDecoration: InputDecoration(
          //       enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
          //             focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
          //             hintText: "Distributor List",
          //             hintStyle: TextStyle(color: Color.fromRGBO(255, 255, 255, 0.5))
          //     )
          //   ),
          //   // dropdownBuilder: (context, distributors) {
          //   //   return
          //   // },
          //   popupProps: const PopupPropsMultiSelection.menu(
          //     showSelectedItems: true,
          //     menuProps: MenuProps(
          //       // backgroundColor: Colors.black,
          //     )
          //   ),
          //   onChanged: (value) {
          //     distList = value;
          //   },
          // ),
          // const SizedBox(height: 20,),
          // // TextField(
          // //   cursorColor: Colors.white,
          // //   style: const TextStyle(color: Colors.white),
          // //   keyboardType: TextInputType.number,
          // //   controller: distributorPrice,
          // //   decoration: const InputDecoration(
          // //       enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
          // //       focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
          // //       hintText: "Distributor Price",
          // //       hintStyle: TextStyle(color: Color.fromRGBO(255, 255, 255, 0.5))
          // //   ),
          // // ),
          // const SizedBox(height: 20,),
          // DropdownSearch<String>.multiSelection(
          //   items: contractors,
          //   dropdownButtonProps: const DropdownButtonProps(
          //       color: Color.fromRGBO(255, 255, 255, 0.3)
          //   ),
          //   dropdownDecoratorProps: const DropDownDecoratorProps(
          //       dropdownSearchDecoration: InputDecoration(
          //           enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
          //           focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
          //           hintText: "Contractor List",
          //           hintStyle: TextStyle(color: Color.fromRGBO(255, 255, 255, 0.5))
          //       )
          //   ),
          //   popupProps: const PopupPropsMultiSelection.menu(
          //       showSelectedItems: true,
          //       menuProps: MenuProps(
          //         // backgroundColor: Colors.black,
          //       )
          //   ),
          //   onChanged: (value) {
          //     contList = value;
          //   },
          // ),
          // const SizedBox(height: 20,),
          // TextField(
          //   cursorColor: Colors.white,
          //   style: const TextStyle(color: Colors.white),
          //   keyboardType: TextInputType.number,
          //   controller: contractorPrice,
          //   decoration: const InputDecoration(
          //       enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
          //       focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
          //       hintText: "Contractor Price",
          //       hintStyle: TextStyle(color: Color.fromRGBO(255, 255, 255, 0.5))
          //   ),
          // ),
          // const SizedBox(height: 20,),
          Container(
            padding: const EdgeInsets.fromLTRB(100, 0, 100, 0),
            child: ElevatedButton(onPressed: () => postData(),
              style: ElevatedButton.styleFrom(
                  primary: const Color.fromRGBO(134, 97, 255, 1)),
              child: const Text("Submit",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}