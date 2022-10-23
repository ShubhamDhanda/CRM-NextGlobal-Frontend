import 'package:crm/dialogs/add_company_dialog.dart';
import 'package:crm/services/constants.dart';
import 'package:crm/services/remote_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:intl/intl.dart';

class updateCustomerDialog extends StatefulWidget {
  final Map<String, dynamic> mp;
  const updateCustomerDialog({Key? key, required this.mp}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _updateCustomerDialogState(mp: mp);
}

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

class _updateCustomerDialogState extends State {
  final Map<String, dynamic> mp;

  TextEditingController companyName = TextEditingController();
  var companyId;
  var salutation;
  TextEditingController firstName = TextEditingController();
  TextEditingController lastName = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController email2 = TextEditingController();
  TextEditingController jobTitle = TextEditingController();
  TextEditingController businessPhone = TextEditingController();
  TextEditingController mobilePhone = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController city = TextEditingController();
  TextEditingController zip = TextEditingController();
  TextEditingController province = TextEditingController(text: "Ontario");
  TextEditingController country = TextEditingController(text: "Canada");
  TextEditingController notes = TextEditingController();
  TextEditingController attachment = TextEditingController();

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

  final snackBar1 = const SnackBar(
    content: Text('Please fill all the Required fields!'),
    backgroundColor: Colors.red,
  );

  final snackBar3 = const SnackBar(
    content: Text('Customer Updated Successfully'),
    backgroundColor: Colors.green,
  );

  final snackBar4 = const SnackBar(
    content: Text('Something Went Wrong!'),
    backgroundColor: Colors.red,
  );

  var apiClient = RemoteServices();
  bool loading = true;
  int currentStep = 0;
  List<String> companies = [],
      cities = Constants.cities,
      provinces = Constants.provinces,
      countries = Constants.countries;
  Map<String, int> companyMap = {};

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
      companies.clear();
      companyMap.clear();

      dynamic res = await apiClient.getAllCompanyNames();

      if (res["success"] == true) {
        for (var e in res["res"]) {
          companies.add(e["Name"]);
          companyMap[e["Name"]] = e["ID"];
        }
      }
    } catch(e) {
      ScaffoldMessenger.of(context).showSnackBar(snackBar4);
    } finally{
      setState(() {
        loading = false;
      });

      await Future.delayed(const Duration(seconds: 2));
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
    }
  }

  _updateCustomerDialogState({required this.mp}) {
    companyId = mp["companyId"];
    if(mp["salutation"] != "") {
      salutation = mp["salutation"];
    }
    firstName.text = mp["firstName"];
    lastName.text = mp["lastName"];
    email.text = mp["emailPersonal"];
    email2.text = mp["emailWork"];
    jobTitle.text = mp["jobTitle"];
    businessPhone.text = mp["business"];
    mobilePhone.text = mp["mobile"];
    address.text = mp["address"];
    city.text = mp["city"];
    province.text = mp["province"];
    zip.text = mp["zip"];
    country.text = mp["country"];
    notes.text = mp["notes"];
    attachment.text = mp["attachments"];

    birthday.text = mp["birthday"];
    anniversary.text = mp["anniversary"];
    if(mp["sports"] != "") {
      sport = mp["sports"];
    }
    if(mp["activities"] != ""){
      activity = mp["activities"];
    }
    if(mp["beverage"] != ""){
      beverage = mp["beverage"];
    }
    if(mp["alcohol"] != ""){
      alcohol = mp["alcohol"];
    }
    travel.text = mp["travelDestination"];
    spouse.text = mp["spouseName"];
    children.text = mp["children"];
    tv.text = mp["tvShow"];
    movie.text = mp["movies"];
    actor.text = mp["actor"];
    dislikes.text = mp["dislikes"];

    companyName.text = mp["companyName"];
  }

  void postData() async {

    if(validate()==true){
      dynamic res = await apiClient.updateClient(companyId, salutation.toString(), mp["id"], firstName.text, lastName.text, email.text, email2.text, jobTitle.text, businessPhone.text, mobilePhone.text, address.text, city.text, province.text, zip.text, country.text, notes.text, attachment.text, birthday.text, anniversary.text, sport.toString(), activity.toString(), beverage.toString(), alcohol.toString(), travel.text, spouse.text, children.text, tv.text, movie.text, actor.text, dislikes.text);

      if(res?["success"]==true) {
        Navigator.pop(context, true);
        ScaffoldMessenger.of(context).showSnackBar(snackBar3);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(snackBar4);
      }
    }

    await Future.delayed(Duration(seconds: 2));
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
  }

  bool validate() {
    if (companyName.text == "" || firstName.text == "") {
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
          title: const Text("Update Client"),
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
                      colorScheme: ColorScheme.light().copyWith(
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
                            child: currentStep==1 ?
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
          title: const Text("Main Info"),
          content: form()),
      Step(
          state: currentStep > 1 ? StepState.complete : StepState.indexed,
          isActive: currentStep >= 1,
          title: const Text("Personal Details"),
          content: personal()),
    ];
  }

  Widget form() {
    return Column(
      children: [
        TypeAheadFormField(
          onSuggestionSelected: (suggestion) {
            if (suggestion != null) {
              if (suggestion.toString() == "+ Add Company") {
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
                    const AddCompanyDialog()).then((value) {
                   if(value! == true){
                     _getData();
                   }
                });
              } else {
                companyName.text = suggestion.toString();
                companyId = companyMap[companyName.text];
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
            var curList = ["+ Add Company"];

            for (var e in companies) {
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
              controller: companyName,
              decoration: const InputDecoration(
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white)),
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white)),
                  hintText: "Company",
                  hintStyle:
                  TextStyle(color: Color.fromRGBO(255, 255, 255, 0.5)))),
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
              enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white)),
              focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white)),
              hintText: "First Name*",
              hintStyle: TextStyle(color: Color.fromRGBO(255, 255, 255, 0.5))),
        ),
        const SizedBox(
          height: 20,
        ),
        TextField(
          cursorColor: Colors.white,
          style: const TextStyle(color: Colors.white),
          keyboardType: TextInputType.text,
          controller: lastName,
          decoration: const InputDecoration(
              enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white)),
              focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white)),
              hintText: "Last Name",
              hintStyle: TextStyle(color: Color.fromRGBO(255, 255, 255, 0.5))),
        ),
        const SizedBox(
          height: 20,
        ),
        TextField(
          cursorColor: Colors.white,
          style: const TextStyle(color: Colors.white),
          keyboardType: TextInputType.text,
          controller: jobTitle,
          decoration: const InputDecoration(
              enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white)),
              focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white)),
              hintText: "Job Title",
              hintStyle: TextStyle(color: Color.fromRGBO(255, 255, 255, 0.5))),
        ),
        const SizedBox(
          height: 20,
        ),
        TextField(
          cursorColor: Colors.white,
          style: const TextStyle(color: Colors.white),
          keyboardType: TextInputType.emailAddress,
          controller: email,
          decoration: const InputDecoration(
              enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white)),
              focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white)),
              hintText: "Email Personal",
              hintStyle: TextStyle(color: Color.fromRGBO(255, 255, 255, 0.5))),
        ),
        const SizedBox(
          height: 20,
        ),
        TextField(
          cursorColor: Colors.white,
          style: const TextStyle(color: Colors.white),
          keyboardType: TextInputType.emailAddress,
          controller: email2,
          decoration: const InputDecoration(
              enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white)),
              focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white)),
              hintText: "Email Work",
              hintStyle: TextStyle(color: Color.fromRGBO(255, 255, 255, 0.5))),
        ),
        const SizedBox(
          height: 20,
        ),
        TextField(
          cursorColor: Colors.white,
          style: const TextStyle(color: Colors.white),
          keyboardType: TextInputType.number,
          controller: businessPhone,
          decoration: const InputDecoration(
              enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white)),
              focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white)),
              hintText: "Business Phone",
              hintStyle: TextStyle(color: Color.fromRGBO(255, 255, 255, 0.5))),
        ),
        const SizedBox(
          height: 20,
        ),
        TextField(
          cursorColor: Colors.white,
          style: const TextStyle(color: Colors.white),
          keyboardType: TextInputType.number,
          controller: mobilePhone,
          decoration: const InputDecoration(
              enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white)),
              focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white)),
              hintText: "Mobile Phone",
              hintStyle: TextStyle(color: Color.fromRGBO(255, 255, 255, 0.5))),
        ),
        const SizedBox(
          height: 20,
        ),
        TextField(
          cursorColor: Colors.white,
          style: const TextStyle(color: Colors.white),
          keyboardType: TextInputType.text,
          controller: address,
          decoration: const InputDecoration(
              enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white)),
              focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white)),
              hintText: "Address",
              hintStyle: TextStyle(color: Color.fromRGBO(255, 255, 255, 0.5))),
        ),
        const SizedBox(
          height: 20,
        ),
        TypeAheadFormField(
          onSuggestionSelected: (suggestion) {
            city.text = suggestion == null ? "" : suggestion.toString();
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

            for (var e in cities) {
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
              controller: city,
              decoration: const InputDecoration(
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white)),
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white)),
                  hintText: "City",
                  hintStyle:
                  TextStyle(color: Color.fromRGBO(255, 255, 255, 0.5)))),
        ),
        const SizedBox(
          height: 20,
        ),
        TextField(
          cursorColor: Colors.white,
          style: const TextStyle(color: Colors.white),
          keyboardType: TextInputType.number,
          controller: zip,
          decoration: const InputDecoration(
              enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white)),
              focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white)),
              hintText: "ZIP/Postal Code",
              hintStyle: TextStyle(color: Color.fromRGBO(255, 255, 255, 0.5))),
        ),
        const SizedBox(
          height: 20,
        ),
        TypeAheadFormField(
          onSuggestionSelected: (suggestion) {
            province.text = suggestion == null ? "" : suggestion.toString();
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

            for (var e in provinces) {
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
              controller: province,
              decoration: const InputDecoration(
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white)),
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white)),
                  hintText: "Province",
                  hintStyle:
                  TextStyle(color: Color.fromRGBO(255, 255, 255, 0.5)))),
        ),
        const SizedBox(
          height: 20,
        ),
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
        const SizedBox(
          height: 20,
        ),
        TextField(
          cursorColor: Colors.white,
          style: const TextStyle(color: Colors.white),
          keyboardType: TextInputType.text,
          controller: notes,
          decoration: const InputDecoration(
              enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white)),
              focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white)),
              hintText: "Notes",
              hintStyle: TextStyle(color: Color.fromRGBO(255, 255, 255, 0.5))),
        ),
        const SizedBox(
          height: 20,
        ),
        TextField(
          cursorColor: Colors.white,
          style: const TextStyle(color: Colors.white),
          keyboardType: TextInputType.text,
          controller: attachment,
          decoration: const InputDecoration(
              enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white)),
              focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white)),
              hintText: "Attachment",
              hintStyle: TextStyle(color: Color.fromRGBO(255, 255, 255, 0.5))),
        ),
        const SizedBox(
          height: 20,
        ),
      ],
    );
  }

  Widget personal() {
    return Column(
      children: [
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
}