import 'package:flutter/material.dart';

class FilterEmployeeDialog extends StatefulWidget{
  List<String> cat;
  FilterEmployeeDialog({Key? key, required this.cat}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _FilterEmployeeDialogState(cat: cat);
}

class _FilterEmployeeDialogState extends State<FilterEmployeeDialog>{
  List<String> cat;
  List<String> prev = [];

  _FilterEmployeeDialogState({required this.cat}) {
    prev.addAll(cat);
  }

  @override
  Widget build(context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          child: Icon(Icons.close),
          onTap: () => Navigator.pop(context, prev),
        ),
        title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Center(child: Text("Filter List")),
              GestureDetector(
                  onTap: () async {
                    Navigator.pop(context, cat);
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
      body: body(),
    );
  }

  Widget body() {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Row(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            width: 150,
            color: Colors.black,
            child: Column(
              children: [
                TextButton(
                  onPressed: () {

                  },
                  child: Text("Category", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),),
                  style: ButtonStyle(
                      textStyle: MaterialStateProperty.all<TextStyle>(
                          TextStyle(color: Colors.white)
                      )
                  ),
                ),
                Divider(
                  color: const Color.fromRGBO(41, 41, 41, 1),
                  thickness: 1.0,
                )
              ],
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width - 150,
            child: Column(
              children: [
                Row(
                  children: [
                    Checkbox(
                      value: cat.contains("Admin"),
                      onChanged: (value) {
                        setState(() {
                          if(value!){
                            cat.add("Admin");
                          }else if(cat.contains("Admin")){
                            cat.remove("Admin");
                          }
                        });
                      },
                      activeColor: const Color.fromRGBO(134, 97, 255, 1),
                      overlayColor: MaterialStateProperty.all<Color>(
                          const Color.fromRGBO(134, 97, 255, 1)
                      ),
                    ),
                    Text("Admin", style: TextStyle(color: Colors.white),)
                  ],
                ),
                Row(
                  children: [
                    Checkbox(
                      value: cat.contains("Engineer"),
                      onChanged: (value) {
                      setState(() {
                        if(value!){
                          cat.add("Engineer");
                        }else if(cat.contains("Engineer")){
                          cat.remove("Engineer");
                        }
                      });
                    },
                      activeColor: const Color.fromRGBO(134, 97, 255, 1),
                      overlayColor: MaterialStateProperty.all<Color>(
                          const Color.fromRGBO(134, 97, 255, 1)
                      ),
                    ),
                    Text("Engineer", style: TextStyle(color: Colors.white),)
                  ],
                ),
                Row(
                  children: [
                    Checkbox(
                      value: cat.contains("Logistics"),
                      onChanged: (value) {
                      setState(() {
                        if(value!){
                          cat.add("Logistics");
                        }else if(cat.contains("Logistics")){
                          cat.remove("Logistics");
                        }
                      });
                    },
                      activeColor: const Color.fromRGBO(134, 97, 255, 1),
                      overlayColor: MaterialStateProperty.all<Color>(
                          const Color.fromRGBO(134, 97, 255, 1)
                      ),
                    ),
                    Text("Logistics", style: TextStyle(color: Colors.white),)
                  ],
                ),
                Row(
                  children: [
                    Checkbox(
                      value: cat.contains("Manager"),
                      onChanged: (value) {
                        setState(() {
                          if(value!){
                            cat.add("Manager");
                          }else if(cat.contains("Manager")){
                            cat.remove("Manager");
                          }
                        });
                      },
                      activeColor: const Color.fromRGBO(134, 97, 255, 1),
                      overlayColor: MaterialStateProperty.all<Color>(
                          const Color.fromRGBO(134, 97, 255, 1)
                      ),
                    ),
                    Text("Manager", style: TextStyle(color: Colors.white),)
                  ],
                ),
                Row(
                  children: [
                    Checkbox(
                      value: cat.contains("Sales"),
                      onChanged: (value) {
                        setState(() {
                          if(value!){
                            cat.add("Sales");
                          }else if(cat.contains("Sales")){
                            cat.remove("Sales");
                          }
                        });
                      },
                      activeColor: const Color.fromRGBO(134, 97, 255, 1),
                      overlayColor: MaterialStateProperty.all<Color>(
                          const Color.fromRGBO(134, 97, 255, 1)
                      ),
                    ),
                    Text("Sales", style: TextStyle(color: Colors.white),)
                  ],
                ),
                Row(
                  children: [
                    Checkbox(
                      value: cat.contains("Supplier"),
                      onChanged: (value) {
                        setState(() {
                          if(value!){
                            cat.add("Supplier");
                          }else if(cat.contains("Supplier")){
                            cat.remove("Supplier");
                          }
                        });
                      },
                      activeColor: const Color.fromRGBO(134, 97, 255, 1),
                      overlayColor: MaterialStateProperty.all<Color>(
                          const Color.fromRGBO(134, 97, 255, 1)
                      ),
                    ),
                    Text("Supplier", style: TextStyle(color: Colors.white),)
                  ],
                ),
                Row(
                  children: [
                    Checkbox(
                      value: cat.contains("IT"),
                      onChanged: (value) {
                        setState(() {
                          if(value!){
                            cat.add("IT");
                          }else if(cat.contains("IT")){
                            cat.remove("IT");
                          }
                        });
                      },
                      activeColor: const Color.fromRGBO(134, 97, 255, 1),
                      overlayColor: MaterialStateProperty.all<Color>(
                          const Color.fromRGBO(134, 97, 255, 1)
                      ),
                    ),
                    Text("IT", style: TextStyle(color: Colors.white),)
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}