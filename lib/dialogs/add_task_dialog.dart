import 'package:crm/services/remote_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:intl/intl.dart';

class AddTaskDialog extends StatefulWidget {
  const AddTaskDialog({super.key});

  @override
  State<StatefulWidget> createState() => _AddTaskDialogState();
}

class _AddTaskDialogState extends State<AddTaskDialog> {
  TextEditingController title = TextEditingController();
  TextEditingController priority = TextEditingController();
  TextEditingController percent = TextEditingController();
  TextEditingController assignedToName = TextEditingController();
  var assignedToId;
  TextEditingController description = TextEditingController();
  TextEditingController startDate = TextEditingController();
  TextEditingController dueDate = TextEditingController();
  TextEditingController attachments = TextEditingController();

  final snackBar2 = const SnackBar(
    content: Text('Please fill all the Required fields!'),
    backgroundColor: Colors.red,
  );

  final snackBar3 = const SnackBar(
    content: Text('Task Added Successfully'),
    backgroundColor: Colors.green,
  );

  final snackBar1 = const SnackBar(
    content: Text('Something Went Wrong!'),
    backgroundColor: Colors.red,
  );

  RemoteServices apiClient = RemoteServices();
  bool dataLoaded = false;
  List<String> employees = [];
  Map<String, int> employeeMap = {};

  @override
  void initState() {
    super.initState();

    _getData();
  }

  void _getData() async {
    try {
      dynamic res = await apiClient.getAllEmployeeNames();

      for (var e in res["res"]) {
        employees.add(e["Full_Name"]);
        employeeMap[e["Full_Name"]] = e["Employee_ID"];
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(snackBar1);
    } finally {
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
        dynamic res = await apiClient.addTask(title.text, priority.text, assignedToId, description.text, startDate.text, dueDate.text, attachments.text);

        if(res["success"] == true){
          ScaffoldMessenger.of(context).showSnackBar(snackBar3);
          Navigator.pop(context, true);
        }else{
          throw "Negative";
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
    if (title.text == "" ||
        assignedToName.text == "" ||
        priority.text == "" ||
        startDate.text == "" ||
        dueDate.text == "") {
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
        title: const Text("Add Task"),
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
                assignedToName.text = suggestion.toString();
                assignedToId = employeeMap[assignedToName.text];
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

              for (var e in employees) {
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
                controller: assignedToName,
                decoration: const InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white)),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white)),
                    hintText: "Employee",
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
            controller: title,
            decoration: const InputDecoration(
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white)),
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white)),
                hintText: "Title*",
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
            controller: priority,
            decoration: const InputDecoration(
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white)),
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white)),
                hintText: "Priority*",
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
            keyboardType: TextInputType.datetime,
            readOnly: true,
            onTap: () async {
              showDatePicker(
                  context: context,
                  initialDate: startDate.text == ""
                      ? DateTime.now()
                      : DateTime.parse(startDate.text),
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
                  startDate.text = value != null
                      ? DateFormat('yyyy-MM-dd').format(value)
                      : startDate.text;
                });
              });
            },
            controller: startDate,
            decoration: const InputDecoration(
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white)),
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white)),
                hintText: "Start Date*",
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
            padding: EdgeInsets.fromLTRB(100, 0, 100, 0),
            child: ElevatedButton(
              onPressed: () {
                _postData();
              },
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
