import 'package:crm/services/remote_services.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

import 'add_takeoff_dialog.dart';

class AddCategoryDialog extends StatefulWidget{
  const AddCategoryDialog({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _AddCategoryDialogState();
}


class _AddCategoryDialogState extends State<AddCategoryDialog> {
  TextEditingController category = TextEditingController();
  var projectValue, probability, distList, contList, quoteStatus;

  final snackBar1 = const SnackBar(
    content: Text('Please fill all the Required fields!'),
    backgroundColor: Colors.red,
  );

  final snackBar3 = const SnackBar(
    content: Text('Product Category Added Successfully'),
    backgroundColor: Colors.green,
  );

  final snackBar4 = const SnackBar(
    content: Text('Something Went Wrong!'),
    backgroundColor: Colors.red,
  );

  var apiClient = RemoteServices();
  bool loading = false;
  List<String> employees = [], clients = [], projects = [],selectedClients = [];
  Map<String, String> empMap = {}, clientMap = {};
  List<String> list = [], clientList = [];
  Map<String,int> projectsMap ={};

  @override
  void initState() {
    super.initState();

    // _getData();
  }



  void postData() async {
    try{
      setState(() {
        loading = false;
      });

      if (validate() == true) {

        dynamic res = await apiClient.addProductCategory(category.text);

        if(res?["success"]==true) {
          // if(true){
          Navigator.pop(context,true);
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
        loading = true;
      });

      await Future.delayed(Duration(seconds: 2));
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
    }
  }
  bool validate() {
    if(category.text=="" ){
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
        title: const Text("Add Product Category"),
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
                hintText: "Category Name*",
                hintStyle:
                TextStyle(color: Color.fromRGBO(255, 255, 255, 0.5))),
          ),
          const SizedBox(
            height: 20,
          ),

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