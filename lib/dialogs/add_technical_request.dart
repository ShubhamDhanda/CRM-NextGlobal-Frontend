import 'package:crm/services/constants.dart';
import 'package:crm/services/remote_services.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:intl/intl.dart';

import 'add_takeoff_dialog.dart';

class AddTechnicalRequestDialog extends StatefulWidget {
  const AddTechnicalRequestDialog({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _AddTechnicalRequestDialogState();
}

const List<String> Status = <String>["Go", "NoGo","Review"];



const List<String> list = <String>[
  'New Project',
  'Modifications',
  'Quote',
  'Negotiation',
  'Closed',
  'Dead'
];


class _AddTechnicalRequestDialogState extends State<AddTechnicalRequestDialog> {

  TextEditingController requestedBy = TextEditingController();
  TextEditingController projectName = TextEditingController();
  TextEditingController requestTo = TextEditingController();
  TextEditingController requestDate = TextEditingController();
  TextEditingController revision = TextEditingController();
  TextEditingController revisionReason = TextEditingController();
  TextEditingController returnBy = TextEditingController();
  TextEditingController designReceived = TextEditingController();


  final snackBar1 = const SnackBar(
    content: Text('Please fill all the Required fields!'),
    backgroundColor: Colors.red,
  );

  final snackBar3 = const SnackBar(
    content: Text('Technical Request Added Successfully'),
    backgroundColor: Colors.green,
  );

  final snackBar4 = const SnackBar(
    content: Text('Something Went Wrong!'),
    backgroundColor: Colors.red,
  );

  var apiClient = RemoteServices();
  List<String> cities = [], departments = [], categories = [];
  Map<String, int> cityMap = {}, departmentMap = {}, employeeMap = {},projectsMap={},companyMap = {};
  Map<String, int> cityIdMap = {}, departmentIdMap = {}, employeeIdMap = {},projectsIdMap={},companyIdMap = {};
  List<String> projects = [];
  bool dataLoaded = false;
  var projectManagerId;
  List<String> provinces = Constants.provinces;
  List<String> countries = Constants.countries;
  var status,bidStatus,Team;
  List<String> employees = <String>[];
  List<String> companies = [];
  var RFPId;
  var ProjectManager;

  @override
  void initState() {
    super.initState();
    _getData();
  }

  void _getData() async {
    setState(() {
      dataLoaded = false;
    });

    dynamic res = await apiClient.getAllEmployeeNames();
    dynamic res1 = await apiClient.getAllDataMining();
    dynamic res2 = await apiClient.getDepartments();

    if (res?["success"] == true&& res1?["success"]==true) {


      for(var e in res["res"]){
        employees.add(e["Full_Name"]);
        employeeMap[e["Full_Name"]] = e["Employee_ID"];

      }
      for(var e in res1["res"]){
        projects.add(e["Project_Name"]);
        projectsMap[e["Project_Name"]] = e["Data_ID"];
      }
      for(var e in res2["res"]){
        departments.add(e["Department"]);
        departmentMap[e["Department"]] = e["Department_ID"];
      }
    }else{
      ScaffoldMessenger.of(context).showSnackBar(snackBar4);
    }

    setState(() {
      dataLoaded = true;
    });

    await Future.delayed(const Duration(seconds: 2));
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
  }


  // void _getBudgetData() async {
  //   try{
  //     setState(() {
  //       dataLoaded = false;
  //     });
  //
  //     dynamic res = await apiClient.getRFPById(RFPId);
  //
  //     department.text = res["res"][0]["Department"];
  //     projectManager.text = res["res"][0]["Manager_Name"];
  //     city.text = res["res"][0]["City"];
  //
  //   } catch(e) {
  //     ScaffoldMessenger.of(context).showSnackBar(snackBar1);
  //   } finally{
  //     setState(() {
  //       dataLoaded = true;
  //     });
  //
  //     await Future.delayed(const Duration(seconds: 2));
  //     ScaffoldMessenger.of(context).hideCurrentSnackBar();
  //   }
  // }

  void postData() async {
    try{
      setState(() {
        dataLoaded = false;
      });

      if (validate() == true) {

        dynamic res = await apiClient.addTechnicalRequest(employeeMap[requestedBy.text], projectsMap[projectName.text],departmentMap[requestTo.text], requestDate.text, revision.text, revisionReason.text,returnBy.text,  designReceived.text);

        if(res?["success"]==true) {
        // if(true){
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
    if(projectName.text=="" || requestedBy.text=="" || requestTo.text==""){
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
        title: const Text("Add Technical Request"),
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
              requestedBy.text = suggestion.toString();
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

              for (var e in employees) {
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
                controller: requestedBy,
                decoration: const InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white)),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white)),
                    hintText: "Requested By*",
                    hintStyle: TextStyle(color: Color.fromRGBO(255, 255, 255, 0.5))
                )
            ),
          ),
          const SizedBox(
            height: 20,
          ),
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
                      const AddTakeoffDialog()).then((value){
                    if(value! == true){
                      _getData();
                    }
                  });
                } else {
                  projectName.text = suggestion.toString();
                  // companyId = companyMap[companyName.text];
                }
              }
              // companyController.text = suggestion==null ? "" : suggestion.toString();
              // companyId = employeeMap[companyController.text];
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
              var curList = ["+ Add New Project"];


              for (var e in projects) {
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
                controller: projectName,
                decoration: const InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white)),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white)),
                    hintText: "Project Name*",
                    hintStyle: TextStyle(color: Color.fromRGBO(255, 255, 255, 0.5))
                )
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          TypeAheadFormField(
            onSuggestionSelected: (suggestion) {
              if(suggestion != null) {
                requestTo.text = suggestion.toString();
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
                controller: requestTo,
                decoration: const InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white)),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white)),
                    hintText: "Request To*",
                    hintStyle: TextStyle(color: Color.fromRGBO(255, 255, 255, 0.5))
                )
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          // TypeAheadFormField(
          //   onSuggestionSelected: (suggestion) {
          //     projectController.text = suggestion==null ? "" : suggestion.toString();
          //     RFPId = projectsMap[projectController.text];
          //     _getBudgetData();
          //   },
          //
          //   itemBuilder: (context, suggestion) {
          //     return ListTile(
          //       title: Text(suggestion==null ? "" : suggestion.toString(), style: const TextStyle(color: Colors.white),),
          //       tileColor: Colors.black,
          //     );
          //   },
          //   transitionBuilder: (context, suggestionsBox, controller) {
          //     return suggestionsBox;
          //   },
          //   suggestionsCallback: (pattern) {
          //     var curList = [];
          //
          //     for (var e in projects) {if(e.toString().toLowerCase().startsWith(pattern.toLowerCase())){
          //       curList.add(e);
          //     }
          //     }
          //
          //     return curList;
          //   },
          //   textFieldConfiguration: TextFieldConfiguration(
          //       cursorColor: Colors.white,
          //       style: const TextStyle(color: Colors.white),
          //       keyboardType: TextInputType.text,
          //       controller: projectController,
          //       decoration: const InputDecoration(
          //           enabledBorder: UnderlineInputBorder(
          //               borderSide: BorderSide(color: Colors.white)),
          //           focusedBorder: UnderlineInputBorder(
          //               borderSide: BorderSide(color: Colors.white)),
          //           hintText: "Project Name*",
          //           hintStyle: TextStyle(color: Color.fromRGBO(255, 255, 255, 0.5))
          //       )
          //   ),
          // ),
          // const SizedBox(height: 20,),





          TextField(
            cursorColor: Colors.white,
            style: const TextStyle(color: Colors.white),
            keyboardType: TextInputType.datetime,
            readOnly: true,
            onTap: () async {
              showDatePicker(
                  context: context,
                  initialDate: requestDate.text == ""
                      ? DateTime.now()
                      : DateTime.parse(requestDate.text),
                  firstDate: DateTime(
                      2000), //DateTime.now() - not to allow to choose before today.
                  lastDate: DateTime(2101),
                  builder: (context, child) {
                    return Theme(
                      data: ThemeData.dark().copyWith(
                        colorScheme: const ColorScheme.dark(
                          onPrimary: Colors.white,
                          surface: Colors.black,
                          onSurface: Colors.white,
                        ),
                        dialogBackgroundColor:
                        const Color.fromRGBO(41, 41, 41, 1),
                      ),
                      child: child!,
                    );
                  }).then((value) {
                setState(() {
                  requestDate.text = value != null
                      ? DateFormat('yyyy-MM-dd').format(value)
                      : requestDate.text;
                });
              });
            },
            controller: requestDate,
            decoration: const InputDecoration(
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white)),
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white)),
                hintText: "Request Date",
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
            controller: revision,
            decoration: const InputDecoration(
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white)),
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white)),
                hintText: "Revision",
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
            controller: revisionReason,
            decoration: const InputDecoration(
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white)),
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white)),
                hintText: "Revision Reason",
                hintStyle:
                TextStyle(color: Color.fromRGBO(255, 255, 255, 0.5))),
          ),
          const SizedBox(
            height: 20,
          ),
          TextField(
            cursorColor: Colors.white,
            style: const TextStyle(color: Colors.white),
            keyboardType: TextInputType.datetime,
            readOnly: true,
            onTap: () async {
              showDatePicker(
                  context: context,
                  initialDate: returnBy.text == ""
                      ? DateTime.now()
                      : DateTime.parse(returnBy.text),
                  firstDate: DateTime(
                      2000), //DateTime.now() - not to allow to choose before today.
                  lastDate: DateTime(2101),
                  builder: (context, child) {
                    return Theme(
                      data: ThemeData.dark().copyWith(
                        colorScheme: const ColorScheme.dark(
                          onPrimary: Colors.white,
                          surface: Colors.black,
                          onSurface: Colors.white,
                        ),
                        dialogBackgroundColor:
                        const Color.fromRGBO(41, 41, 41, 1),
                      ),
                      child: child!,
                    );
                  }).then((value) {
                setState(() {
                  returnBy.text = value != null
                      ? DateFormat('yyyy-MM-dd').format(value)
                      : returnBy.text;
                });
              });
            },
            controller: returnBy,
            decoration: const InputDecoration(
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white)),
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white)),
                hintText: "Return By",
                hintStyle:
                TextStyle(color: Color.fromRGBO(255, 255, 255, 0.5))),
          ),
          const SizedBox(
            height: 20,
          ),
          TextField(
            cursorColor: Colors.white,
            style: const TextStyle(color: Colors.white),
            keyboardType: TextInputType.datetime,
            readOnly: true,
            onTap: () async {
              showDatePicker(
                  context: context,
                  initialDate: designReceived.text == ""
                      ? DateTime.now()
                      : DateTime.parse(designReceived.text),
                  firstDate: DateTime(
                      2000), //DateTime.now() - not to allow to choose before today.
                  lastDate: DateTime(2101),
                  builder: (context, child) {
                    return Theme(
                      data: ThemeData.dark().copyWith(
                        colorScheme: const ColorScheme.dark(
                          onPrimary: Colors.white,
                          surface: Colors.black,
                          onSurface: Colors.white,
                        ),
                        dialogBackgroundColor:
                        const Color.fromRGBO(41, 41, 41, 1),
                      ),
                      child: child!,
                    );
                  }).then((value) {
                setState(() {
                  designReceived.text = value != null
                      ? DateFormat('yyyy-MM-dd').format(value)
                      : designReceived.text;
                });
              });
            },
            controller: designReceived,
            decoration: const InputDecoration(
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white)),
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white)),
                hintText: ""
                    "Design Received",
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