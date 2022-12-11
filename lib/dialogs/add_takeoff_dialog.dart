import 'package:crm/dialogs/add_jobtitle_dialog.dart';
import 'package:crm/services/constants.dart';
import 'package:crm/services/remote_services.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:intl/intl.dart';

class AddTakeoffDialog extends StatefulWidget {
  const AddTakeoffDialog({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _AddTakeoffDialogState();
}

const List<String> depts = <String>[
  'Admin',
  'Engineer',
  'Manager',
  'Sales',
  'Logistics',
  'Supplier',
  'IT'
];
const List<String> sals = ["Mr.", "Mrs.", "Ms", "None"],
    sports = [
      "Soccer",
      "Hockey",
      "Basketball",
      "Baseball",
      "Boxing",
      "MMA",
      "Others"
    ],
    activities = ["Running", "Walking", "Travelling"],
    beverages = ["Coffee", "Tea", "Ice Cap"],
    alcohols = ["Vodka", "Scotch", "Beer", "Tequila", "Rum", "Cocktail"],
projectManagers = [];

class _AddTakeoffDialogState extends State {

  List<TextEditingController>? _controllers = [];
  TextEditingController teamMember = TextEditingController();
  TextEditingController projectManager = TextEditingController();
  List <String> salutation = ["Mr.", "Mr.", "Mr.", "Mr.", "Mr.", "Mr."];
  TextEditingController firstName = TextEditingController();
  TextEditingController lastName = TextEditingController();
  TextEditingController jobTitle = TextEditingController();
  var jobTitleId;
  var department;
  TextEditingController directManager = TextEditingController();
  var directManagerID;
  TextEditingController emailWork = TextEditingController();
  TextEditingController emailPersonal = TextEditingController();
  TextEditingController businessPhone = TextEditingController();
  TextEditingController mobilePhone = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController city = TextEditingController();
  TextEditingController state = TextEditingController();
  TextEditingController zip = TextEditingController();
  TextEditingController country = TextEditingController(text: "Canada");
  TextEditingController joiningDate = TextEditingController();
  TextEditingController expertise = TextEditingController();
  TextEditingController resume = TextEditingController();
  TextEditingController webpage = TextEditingController();
  TextEditingController notes = TextEditingController();
  TextEditingController attachment = TextEditingController();
  TextEditingController softwarePrivilege = TextEditingController();

  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();

  TextEditingController birthday = TextEditingController();
  TextEditingController anniversary = TextEditingController();
  var sport, activity, beverage, alcohol;
  TextEditingController travel = TextEditingController();
  TextEditingController spouse = TextEditingController();
  TextEditingController children = TextEditingController();
  TextEditingController tv = TextEditingController();
  TextEditingController movie = TextEditingController();
  TextEditingController actor = TextEditingController();
  TextEditingController dislikes = TextEditingController();

  TextEditingController proficiency = TextEditingController();
  TextEditingController interest = TextEditingController();
  TextEditingController cocurricular = TextEditingController();
  TextEditingController trainings = TextEditingController();

  TextEditingController strengths = TextEditingController();
  TextEditingController weaknesses = TextEditingController();
  TextEditingController socialActiveIndex = TextEditingController();

  final snackBar1 = const SnackBar(
    content: Text('Please fill all the Required fields!'),
    backgroundColor: Colors.red,
  );

  final snackBar2 = const SnackBar(
    content: Text('Passwords don\'t match'),
    backgroundColor: Colors.red,
  );

  final snackBar3 = const SnackBar(
    content: Text('Employee Added Successfully'),
    backgroundColor: Colors.green,
  );

  final snackBar4 = const SnackBar(
    content: Text('Something Went Wrong!'),
    backgroundColor: Colors.red,
  );

  final snackBar5 = const SnackBar(
    content: Text('Username Already exists!'),
    backgroundColor: Colors.red,
  );

  var apiClient = RemoteServices();
  bool loading = false;
  int currentStep = 0;
  List<String> countries = Constants.countries,
      jobTitles = [],
      directManagers = [],
      products = ["HII", "Shubham", "Dhanda", "Jatt"],
      selectedProducts = [];
  Map<String, int> jobTitleMap = {},
      directManagerMap = {};

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

      // dynamic res = await apiClient.getAllEmployeeNames();
      // dynamic res4 = await apiClient.getAllCompanyNames();
      //
      // for (var e in res["res"]) {
      //   directManagers.add(e["Full_Name"]);
      //   directManagerMap[e["Full_Name"]] = e["Employee_ID"];
      // }
      // for (var e in res4["res"]) {
      //   products.add(e["Name"]);
      //   // companyMap[e["Name"]] = e["ID"];
      //   // companyIdMap[e["ID"]] = e["Name"];
      // }
    } catch (err) {
      print(err);
      ScaffoldMessenger.of(context).showSnackBar(snackBar4);
    } finally {
      setState(() {
        loading = false;
      });

      await Future.delayed(const Duration(seconds: 2));
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
    }
  }

  void getJobTitles() async {
    try {
      setState(() {
        loading = true;
      });

      dynamic res = await apiClient.getAllJobTitles(department.toString());

      jobTitles.clear();
      jobTitleMap.clear();

      for (var e in res["res"]) {
        jobTitles.add(e["Title"]);
        jobTitleMap[e["Title"]] = e["Title_ID"];
      }
    } catch (err) {
      print(err);
      ScaffoldMessenger.of(context).showSnackBar(snackBar4);
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
        // dynamic res = await apiClient.addEmployee();

        // if (res["success"] == true) {
        if (true) {
          Navigator.pop(context, true);
          ScaffoldMessenger.of(context).showSnackBar(snackBar3);
          // } else if (res['code'] == 409) {
        } else {
          ScaffoldMessenger.of(context).showSnackBar(snackBar5);
        }
      }
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(snackBar4);
    } finally {
      setState(() {
        loading = false;
      });

      await Future.delayed(const Duration(seconds: 2));
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
    }
  }

  bool validate() {
    if (firstName.text == "" || department.toString() == "" ||
        password.text == "" || confirmPassword.text == "" ||
        jobTitle.text == "" || emailWork.text == "" ||
        directManager.text == "" || businessPhone.text == "" ||
        city.text == "") {
      ScaffoldMessenger.of(context).showSnackBar(snackBar1);
      return false;
    }
    if (password.text != confirmPassword.text) {
      ScaffoldMessenger.of(context).showSnackBar(snackBar2);
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
            onTap: () => Navigator.pop(context, false),
          ),
          title: const Text("Add TakeOff"),
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
          visible: !loading,
          child: Container(
              padding: const EdgeInsets.all(20),
              child: Theme(
                  data: ThemeData.dark().copyWith(
                      primaryColor: const Color.fromRGBO(134, 97, 255, 1),
                      colorScheme: const ColorScheme.light().copyWith(
                        primary: const Color.fromRGBO(134, 97, 255, 1),
                      )),
                  child: Stepper(
                    type: StepperType.horizontal,
                    currentStep: currentStep,
                    steps: getSteps(),
                    controlsBuilder: (BuildContext context, _) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          ElevatedButton(
                            onPressed: currentStep == 0 ? null : () {
                              currentStep == 0
                                  ? null
                                  : setState(() {
                                currentStep -= 1;
                              });
                            },
                            style: ElevatedButton.styleFrom(
                                primary: const Color.fromRGBO(134, 97, 255, 1)),
                            child: const Text(
                              "Back",
                              style:
                              TextStyle(color: Colors.white, fontSize: 16),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              bool isLastStep =
                              (currentStep == getSteps().length - 1);
                              if (isLastStep) {
                                postData();
                              } else {
                                setState(() {
                                  currentStep += 1;
                                });
                              }
                            },
                            style: ElevatedButton.styleFrom(
                                primary: const Color.fromRGBO(134, 97, 255, 1)),
                            child: currentStep == 1 ?
                            const Text(
                              "Submit",
                              style:
                              TextStyle(color: Colors.white, fontSize: 16),
                            )
                                : const Text(
                              "Next",
                              style:
                              TextStyle(color: Colors.white, fontSize: 16),
                            ),
                          ),
                        ],
                      );
                    },
                  ))),
        ));
  }

  List<Step> getSteps() {
    return <Step>[
      Step(
          state: currentStep > 0 ? StepState.complete : StepState.indexed,
          isActive: currentStep >= 0,
          title: const Text(""),
          content: form()),
      Step(
          state: currentStep > 1 ? StepState.complete : StepState.indexed,
          isActive: currentStep >= 1,
          title: const Text(""),
          content: step2()),
    ];
  }

  Widget form() {
    return Column(
      children: [
        const Center(
          child: Text(
            "Product Name",
            style: TextStyle(
                color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        DropdownSearch<String>.multiSelection(
          items: products,
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
                backgroundColor: Colors.black,
              )
          ),
          onChanged: (value) {
            selectedProducts = value;
            selectedProducts.sort((a, b) => a.toString().compareTo(b.toString()));
            teamMember.text = selectedProducts.join(",");
            print(teamMember.text);
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

            for (var e in projectManagers) {
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
              controller: projectManager,
              decoration: const InputDecoration(
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white)),
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white)),
                  hintText: "Action*",
                  hintStyle: TextStyle(color: Color.fromRGBO(255, 255, 255, 0.5))
              )
          ),
        ),
        const SizedBox(height: 20,), TypeAheadFormField(
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

            for (var e in projectManagers) {
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
              controller: projectManager,
              decoration: const InputDecoration(
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white)),
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white)),
                  hintText: "Sales Person",
                  hintStyle: TextStyle(color: Color.fromRGBO(255, 255, 255, 0.5))
              )
          ),
        ),
        const SizedBox(height: 20,), TypeAheadFormField(
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

            for (var e in projectManagers) {
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
              controller: projectManager,
              decoration: const InputDecoration(
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white)),
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white)),
                  hintText: "Manager",
                  hintStyle: TextStyle(color: Color.fromRGBO(255, 255, 255, 0.5))
              )
          ),
        ),
        const SizedBox(height: 20,), TypeAheadFormField(
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

            for (var e in projectManagers) {
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
              controller: projectManager,
              decoration: const InputDecoration(
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white)),
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white)),
                  hintText: "General Contractor*",
                  hintStyle: TextStyle(color: Color.fromRGBO(255, 255, 255, 0.5))
              )
          ),
        ),
        const SizedBox(height: 20,), TypeAheadFormField(
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

            for (var e in projectManagers) {
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
              controller: projectManager,
              decoration: const InputDecoration(
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white)),
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white)),
                  hintText: "Contractor*",
                  hintStyle: TextStyle(color: Color.fromRGBO(255, 255, 255, 0.5))
              )
          ),
        ),
        const SizedBox(height: 20,), TypeAheadFormField(
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

            for (var e in projectManagers) {
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
              controller: projectManager,
              decoration: const InputDecoration(
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white)),
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white)),
                  hintText: "Project Source",
                  hintStyle: TextStyle(color: Color.fromRGBO(255, 255, 255, 0.5))
              )
          ),
        ),
        const SizedBox(height: 20,),
        TextField(
          cursorColor: Colors.white,
          style: const TextStyle(color: Colors.white),
          keyboardType: TextInputType.text,
          controller: projectManager,
          decoration: const InputDecoration(
              enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white)),
              focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white)),
              hintText: "Project Name*",
              hintStyle:
              TextStyle(color: Color.fromRGBO(255, 255, 255, 0.5))),
        ),



      ],
    );
  }













  Widget step2() {
    return (
        ListView.builder(
          shrinkWrap: true,
          itemBuilder: (buider, index) {
            _controllers!.add(TextEditingController());
            return Column(
              children: [
                const Center(
                  child: Text(
                    "Product Name",
                    style: TextStyle(color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextField(
                  cursorColor: Colors.white,
                  style: const TextStyle(color: Colors.white),
                  keyboardType: TextInputType.text,
                  controller: _controllers![index],
                  decoration: const InputDecoration(
                      enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                      focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                      hintText: "First Name*",
                      hintStyle: TextStyle(color: Color.fromRGBO(255, 255, 255, 0.5))
                  ),
                ),
                const SizedBox(height: 20,),
                DropdownButton<String>(
                  value: salutation[index],
                  isExpanded: true,
                  dropdownColor: Colors.black,
                  hint: const Text(
                    "Salutation*",
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
                      salutation[index]= value!;
                    });
                  },
                  items: sals.map<DropdownMenuItem<String>>((String value) {
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
              ],
            );
          },
          itemCount: selectedProducts!.length,
        )
    );
  }
}

