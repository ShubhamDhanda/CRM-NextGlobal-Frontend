import 'package:crm/dialogs/add_employee_dialog.dart';
import 'package:crm/dialogs/add_people.dart';
import 'package:crm/services/constants.dart';
import 'package:crm/services/remote_services.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:intl/intl.dart';

import 'add_product_dialog.dart';

class updateInventoryDialog extends StatefulWidget {
  final Map<String, dynamic> mp;
  const updateInventoryDialog({Key? key, required this.mp}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _updateInventoryDialogState(mp: mp);
}

const List<String> Status = <String>["Go", "NoGo", "Review"];

class _updateInventoryDialogState extends State<updateInventoryDialog> {
  late Map<String, dynamic> mp;
  TextEditingController transactionType = TextEditingController();
  TextEditingController transactionDateCreated = TextEditingController();
  TextEditingController transactionModifiedDate = TextEditingController();
  TextEditingController product = TextEditingController();
  TextEditingController quantity = TextEditingController();
  TextEditingController orderId = TextEditingController();
  TextEditingController comments = TextEditingController();


  final snackBar1 = const SnackBar(
    content: Text('Please fill all the Required fields!'),
    backgroundColor: Colors.red,
  );

  final snackBar3 = const SnackBar(
    content: Text('Inventory Updated Successfully'),
    backgroundColor: Colors.green,
  );

  final snackBar4 = const SnackBar(
    content: Text('Something Went Wrong!'),
    backgroundColor: Colors.red,
  );

  var apiClient = RemoteServices();
  List<String> cities = [],
      departments = [],
      categories = [],
      products = [],type = [];
  Map<String, int> cityMap = {},
      departmentMap = {},
      employeeMap = {},
      projectsMap = {},
      companyMap = {};
  Map<String, int> typeMap = {},productIdMap = {};
  List<String> projects = [];
  bool dataLoaded = false;
  var transactionId;
  List<String> provinces = Constants.provinces;
  List<String> countries = Constants.countries;
  var status, bidStatus, Team;
  List<String> employees = <String>[];
  List<String> companies = [];
  List<String> contacts = [];
  // var productId;
  var ProjectManager;

  _updateInventoryDialogState({required this.mp}) {
    transactionType.text = mp["transactionType"];
    transactionDateCreated.text = mp["transactionCreatedDate"];
    transactionModifiedDate.text = mp["transactionModifiedDate"];
    product.text = mp["productId"];
    quantity.text = mp["quantity"];
    comments.text = mp["comments"];
    orderId.text = mp["orderId"];
  }

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
      dynamic res = await apiClient.getAllProducts();
      dynamic res1 = await apiClient.getTransactionTypes();

      // if (res?["success"]==true&&res1?["success"]==true) {

        for(var e in res["res"]){
          String name = e["Product_Name"] + " " + e["Product_Code"].toString();
          products.add(name);
          productIdMap[name] = e["Product_ID"];
        }
        for(var e in res1["res"]){
          type.add(e["Type_Name"]);
          typeMap[e["Type_Name"]] = e["Transaction_ID"];
        }
      // }
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(snackBar4);
    } finally {
      setState(() {
        dataLoaded = true;
      });

      await Future.delayed(Duration(seconds: 2));
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
    }
  }

  void postData() async {
    try {
      setState(() {
        dataLoaded = false;
      });

      if (validate() == true) {
        dynamic res = await apiClient.updateInventory(mp["inventoryId"],typeMap[transactionType.text],transactionDateCreated.text, productIdMap[product.text],quantity.text, orderId.text, comments.text);

        if(res["success"] == true){
          Navigator.pop(context,true);
          ScaffoldMessenger.of(context).showSnackBar(snackBar3);
        } else {
          throw "Negative";
        }
      }
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(snackBar4);
    } finally {
      setState(() {
        dataLoaded = true;
      });

      await Future.delayed(Duration(seconds: 2));
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
    }
  }

  bool validate() {
    if(transactionType.text=="" || product.text=="" ){
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
          child: Icon(Icons.close),
          onTap: () => Navigator.pop(context),
        ),
        title: Text("Update Inventory"),
        titleTextStyle: const TextStyle(color: Colors.white, fontSize: 24),
        backgroundColor: Colors.black,
      ),
      backgroundColor: const Color.fromRGBO(41, 41, 41, 1),
      body: Visibility(
        replacement: const Center(
          child: CircularProgressIndicator(
            color: Color.fromRGBO(134, 97, 255, 1),
          ),
        ),
        visible: dataLoaded,
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
              transactionType.text =
              suggestion == null ? "" : suggestion.toString();
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
              var curList = [];

              for (var e in type) {
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
                controller: transactionType,
                decoration: const InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white)),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white)),
                    hintText: "Transaction Type*",
                    hintStyle: TextStyle(
                        color: Color.fromRGBO(255, 255, 255, 0.5))
                )
            ),
          ),
          const SizedBox(height: 20,),

          TypeAheadFormField(
            onSuggestionSelected: (suggestion) {
              if (suggestion != null) {
                if (suggestion.toString() == "+ Add Product") {
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
                      const AddProductDialog()).then((value){
                    if(value! == true){
                      _getData();
                    }
                  });
                } else {
                  product.text = suggestion.toString();
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
              var curList = ["+ Add Product"];

              for (var e in products) {
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
                controller: product,
                decoration: const InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white)),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white)),
                    hintText: "Product*",
                    hintStyle: TextStyle(
                        color: Color.fromRGBO(255, 255, 255, 0.5))
                )
            ),
          ),
          const SizedBox(height: 20,),
          TextField(
            cursorColor: Colors.white,
            style: const TextStyle(color: Colors.white),
            keyboardType: TextInputType.number,
            controller: quantity,
            decoration: const InputDecoration(
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white)),
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white)),
                hintText: "Product Quantity",
                hintStyle:
                TextStyle(color: Color.fromRGBO(255, 255, 255, 0.5))),
          ),
          const SizedBox(
            height: 20,
          ),
          TextField(
            cursorColor: Colors.white,
            style: const TextStyle(color: Colors.white),
            keyboardType: TextInputType.text,
            controller: orderId,
            decoration: const InputDecoration(
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white)),
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white)),
                hintText: "Order Id*",
                hintStyle:
                TextStyle(color: Color.fromRGBO(255, 255, 255, 0.5))),
          ),
          const SizedBox(
            height: 20,
          ),
          TextField(
            cursorColor: Colors.white,
            style: const TextStyle(color: Colors.white),
            keyboardType: TextInputType.text,
            controller: comments,
            decoration: const InputDecoration(
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white)),
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white)),
                hintText: "Comments",
                hintStyle:
                TextStyle(color: Color.fromRGBO(255, 255, 255, 0.5))),
          ),
          const SizedBox(
            height: 20,
          ),

          Container(
            padding: const EdgeInsets.fromLTRB(100, 0, 100, 0),
            child: ElevatedButton(
              onPressed: () => postData(),
              style: ElevatedButton.styleFrom(
                  primary: const Color.fromRGBO(134, 97, 255, 1)),
              child: const Text(
                "Submit",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          )
        ],
      ),
    );
  }
}
