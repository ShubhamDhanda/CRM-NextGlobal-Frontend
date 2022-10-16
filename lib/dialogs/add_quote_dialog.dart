import 'package:crm/services/remote_services.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class AddQuoteDialog extends StatefulWidget{
  const AddQuoteDialog({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _AddQuoteDialogState();
}

const List<String> values = <String>[
  "\$0 - \$50k",
  "\$50k - \$100k",
  "\$100k - \$500k",
  "\$500k - \$1 million",
  "Above \$1 million"
];

const List<String> prob = <String>[
  "0% - 30%",
  "30% - 50%",
  "50% - 70%",
  "70% - 100%"
];

const List<String> status = <String>[
  "Won",
  "Lost",
  "Negotiation",
  "Closed"
];

class _AddQuoteDialogState extends State<AddQuoteDialog> {
  TextEditingController projectController = TextEditingController();
  TextEditingController empId = TextEditingController();
  TextEditingController productQuantity = TextEditingController();
  TextEditingController productSpecified = TextEditingController();
  TextEditingController distributorPrice = TextEditingController();
  TextEditingController contractorPrice = TextEditingController();
  TextEditingController awardedContractor = TextEditingController();
  TextEditingController awardedDistributor = TextEditingController();
  TextEditingController awardedValue = TextEditingController();
  TextEditingController shippingStatus = TextEditingController();

  var projectValue, probability, distList, contList, quoteStatus;

  final snackBar1 = const SnackBar(
    content: Text('Please fill all the Required fields!'),
    backgroundColor: Colors.red,
  );

  final snackBar3 = const SnackBar(
    content: Text('Quote Added Successfully'),
    backgroundColor: Colors.green,
  );

  final snackBar4 = const SnackBar(
    content: Text('Something Went Wrong!'),
    backgroundColor: Colors.red,
  );

  var apiClient = RemoteServices();
  bool loading = false;
  List<String> projects = [], distributors = [], contractors = [];

  @override
  void initState() {
    super.initState();

    _getData();
  }

  void _getData() async {
    setState(() {
      loading = true;
    });
    dynamic res = await apiClient.getAllProjectNames();
    dynamic res2 = await apiClient.getAllDistributors();
    dynamic res3 = await apiClient.getAllContractors();
    print(res);
    print(res2);
    print(res3);
    if(res?["success"] == true && res2?["success"] == true && res3?["success"] == true){
      for(var e in res["res"]){
        projects.add(e["Project_Name"].toString());
      }
      for(var e in res2["res"]){
        distributors.add(e["Full_Name"].toString());
      }
      for(var e in res3["res"]){
        contractors.add(e["Full_Name"].toString());
      }
    }else{
      ScaffoldMessenger.of(context).showSnackBar(snackBar4);
    }

    setState(() {
      loading = false;
    });

    await Future.delayed(const Duration(seconds: 2));
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
  }

  void postData () async {
    setState(() {
      loading = true;
    });

    if(validate() == true){

    }

    setState(() {
      loading = false;
    });

    await Future.delayed(const Duration(seconds: 2));
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
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
          onTap: () => Navigator.pop(context),
        ),
        title: const Text("Add Quote"),
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
        visible: !loading,
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
                controller: projectController,
                decoration: const InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white)),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white)),
                    hintText: "Project Name",
                    hintStyle: TextStyle(color: Color.fromRGBO(255, 255, 255, 0.5))
                )
            ),
          ),
          const SizedBox(height: 20,),
          TextField(
            cursorColor: Colors.white,
            style: const TextStyle(color: Colors.white),
            keyboardType: TextInputType.number,
            controller: empId,
            decoration: const InputDecoration(
                enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                hintText: "Employee ID*",
                hintStyle: TextStyle(color: Color.fromRGBO(255, 255, 255, 0.5))
            ),
          ),
          const SizedBox(height: 20,),
          TextField(
            cursorColor: Colors.white,
            style: const TextStyle(color: Colors.white),
            keyboardType: TextInputType.number,
            controller: productQuantity,
            decoration: const InputDecoration(
                enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                hintText: "Product Quantity",
                hintStyle: TextStyle(color: Color.fromRGBO(255, 255, 255, 0.5))
            ),
          ),
          const SizedBox(height: 20,),
          TextField(
            cursorColor: Colors.white,
            style: const TextStyle(color: Colors.white),
            keyboardType: TextInputType.number,
            controller: productSpecified,
            decoration: const InputDecoration(
                enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                hintText: "Product Specified",
                hintStyle: TextStyle(color: Color.fromRGBO(255, 255, 255, 0.5))
            ),
          ),
          const SizedBox(height: 20,),
          DropdownButton<String>(
            value: projectValue,
            isExpanded: true,
            dropdownColor: Colors.black,
            hint: const Text(
              "Project Value",
              style: TextStyle(color: Color.fromRGBO(255, 255, 255, 0.5), fontSize: 16.0),
            ),
            style: const TextStyle(color: Colors.white),
            underline: Container(
              height: 1,
              color: Colors.white,
            ),
            onChanged: (value) {
              setState(() {
                projectValue = value!;
              });
            },
            items: values.map<DropdownMenuItem<String>>((String value) {
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
          DropdownButton<String>(
            value: probability,
            isExpanded: true,
            dropdownColor: Colors.black,
            hint: const Text(
              "Probability of Winning",
              style: TextStyle(color: Color.fromRGBO(255, 255, 255, 0.5), fontSize: 16.0),
            ),
            style: const TextStyle(color: Colors.white),
            underline: Container(
              height: 1,
              color: Colors.white,
            ),
            onChanged: (value) {
              setState(() {
                probability = value!;
              });
            },
            items: prob.map<DropdownMenuItem<String>>((String value) {
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
          DropdownSearch<String>.multiSelection(
            items: distributors,
            dropdownButtonProps: const DropdownButtonProps(
              color: Color.fromRGBO(255, 255, 255, 0.3)
            ),
            dropdownDecoratorProps: const DropDownDecoratorProps(
              dropdownSearchDecoration: InputDecoration(
                enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                      focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                      hintText: "Distributor List",
                      hintStyle: TextStyle(color: Color.fromRGBO(255, 255, 255, 0.5))
              )
            ),
            // dropdownBuilder: (context, distributors) {
            //   return
            // },
            popupProps: const PopupPropsMultiSelection.menu(
              showSelectedItems: true,
              menuProps: MenuProps(
                // backgroundColor: Colors.black,
              )
            ),
            onChanged: (value) {
              distList = value;
            },
          ),
          const SizedBox(height: 20,),
          TextField(
            cursorColor: Colors.white,
            style: const TextStyle(color: Colors.white),
            keyboardType: TextInputType.number,
            controller: distributorPrice,
            decoration: const InputDecoration(
                enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                hintText: "Distributor Price",
                hintStyle: TextStyle(color: Color.fromRGBO(255, 255, 255, 0.5))
            ),
          ),
          const SizedBox(height: 20,),
          DropdownSearch<String>.multiSelection(
            items: contractors,
            dropdownButtonProps: const DropdownButtonProps(
                color: Color.fromRGBO(255, 255, 255, 0.3)
            ),
            dropdownDecoratorProps: const DropDownDecoratorProps(
                dropdownSearchDecoration: InputDecoration(
                    enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                    focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                    hintText: "Contractor List",
                    hintStyle: TextStyle(color: Color.fromRGBO(255, 255, 255, 0.5))
                )
            ),
            popupProps: const PopupPropsMultiSelection.menu(
                showSelectedItems: true,
                menuProps: MenuProps(
                  // backgroundColor: Colors.black,
                )
            ),
            onChanged: (value) {
              contList = value;
            },
          ),
          const SizedBox(height: 20,),
          TextField(
            cursorColor: Colors.white,
            style: const TextStyle(color: Colors.white),
            keyboardType: TextInputType.number,
            controller: contractorPrice,
            decoration: const InputDecoration(
                enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                hintText: "Contractor Price",
                hintStyle: TextStyle(color: Color.fromRGBO(255, 255, 255, 0.5))
            ),
          ),
          const SizedBox(height: 20,),
          DropdownButton<String>(
            value: quoteStatus,
            isExpanded: true,
            dropdownColor: Colors.black,
            hint: const Text(
              "Quote Status",
              style: TextStyle(color: Color.fromRGBO(255, 255, 255, 0.5), fontSize: 16.0),
            ),
            style: const TextStyle(color: Colors.white),
            underline: Container(
              height: 1,
              color: Colors.white,
            ),
            onChanged: (value) {
              setState(() {
                quoteStatus = value!;
              });
            },
            items: status.map<DropdownMenuItem<String>>((String value) {
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
          TextField(
            cursorColor: Colors.white,
            style: const TextStyle(color: Colors.white),
            keyboardType: TextInputType.text,
            controller: awardedContractor,
            decoration: const InputDecoration(
                enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                hintText: "Awarded Contractor",
                hintStyle: TextStyle(color: Color.fromRGBO(255, 255, 255, 0.5))
            ),
          ),
          const SizedBox(height: 20,),
          TextField(
            cursorColor: Colors.white,
            style: const TextStyle(color: Colors.white),
            keyboardType: TextInputType.text,
            controller: awardedDistributor,
            decoration: const InputDecoration(
                enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                hintText: "Awarded Distributor",
                hintStyle: TextStyle(color: Color.fromRGBO(255, 255, 255, 0.5))
            ),
          ),
          const SizedBox(height: 20,),
          TextField(
            cursorColor: Colors.white,
            style: const TextStyle(color: Colors.white),
            keyboardType: TextInputType.number,
            controller: awardedValue,
            decoration: const InputDecoration(
                enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                hintText: "Awarded Value",
                hintStyle: TextStyle(color: Color.fromRGBO(255, 255, 255, 0.5))
            ),
          ),
          const SizedBox(height: 20,),
          TextField(
            cursorColor: Colors.white,
            style: const TextStyle(color: Colors.white),
            keyboardType: TextInputType.number,
            controller: shippingStatus,
            decoration: const InputDecoration(
                enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                hintText: "Shipping Status",
                hintStyle: TextStyle(color: Color.fromRGBO(255, 255, 255, 0.5))
            ),
          ),
          const SizedBox(height: 20,),
          Container(
            padding: const EdgeInsets.fromLTRB(100, 0, 100, 0),
            child: ElevatedButton(onPressed: () => postData(),
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