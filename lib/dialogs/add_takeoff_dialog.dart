import 'dart:convert';

import 'package:crm/dialogs/add_jobtitle_dialog.dart';
import 'package:crm/services/constants.dart';
import 'package:crm/services/remote_services.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
const List<String> sals = ["Mr.", "Mrs.", "Ms", "None"], projectManagers = [];

class _AddTakeoffDialogState extends State {

  List<TextEditingController>? productCategory = [];
  List<TextEditingController>? productMaterial = [];
  List<TextEditingController>? productSubcategory = [];
  List<TextEditingController>? productCode = [];
  List<TextEditingController>? productName = [];
  List<TextEditingController>? specifiedProduct = [];
  List<TextEditingController>? proposedProduct = [];
  List<TextEditingController>? unit = [];
  List<TextEditingController>? quantity = [];
  List<TextEditingController>? price = [];
  TextEditingController action = TextEditingController();
  TextEditingController salesPerson = TextEditingController();
  TextEditingController manager = TextEditingController();
  TextEditingController projectSource = TextEditingController();
  TextEditingController products = TextEditingController();
  TextEditingController generalContractors = TextEditingController();
  TextEditingController contractors = TextEditingController();
  TextEditingController projectName = TextEditingController();
  TextEditingController projectValue = TextEditingController();



  final snackBar1 = const SnackBar(
    content: Text('Please fill all the Required fields!'),
    backgroundColor: Colors.red,
  );

  final snackBar2 = const SnackBar(
    content: Text('Passwords don\'t match'),
    backgroundColor: Colors.red,
  );

  final snackBar3 = const SnackBar(
    content: Text('Data Mining Added Successfully'),
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
      Products = [],
      selectedProducts = [],companies = [],selectedItems = [],employees = [];
  Map<String, int> jobTitleMap = {},
      directManagerMap = {},companyMap = {},categoryMap = {},employeeMap = {},generalContractorsMap = {};
  Map<String,String> ProductMap = {};
  List<String> generalContractor =[],Contractors = [],categories = [];
  Map<String,Map<String, dynamic>> info = {};
  Map <int,String> categoryIdMap = {};


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

      dynamic res = await apiClient.getAllProducts();
      dynamic res1 = await apiClient.getAllCompanyNames();
      dynamic res2 = await apiClient.getProductCategory();
      dynamic res3 = await apiClient.getAllEmployeeNames();
      dynamic res4 = await apiClient.getAllContractors();
      //
      for (var e in res["res"]) {
        Map<String, dynamic> mp = {};
        mp["productId"] = e["Product_ID"]==null? "": e["Product_ID"].toString();
        mp["productCode"] = e["Product_Code"]==null? "": e["Product_Code"].toString();
        mp["productName"] = e["Product_Name"]==null? "": e["Product_Name"]??"";
        mp["description"] = e["Description"]== null? "": e["Description"]??"";
        mp["standardCost"] = e["Standard_Cost"]==null? "": e["Standard_Cost"].toString();
        mp["reorderLevel"] = e["Reorder_Level"]==null? "": e["Reorder_Level"].toString();
        mp["targetLevel"] = e["Target_Level"] == null? "" : e["Target_Level"].toString();
        mp["quantityPerUnit"] = e["Quantity_Per_Unit"]==null? "": e["Quantity_Per_Unit"].toString();
        mp["discontinued"] = e["Discontinued"]==null? "": e["Discontinued"]??"";
        mp["minimumReorderQuantity"] = e["Minimum_Reorder_Quantity"]==null? "": e["Minimum_Reorder_Quantity"].toString();
        mp["category"] = e["Category"]==null? "": e["Category"]??"";
        String name = e["Product_Name"] + " " + e["Product_Code"].toString();
        info[e["Product_Name"]] = mp;
        Products.add(name);
        ProductMap[name] = e["Product_Name"];

        // directManagerMap[e["Full_Name"]] = e["Employee_ID"];
      }
      for(var e in res1["res"]){
        companies.add(e["Name"]);
        companyMap[e["Name"]] = e["ID"];
        // companyIdMap[e["ID"]] = e["Name"];
      }
      for (var e in res2["res"]) {
        categories.add(e["Product_Category"]);
        categoryMap[e["Product_Category"]] = e["Category_ID"];
        categoryIdMap[e["Category_ID"]] = e["Product_Category"];
        // print(e["Category_ID"].toString());
        // print(e["Product_Category"]);
      }
      for(var e in res3["res"]){
        employees.add(e["Full_Name"]);
        employeeMap[e["Full_Name"]] = e["Employee_ID"];
      }
      // print(res4);
      for(var e in res4["res"]){
        generalContractor.add(e["Full_Name"]);
        generalContractorsMap[e["Full_Name"]] = e["ID"];
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
        List<List<String>> row = [];
        for(var i=0;i<selectedProducts.length;i++){
          List<String> data = [];
          data.add(categoryMap[productCategory![i].text].toString());
          data.add(productMaterial![i].text);
          data.add(productSubcategory![i].text);
          data.add(productCode![i].text);
          data.add(productName![i].text);
          data.add(specifiedProduct![i].text);
          data.add(proposedProduct![i].text);
          data.add(unit![i].text);
          data.add(quantity![i].text);
          data.add(price![i].text);
          row.add(data);
        }
        String jsonString = json.encode(row);
        dynamic res = await apiClient.addTakeoff(products.text, action.text, employeeMap[salesPerson.text].toString(), employeeMap[manager.text].toString(), generalContractorsMap[generalContractors.text].toString(), generalContractorsMap[contractors.text].toString(), projectSource.text,projectName.text,projectValue.text, jsonString);

        if (res["success"] == true) {
          Navigator.pop(context, true);
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
        loading = false;
      });

      await Future.delayed(const Duration(seconds: 2));
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
    }
  }

  bool validate() {
    if (projectName.text==""||action.text==""||generalContractors.text=="") {
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
            "Data Mining",
            style: TextStyle(
                color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
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
        DropdownSearch<String>.multiSelection(
          items: Products,
          dropdownButtonProps: const DropdownButtonProps(
              color: Color.fromRGBO(255, 255, 255, 0.5)
          ),
          selectedItems: selectedItems,
          dropdownDecoratorProps: const DropDownDecoratorProps(
              baseStyle :TextStyle(color: Colors.black),
              dropdownSearchDecoration: InputDecoration(

                  enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                  focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                  hintText: "Products",
                  hintStyle: TextStyle(color: Color.fromRGBO(255, 255, 255, 0.5))
              )
          ),
          // dropdownBuilder: (context, distributors) {
          //   return
          // },
          popupProps: const PopupPropsMultiSelection.menu(
              showSelectedItems: true,
              showSearchBox: true,
              searchFieldProps: TextFieldProps(
                  decoration: InputDecoration(
                      enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                      focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                      hintText: "Products",
                      hintStyle: TextStyle(color: Color.fromRGBO(255, 255, 255, 0.3))
                  )
              ),
              // menuProps: MenuProps(
              //   backgroundColor: Colors.white,
              // )
          ),
          onChanged: (value) {
            selectedItems = value;
            selectedItems.sort((a, b) => a.toString().compareTo(b.toString()));
            selectedProducts.clear();
            for(int i=0;i<selectedItems.length;i++){
              String? s = selectedItems[i];
              selectedProducts.add(ProductMap[s]!);
            }
            selectedProducts.sort((a, b) => a.toString().compareTo(b.toString()));

            products.text = selectedProducts.join(",");
          },
        ),
        const SizedBox(
          height: 20,
        ),
        TypeAheadFormField(
          onSuggestionSelected: (suggestion) {
            action.text = suggestion==null ? "" : suggestion.toString();
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
              controller: action,
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
        const SizedBox(height: 20,),
        TypeAheadFormField(
          onSuggestionSelected: (suggestion) {
            salesPerson.text = suggestion==null ? "" : suggestion.toString();
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
              controller: salesPerson,
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
            manager.text = suggestion==null ? "" : suggestion.toString();
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
              controller: manager,
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
            generalContractors.text = suggestion==null ? "" : suggestion.toString();
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

            for (var e in generalContractor) {
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
              controller: generalContractors,
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
        const SizedBox(height: 20,),
        TypeAheadFormField(
          onSuggestionSelected: (suggestion) {
            contractors.text = suggestion==null ? "" : suggestion.toString();
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

            for (var e in generalContractor) {
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
              controller: contractors,
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
        const SizedBox(height: 20,),
        TypeAheadFormField(
          onSuggestionSelected: (suggestion) {
            projectSource.text = suggestion==null ? "" : suggestion.toString();
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
              controller: projectSource,
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
      ],
    );
  }


  Widget step2() {
    return (
        SingleChildScrollView(
          child: ListView.builder(
            scrollDirection: Axis.vertical,
            controller: ScrollController(),
            shrinkWrap: true,
            itemBuilder: (buider, index) {
              productCategory!.add(TextEditingController());
              productMaterial!.add(TextEditingController());
              productSubcategory!.add(TextEditingController());
              productCode!.add(TextEditingController());
              proposedProduct!.add(TextEditingController());
              unit!.add(TextEditingController());
              quantity!.add(TextEditingController());
              price!.add(TextEditingController());
              productName!.add(TextEditingController());
              specifiedProduct!.add(TextEditingController());
              productName![index].text = selectedProducts[index];
              price![index].text = info[selectedProducts[index]]!["standardCost"];
              String cat = info[selectedProducts[index]]!["category"];
              productCategory![index].text = categoryIdMap[int.parse(cat)]!;
              productCode![index].text = info[selectedProducts[index]]!["productCode"];
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
                  TypeAheadFormField(
                    onSuggestionSelected: (suggestion) {
                      productCategory?[index].text = suggestion==null ? "" : suggestion.toString();
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
                        controller: productCategory?[index],
                        decoration: const InputDecoration(
                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white)),
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white)),
                            hintText: "Product Category",
                            hintStyle: TextStyle(color: Color.fromRGBO(255, 255, 255, 0.5))
                        )
                    ),
                  ),
                  const SizedBox(height: 20,),
                  TypeAheadFormField(
                    onSuggestionSelected: (suggestion) {
                      productMaterial?[index].text = suggestion==null ? "" : suggestion.toString();
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

                      for (var e in companies) {
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
                        controller: productMaterial?[index],
                        decoration: const InputDecoration(
                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white)),
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white)),
                            hintText: "Product Material",
                            hintStyle: TextStyle(color: Color.fromRGBO(255, 255, 255, 0.5))
                        )
                    ),
                  ),

                  const SizedBox(height: 20,),
                  TextField(
                    cursorColor: Colors.white,
                    style: const TextStyle(color: Colors.white),
                    keyboardType: TextInputType.text,
                    controller: productCode![index],
                    decoration: const InputDecoration(
                        enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                        focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                        hintText: "Product Code",
                        hintStyle: TextStyle(color: Color.fromRGBO(255, 255, 255, 0.5))
                    ),
                  ),
                  const SizedBox(height: 20,),
                  TypeAheadFormField(
                    onSuggestionSelected: (suggestion) {
                      productName?[index].text = suggestion==null ? "" : suggestion.toString();
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

                      for (var e in companies) {
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
                        controller: productName?[index],
                        decoration: const InputDecoration(
                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white)),
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white)),
                            hintText: "Product Name",
                            hintStyle: TextStyle(color: Color.fromRGBO(255, 255, 255, 0.5))
                        )
                    ),
                  ),

                  const SizedBox(height: 20,),
                  TypeAheadFormField(
                    onSuggestionSelected: (suggestion) {
                      specifiedProduct?[index].text = suggestion==null ? "" : suggestion.toString();
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

                      for (var e in companies) {
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
                        controller: specifiedProduct?[index],
                        decoration: const InputDecoration(
                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white)),
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white)),
                            hintText: "Specified Product",
                            hintStyle: TextStyle(color: Color.fromRGBO(255, 255, 255, 0.5))
                        )
                    ),
                  ),

                  const SizedBox(height: 20,),
                  TextField(
                    cursorColor: Colors.white,
                    style: const TextStyle(color: Colors.white),
                    keyboardType: TextInputType.text,
                    controller: proposedProduct![index],
                    decoration: const InputDecoration(
                        enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                        focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                        hintText: "Proposed Product",
                        hintStyle: TextStyle(color: Color.fromRGBO(255, 255, 255, 0.5))
                    ),
                  ),
                  const SizedBox(height: 20,),
                  TextField(
                    cursorColor: Colors.white,
                    style: const TextStyle(color: Colors.white),
                    keyboardType: TextInputType.text,
                    controller: unit![index],
                    decoration: const InputDecoration(
                        enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                        focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                        hintText: "Unit",
                        hintStyle: TextStyle(color: Color.fromRGBO(255, 255, 255, 0.5))
                    ),
                  ),
                  const SizedBox(height: 20,),
                  TextField(
                    cursorColor: Colors.white,
                    style: const TextStyle(color: Colors.white),
                    keyboardType: TextInputType.text,
                    controller: quantity![index],
                    decoration: const InputDecoration(
                        enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                        focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                        hintText: "Quantity",
                        hintStyle: TextStyle(color: Color.fromRGBO(255, 255, 255, 0.5))
                    ),
                  ),
                  const SizedBox(height: 20,),
                  TextField(
                    cursorColor: Colors.white,
                    style: const TextStyle(color: Colors.white),
                    keyboardType: TextInputType.text,
                    controller: price![index],
                    decoration: const InputDecoration(
                        enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                        focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                        hintText: "Price",
                        hintStyle: TextStyle(color: Color.fromRGBO(255, 255, 255, 0.5))
                    ),
                  ),
                  const SizedBox(height: 20,),

                ],
              );
            },
            itemCount: selectedProducts!.length,
          )
        )
    );
  }
}

