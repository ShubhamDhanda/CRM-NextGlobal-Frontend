import 'package:crm/dialogs/add_employee_dialog.dart';
import 'package:crm/dialogs/add_people.dart';
import 'package:crm/services/constants.dart';
import 'package:crm/services/remote_services.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:intl/intl.dart';

class AddProjectDialog extends StatefulWidget {
  const AddProjectDialog({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _AddProjectDialogState();
}
List<String> Employees = ["Departments","Clients","Workers"], clients = [];
Map<String, String> empMap = {}, clientMap = {};
Map<String, int> projectManagerMap = {};
var stringList,empId,status;
List<Map<String, dynamic>> customers = [];
List<String> departments = ["Worker","Shipper","IT","Sales","Designer","Modelling"];
const List<String> Status = <String>["Yes","No"];
List<String> Departments = [];
List<Map<String, dynamic>> employees = [];
List<String> projectManagers =["hi"];

List<Map<String, dynamic>> search = [];
List<Map<String, dynamic>> search1 = [];
List<Map<String, dynamic>> filtered = [];
bool dataLoaded = false;
var ProjectManager;


const List<String> list = <String>[
  'New Project',
  'Modifications',
  'Quote',
  'Negotiation',
  'Closed',
  'Dead'
];
const List<String> depts = <String>[
  'Engineer',
  'Manager',
  'Sales',
  'Logistics',
  'Closed',
  'Dead'
];


class _AddProjectDialogState extends State<AddProjectDialog> {
  TextEditingController projectController = TextEditingController();
  TextEditingController dueDate = TextEditingController();
  TextEditingController followUpNotes = TextEditingController();
  TextEditingController nextFollowUp = TextEditingController();
  TextEditingController tentClosing = TextEditingController();
  // TextEditingController empId = TextEditingController();
  TextEditingController productQuantity = TextEditingController();
  TextEditingController productSpecified = TextEditingController();
  TextEditingController projectValue = TextEditingController();
  TextEditingController projectManagerName = TextEditingController();
  // TextEditingController consultant = TextEditingController();
  //consultants here is Project Manager
  TextEditingController city = TextEditingController();
  TextEditingController province = TextEditingController();
  TextEditingController country = TextEditingController(text: "Canada");
  TextEditingController assignedTo = TextEditingController();
  TextEditingController distributor = TextEditingController();
  TextEditingController contractor = TextEditingController();

  final snackBar1 = const SnackBar(
    content: Text('Please fill all the Required fields!'),
    backgroundColor: Colors.red,
  );

  final snackBar3 = const SnackBar(
    content: Text('Project Added Successfully'),
    backgroundColor: Colors.green,
  );

  final snackBar4 = const SnackBar(
    content: Text('Something Went Wrong!'),
    backgroundColor: Colors.red,
  );

  var apiClient = RemoteServices();
  bool loading = false;
  var projectStageVal, dept;
  List<String> cities = Constants.cities;
  List<String> provinces = Constants.provinces;
  List<String> countries = Constants.countries;
  List<String> distributors = <String>[];
  List<String> contractors = <String>[];
  List<String> consultants = <String>[];
  // List<String> employees = <String>[];

  @override
  void initState() {
    super.initState();
    _getData();
    print("HI");
  }

  void _getData() async {
    // dynamic res = await apiClient.getAllDistributors();
    // dynamic res = await apiClient.getAllEmployeeNames();
    // dynamic res2 = await apiClient.getAllConsultants();
    dynamic res = await apiClient.getAllEmployeeNames();
    // dynamic res4 = await apiClient.getAllContractors();
    employees.clear();
    search.clear();
    search1.clear();
    filtered.clear();

    // if(res?["success"] == true && res2?["success"] == true && res3?["success"] == true && res4?["success"]){
    if (res?["success"] == true) {
      for (var i = 0; i < res["res"].length; i++) {
        var e = res["res"][i];

        Map<String, dynamic> mp = {};
        mp["id"] = e["Employee_ID"];
        mp["company"] = e["Company"];
        mp["department"] = e["Department"];
        mp["lastName"] = e["Last_Name"];
        mp["firstName"] = e["First_Name"];
        mp["email"] = e["Email"];
        mp["jobTitle"] = e["Job_Title"];
        mp["joiningDate"] = e["Joining_Date"];
        mp["resignationDate"] = e["Resignation_Date"];
        mp["business"] = e["Business_Phone"];
        mp["home"] = e["Home_Phone"];
        mp["mobile"] = e["Mobile_Phone"];
        mp["fax"] = e["Fax_Number"];
        mp["address"] = e["Address"];
        mp["city"] = e["City"];
        mp["state"] = e["State"];
        mp["zip"] = e["ZIP"];
        mp["country"] = e["Country"];
        mp["webpage"] = e["Web_Page"];
        mp["notes"] = e["Notes"];
        mp["attachments"] = e["Attachments"];
        employees.add(mp);
        var first = mp["email"];
        String second = first;
        print(second);
        projectManagers?.insert(i,second);
      }

      search.addAll(employees);
      search1.addAll(employees);

      print(projectManagers);
      // print(employees);
      filtered.addAll(employees);
    }else{
      ScaffoldMessenger.of(context).showSnackBar(snackBar4);
    }

    await Future.delayed(const Duration(seconds: 2));
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
  }

  void postData() async {
    setState(() {
      loading = true;
    });

    if (validate() == true) {
      dynamic res = await apiClient.addProject(projectController.text, dueDate.text, projectStageVal.toString(), followUpNotes.text, nextFollowUp.text, tentClosing.text, productQuantity.text, productSpecified.text, projectValue.text, ProjectManager.toString(), city.text, province.text, dept.toString(), assignedTo.text, contractor.text, distributor.text);

      if(res?["success"]==true) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(snackBar3);
      }
      else {
        ScaffoldMessenger.of(context).showSnackBar(snackBar4);
      }

      setState(() {
        loading = true;
      });

      await Future.delayed(const Duration(seconds: 2));
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
    }

    setState(() {
      loading = false;
    });

    await Future.delayed(const Duration(seconds: 2));
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
      search.forEach((e) {
        if(e["firstName"].toString().toLowerCase().contains(text.toLowerCase()) || e["lastName"].toString().toLowerCase().contains(text.toLowerCase()) || (e["firstName"] + " " + e["lastName"]).toString().toLowerCase().contains(text.toLowerCase()) || (int.tryParse(text)!=null && e["id"] == int.parse(text))  || e["company"].toString().toLowerCase().contains(text.toLowerCase())){
          search.add(e);
        }
      });
    }

    setState(() {
      dataLoaded = true;
    });
  }

  void _onSearchChange(String text) async {
    setState(() {
      dataLoaded = false;
    });
    search1.clear();

    if(text.isEmpty){
      search1.addAll(filtered);
    }else{
      search1.forEach((e) {
        if(e["firstName"].toString().toLowerCase().contains(text.toLowerCase()) || e["lastName"].toString().toLowerCase().contains(text.toLowerCase()) || (e["firstName"] + " " + e["lastName"]).toString().toLowerCase().contains(text.toLowerCase()) || (int.tryParse(text)!=null && e["id"] == int.parse(text))  || e["company"].toString().toLowerCase().contains(text.toLowerCase())){
          search1.add(e);
        }
      });
    }

    setState(() {
      dataLoaded = true;
    });
  }

  bool validate() {
    if(projectController.text=="" || dueDate.text=="" || projectStageVal.toString() == "" || tentClosing.text == "" || projectValue.text == "" || ProjectManager.toString() == "" || dept.toString() == "" || assignedTo.text == ""){
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
        title: const Text("Add Project"),
        titleTextStyle: const TextStyle(color: Colors.white, fontSize: 24),
        backgroundColor: Colors.black,
      ),
      backgroundColor: const Color.fromRGBO(41, 41, 41, 1),
      body: form(),
    );
  }

  Widget form() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
      child: ListView(
        children: [
          TextField(
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
                hintStyle:
                TextStyle(color: Color.fromRGBO(255, 255, 255, 0.5))),
          ),
          const SizedBox(
            height: 20,
          ),
          // const SizedBox(height: 20,),
          // DropdownSearch<String>.multiSelection(
          //   items: employees,
          //   dropdownButtonProps: const DropdownButtonProps(
          //       color: Color.fromRGBO(255, 255, 255, 0.3)
          //   ),
          //   dropdownDecoratorProps: const DropDownDecoratorProps(
          //       dropdownSearchDecoration: InputDecoration(
          //           enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
          //           focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
          //           hintText: "Employees",
          //           hintStyle: TextStyle(color: Color.fromRGBO(255, 255, 255, 0.5))
          //       )
          //   ),
          //   popupProps: const PopupPropsMultiSelection.dialog(
          //     showSelectedItems: true,
          //     showSearchBox: true,
          //   ),
          //   onChanged: (value) {
          //     // list.clear();
          //     value.forEach((e) {
          //       list.add(empMap[e]!);
          //       empMap.forEach((key, value) {
          //         print(key);
          //         print(value);
          //       });
          //     }
          //     );
          //   },
          // ),
          DropdownSearch<String>.multiSelection(
            items: departments,
            dropdownButtonProps: const DropdownButtonProps(
                color: Color.fromRGBO(255, 255, 255, 0.5)
            ),
            dropdownDecoratorProps: const DropDownDecoratorProps(
                dropdownSearchDecoration: InputDecoration(

                    enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                    focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                    hintText: "Departments",
                    hintStyle: TextStyle(color: Color.fromRGBO(255, 255, 255, 0.5))
                )
            ),
            // dropdownBuilder: (context, distributors) {
            //   return
            // },
            popupProps: const PopupPropsMultiSelection.menu(
                showSelectedItems: true,
                menuProps: MenuProps(
                  backgroundColor: Colors.white,
                )
            ),
            onChanged: (value) {
              Departments = value;
              Departments.sort((a, b) => a.toString().compareTo(b.toString()));
              stringList = Employees.join(",");
              print(stringList);
            },
          ),
          const SizedBox(
            height: 20,
          ),
          TypeAheadFormField(
            onSuggestionSelected: (suggestion) {
              city.text = suggestion==null ? "" : suggestion.toString();
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

              for (var e in cities) {
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
                controller: city,
                decoration: const InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white)),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white)),
                    hintText: "City*",
                    hintStyle: TextStyle(color: Color.fromRGBO(255, 255, 255, 0.5))
                )
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          TypeAheadFormField(
            onSuggestionSelected: (suggestion) {
              province.text = suggestion==null ? "" : suggestion.toString();
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

              for (var e in provinces) {
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
                controller: province,
                decoration: const InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white)),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white)),
                    hintText: "Province",
                    hintStyle: TextStyle(color: Color.fromRGBO(255, 255, 255, 0.5))
                )
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          TypeAheadFormField(
            onSuggestionSelected: (suggestion) {
              country.text = suggestion==null ? "" : suggestion.toString();
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

              for (var e in countries) {
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
                controller: country,
                decoration: const InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white)),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white)),
                    hintText: "Country",
                    hintStyle: TextStyle(color: Color.fromRGBO(255, 255, 255, 0.5))
                )
            ),
          ),
          const SizedBox(
            height: 20,
          ),

          DropdownButton<String>(
            value: projectStageVal,
            isExpanded: true,
            dropdownColor: Colors.black,
            hint: const Text(
              "Project Stage*",
              style: TextStyle(color: Color.fromRGBO(255, 255, 255, 0.5),fontSize: 16.0),
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
                projectStageVal = value!;
              });
            },
            items: list.map<DropdownMenuItem<String>>((String value) {
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
            keyboardType: TextInputType.datetime,
            readOnly: true,
            onTap: () async {
              showDatePicker(
                  context: context,
                  initialDate: dueDate.text == ""
                      ? DateTime.now()
                      : DateTime.parse(dueDate.text),
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
                  dueDate.text = value != null
                      ? DateFormat('yyyy-MM-dd').format(value)
                      : dueDate.text;
                });
              });
            },
            controller: dueDate,
            decoration: const InputDecoration(
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white)),
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white)),
                hintText: "Submission Date*",
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
            controller: followUpNotes,
            decoration: const InputDecoration(
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white)),
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white)),
                hintText: "Follow Up Notes",
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
                  initialDate: nextFollowUp.text == ""
                      ? DateTime.now()
                      : DateTime.parse(nextFollowUp.text),
                  firstDate: DateTime(
                      2000), //DateTime.now() - not to allow to choose before today.
                  lastDate: DateTime(2101),
                  builder: (context, child) {
                    return Theme(
                      data: ThemeData.dark().copyWith(
                        colorScheme: const ColorScheme.dark(
                          // primary: Colors.black,
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
                  nextFollowUp.text = value != null
                      ? DateFormat('yyyy-MM-dd').format(value)
                      : nextFollowUp.text;
                });
              });
            },
            controller: nextFollowUp,
            decoration: const InputDecoration(
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white)),
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white)),
                hintText: "Next Follow Up",
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
                  initialDate: tentClosing.text == ""
                      ? DateTime.now()
                      : DateTime.parse(tentClosing.text),
                  firstDate: DateTime(
                      2000), //DateTime.now() - not to allow to choose before today.
                  lastDate: DateTime(2101),
                  builder: (context, child) {
                    return Theme(
                      data: ThemeData.dark().copyWith(
                        colorScheme: const ColorScheme.dark(
                          // primary: Colors.black,
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
                  tentClosing.text = value != null
                      ? DateFormat('yyyy-MM-dd').format(value)
                      : tentClosing.text;
                });
              });
            },
            controller: tentClosing,
            decoration: const InputDecoration(
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white)),
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white)),
                hintText: "Tentative Closing Date*",
                hintStyle:
                TextStyle(color: Color.fromRGBO(255, 255, 255, 0.5))),
          ),
          const SizedBox(
            height: 20,
          ),
          // TextField(
          //   cursorColor: Colors.white,
          //   style: const TextStyle(color: Colors.white),
          //   keyboardType: TextInputType.number,
          //   controller: productQuantity,
          //   decoration: const InputDecoration(
          //       enabledBorder: UnderlineInputBorder(
          //           borderSide: BorderSide(color: Colors.white)),
          //       focusedBorder: UnderlineInputBorder(
          //           borderSide: BorderSide(color: Colors.white)),
          //       hintText: "Product Quantity",
          //       hintStyle:
          //           TextStyle(color: Color.fromRGBO(255, 255, 255, 0.5))),
          // ),
          // const SizedBox(
          //   height: 20,
          // ),
          // TextField(
          //   cursorColor: Colors.white,
          //   style: const TextStyle(color: Colors.white),
          //   keyboardType: TextInputType.number,
          //   controller: productSpecified,
          //   decoration: const InputDecoration(
          //       enabledBorder: UnderlineInputBorder(
          //           borderSide: BorderSide(color: Colors.white)),
          //       focusedBorder: UnderlineInputBorder(
          //           borderSide: BorderSide(color: Colors.white)),
          //       hintText: "Product Specified",
          //       hintStyle:
          //           TextStyle(color: Color.fromRGBO(255, 255, 255, 0.5))),
          // ),
          // const SizedBox(
          //   height: 20,
          // ),
          // TextField(
          //   cursorColor: Colors.white,
          //   style: const TextStyle(color: Colors.white),
          //   keyboardType: TextInputType.number,
          //   controller: projectValue,
          //   decoration: const InputDecoration(
          //       enabledBorder: UnderlineInputBorder(
          //           borderSide: BorderSide(color: Colors.white)),
          //       focusedBorder: UnderlineInputBorder(
          //           borderSide: BorderSide(color: Colors.white)),
          //       hintText: "Project Value*",
          //       hintStyle:
          //           TextStyle(color: Color.fromRGBO(255, 255, 255, 0.5))),
          // ),
          // const SizedBox(
          //   height: 20,
          // ),
          // TypeAheadFormField(
          //   onSuggestionSelected: (suggestion) {
          //     city.text = suggestion==null ? "" : suggestion.toString();
          //   },
          //     itemBuilder: (context, suggestion) {
          //       return ListTile(
          //         title: Text(suggestion==null ? "" : suggestion.toString(), style: const TextStyle(color: Colors.white),),
          //         tileColor: Colors.black,
          //       );
          //     },
          //   transitionBuilder: (context, suggestionsBox, controller) {
          //     return suggestionsBox;
          //   },
          //     suggestionsCallback: (pattern) {
          //       var curList = [];
          //
          //       for (var e in cities) {
          //         if(e.toString().toLowerCase().startsWith(pattern.toLowerCase())){
          //           curList.add(e);
          //         }
          //       }
          //
          //       return curList;
          //     },
          //   textFieldConfiguration: TextFieldConfiguration(
          //       cursorColor: Colors.white,
          //       style: const TextStyle(color: Colors.white),
          //       keyboardType: TextInputType.text,
          //       controller: city,
          //       decoration: const InputDecoration(
          //           enabledBorder: UnderlineInputBorder(
          //               borderSide: BorderSide(color: Colors.white)),
          //           focusedBorder: UnderlineInputBorder(
          //               borderSide: BorderSide(color: Colors.white)),
          //           hintText: "City",
          //           hintStyle: TextStyle(color: Color.fromRGBO(255, 255, 255, 0.5))
          //       )
          //   ),
          // ),
          // const SizedBox(
          //   height: 20,
          // ),
          // TypeAheadFormField(
          //   onSuggestionSelected: (suggestion) {
          //     province.text = suggestion==null ? "" : suggestion.toString();
          //   },
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
          //     for (var e in provinces) {
          //       if(e.toString().toLowerCase().startsWith(pattern.toLowerCase())){
          //         curList.add(e);
          //       }
          //     }
          //
          //     return curList;
          //   },
          //   textFieldConfiguration: TextFieldConfiguration(
          //       cursorColor: Colors.white,
          //       style: const TextStyle(color: Colors.white),
          //       keyboardType: TextInputType.text,
          //       controller: province,
          //       decoration: const InputDecoration(
          //           enabledBorder: UnderlineInputBorder(
          //               borderSide: BorderSide(color: Colors.white)),
          //           focusedBorder: UnderlineInputBorder(
          //               borderSide: BorderSide(color: Colors.white)),
          //           hintText: "Province",
          //           hintStyle: TextStyle(color: Color.fromRGBO(255, 255, 255, 0.5))
          //       )
          //   ),
          // ),
          // const SizedBox(
          //   height: 20,
          // ),
          DropdownButton<String>(
            value: dept,
            isExpanded: true,
            dropdownColor: Colors.black,
            hint: const Text(
              "Department*",
              style: TextStyle(color: Color.fromRGBO(255, 255, 255, 0.5), fontSize: 16.0),
            ),
            style: const TextStyle(color: Colors.white),
            underline: Container(
              height: 1,
              color: Colors.white,
            ),
            onChanged: (String? value) {
              setState(() {
                dept = value!;
              });
            },
            items: depts.map<DropdownMenuItem<String>>((String value) {
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
          // TypeAheadFormField(
          //   onSuggestionSelected: (suggestion) {
          //     if(suggestion?.toString() == "+ Add Employee"){
          //       Navigator.pop(context);
          //       showGeneralDialog(
          //           context: context,
          //           barrierDismissible: false,
          //           transitionDuration: const Duration(milliseconds: 500),
          //           transitionBuilder: (context, animation, secondaryAnimation, child) {
          //             const begin = Offset(0.0, 1.0);
          //             const end = Offset.zero;
          //             const curve = Curves.ease;
          //
          //             var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          //
          //             return SlideTransition(
          //               position: animation.drive(tween),
          //               child: child,
          //             );
          //           },
          //           pageBuilder: (context, animation, secondaryAnimation) => const AddEmployeeDialog());
          //       return;
          //     }
          //     assignedTo.text = suggestion==null ? "" : suggestion.toString();
          //   },
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
          //     var curList = ["+ Add Employee"];
          //
          //     for (var e in employees) {
          //       if(e.toString().toLowerCase().startsWith(pattern.toLowerCase())){
          //         // curList.add(e);
          //       }
          //     }
          //
          //     return curList;
          //   },
          //   textFieldConfiguration: TextFieldConfiguration(
          //       cursorColor: Colors.white,
          //       style: const TextStyle(color: Colors.white),
          //       keyboardType: TextInputType.text,
          //       controller: assignedTo,
          //       decoration: const InputDecoration(
          //           enabledBorder: UnderlineInputBorder(
          //               borderSide: BorderSide(color: Colors.white)),
          //           focusedBorder: UnderlineInputBorder(
          //               borderSide: BorderSide(color: Colors.white)),
          //           hintText: "Assigned To*",
          //           hintStyle: TextStyle(color: Color.fromRGBO(255, 255, 255, 0.5))
          //       )
          //   ),
          // ),
          // const SizedBox(
          //   height: 20,
          // ),
          TypeAheadFormField(
            onSuggestionSelected: (suggestion) {
              projectController.text = suggestion==null ? "" : suggestion.toString();
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

              for (var e in projectManagers) {
                if(e.toString().toLowerCase().startsWith(pattern.toLowerCase())){
                  curList.add(e);
                }
              }

              return curList;
            },
            textFieldConfiguration: TextFieldConfiguration(
                cursorColor: Colors.white,
                onChanged: _onSearchChanged,
                style: const TextStyle(color: Colors.white),
                keyboardType: TextInputType.text,
                controller: projectController,
                decoration: const InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white)),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white)),
                    hintText: "Project Manager",
                    hintStyle: TextStyle(color: Color.fromRGBO(255, 255, 255, 0.5))
                )
            ),
          ),
          const SizedBox(height: 20,),

          TypeAheadFormField(
            onSuggestionSelected: (suggestion) {
              projectController.text = suggestion==null ? "" : suggestion.toString();
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
              var curListed = [];

              for (var e in projectManagers) {
                if(e.toString().toLowerCase().startsWith(pattern.toLowerCase())){
                  curListed.add(e);
                }
              }

              return curListed;
            },
            textFieldConfiguration: TextFieldConfiguration(
                cursorColor: Colors.white,
                onChanged: _onSearchChange,
                style: const TextStyle(color: Colors.white),
                keyboardType: TextInputType.text,
                controller: projectController,
                decoration: const InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white)),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white)),
                    hintText: "Team Member",
                    hintStyle: TextStyle(color: Color.fromRGBO(255, 255, 255, 0.5))
                )
            ),
          ),
          const SizedBox(height: 20,),
          TypeAheadFormField(
            onSuggestionSelected: (suggestion) {
              if(suggestion?.toString() == "+ Add Distributor"){
                Navigator.pop(context);
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
                    pageBuilder: (context, animation, secondaryAnimation) => const AddPeopleDialog());
                return;
              }
              distributor.text = suggestion==null ? "" : suggestion.toString();
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
              var curList = ["+ Add Distributor"];

              for (var e in distributors) {
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
                controller: distributor,
                decoration: const InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white)),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white)),
                    hintText: "Distributor",
                    hintStyle: TextStyle(color: Color.fromRGBO(255, 255, 255, 0.5))
                )
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          TypeAheadFormField(
            onSuggestionSelected: (suggestion) {
              if(suggestion?.toString() == "+ Add Contractor"){
                Navigator.pop(context);
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
                    pageBuilder: (context, animation, secondaryAnimation) => const AddPeopleDialog());
                return;
              }
              contractor.text = suggestion==null ? "" : suggestion.toString();
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
              var curList = ["+ Add Contractor"];

              for (var e in contractors) {
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
                controller: contractor,
                decoration: const InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white)),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white)),
                    hintText: "Contractor",
                    hintStyle: TextStyle(color: Color.fromRGBO(255, 255, 255, 0.5))
                )
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          DropdownButton<String>(
            value: status,
            isExpanded: true,
            dropdownColor: Colors.black,
            hint: const Text(
              "Status*",
              style: TextStyle(color: Color.fromRGBO(255, 255, 255, 0.5)),
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