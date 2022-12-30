import 'package:crm/dialogs/add_employee_dialog.dart';
import 'package:crm/dialogs/add_people.dart';
import 'package:crm/services/constants.dart';
import 'package:crm/services/remote_services.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:intl/intl.dart';

class updateInventoryDialog extends StatefulWidget {
  final Map<String, dynamic> mp;
  const updateInventoryDialog({Key? key, required this.mp}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _updateInventoryDialogState(mp: mp);
}

const List<String> Status = <String>["Go", "NoGo", "Review"];

const List<String> type = <String>[
  'Purchased',
  'Sold',
  'On Hold',
  'Waste'
];
class _updateInventoryDialogState extends State<updateInventoryDialog> {
  late Map<String, dynamic> mp;
  TextEditingController transactionType = TextEditingController();
  TextEditingController transactionDateCreated = TextEditingController();
  TextEditingController transactionModifiedDate = TextEditingController();
  TextEditingController product = TextEditingController();
  TextEditingController quantity = TextEditingController();
  TextEditingController order = TextEditingController();
  TextEditingController comments = TextEditingController();


  final snackBar1 = const SnackBar(
    content: Text('Please fill all the Required fields!'),
    backgroundColor: Colors.red,
  );

  final snackBar3 = const SnackBar(
    content: Text('Project Updated Successfully'),
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
      products = [];
  Map<String, int> cityMap = {},
      departmentMap = {},
      employeeMap = {},
      projectsMap = {},
      companyMap = {};
  Map<String, int> cityIdMap = {},
      departmentIdMap = {},
      employeeIdMap = {},
      productIdMap = {},
      transactionIdMap = {};
  List<String> projects = [];
  bool dataLoaded = false;
  var transactionId;
  List<String> provinces = Constants.provinces;
  List<String> countries = Constants.countries;
  var status, bidStatus, Team;
  List<String> employees = <String>[];
  List<String> companies = [];
  List<String> contacts = [];
  var productId;
  var ProjectManager;

  _updateInventoryDialogState({required this.mp}) {
    // projectController.text = mp["projectName"];
    // department.text = mp["department"];
    // closingDeadline.text = mp["closingDeadline"];
    // resultDate.text = mp["resultDate"];
    // projectManager.text = mp["managerName"];
    // questionDeadline.text = mp["questionDeadline"];
    // city.text = mp["city"];
    // province.text = mp["province"];
    // department.text = mp["department"];
    // teamMember.text = mp["team"];
    // designPrice.text = mp["designPrice"];
    // provisionalItems.text = mp["provisionalItems"];
    // contractAdminPrice.text = mp["contractAdminPrice"];
    // subConsultantPrice.text = mp["subConsultantPrice"];
    // totalBid.text = mp["totalBid"];
    // planTakers.text = mp["planTakers"];
    // bidders.text = mp["bidders"];
    // bidderPrice.text = mp["bidderPrice"];
    // winnerPrice.text = mp["winningPrice"];
    // winningBidder.text = mp["winningBidderName"];
    // if(teamMember.text!="")prevMember = teamMember.text.split(",");
    // if(planTakers.text!="")prevPlan = planTakers.text.split(",");
    // if(bidders.text!="")prevBid = bidders.text.split(",");

    // if(mp["status"]!=""){
    //   status = mp["status"];
    // }
    //
    // if (mp["bidStatus"] != "") {
    //   bidStatus = mp["bidStatus"];
    // }
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
      dynamic res1 = await apiClient.getCities();
      dynamic res2 = await apiClient.getDepartments();
      dynamic res3 = await apiClient.getAllEmployeeNames();
      dynamic res4 = await apiClient.getAllCompanyNames();

      for (var e in res1["res"]) {
        cities.add(e["City"]);
        cityMap[e["City"]] = e["City_ID"];
      }

      for (var e in res2["res"]) {
        departments.add(e["Department"]);
        departmentMap[e["Department"]] = e["Department_ID"];
      }

      for (var e in res3["res"]) {
        employees.add(e["Full_Name"].toString());
        employeeMap[e["Full_Name"].toString()] = e["Employee_ID"];
        print(e["Full_Name"]);
        print(e["Employee_ID"]);
      }
      for (var e in res4["res"]) {
        companies.add(e["Name"]);
        companyMap[e["Name"]] = e["ID"];
      }
      print(employees);
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
        // dynamic res = await apiClient.updateProposal(mp["id"],cityMap[city.text], departmentMap[department.text], projectController.text, questionDeadline.text, closingDeadline.text, resultDate.text,status.toString(),  employeeMap[projectManager.text],  teamMember.text, designPrice.text, provisionalItems.text, contractAdminPrice.text,subConsultantPrice.text, totalBid.text,planTakers.text, bidders.text, bidderPrice.text, bidStatus ?? "", winnerPrice.text, companyMap[winningBidder.text]);

        // if(res["success"] == true){
        if (true) {
          Navigator.pop(context);
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
    // if(projectController.text=="" || city.text=="" || department.text=="" || status=="" || projectManager.text == "" ){
    //   ScaffoldMessenger.of(context).showSnackBar(snackBar1);
    //   return false;
    // }

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
        title: Text("Update Proposal"),
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
              transactionId = transactionIdMap[transactionType.text];
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
          // TextField(
          //   cursorColor: Colors.white,
          //   style: const TextStyle(color: Colors.white),
          //   keyboardType: TextInputType.datetime,
          //   readOnly: true,
          //   onTap: () async {
          //     showDatePicker(
          //         context: context,
          //         initialDate: transactionModifiedDate.text == ""
          //             ? DateTime.now()
          //             : DateTime.parse(transactionModifiedDate.text),
          //         firstDate: DateTime(
          //             2000), //DateTime.now() - not to allow to choose before today.
          //         lastDate: DateTime(2101),
          //         builder: (context, child) {
          //           return Theme(
          //             data: ThemeData.dark().copyWith(
          //               colorScheme: const ColorScheme.dark(
          //                 // primary: Colors.black,
          //                 onPrimary: Colors.white,
          //                 surface: Colors.black,
          //                 onSurface: Colors.white,
          //               ),
          //               dialogBackgroundColor:
          //               const Color.fromRGBO(41, 41, 41, 1),
          //             ),
          //             child: child!,
          //           );
          //         }).then((value) {
          //       setState(() {
          //         transactionModifiedDate.text = value != null
          //             ? DateFormat('yyyy-MM-dd').format(value)
          //             : transactionModifiedDate.text;
          //       });
          //     });
          //   },
          //   controller: transactionModifiedDate,
          //   decoration: const InputDecoration(
          //       enabledBorder: UnderlineInputBorder(
          //           borderSide: BorderSide(color: Colors.white)),
          //       focusedBorder: UnderlineInputBorder(
          //           borderSide: BorderSide(color: Colors.white)),
          //       hintText: "Transaction Created Date",
          //       hintStyle:
          //       TextStyle(color: Color.fromRGBO(255, 255, 255, 0.5))),
          // ),
          // const SizedBox(
          //   height: 20,
          // ),
          TypeAheadFormField(
            onSuggestionSelected: (suggestion) {
              product.text = suggestion == null ? "" : suggestion.toString();
              productId = productIdMap[product.text];
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
                controller: transactionType,
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
            controller: order,
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
