import 'package:crm/services/remote_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class AddBudgetDialog extends StatefulWidget{
  const AddBudgetDialog({super.key});

  @override
  State<StatefulWidget> createState() => _AddBudgetDialogState();
}

const List<String> budCategories = ["Design Project", "Product Project"];

class _AddBudgetDialogState extends State<AddBudgetDialog>{
  TextEditingController city = TextEditingController();
  var cityId;
  TextEditingController department = TextEditingController();
  var departmentId;
  TextEditingController category = TextEditingController();
  var categoryId;
  TextEditingController projectName = TextEditingController();
  var budgetCategory;
  TextEditingController budgetAmount = TextEditingController();

  final snackBar2 = const SnackBar(
    content: Text('Please fill all the Required fields!'),
    backgroundColor: Colors.red,
  );

  final snackBar3 = const SnackBar(
    content: Text('Budget Added Successfully'),
    backgroundColor: Colors.green,
  );

  final snackBar1 = const SnackBar(
    content: Text('Something Went Wrong!'),
    backgroundColor: Colors.red,
  );

  var apiClient = RemoteServices();
  bool dataLoaded = false;
  List<String> cities = [], departments = [], categories = [];
  Map<String, int> cityMap = {}, departmentMap = {}, categoryMap = {};

  @override
  void initState() {
    super.initState();

    _getData();
  }

  void _getData() async {
    try{
      setState(() {
        dataLoaded = false;
      });

      dynamic res = await apiClient.getCities();
      dynamic res2 = await apiClient.getDepartments();
      dynamic res3 = await apiClient.getProjectCategories();

      for(var e in res["res"]){
        cities.add(e["City"]);
        cityMap[e["City"]] = e["City_ID"];
      }

      for(var e in res2["res"]){
        departments.add(e["Department"]);
        departmentMap[e["Department"]] = e["Department_ID"];
      }

      for(var e in res3["res"]){
        categories.add(e["Project_Category"]);
        categoryMap[e["Project_Category"]] = e["Project_Cat_ID"];
      }
    } catch(e) {
      ScaffoldMessenger.of(context).showSnackBar(snackBar1);
    } finally{
      setState(() {
        dataLoaded = true;
      });

      await Future.delayed(const Duration(seconds: 2));
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
    }
  }

  void _postData() async {
    try{
      if(validate() == true){
        dynamic res = await apiClient.addBudget(cityId.toString(), departmentId.toString(), categoryId.toString(), projectName.text, budgetCategory.toString(), budgetAmount.text);
print(res);
        if(res["success"] == true){
          Navigator.pop(context, true);
          ScaffoldMessenger.of(context).showSnackBar(snackBar3);
        }else{
          throw "";
        }
      }else{
        ScaffoldMessenger.of(context).showSnackBar(snackBar2);
      }
    } catch(e) {
      ScaffoldMessenger.of(context).showSnackBar(snackBar1);
    } finally{
      setState(() {
        dataLoaded = true;
      });

      await Future.delayed(const Duration(seconds: 2));
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
    }
  }

  bool validate() {
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
        title: const Text("Add Budget"),
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
              if(suggestion != null) {
                city.text = suggestion.toString();
                cityId = cityMap[city.text];
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
              if(suggestion != null) {
                if(suggestion == "+ Add Department"){

                }else{
                  department.text = suggestion.toString();
                  departmentId = departmentMap[department.text];
                }
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
              var curList = ["+ Add Department"];

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
                controller: department,
                decoration: const InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white)),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white)),
                    hintText: "Department*",
                    hintStyle: TextStyle(color: Color.fromRGBO(255, 255, 255, 0.5))
                )
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          DropdownButton<String>(
            value: budgetCategory,
            isExpanded: true,
            dropdownColor: Colors.black,
            hint: const Text(
              "Budget Category*",
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
                budgetCategory = value!;
              });
            },
            items: budCategories.map<DropdownMenuItem<String>>((String value) {
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
          TypeAheadFormField(
            onSuggestionSelected: (suggestion) {
              if(suggestion != null) {
                if(suggestion == "+ Add Project Category"){

                }else{
                  category.text = suggestion.toString();
                  categoryId = categoryMap[category.text];
                }
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
              var curList = ["+ Add Project Category"];

              for (var e in categories) {
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
            controller: projectName,
            decoration: const InputDecoration(
                enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                hintText: "Project Name*",
                hintStyle: TextStyle(color: Color.fromRGBO(255, 255, 255, 0.5))
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          TextField(
            cursorColor: Colors.white,
            style: const TextStyle(color: Colors.white),
            keyboardType: TextInputType.number,
            controller: budgetAmount,
            decoration: const InputDecoration(
                enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                hintText: "Budget Amount*",
                hintStyle: TextStyle(color: Color.fromRGBO(255, 255, 255, 0.5))
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Container(
            padding: EdgeInsets.fromLTRB(100, 0, 100, 0),
            child: ElevatedButton(onPressed: () {
              _postData();
            } ,
              style: ElevatedButton.styleFrom(primary: const Color.fromRGBO(134, 97, 255, 1)),
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