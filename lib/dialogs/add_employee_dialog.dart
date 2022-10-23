import 'package:crm/dialogs/add_jobtitle_dialog.dart';
import 'package:crm/services/constants.dart';
import 'package:crm/services/remote_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:intl/intl.dart';

class AddEmployeeDialog extends StatefulWidget {
  const AddEmployeeDialog({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _AddPeopleDialogState();
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
    alcohols = ["Vodka", "Scotch", "Beer", "Tequila", "Rum", "Cocktail"];

class _AddPeopleDialogState extends State {
  var salutation = "None";
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
  TextEditingController webpage= TextEditingController();
  TextEditingController notes= TextEditingController();
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
  List<String> countries = Constants.countries, jobTitles = [], directManagers = [];
  Map<String, int> jobTitleMap = {}, directManagerMap = {};

  @override
  void initState() {
    super.initState();

    _getData();
  }

  void _getData() async {
    try{
      setState(() {
        loading = true;
      });

      dynamic res = await apiClient.getAllEmployeeNames();

      for (var e in res["res"]) {
        directManagers.add(e["Full_Name"]);
        directManagerMap[e["Full_Name"]] = e["Employee_ID"];
      }
    } catch(err) {
      print(err);
      ScaffoldMessenger.of(context).showSnackBar(snackBar4);
    } finally{
      setState(() {
        loading = false;
      });

      await Future.delayed(const Duration(seconds: 2));
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
    }
  }

  void getJobTitles() async {
    try{
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
    } catch(err) {
      print(err);
      ScaffoldMessenger.of(context).showSnackBar(snackBar4);
    } finally{
      setState(() {
        loading = false;
      });

      await Future.delayed(const Duration(seconds: 2));
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
    }
  }

  void postData() async {
    try{
      setState(() {
        loading = true;
      });

      if(validate()==true){
        dynamic res = await apiClient.addEmployee(department.toString(), salutation.toString(), firstName.text, lastName.text, emailWork.text, emailPersonal.text, directManagerID.toString(), username.text, password.text, jobTitleId.toString(), joiningDate.text, businessPhone.text, mobilePhone.text, address.text, city.text, state.text, zip.text, country.text, expertise.text, resume.text, softwarePrivilege.text, webpage.text, notes.text, attachment.text, proficiency.text, interest.text, cocurricular.text, trainings.text, birthday.text, anniversary.text, sport ?? "", activity ?? "", beverage ?? "", alcohol ?? "", travel.text, spouse.text, children.text, tv.text, movie.text, actor.text, dislikes.text, strengths.text, weaknesses.text, socialActiveIndex.text);

        if(res["success"]==true) {
          Navigator.pop(context, true);
          ScaffoldMessenger.of(context).showSnackBar(snackBar3);
        } else if(res['code'] == 409) {
          ScaffoldMessenger.of(context).showSnackBar(snackBar5);
        }
      }
    } catch(e) {
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
    if(firstName.text=="" || department.toString()=="" || password.text=="" || confirmPassword.text=="" || jobTitle.text=="" || emailWork.text == "" || directManager.text=="" || businessPhone.text == "" || city.text == ""){
      ScaffoldMessenger.of(context).showSnackBar(snackBar1);
      return false;
    }
    if(password.text!=confirmPassword.text){
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
          title: const Text("New Employee"),
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
                            onPressed: currentStep==0 ? null : () {
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
                            child: currentStep==4 ?
                            const Text(
                              "Submit",
                              style:
                              TextStyle(color: Colors.white, fontSize: 16),
                            )
                                :const Text(
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
          content: personal()),
      Step(
          state: currentStep > 2 ? StepState.complete : StepState.indexed,
          isActive: currentStep >= 2,
          title: const Text(""),
          content: skills()),
      Step(
          state: currentStep > 3 ? StepState.complete : StepState.indexed,
          isActive: currentStep >= 3,
          title: const Text(""),
          content: traits()),
      Step(
          state: currentStep > 4 ? StepState.complete : StepState.indexed,
          isActive: currentStep >= 4,
          title: const Text(""),
          content: auth()),
    ];
  }

  Widget form() {
    return Column(
      children: [
        const Center(
          child: Text(
            "Main Info",
            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        DropdownButton<String>(
          value: salutation,
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
              salutation = value!;
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
        TextField(
          cursorColor: Colors.white,
          style: const TextStyle(color: Colors.white),
          keyboardType: TextInputType.text,
          controller: firstName,
          decoration: const InputDecoration(
              enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
              focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
              hintText: "First Name*",
              hintStyle: TextStyle(color: Color.fromRGBO(255, 255, 255, 0.5))
          ),
        ),
        const SizedBox(height: 20,),
        TextField(
          cursorColor: Colors.white,
          style: const TextStyle(color: Colors.white),
          keyboardType: TextInputType.text,
          controller: lastName,
          decoration: const InputDecoration(
              enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
              focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
              hintText: "Last Name*",
              hintStyle: TextStyle(color: Color.fromRGBO(255, 255, 255, 0.5))
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        DropdownButton<String>(
          value: department,
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
              department = value!;
            });
            getJobTitles();
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
        const SizedBox(height: 20,),
        TypeAheadFormField(
          onSuggestionSelected: (suggestion) {
            if (suggestion != null) {
              if (suggestion.toString() == "+ Add Job Title") {
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
                    const AddJobTitleDialog()).then((value){
                  if(value! == true){
                    getJobTitles();
                  }
                });
              } else {
                jobTitle.text = suggestion.toString();
                jobTitleId = jobTitleMap[jobTitle.text];
              }
            }
          },
          itemBuilder: (context, suggestion) {
            return ListTile(
              title: Text(
                suggestion == null ? "" : suggestion.toString(),
                style: const TextStyle(color: Colors.white),
              ),
              tileColor: Colors.black,
            );
          },
          transitionBuilder: (context, suggestionsBox, controller) {
            return suggestionsBox;
          },
          suggestionsCallback: (pattern) {
            var curList = ["+ Add Job Title"];

            for (var e in jobTitles) {
              if (e
                  .toString()
                  .toLowerCase()
                  .startsWith(pattern.toLowerCase())) {
                curList.add(e);
              }
            }

            return curList;
          },
          textFieldConfiguration: TextFieldConfiguration(
              cursorColor: Colors.white,
              style: const TextStyle(color: Colors.white),
              keyboardType: TextInputType.text,
              controller: jobTitle,
              decoration: const InputDecoration(
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white)),
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white)),
                  hintText: "Job Title*",
                  hintStyle:
                  TextStyle(color: Color.fromRGBO(255, 255, 255, 0.5)))),
        ),
        const SizedBox(height: 20,),
        TypeAheadFormField(
          onSuggestionSelected: (suggestion) {
            if (suggestion != null) {
                directManager.text = suggestion.toString();
                directManagerID = directManagerMap[directManager.text];
            }
          },
          itemBuilder: (context, suggestion) {
            return ListTile(
              title: Text(
                suggestion == null ? "" : suggestion.toString(),
                style: const TextStyle(color: Colors.white),
              ),
              tileColor: Colors.black,
            );
          },
          transitionBuilder: (context, suggestionsBox, controller) {
            return suggestionsBox;
          },
          suggestionsCallback: (pattern) {
            var curList = [];

            for (var e in directManagers) {
              if (e
                  .toString()
                  .toLowerCase()
                  .startsWith(pattern.toLowerCase())) {
                curList.add(e);
              }
            }

            return curList;
          },
          textFieldConfiguration: TextFieldConfiguration(
              cursorColor: Colors.white,
              style: const TextStyle(color: Colors.white),
              keyboardType: TextInputType.text,
              controller: directManager,
              decoration: const InputDecoration(
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white)),
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white)),
                  hintText: "Direct Manager*",
                  hintStyle:
                  TextStyle(color: Color.fromRGBO(255, 255, 255, 0.5)))),
        ),
        const SizedBox(height: 20,),
        TextField(
          cursorColor: Colors.white,
          style: const TextStyle(color: Colors.white),
          keyboardType: TextInputType.emailAddress,
          controller: emailWork,
          decoration: const InputDecoration(
              enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
              focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
              hintText: "Email Work*",
              hintStyle: TextStyle(color: Color.fromRGBO(255, 255, 255, 0.5))
          ),
        ),
        const SizedBox(height: 20,),
        TextField(
          cursorColor: Colors.white,
          style: const TextStyle(color: Colors.white),
          keyboardType: TextInputType.emailAddress,
          controller: emailPersonal,
          decoration: const InputDecoration(
              enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
              focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
              hintText: "Email Personal",
              hintStyle: TextStyle(color: Color.fromRGBO(255, 255, 255, 0.5))
          ),
        ),
        const SizedBox(height: 20,),
        TextField(
          cursorColor: Colors.white,
          style: const TextStyle(color: Colors.white),
          keyboardType: TextInputType.number,
          controller: businessPhone,
          decoration: const InputDecoration(
              enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
              focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
              hintText: "Business Phone*",
              hintStyle: TextStyle(color: Color.fromRGBO(255, 255, 255, 0.5))
          ),
        ),
        const SizedBox(height: 20,),
        TextField(
          cursorColor: Colors.white,
          style: const TextStyle(color: Colors.white),
          keyboardType: TextInputType.number,
          controller: mobilePhone,
          decoration: const InputDecoration(
              enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
              focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
              hintText: "Mobile Phone",
              hintStyle: TextStyle(color: Color.fromRGBO(255, 255, 255, 0.5))
          ),
        ),
        const SizedBox(height: 20,),
        TextField(
          cursorColor: Colors.white,
          style: const TextStyle(color: Colors.white),
          keyboardType: TextInputType.text,
          controller: address,
          decoration: const InputDecoration(
              enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
              focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
              hintText: "Address",
              hintStyle: TextStyle(color: Color.fromRGBO(255, 255, 255, 0.5))
          ),
        ),
        const SizedBox(height: 20,),
        TextField(
          cursorColor: Colors.white,
          style: const TextStyle(color: Colors.white),
          keyboardType: TextInputType.text,
          controller: city,
          decoration: const InputDecoration(
              enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
              focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
              hintText: "City*",
              hintStyle: TextStyle(color: Color.fromRGBO(255, 255, 255, 0.5))
          ),
        ),
        const SizedBox(height: 20,),
        TextField(
          cursorColor: Colors.white,
          style: const TextStyle(color: Colors.white),
          keyboardType: TextInputType.text,
          controller: state,
          decoration: const InputDecoration(
              enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
              focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
              hintText: "State",
              hintStyle: TextStyle(color: Color.fromRGBO(255, 255, 255, 0.5))
          ),
        ),
        const SizedBox(height: 20,),
        TextField(
          cursorColor: Colors.white,
          style: const TextStyle(color: Colors.white),
          keyboardType: TextInputType.number,
          controller: zip,
          decoration: const InputDecoration(
              enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
              focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
              hintText: "ZIP/Postal Code",
              hintStyle: TextStyle(color: Color.fromRGBO(255, 255, 255, 0.5))
          ),
        ),
        const SizedBox(height: 20,),
        TypeAheadFormField(
          onSuggestionSelected: (suggestion) {
            country.text = suggestion == null ? "" : suggestion.toString();
          },
          itemBuilder: (context, suggestion) {
            return ListTile(
              title: Text(
                suggestion == null ? "" : suggestion.toString(),
                style: const TextStyle(color: Colors.white),
              ),
              tileColor: Colors.black,
            );
          },
          transitionBuilder: (context, suggestionsBox, controller) {
            return suggestionsBox;
          },
          suggestionsCallback: (pattern) {
            var curList = [];

            for (var e in countries) {
              if (e
                  .toString()
                  .toLowerCase()
                  .startsWith(pattern.toLowerCase())) {
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
                  hintStyle:
                  TextStyle(color: Color.fromRGBO(255, 255, 255, 0.5)))),
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
                initialDate: joiningDate.text == ""
                    ? DateTime.now()
                    : DateTime.parse(joiningDate.text),
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
                joiningDate.text = value != null
                    ? DateFormat('yyyy-MM-dd').format(value)
                    : joiningDate.text;
              });
            });
          },
          controller: joiningDate,
          decoration: const InputDecoration(
              enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white)),
              focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white)),
              hintText: "Joining Date",
              hintStyle:
              TextStyle(color: Color.fromRGBO(255, 255, 255, 0.5))),
        ),
        const SizedBox(height: 20,),
        TextField(
          cursorColor: Colors.white,
          style: const TextStyle(color: Colors.white),
          keyboardType: TextInputType.text,
          controller: expertise,
          decoration: const InputDecoration(
              enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
              focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
              hintText: "Expertise",
              hintStyle: TextStyle(color: Color.fromRGBO(255, 255, 255, 0.5))
          ),
        ),
        const SizedBox(height: 20,),
        TextField(
          cursorColor: Colors.white,
          style: const TextStyle(color: Colors.white),
          keyboardType: TextInputType.text,
          controller: resume,
          decoration: const InputDecoration(
              enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
              focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
              hintText: "Resume",
              hintStyle: TextStyle(color: Color.fromRGBO(255, 255, 255, 0.5))
          ),
        ),
        const SizedBox(height: 20,),
        TextField(
          cursorColor: Colors.white,
          style: const TextStyle(color: Colors.white),
          keyboardType: TextInputType.text,
          controller: webpage,
          decoration: const InputDecoration(
              enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
              focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
              hintText: "Webpage",
              hintStyle: TextStyle(color: Color.fromRGBO(255, 255, 255, 0.5))
          ),
        ),
        const SizedBox(height: 20,),
        TextField(
          cursorColor: Colors.white,
          style: const TextStyle(color: Colors.white),
          keyboardType: TextInputType.text,
          controller: notes,
          decoration: const InputDecoration(
              enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
              focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
              hintText: "Notes",
              hintStyle: TextStyle(color: Color.fromRGBO(255, 255, 255, 0.5))
          ),
        ),
        const SizedBox(height: 20,),
        TextField(
          cursorColor: Colors.white,
          style: const TextStyle(color: Colors.white),
          keyboardType: TextInputType.text,
          controller: attachment,
          decoration: const InputDecoration(
              enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
              focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
              hintText: "Attachment",
              hintStyle: TextStyle(color: Color.fromRGBO(255, 255, 255, 0.5))
          ),
        ),
        const SizedBox(height: 20,),
      ],
    );
  }

  Widget personal() {
    return Column(
      children: [
        const Center(
          child: Text(
            "Personal Info",
            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
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
                initialDate: birthday.text == ""
                    ? DateTime.now()
                    : DateTime.parse(birthday.text),
                firstDate: DateTime(1900),
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
                birthday.text = value != null
                    ? DateFormat('yyyy-MM-dd').format(value)
                    : birthday.text;
              });
            });
          },
          controller: birthday,
          decoration: const InputDecoration(
              enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white)),
              focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white)),
              hintText: "Birthday",
              hintStyle: TextStyle(color: Color.fromRGBO(255, 255, 255, 0.5))),
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
                initialDate: anniversary.text == ""
                    ? DateTime.now()
                    : DateTime.parse(anniversary.text),
                firstDate: DateTime(1900),
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
                anniversary.text = value != null
                    ? DateFormat('yyyy-MM-dd').format(value)
                    : anniversary.text;
              });
            });
          },
          controller: anniversary,
          decoration: const InputDecoration(
              enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white)),
              focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white)),
              hintText: "Anniversary",
              hintStyle: TextStyle(color: Color.fromRGBO(255, 255, 255, 0.5))),
        ),
        const SizedBox(
          height: 20,
        ),
        DropdownButton<String>(
          value: sport,
          isExpanded: true,
          dropdownColor: Colors.black,
          hint: const Text(
            "Sports",
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
              sport = value!;
            });
          },
          items: sports.map<DropdownMenuItem<String>>((String value) {
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
        DropdownButton<String>(
          value: activity,
          isExpanded: true,
          dropdownColor: Colors.black,
          hint: const Text(
            "Activity",
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
              activity = value!;
            });
          },
          items: activities.map<DropdownMenuItem<String>>((String value) {
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
        DropdownButton<String>(
          value: beverage,
          isExpanded: true,
          dropdownColor: Colors.black,
          hint: const Text(
            "Beverage",
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
              beverage = value!;
            });
          },
          items: beverages.map<DropdownMenuItem<String>>((String value) {
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
        DropdownButton<String>(
          value: alcohol,
          isExpanded: true,
          dropdownColor: Colors.black,
          hint: const Text(
            "Alcohol",
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
              alcohol = value!;
            });
          },
          items: alcohols.map<DropdownMenuItem<String>>((String value) {
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
          controller: travel,
          decoration: const InputDecoration(
              enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white)),
              focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white)),
              hintText: "Travel Destination",
              hintStyle: TextStyle(color: Color.fromRGBO(255, 255, 255, 0.5))),
        ),
        const SizedBox(
          height: 20,
        ),
        TextField(
          cursorColor: Colors.white,
          style: const TextStyle(color: Colors.white),
          keyboardType: TextInputType.text,
          controller: spouse,
          decoration: const InputDecoration(
              enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white)),
              focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white)),
              hintText: "Spouse Name",
              hintStyle: TextStyle(color: Color.fromRGBO(255, 255, 255, 0.5))),
        ),
        const SizedBox(
          height: 20,
        ),
        TextField(
          cursorColor: Colors.white,
          style: const TextStyle(color: Colors.white),
          keyboardType: TextInputType.number,
          controller: children,
          decoration: const InputDecoration(
              enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white)),
              focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white)),
              hintText: "Children",
              hintStyle: TextStyle(color: Color.fromRGBO(255, 255, 255, 0.5))),
        ),
        const SizedBox(
          height: 20,
        ),
        TextField(
          cursorColor: Colors.white,
          style: const TextStyle(color: Colors.white),
          keyboardType: TextInputType.text,
          controller: tv,
          decoration: const InputDecoration(
              enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white)),
              focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white)),
              hintText: "TV Show",
              hintStyle: TextStyle(color: Color.fromRGBO(255, 255, 255, 0.5))),
        ),
        const SizedBox(
          height: 20,
        ),
        TextField(
          cursorColor: Colors.white,
          style: const TextStyle(color: Colors.white),
          keyboardType: TextInputType.text,
          controller: movie,
          decoration: const InputDecoration(
              enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white)),
              focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white)),
              hintText: "Movie",
              hintStyle: TextStyle(color: Color.fromRGBO(255, 255, 255, 0.5))),
        ),
        const SizedBox(
          height: 20,
        ),
        TextField(
          cursorColor: Colors.white,
          style: const TextStyle(color: Colors.white),
          keyboardType: TextInputType.text,
          controller: actor,
          decoration: const InputDecoration(
              enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white)),
              focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white)),
              hintText: "Actor",
              hintStyle: TextStyle(color: Color.fromRGBO(255, 255, 255, 0.5))),
        ),
        const SizedBox(
          height: 20,
        ),
        TextField(
          cursorColor: Colors.white,
          style: const TextStyle(color: Colors.white),
          keyboardType: TextInputType.text,
          controller: dislikes,
          decoration: const InputDecoration(
              enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white)),
              focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white)),
              hintText: "Dislikes",
              hintStyle: TextStyle(color: Color.fromRGBO(255, 255, 255, 0.5))),
        ),
        const SizedBox(
          height: 20,
        ),
      ],
    );
  }

  Widget skills() {
    return Column(
      children: [
        const Center(
          child: Text(
            "Employee Skills",
            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        TextField(
          cursorColor: Colors.white,
          style: const TextStyle(color: Colors.white),
          keyboardType: TextInputType.text,
          controller: proficiency,
          decoration: const InputDecoration(
              enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
              focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
              hintText: "Proficiency",
              hintStyle: TextStyle(color: Color.fromRGBO(255, 255, 255, 0.5))
          ),
        ),
        const SizedBox(height: 20,),
        TextField(
          cursorColor: Colors.white,
          style: const TextStyle(color: Colors.white),
          keyboardType: TextInputType.text,
          controller: interest,
          decoration: const InputDecoration(
              enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
              focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
              hintText: "Interest",
              hintStyle: TextStyle(color: Color.fromRGBO(255, 255, 255, 0.5))
          ),
        ),
        const SizedBox(height: 20,),
        TextField(
          cursorColor: Colors.white,
          style: const TextStyle(color: Colors.white),
          keyboardType: TextInputType.text,
          controller: cocurricular,
          decoration: const InputDecoration(
              enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
              focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
              hintText: "Co-Curricular",
              hintStyle: TextStyle(color: Color.fromRGBO(255, 255, 255, 0.5))
          ),
        ),
        const SizedBox(height: 20,),
        TextField(
          cursorColor: Colors.white,
          style: const TextStyle(color: Colors.white),
          keyboardType: TextInputType.text,
          controller: trainings,
          decoration: const InputDecoration(
              enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
              focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
              hintText: "Training",
              hintStyle: TextStyle(color: Color.fromRGBO(255, 255, 255, 0.5))
          ),
        ),
        const SizedBox(height: 20,),
      ],
    );
  }

  Widget traits() {
    return Column(
      children: [
        const Center(
          child: Text(
            "Employee Traits",
            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        TextField(
          cursorColor: Colors.white,
          style: const TextStyle(color: Colors.white),
          keyboardType: TextInputType.text,
          controller: strengths,
          decoration: const InputDecoration(
              enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
              focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
              hintText: "Strengths",
              hintStyle: TextStyle(color: Color.fromRGBO(255, 255, 255, 0.5))
          ),
        ),
        const SizedBox(height: 20,),
        TextField(
          cursorColor: Colors.white,
          style: const TextStyle(color: Colors.white),
          keyboardType: TextInputType.text,
          controller: weaknesses,
          decoration: const InputDecoration(
              enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
              focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
              hintText: "Weakness",
              hintStyle: TextStyle(color: Color.fromRGBO(255, 255, 255, 0.5))
          ),
        ),
        const SizedBox(height: 20,),
        TextField(
          cursorColor: Colors.white,
          style: const TextStyle(color: Colors.white),
          keyboardType: TextInputType.number,
          controller: socialActiveIndex,
          decoration: const InputDecoration(
              enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
              focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
              hintText: "Social Active Index",
              hintStyle: TextStyle(color: Color.fromRGBO(255, 255, 255, 0.5))
          ),
        ),
        const SizedBox(height: 20,),
      ],
    );
  }

  Widget auth() {
    return Column(
      children: [
        const Center(
          child: Text(
            "Authentication",
            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        TextField(
          cursorColor: Colors.white,
          style: const TextStyle(color: Colors.white),
          keyboardType: TextInputType.emailAddress,
          controller: username,
          decoration: const InputDecoration(
              enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
              focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
              hintText: "Username*",
              hintStyle: TextStyle(color: Color.fromRGBO(255, 255, 255, 0.5))
          ),
        ),
        const SizedBox(height: 20,),
        TextField(
          cursorColor: Colors.white,
          style: const TextStyle(color: Colors.white),
          keyboardType: TextInputType.text,
          obscureText: true,
          controller: password,
          decoration: const InputDecoration(
              enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
              focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
              hintText: "Password*",
              hintStyle: TextStyle(color: Color.fromRGBO(255, 255, 255, 0.5))
          ),
        ),
        const SizedBox(height: 20,),
        TextField(
          cursorColor: Colors.white,
          style: const TextStyle(color: Colors.white),
          keyboardType: TextInputType.text,
          obscureText: true,
          controller: confirmPassword,
          decoration: const InputDecoration(
              enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
              focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
              hintText: "Confirm Password*",
              hintStyle: TextStyle(color: Color.fromRGBO(255, 255, 255, 0.5))
          ),
        ),
        const SizedBox(height: 20,),
      ],
    );
  }
}