import 'package:crm/services/remote_services.dart';
import 'package:flutter/material.dart';

class FilterProjectDialog extends StatefulWidget{
  List<String> cat, dept, prevCat, prevDept;

  FilterProjectDialog({Key? key, required this.cat, required this.dept, required this.prevCat, required this.prevDept}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _FilterProjectDialogState(cats: cat, depts: dept, prevCat: prevCat, prevDept: prevDept);
}

class _FilterProjectDialogState extends State<FilterProjectDialog> {
  List<String> selectedDept = [], selectedCat = [];
  List<String> prevDept, prevCat;
  int switcher = 0;
  List<String> depts = [], cats = [];

  final snackBar1 = const SnackBar(
    content: Text('Something Went Wrong!'),
    backgroundColor: Colors.red,
  );

  _FilterProjectDialogState(
      {required this.depts, required this.cats, required this.prevCat, required this.prevDept}){
    selectedCat = prevCat;
    selectedDept = prevDept;
  }

  @override
  Widget build(context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        leading: GestureDetector(
          child: Icon(Icons.close),
          onTap: () => Navigator.pop(context, {"Departments" : prevDept, "Categories" : prevCat}),
        ),
        title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Center(child: Text("Filter List")),
              GestureDetector(
                  onTap: (){
                    Navigator.pop(context, {"Departments" : selectedDept, "Categories" : selectedCat});
                  },
                  child: const Icon(
                    Icons.check,
                    size: 30,
                  )
              )
            ]

        ),
        titleTextStyle: const TextStyle(
            color: Colors.white,
            fontSize: 24
        ),
        backgroundColor: Colors.black,
      ),
      backgroundColor: const Color.fromRGBO(41, 41, 41, 1),
      body: body()
    );
  }

  Widget body() {
    return Container(
      width: MediaQuery
          .of(context)
          .size
          .width,
      child: Row(
        children: [
          Container(
            height: MediaQuery
                .of(context)
                .size
                .height,
            width: 150,
            color: Colors.black,
            child: Column(
              children: [
                TextButton(
                  onPressed: () {
                    switcher = 0;
                    setState(() {

                    });
                  },
                  child: Text("Department", style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18),),
                  style: ButtonStyle(
                      textStyle: MaterialStateProperty.all<TextStyle>(
                          TextStyle(color: Colors.white)
                      )
                  ),
                ),
                Divider(
                  color: const Color.fromRGBO(41, 41, 41, 1),
                  thickness: 1.0,
                ),
                TextButton(
                  onPressed: () {
                    switcher = 1;
                    setState(() {

                    });
                  },
                  child: Text("Categories", style: TextStyle(color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18),),
                  style: ButtonStyle(
                      textStyle: MaterialStateProperty.all<TextStyle>(
                          TextStyle(color: Colors.white)
                      )
                  ),
                ),
                Divider(
                  color: const Color.fromRGBO(41, 41, 41, 1),
                  thickness: 1.0,
                ),
              ],
            ),
          ),
          switching(),
        ],
      ),
    );
  }

  Widget switching() {
    switch (switcher) {
      case 0:
        return departments();
      case 1:
        return categories();
    }
    return Text("hi");
  }

  Widget departments() {
    return Container(
      height: MediaQuery
          .of(context)
          .size
          .height,
      width: MediaQuery
          .of(context)
          .size
          .width - 150,
      child: ListView(
        children: depts.map<Widget>((e) {
          return Row(
            children: [
                Checkbox(
                  value: selectedDept.contains(e), onChanged: (value) {
                  setState(() {
                    if (value!) {
                      selectedDept.add(e);
                    } else if (selectedDept.contains(e)) {
                      selectedDept.remove(e);
                    }
                  });
                },
                  activeColor: const Color.fromRGBO(134, 97, 255, 1),
                  overlayColor: MaterialStateProperty.all<Color>(
                      const Color.fromRGBO(134, 97, 255, 1)
                  ),
                ),
                Text(e, style: TextStyle(color: Colors.white),)
              ],
          );
        }).toList()
      ),
    );
  }

  Widget categories() {
    return Container(
      height: MediaQuery
          .of(context)
          .size
          .height,
      width: MediaQuery
          .of(context)
          .size
          .width - 150,
      child: ListView(
          children: cats.map<Widget>((e) {
            return Row(
              children: [
                Checkbox(
                  value: selectedCat.contains(e), onChanged: (value) {
                  setState(() {
                    if (value!) {
                      selectedCat.add(e);
                    } else if (selectedCat.contains(e)) {
                      selectedCat.remove(e);
                    }
                  });
                },
                  activeColor: const Color.fromRGBO(134, 97, 255, 1),
                  overlayColor: MaterialStateProperty.all<Color>(
                      const Color.fromRGBO(134, 97, 255, 1)
                  ),
                ),
                Text(e, style: TextStyle(color: Colors.white),)
              ],
            );
          }).toList()
      ),
    );
  }
}