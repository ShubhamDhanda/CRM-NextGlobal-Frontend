import 'package:crm/dialogs/add_employee_dialog.dart';
import 'package:crm/dialogs/add_people.dart';
import 'package:crm/services/constants.dart';
import 'package:crm/services/remote_services.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:intl/intl.dart';

class updateCompetitorDialog extends StatefulWidget {
  final Map<String, dynamic> mp;
  const updateCompetitorDialog({Key? key, required this.mp}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _updateCompetitorDialogState(mp: mp);
}

const List<String> Status = <String>["Go", "NoGo", "Review"];
const List<String> list = <String>[
  'New Project',
  'Modifications',
  'Quote',
  'Negotiation',
  'Closed',
  'Dead'
];

class _updateCompetitorDialogState extends State<updateCompetitorDialog> {
  late Map<String, dynamic> mp;
  TextEditingController companyController = TextEditingController();
  TextEditingController category = TextEditingController();
  TextEditingController product = TextEditingController();
  TextEditingController approxSales = TextEditingController();
  TextEditingController geographicalCoverage = TextEditingController();
  TextEditingController distributedBy = TextEditingController();
  TextEditingController keyPersonnel = TextEditingController();

  final snackBar1 = const SnackBar(
    content: Text('Please fill all the Required fields!'),
    backgroundColor: Colors.red,
  );

  final snackBar3 = const SnackBar(
    content: Text('Competitor Updated Successfully'),
    backgroundColor: Colors.green,
  );

  final snackBar4 = const SnackBar(
    content: Text('Something Went Wrong!'),
    backgroundColor: Colors.red,
  );

  var apiClient = RemoteServices();
  bool dataLoaded = false;
  var projectStageVal, dept;
  List<String> provinces = Constants.provinces;
  List<String> employees = <String>[];
  List<String> prevCat = [];
  List<String> prevDep = [];
  var companyId;
  List<String> prevMember = [], prevPlan = [], prevBid = [];
  List<String> clients = [];
  Map<String, String> empMap = {}, clientMap = {};
  Map<String, int> projectManagerMap = {};
  var stringList, empId, Team;
  var status, bidStatus,projectManagerId;
  List<Map<String, dynamic>> customers = [];
  List<String> Departments = [];
  List<String> cities = [], departments = [], companies = [],contacts = [];
  Map<String, int> cityMap = {},
      departmentMap = {},
      companyMap = {},
      employeeMap = {};
  var ProjectManager;

  _updateCompetitorDialogState({required this.mp}) {
    companyController.text = mp["company"];
    category.text = mp["category"];
    approxSales.text = mp["approxSales"];
    geographicalCoverage.text = mp["geographicalCoverage"];
    distributedBy.text = mp["distributedBy"];
    keyPersonnel.text = mp["keyPersonnel"];

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
      // dynamic res1 = await apiClient.getCities();
      dynamic res2 = await apiClient.getDepartments();
      // dynamic res3 = await apiClient.getAllEmployeeNames();
      dynamic res4 = await apiClient.getAllCompanyNames();


      for (var e in res2["res"]) {
        departments.add(e["Department"]);
        departmentMap[e["Department"]] = e["Department_ID"];
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
    try{
      setState(() {
        dataLoaded = false;
      });

      if (validate() == true) {
        dynamic res = await apiClient.updateCompetitor(mp["competitorId"],companyMap[companyController.text], departmentMap[category.text], product.text,approxSales.text, geographicalCoverage.text,distributedBy.text,keyPersonnel.text);

        // if(res["success"] == true){
        if(true){
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(snackBar3);
        }else{
          throw "Negative";
        }
      }
    } catch(e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(snackBar4);
    }finally{
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
        title: Text("Update Competitor"),
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
              companyController.text = suggestion==null ? "" : suggestion.toString();
              companyId = employeeMap[companyController.text];
            },

            itemBuilder: (context, suggestion) {
              return ListTile(
                title: Text(suggestion==null ? "" : suggestion.toString(), style: const TextStyle(color: Colors.white),),
                tileColor: Colors.black,
              );
            },
            transitionBuilder: (context, suggestionsBox, controller) {
              return suggestionsBox;
            },
            suggestionsCallback: (pattern) {
              var curList = [];

              for (var e in companies) {
                if(e.toString().toLowerCase().startsWith(pattern.toLowerCase())){
                  curList.add(e);
                }
              }
              return curList;
            },
            textFieldConfiguration: TextFieldConfiguration(
                cursorColor: Colors.white,
                style: const TextStyle(color: Colors.white),
                keyboardType: TextInputType.text,
                controller: companyController,
                decoration: const InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white)),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white)),
                    hintText: "Company Name*",
                    hintStyle: TextStyle(color: Color.fromRGBO(255, 255, 255, 0.5))
                )
            ),
          ),
          const SizedBox(height: 20,),
          TypeAheadFormField(
            onSuggestionSelected: (suggestion) {
              if(suggestion != null) {
                category.text = suggestion.toString();
              }
            },
            itemBuilder: (context, suggestion) {
              return ListTile(
                title: Text(suggestion==null ? "" : suggestion.toString(), style: const TextStyle(color: Colors.white),),
                tileColor: Colors.black,
              );
            },
            transitionBuilder: (context, suggestionsBox, controller) {
              return suggestionsBox;
            },
            suggestionsCallback: (pattern) {
              var curList = [];


              for (var e in departments) {
                if(e.toString().toLowerCase().startsWith(pattern.toLowerCase())){
                  curList.add(e);
                }
              }

              return curList;
            },
            textFieldConfiguration: TextFieldConfiguration(
                cursorColor: Colors.white,
                style: const TextStyle(color: Colors.white),
                keyboardType: TextInputType.text,
                controller: category,
                decoration: const InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white)),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white)),
                    hintText: "Category*",
                    hintStyle: TextStyle(color: Color.fromRGBO(255, 255, 255, 0.5))
                )
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          TextField(
            cursorColor: Colors.white,
            style: const TextStyle(color: Colors.white),
            keyboardType: TextInputType.text,
            controller: product,
            decoration: const InputDecoration(
                enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                hintText: "Product",
                hintStyle: TextStyle(color: Color.fromRGBO(255, 255, 255, 0.5))
            ),
          ),
          const SizedBox(height: 20,),
          DropdownButton<String>(
            value: status,
            isExpanded: true,
            dropdownColor: Colors.black,
            hint: const Text(
              "Status",
              style: TextStyle(color: Color.fromRGBO(255, 255, 255, 0.5),fontSize: 16),
            ),
            icon: null,
            style: const TextStyle(color: Colors.white),
            underline: Container(
              height: 1,
              color: Colors.white,
            ),
            onChanged: (String? value) {
              // This is called when the user selects an item.
              setState(() {
                status = value!;
              });
            },
            items: Status.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(
                  value,
                  style: const TextStyle(),
                ),
              );
            }).toList(),
          ),
          const SizedBox(
            height: 20,
          ),
          TextField(
            cursorColor: Colors.white,
            style: const TextStyle(color: Colors.white),
            keyboardType: TextInputType.number,
            controller: approxSales,
            decoration: const InputDecoration(
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white)),
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white)),
                hintText: "Approx Sales*",
                hintStyle:
                TextStyle(color: Color.fromRGBO(255, 255, 255, 0.5))),
          ),
          const SizedBox(
            height: 20,
          ),
          TextField(
            cursorColor: Colors.white,
            style: const TextStyle(color: Colors.white),
            keyboardType: TextInputType.number,
            controller: geographicalCoverage,
            decoration: const InputDecoration(
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white)),
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white)),
                hintText: "Geographical Coverage",
                hintStyle:
                TextStyle(color: Color.fromRGBO(255, 255, 255, 0.5))),
          ),
          const SizedBox(
            height: 20,
          ),
          TypeAheadFormField(
            onSuggestionSelected: (suggestion) {
              distributedBy.text = suggestion.toString();
            },
            itemBuilder: (context, suggestion) {
              return ListTile(
                title: Text(suggestion==null ? "" : suggestion.toString(), style: const TextStyle(color: Colors.white),),
                tileColor: Colors.black,
              );
            },
            transitionBuilder: (context, suggestionsBox, controller) {
              return suggestionsBox;
            },
            suggestionsCallback: (pattern) {
              var curList = [];

              for (var e in contacts) {
                if(e.toString().toLowerCase().startsWith(pattern.toLowerCase())){
                  curList.add(e);
                }
              }

              return curList;
            },
            textFieldConfiguration: TextFieldConfiguration(
                cursorColor: Colors.white,
                style: const TextStyle(color: Colors.white),
                keyboardType: TextInputType.text,
                controller: distributedBy,
                decoration: const InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white)),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white)),
                    hintText: "Distributed By",
                    hintStyle: TextStyle(color: Color.fromRGBO(255, 255, 255, 0.5))
                )
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          TypeAheadFormField(
            onSuggestionSelected: (suggestion) {
              keyPersonnel.text = suggestion.toString();
            },
            itemBuilder: (context, suggestion) {
              return ListTile(
                title: Text(suggestion==null ? "" : suggestion.toString(), style: const TextStyle(color: Colors.white),),
                tileColor: Colors.black,
              );
            },
            transitionBuilder: (context, suggestionsBox, controller) {
              return suggestionsBox;
            },
            suggestionsCallback: (pattern) {
              var curList = [];

              for (var e in contacts) {
                if(e.toString().toLowerCase().startsWith(pattern.toLowerCase())){
                  curList.add(e);
                }
              }

              return curList;
            },
            textFieldConfiguration: TextFieldConfiguration(
                cursorColor: Colors.white,
                style: const TextStyle(color: Colors.white),
                keyboardType: TextInputType.text,
                controller: keyPersonnel,
                decoration: const InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white)),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white)),
                    hintText: "Key Personnel",
                    hintStyle: TextStyle(color: Color.fromRGBO(255, 255, 255, 0.5))
                )
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Container(
            padding: EdgeInsets.fromLTRB(100, 0, 100, 0),
            child: ElevatedButton(
              onPressed: () {
                postData();
              },
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
