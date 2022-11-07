import 'package:crm/dialogs/add_project_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:crm/admin/projects.dart';

class FilterProjectDialog extends StatefulWidget{
  List<String> cat;
  int price=0;
  FilterProjectDialog({Key? key, required this.cat, required this.price}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _FilterProjectDialogState(cat: cat,price: price);
}

class _FilterProjectDialogState extends State<FilterProjectDialog> {
  TextEditingController teamMembers = TextEditingController();
  TextEditingController projectManager = TextEditingController();
  List<String> cat;
  int price=0;
  List<String> prev = [];
  int prevPrice = 0;
  int abc = 0;
  bool dataLoaded = false;

  _FilterProjectDialogState(
      {required this.cat, required this.price}) {
    prev.addAll(cat);
    prevPrice = price;
  }


  @override
  Widget build(context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
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

  Widget switching() {
    switch (abc) {
      case 0:
        return Container(
          height: MediaQuery
              .of(context)
              .size
              .height,
          width: MediaQuery
              .of(context)
              .size
              .width - 150,
          child: Column(
            children: [
              Row(
                children: [
                  Checkbox(
                    value: cat.contains("Storm Water"), onChanged: (value) {
                    setState(() {
                      if (value!) {
                        cat.add("Storm Water");
                      } else if (cat.contains("Storm Water")) {
                        cat.remove("Storm Water");
                      }
                    });
                  },
                    activeColor: const Color.fromRGBO(134, 97, 255, 1),
                    overlayColor: MaterialStateProperty.all<Color>(
                        const Color.fromRGBO(134, 97, 255, 1)
                    ),
                  ),
                  Text("Storm Water", style: TextStyle(color: Colors.white),)
                ],
              ),
              Row(
                children: [
                  Checkbox(
                    value: cat.contains("Traffic"), onChanged: (value) {
                    setState(() {
                      if (value!) {
                        cat.add("Traffic");
                      } else if (cat.contains("Traffic")) {
                        cat.remove("Traffic");
                      }
                    });
                  },
                    activeColor: const Color.fromRGBO(134, 97, 255, 1),
                    overlayColor: MaterialStateProperty.all<Color>(
                        const Color.fromRGBO(134, 97, 255, 1)
                    ),
                  ),
                  Text("Traffic", style: TextStyle(color: Colors.white),)
                ],
              ),
              Row(
                children: [
                  Checkbox(
                    value: cat.contains("Transportation"), onChanged: (value) {
                    setState(() {
                      if (value!) {
                        cat.add("Transportation");
                      } else if (cat.contains("Transportation")) {
                        cat.remove("Transportation");
                      }
                    });
                  },
                    activeColor: const Color.fromRGBO(134, 97, 255, 1),
                    overlayColor: MaterialStateProperty.all<Color>(
                        const Color.fromRGBO(134, 97, 255, 1)
                    ),
                  ),
                  Text("Transportation", style: TextStyle(color: Colors.white),)
                ],
              ),
              Row(
                children: [
                  Checkbox(
                    value: cat.contains("Site Plan"), onChanged: (value) {
                    setState(() {
                      if (value!) {
                        cat.add("Site Plan");
                      } else if (cat.contains("Site Plan")) {
                        cat.remove("Site Plan");
                      }
                    });
                  },
                    activeColor: const Color.fromRGBO(134, 97, 255, 1),
                    overlayColor: MaterialStateProperty.all<Color>(
                        const Color.fromRGBO(134, 97, 255, 1)
                    ),
                  ),
                  Text("Site Plan", style: TextStyle(color: Colors.white),)
                ],
              ),
              Row(
                children: [
                  Checkbox(value: cat.contains("Land Development"), onChanged: (value) {
                    setState(() {
                      if (value!) {
                        cat.add("Land Development");
                      } else if (cat.contains("Land Development")) {
                        cat.remove("Land Development");
                      }
                    });
                  },
                    activeColor: const Color.fromRGBO(134, 97, 255, 1),
                    overlayColor: MaterialStateProperty.all<Color>(
                        const Color.fromRGBO(134, 97, 255, 1)
                    ),
                  ),
                  Text("Land Development", style: TextStyle(color: Colors.white),)
                ],
              ),
              Row(
                children: [
                  Checkbox(
                    value: cat.contains("Proposal"), onChanged: (value) {
                    setState(() {
                      if (value!) {
                        cat.add("Proposal");
                      } else if (cat.contains("Proposal")) {
                        cat.remove("Proposal");
                      }
                    });
                  },
                    activeColor: const Color.fromRGBO(134, 97, 255, 1),
                    overlayColor: MaterialStateProperty.all<Color>(
                        const Color.fromRGBO(134, 97, 255, 1)
                    ),
                  ),
                  Text("Proposal", style: TextStyle(color: Colors.white),)
                ],
              ),
              Row(
                children: [
                  Checkbox(value: cat.contains("IT"), onChanged: (value) {
                    setState(() {
                      if (value!) {
                        cat.add("IT");
                      } else if (cat.contains("IT")) {
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
              Row(
                children: [
                  Checkbox(value: cat.contains("Take-Off"), onChanged: (value) {
                    setState(() {
                      if (value!) {
                        cat.add("Take-Off");
                      } else if (cat.contains("Take-Off")) {
                        cat.remove("Take-Off");
                      }
                    });
                  },
                    activeColor: const Color.fromRGBO(134, 97, 255, 1),
                    overlayColor: MaterialStateProperty.all<Color>(
                        const Color.fromRGBO(134, 97, 255, 1)
                    ),
                  ),
                  Text("Take-Off", style: TextStyle(color: Colors.white),)
                ],
              ),
              Row(
                children: [
                  Checkbox(value: cat.contains("Data Mining"), onChanged: (value) {
                    setState(() {
                      if (value!) {
                        cat.add("Data Mining");
                      } else if (cat.contains("Data Mining")) {
                        cat.remove("Data Mining");
                      }
                    });
                  },
                    activeColor: const Color.fromRGBO(134, 97, 255, 1),
                    overlayColor: MaterialStateProperty.all<Color>(
                        const Color.fromRGBO(134, 97, 255, 1)
                    ),
                  ),
                  Text("Data Mining", style: TextStyle(color: Colors.white),)
                ],
              ),
              Row(
                children: [
                  Checkbox(value: cat.contains("Smart Infra"), onChanged: (value) {
                    setState(() {
                      if (value!) {
                        cat.add("Smart Infra");
                      } else if (cat.contains("Smart Infra")) {
                        cat.remove("Smart Infra");
                      }
                    });
                  },
                    activeColor: const Color.fromRGBO(134, 97, 255, 1),
                    overlayColor: MaterialStateProperty.all<Color>(
                        const Color.fromRGBO(134, 97, 255, 1)
                    ),
                  ),
                  Text("Smart Infra", style: TextStyle(color: Colors.white),)
                ],
              ),
              Row(
                children: [
                  Checkbox(value: cat.contains("Marketing"), onChanged: (value) {
                    setState(() {
                      if (value!) {
                        cat.add("Marketing");
                      } else if (cat.contains("Marketing")) {
                        cat.remove("Marketing");
                      }
                    });
                  },
                    activeColor: const Color.fromRGBO(134, 97, 255, 1),
                    overlayColor: MaterialStateProperty.all<Color>(
                        const Color.fromRGBO(134, 97, 255, 1)
                    ),
                  ),
                  Text("Marketing", style: TextStyle(color: Colors.white),)
                ],
              ),

            ],
          ),
        );
        break;

      case 1:
        return Container(
          height: MediaQuery
              .of(context)
              .size
              .height,
          width: MediaQuery
              .of(context)
              .size
              .width - 150,
          child: Column(
            children: [

              Row(
                children: [
                  Checkbox(
                    value: !(price!=0||price!=200000||price!=500000||price!=1000000||price!=2000000||price!=5000000), onChanged: (value) {
                    setState(() {
                      if (value!) {
                        price=100000;
                      } else  {
                        price=0;
                      }
                      print(price);
                    });
                  },
                    activeColor: const Color.fromRGBO(134, 97, 255, 1),
                    overlayColor: MaterialStateProperty.all<Color>(
                        const Color.fromRGBO(134, 97, 255, 1)
                    ),
                  ),
                  Text(
                    "100000-200000", style: TextStyle(color: Colors.white),)
                ],
              ),
              Row(
                children: [
                  Checkbox(
                    value: !(price!=0||price!=100000||price!=500000||price!=1000000||price!=2000000||price!=5000000), onChanged: (value) {
                    setState(() {
                      if (value!) {
                        price=200000;
                      } else {
                        price=0;
                      }
                    });
                  },
                    activeColor: const Color.fromRGBO(134, 97, 255, 1),
                    overlayColor: MaterialStateProperty.all<Color>(
                        const Color.fromRGBO(134, 97, 255, 1)
                    ),
                  ),
                  Text(
                    "200000-500000", style: TextStyle(color: Colors.white),)
                ],
              ),
              Row(
                children: [
                  Checkbox(
                    value: !(price!=0||price!=100000||price!=200000||price!=1000000||price!=2000000||price!=5000000), onChanged: (value) {
                    setState(() {
                      if (value!) {
                        price=500000;
                      } else  {
                        price=0;
                      }
                    });
                  },
                    activeColor: const Color.fromRGBO(134, 97, 255, 1),
                    overlayColor: MaterialStateProperty.all<Color>(
                        const Color.fromRGBO(134, 97, 255, 1)
                    ),
                  ),
                  Text(
                    "500000-1 million", style: TextStyle(color: Colors.white),)
                ],
              ),

              Row(
                children: [
                  Checkbox(
                    value: !(price!=0||price!=100000||price!=500000||price!=200000||price!=2000000||price!=5000000), onChanged: (value) {
                    setState(() {
                      if (value!) {
                        price=1000000;
                      } else  {
                        price=0;
                      }
                    });
                  },
                    activeColor: const Color.fromRGBO(134, 97, 255, 1),
                    overlayColor: MaterialStateProperty.all<Color>(
                        const Color.fromRGBO(134, 97, 255, 1)
                    ),
                  ),
                  Text(
                    "1 million - 2 million", style: TextStyle(color: Colors.white),)
                ],
              ),
              Row(
                children: [
                  Checkbox(value: !(price!=0||price!=100000||price!=500000||price!=1000000||price!=200000||price!=5000000), onChanged: (value) {
                    setState(() {
                      if (value!) {
                        price=2000000;
                      } else  {
                        price=0;
                      }
                    });
                  },
                    activeColor: const Color.fromRGBO(134, 97, 255, 1),
                    overlayColor: MaterialStateProperty.all<Color>(
                        const Color.fromRGBO(134, 97, 255, 1)
                    ),
                  ),
                  Text(
                    "2 million -5 million", style: TextStyle(color: Colors.white),)
                ],
              ),
              Row(
                children: [
                  Checkbox(value: !(price!=0||price!=100000||price!=500000||price!=1000000||price!=2000000||price!=200000), onChanged: (value) {
                    setState(() {
                      if (value!) {
                        price=5000000;
                      } else  {
                        price=0;
                      }
                    });
                  },
                    activeColor: const Color.fromRGBO(134, 97, 255, 1),
                    overlayColor: MaterialStateProperty.all<Color>(
                        const Color.fromRGBO(134, 97, 255, 1)
                    ),
                  ),
                  Text(
                    "More than 5 million", style: TextStyle(color: Colors.white),)
                ],
              ),
            ],
          ),
        );
    }
    return Text("hi");
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
                    abc = 0;
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
                // TextButton(
                //   onPressed: () {
                //     abc = 1;
                //     setState(() {
                //
                //     });
                //   },
                //   child: Text("Price", style: TextStyle(color: Colors.white,
                //       fontWeight: FontWeight.bold,
                //       fontSize: 18),),
                //   style: ButtonStyle(
                //       textStyle: MaterialStateProperty.all<TextStyle>(
                //           TextStyle(color: Colors.white)
                //       )
                //   ),
                // ),
                // Divider(
                //   color: const Color.fromRGBO(41, 41, 41, 1),
                //   thickness: 1.0,
                // ),
              ],
            ),
          ),
          switching(),
        ],
      ),
    );
  }
}