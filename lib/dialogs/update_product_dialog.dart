import 'package:crm/dialogs/add_employee_dialog.dart';
import 'package:crm/dialogs/add_people.dart';
import 'package:crm/services/constants.dart';
import 'package:crm/services/remote_services.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:intl/intl.dart';

class updateProductDialog extends StatefulWidget {
  final Map<String, dynamic> mp;
  const updateProductDialog({Key? key, required this.mp}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _updateProductDialogState(mp: mp);
}

const List<String> Status = <String>["Yes","No"];
const List<String> list = <String>[
  'New Project',
  'Modifications',
  'Quote',
  'Negotiation',
  'Closed',
  'Dead'
];

class _updateProductDialogState extends State<updateProductDialog> {
  late Map<String, dynamic> mp;
  TextEditingController companyName = TextEditingController();
  TextEditingController productCode = TextEditingController();
  TextEditingController productName = TextEditingController();
  TextEditingController description = TextEditingController();
  TextEditingController standardCost = TextEditingController();
  TextEditingController listPrice = TextEditingController();
  TextEditingController reorderLevel = TextEditingController();
  TextEditingController targetLevel = TextEditingController();
  TextEditingController quantityPerUnit = TextEditingController();
  TextEditingController discontinued = TextEditingController();
  TextEditingController minimumReorderQuantity = TextEditingController();
  TextEditingController category = TextEditingController();
  TextEditingController attachments = TextEditingController();

  final snackBar1 = const SnackBar(
    content: Text('Please fill all the Required fields!'),
    backgroundColor: Colors.red,
  );

  final snackBar3 = const SnackBar(
    content: Text('Product Updated Successfully'),
    backgroundColor: Colors.green,
  );

  final snackBar4 = const SnackBar(
    content: Text('Something Went Wrong!'),
    backgroundColor: Colors.red,
  );

  var apiClient = RemoteServices();
  bool dataLoaded = false;
  var projectStageVal, dept;
  List<String> provinces = Constants.provinces;
  List<String> employees = <String>[];
  List<String> prevCat = [];
  List<String> prevDep = [];
  var companyId;
  List<String> prevMember = [], prevPlan = [], prevBid = [];
  List<String> clients = [];
  Map<String, String> empMap = {}, clientMap = {};
  Map<String, int> projectManagerMap = {};
  var stringList, empId, Team;
  var status, bidStatus,projectManagerId;
  List<Map<String, dynamic>> customers = [];
  List<String> Departments = [];
  List<String> cities = [], departments = [], companies = [],contacts = [];
  Map<String, int> cityMap = {},
      departmentMap = {},
      companyMap = {},
      employeeMap = {};
  var ProjectManager;

  _updateProductDialogState({required this.mp}) {
    productCode.text = mp["productCode"];
    productName.text = mp["productName"];
    description.text = mp["description"];
    standardCost.text = mp["standardCost"];
    listPrice.text = mp["listPrice"];
    reorderLevel.text = mp["reorderLevel"];
    targetLevel.text = mp["targetLevel"];
    quantityPerUnit.text = mp["quantityPerUnit"];
    minimumReorderQuantity.text = mp["minimumReorderQuantity"];
    category.text = mp["category"];
    print(mp["discontinued"]);
    if(mp["discontinued"]!=""){
      status = mp["discontinued"];
    }
  }

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
      dynamic res1 = await apiClient.getCities();
      dynamic res2 = await apiClient.getDepartments();
      dynamic res3 = await apiClient.getAllEmployeeNames();
      dynamic res4 = await apiClient.getAllCompanyNames();

      for (var e in res1["res"]) {
        cities.add(e["City"]);
        cityMap[e["City"]] = e["City_ID"];
      }

      for (var e in res2["res"]) {
        departments.add(e["Department"]);
        departmentMap[e["Department"]] = e["Department_ID"];
      }

      for (var e in res3["res"]) {
        employees.add(e["Full_Name"].toString());
        employeeMap[e["Full_Name"].toString()] = e["Employee_ID"];
        print(e["Full_Name"]);
        print(e["Employee_ID"]);
      }
      for (var e in res4["res"]) {
        companies.add(e["Name"]);
        companyMap[e["Name"]] = e["ID"];
      }
      print(employees);
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
        dynamic res = await apiClient.updateProduct(mp["productId"],productCode.text, productName.text, description.text, standardCost.text, listPrice.text, reorderLevel.text, targetLevel.text, quantityPerUnit.text, status.toString(), minimumReorderQuantity.text, category.text, attachments.text);

        if(res["success"] == true){
          Navigator.pop(context, true);
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
    if(status=="" ){
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
        title: Text("Update Product"),
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
          TextField(
            cursorColor: Colors.white,
            style: const TextStyle(color: Colors.white),
            keyboardType: TextInputType.text,
            controller: productCode,
            decoration: const InputDecoration(
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white)),
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white)),
                hintText: "Product Code",
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
            controller: productName,
            decoration: const InputDecoration(
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white)),
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white)),
                hintText: "Product Name",
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
            controller: description,
            decoration: const InputDecoration(
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white)),
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white)),
                hintText: "Description",
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
            controller: standardCost,
            decoration: const InputDecoration(
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white)),
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white)),
                hintText: "Standard Cost",
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
            controller: listPrice,
            decoration: const InputDecoration(
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white)),
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white)),
                hintText: "List Price",
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
            controller: reorderLevel,
            decoration: const InputDecoration(
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white)),
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white)),
                hintText: "Reorder Level",
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
            controller: targetLevel,
            decoration: const InputDecoration(
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white)),
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white)),
                hintText: "Target Level",
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
            controller: quantityPerUnit,
            decoration: const InputDecoration(
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white)),
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white)),
                hintText: "Quality Per Unit",
                hintStyle:
                TextStyle(color: Color.fromRGBO(255, 255, 255, 0.5))),
          ),
          const SizedBox(
            height: 20,
          ),
          DropdownButton<String>(
            value: status,
            isExpanded: true,
            dropdownColor: Colors.black,
            hint: const Text(
              "Discontinued*",
              style: TextStyle(color: Color.fromRGBO(255, 255, 255, 0.5),fontSize: 16),
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

          TextField(
            cursorColor: Colors.white,
            style: const TextStyle(color: Colors.white),
            keyboardType: TextInputType.number,
            controller: minimumReorderQuantity,
            decoration: const InputDecoration(
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white)),
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white)),
                hintText: "Minimum Reorder Quantity",
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
            controller: category,
            decoration: const InputDecoration(
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white)),
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white)),
                hintText: "Category",
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
            controller: attachments,
            decoration: const InputDecoration(
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white)),
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white)),
                hintText: "Attachments",
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