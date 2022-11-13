import 'package:crm/dialogs/add_employee_dialog.dart';
import 'package:crm/dialogs/add_people.dart';
import 'package:crm/services/constants.dart';
import 'package:crm/services/remote_services.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:intl/intl.dart';

class updateProjectDialog extends StatefulWidget{
  final Map<String, dynamic> mp;
  const updateProjectDialog({Key? key, required this.mp}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _updateProjectDialogState(mp: mp);
}

List<String> clients = [];
Map<String, String> empMap = {}, clientMap = {};
Map<String, int> projectManagerMap = {};
var stringList,empId,Team;
var status;
List<Map<String, dynamic>> customers = [];
List<String> departments = ["Storm Water","Traffic","Transportation","Site Plan","Land Development","Proposal","Take-Off","Data Mining","IT","Smart Infra","Marketing"];
List<String> categories = ["Water Main","Road","Highway","Traffic","Site Development","Site Plan","Traffic","Sub Division"];
const List<String> Status = <String>["Not Started Yet", "Ongoing","Completed"];
List<String> Departments = [];
List<Map<String, dynamic>> employees = [];
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


class _updateProjectDialogState extends State<updateProjectDialog>{
  final Map<String, dynamic> mp;
  TextEditingController projectController = TextEditingController();
  TextEditingController dueDate = TextEditingController();
  TextEditingController followUpNotes = TextEditingController();
  TextEditingController nextFollowUp = TextEditingController();
  TextEditingController tentClosing = TextEditingController();
  TextEditingController projectValue = TextEditingController();
  TextEditingController city = TextEditingController();
  TextEditingController province = TextEditingController();
  TextEditingController department = TextEditingController();
  TextEditingController projectManager = TextEditingController();
  TextEditingController teamMembers = TextEditingController();
  TextEditingController projectCategory = TextEditingController();

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
  bool dataLoaded = false;
  var projectStageVal="", dept;
  List<String> cities = Constants.cities;
  List<String> provinces = Constants.provinces;
  List<String> distributors = <String>[];
  List<String> contractors = <String>[];
  List<String> consultants = <String>[];
  List<String> employees = <String>[];
  List<String> prevCat = [];
  List<String> prevDep= [];
  List<String> prevMember = [];

  _updateProjectDialogState({required this.mp}) {
    projectController.text = mp["name"];
    dueDate.text = mp["dateCreated"];
    projectStageVal = mp["stage"]=="" ? "New Project" : mp["stage"];
    followUpNotes.text = mp["followupNotes"];
    nextFollowUp.text = mp["nextFollowup"];
    tentClosing.text = mp["tentClosing"];
    projectValue.text = mp["value"];
    city.text = mp["city"];
    province.text = mp["province"];
    department.text = mp["department"];
    projectManager.text = mp["projectManager"] ?? "";
    teamMembers.text = mp["teamMembers"];
    projectCategory.text = mp["projectCategory"];
    projectCategory.text = mp["projectCategory"];
    print(mp["projectCategory"]);

    if(mp["status"]!=""){
      status = mp["status"];
    }
    prevDep = department.text.split(",");
    print(prevDep);
    prevMember = teamMembers.text.split(",");
    print(prevMember);

  }

  @override
  void initState() {
    super.initState();

    _getData();
  }

  void _getData() async {
    setState(() {
      dataLoaded = false;
    });
    // dynamic res = await apiClient.getAllDistributors();
    // dynamic res2 = await apiClient.getAllConsultants();
    dynamic res3 = await apiClient.getAllEmployeeNames();
    // dynamic res4 = await apiClient.getAllContractors();

    if(res3?["success"] == true ){

      for(var e in res3["res"]){
        employees.add(e["Full_Name"].toString());
      }
      print(employees);
      // for(var e in res4["res"]){
      //   contractors.add(e["Full_Name"].toString());
      // }
    }else{
      ScaffoldMessenger.of(context).showSnackBar(snackBar4);
    }
    setState(() {
      dataLoaded = true;
    });

    await Future.delayed(Duration(seconds: 2));
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
  }

  void postData() async {
    setState(() {
      dataLoaded = false;
    });

    if (validate() == true) {
      dynamic res = await apiClient.updateProject(mp["id"], projectController.text, dueDate.text, projectStageVal.toString(), followUpNotes.text, nextFollowUp.text, tentClosing.text,  projectValue.text,  city.text, province.text, stringList, projectManager.text,  Team, status.toString(),projectCategory.text);

      if(res?["success"]==true) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(snackBar3);
      } else {

        print("NO");
        ScaffoldMessenger.of(context).showSnackBar(snackBar4);
      }

      setState(() {
        dataLoaded = false;
      });

      await Future.delayed(Duration(seconds: 2));
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

  bool validate() {
    if(projectController.text=="" || dueDate.text=="" || projectStageVal.toString() == "" || tentClosing.text == "" || projectValue.text == "" ||stringList == ""|| projectManager.text==""){
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
        title: Text("Update Project"),
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
          TypeAheadFormField(
            onSuggestionSelected: (suggestion) {
              projectCategory.text = suggestion==null ? "" : suggestion.toString();
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

              for (var e in categories) {
                if(e.toString().toLowerCase().startsWith(pattern.toLowerCase())){
                  curListed.add(e);
                }
              }

              return curListed;
            },
            textFieldConfiguration: TextFieldConfiguration(
                cursorColor: Colors.white,
                onChanged: (text){

                },
                style: const TextStyle(color: Colors.white),
                keyboardType: TextInputType.text,
                controller: projectCategory,
                decoration: const InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white)),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white)),
                    hintText: "Project Category*",
                    hintStyle: TextStyle(color: Color.fromRGBO(255, 255, 255, 0.5))
                )
            ),
          ),
          const SizedBox(height: 20,),
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
                hintText: "Due Date*",
                hintStyle:
                TextStyle(color: Color.fromRGBO(255, 255, 255, 0.5))),
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

          TextField(
            cursorColor: Colors.white,
            style: const TextStyle(color: Colors.white),
            keyboardType: TextInputType.number,
            controller: projectValue,
            decoration: const InputDecoration(
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white)),
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white)),
                hintText: "Project Value*",
                hintStyle:
                TextStyle(color: Color.fromRGBO(255, 255, 255, 0.5))),
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
          DropdownSearch<String>.multiSelection(
            items: departments,
            selectedItems: prevDep,
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
              stringList = Departments.join(",");
              print(stringList);
            },
          ),
          const SizedBox(
            height: 20,
          ),
          TypeAheadFormField(
            onSuggestionSelected: (suggestion) {
              projectManager.text = suggestion==null ? "" : suggestion.toString();
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
                onChanged: _onSearchChanged,
                style: const TextStyle(color: Colors.white),
                keyboardType: TextInputType.text,
                controller: projectManager,
                decoration: const InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white)),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white)),
                    hintText: "Project Manager*",
                    hintStyle: TextStyle(color: Color.fromRGBO(255, 255, 255, 0.5))
                )
            ),
          ),
          const SizedBox(height: 20,),

          // TypeAheadFormField(
          //   onSuggestionSelected: (suggestion) {
          //     teamMembers.text = suggestion==null ? "" : suggestion.toString();
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
          //     var curListed = [];
          //
          //     for (var e in employees) {
          //       if(e.toString().toLowerCase().startsWith(pattern.toLowerCase())){
          //         curListed.add(e);
          //       }
          //     }
          //
          //     return curListed;
          //   },
          //   textFieldConfiguration: TextFieldConfiguration(
          //       cursorColor: Colors.white,
          //       onChanged: _onSearchChange2,
          //       style: const TextStyle(color: Colors.white),
          //       keyboardType: TextInputType.text,
          //       controller: teamMembers,
          //       decoration: const InputDecoration(
          //           enabledBorder: UnderlineInputBorder(
          //               borderSide: BorderSide(color: Colors.white)),
          //           focusedBorder: UnderlineInputBorder(
          //               borderSide: BorderSide(color: Colors.white)),
          //           hintText: "Team Member",
          //           hintStyle: TextStyle(color: Color.fromRGBO(255, 255, 255, 0.5))
          //       )
          //   ),
          // ),
          // const SizedBox(height: 20,),

          DropdownSearch<String>.multiSelection(
            items: employees,
            selectedItems: prevMember,
            dropdownButtonProps: const DropdownButtonProps(
                color: Color.fromRGBO(255, 255, 255, 0.5)
            ),
            dropdownDecoratorProps: const DropDownDecoratorProps(
                dropdownSearchDecoration: InputDecoration(

                    enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                    focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                    hintText: "Team Members",
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
              List<String> member=[];
              member = value;
              member.sort((a, b) => a.toString().compareTo(b.toString()));
              Team = member.join(",");
              print(Team);
            },
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
                status = value;
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
          const SizedBox(height: 20,),
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