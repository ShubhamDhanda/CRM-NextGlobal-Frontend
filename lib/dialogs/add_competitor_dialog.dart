import 'package:crm/dialogs/add_company_dialog.dart';
import 'package:crm/services/constants.dart';
import 'package:crm/services/remote_services.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:intl/intl.dart';

import 'add_people.dart';

class AddCompetitorDialog extends StatefulWidget {
  const AddCompetitorDialog({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _AddCompetitorDialogState();
}

const List<String> Status = <String>["Go", "NoGo","Review"];




class _AddCompetitorDialogState extends State<AddCompetitorDialog> {
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
    content: Text('Competitor Added Successfully'),
    backgroundColor: Colors.green,
  );

  final snackBar4 = const SnackBar(
    content: Text('Something Went Wrong!'),
    backgroundColor: Colors.red,
  );

  var apiClient = RemoteServices();
  List<String> cities = [], categories = [];
  Map<String, int>  categoryMap = {} ,companyMap = {},productMap = {};
  bool dataLoaded = false;
  List<String> companies = [];
  List<String> contacts = [],products = [],
  selectedProducts = [];

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
      dynamic res = await apiClient.getAllProducts();
      dynamic res1 = await apiClient.getProductCategory();
      dynamic res2 = await apiClient.getAllCompanyNames();

      if (res?["success"]==true&&res1?["success"]==true&& res2?["success"]) {
        for (var e in res["res"]) {
          String name = e["Product_Name"]+" "+ e["Product_Code"].toString();
          products.add(name);
          productMap[name] = e["Product_ID"];
        }
        for (var e in res1["res"]) {
          categories.add(e["Product_Category"]);
          categoryMap[e["Product_Category"]] = e["Category_ID"];
        }

        for(var e in res2["res"]){
          companies.add(e["Name"]);
          companyMap[e["Name"]] = e["ID"];
        }
      } else {
        throw "Negative";
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


  void postData() async {
    try{
      setState(() {
        dataLoaded = false;
      });

      if (validate() == true) {

        dynamic res = await apiClient.addCompetitor(companyMap[companyController.text], categoryMap[category.text], product.text,approxSales.text, geographicalCoverage.text,distributedBy.text,keyPersonnel.text);
        if(res?["success"]==true) {
        // if(true) {
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
    if(companyController.text=="" || category.text=="" || approxSales.text=="" ){
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
        title: const Text("Add Competitor"),
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
                      const AddCompanyDialog()).then((value){
                    if(value! == true){
                      _getData();
                    }
                  });
                } else {
                  companyController.text = suggestion.toString();
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
              var curList = ["+ Add Company"];

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

          DropdownSearch<String>.multiSelection(
            items: products,
            dropdownButtonProps: const DropdownButtonProps(
                color: Color.fromRGBO(255, 255, 255, 0.5)
            ),
            selectedItems: selectedProducts,
            // showSearchBox: true,
            // filterFn: (searchText, option) {
            //   // Return true if the option should be included in the filtered list,
            //   // based on the search text
            //   print(option);
            //   return option.toLowerCase().startsWith(searchText.toLowerCase());
            // },
            dropdownDecoratorProps: const DropDownDecoratorProps(
                baseStyle :TextStyle(color: Colors.white),
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
                menuProps: MenuProps(
                  backgroundColor: Colors.white,
                )
            ),
            onChanged: (value) {
              selectedProducts = value;
              // List<int> val = [];
              // val.clear();
              // for(var i in selectedProducts){
              //   val.add(productMap[i]!);
              // }
              selectedProducts.sort((a, b) => a.toString().compareTo(b.toString()));
              // val.sort((a, b) => a.compareTo(b));
              product.text = selectedProducts.join(",");
              // setState(() {
              //   selectedProducts = value;
              //   selectedProducts.sort((a, b) => a.toString().compareTo(b.toString()));
              //   product.text = selectedProducts.join(",");
              // });
            },
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
              if (suggestion != null) {
                if (suggestion.toString() == "+Add New Client") {
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
                      const AddPeopleDialog()).then((value){
                    if(value! == true){
                      _getData();
                    }
                  });
                } else {
                  distributedBy.text = suggestion.toString();
                  // companyId = companyMap[companyName.text];
                }
              }
              // keyPersonnel.text = suggestion.toString();
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
              var curList = ["+Add New Client"];

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
          TypeAheadFormField(
            onSuggestionSelected: (suggestion) {
              if (suggestion != null) {
                if (suggestion.toString() == "+Add New Client") {
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
                      const AddPeopleDialog()).then((value){
                    if(value! == true){
                      _getData();
                    }
                  });
                } else {
                  distributedBy.text = suggestion.toString();
                  // companyId = companyMap[companyName.text];
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
              var curList = ["+Add New Client"];

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