import 'package:crm/admin/drawer.dart';
import 'package:crm/services/remote_services.dart';
import 'package:flutter/material.dart';

class Budgets extends StatefulWidget{
  const Budgets({super.key});

  @override
  State<StatefulWidget> createState() => _BudgetsState();
}

class _BudgetsState extends State<Budgets>{
  var apiClient = RemoteServices();
  TextEditingController searchController = TextEditingController();
  bool dataLoaded = false;
  final snackBar1 = const SnackBar(
    content: Text('Something Went Wrong'),
    backgroundColor: Colors.red,
  );

  List<Map<String, dynamic>> budgets = [], search = [];

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
      dynamic res = await apiClient.getAllEmployees();
      budgets.clear();
      search.clear();

      for (var i = 0; i < res["res"].length; i++) {
        var e = res["res"][i];

        Map<String, dynamic> mp = {};

        budgets.add(mp);
        search.add(mp);
      }

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(snackBar1);
    } finally {
      setState(() {
        dataLoaded = true;
      });

      await Future.delayed(Duration(seconds: 2));
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
    }
  }

  void _onSearchChanged(String text) async {
    setState(() {
      dataLoaded = false;
    });
    search.clear();

    if (text.isEmpty) {
      search.addAll(budgets);
    } else {
      budgets.forEach((e) {
        if ((e["firstName"] + " " + e["lastName"])
            .toString()
            .toLowerCase()
            .contains(text.toLowerCase())) {
          search.add(e);
        }
      });
    }

    setState(() {
      dataLoaded = true;
    });
  }

  @override
  Widget build(context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Budgets"),
          titleTextStyle: const TextStyle(color: Colors.white, fontSize: 24),
          backgroundColor: Colors.black,
        ),
        drawer: const NavDrawerWidget(
          name: '/budgets',
        ),
        body: dashboard());
  }

  Widget dashboard() {
    return Container(
        color: const Color.fromRGBO(0, 0, 0, 1),
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5.0),
            child: Column(
              children: [
                Container(
                    width: MediaQuery.of(context).size.width - 10,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [searchBar()],
                    )),
                Visibility(
                    replacement: const Center(
                      child: CircularProgressIndicator(
                        color: Color.fromRGBO(134, 97, 255, 1),
                      ),
                    ),
                    visible: dataLoaded,
                    child: search.isEmpty
                        ? const Center(
                      child: Text(
                        "No Employees Found",
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                        : Expanded(
                      child: ListView.builder(
                        itemCount: search.length,
                        prototypeItem: ListCard(search.first),
                        itemBuilder: (context, index) {
                          return ListCard(search[index]);
                        },
                      ),
                    ))
              ],
            )));
  }

  Widget searchBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
      width: 300,
      child: TextField(
          cursorColor: Colors.white,
          controller: searchController,
          onChanged: _onSearchChanged,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.search,
              color: Colors.white,
            ),
            hintText: "Search",
            hintStyle:
            const TextStyle(color: Color.fromRGBO(255, 255, 255, 0.5)),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(40.0),
                borderSide: const BorderSide(color: Colors.white)),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(40.0),
                borderSide: const BorderSide(color: Colors.white)),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(40.0),
                borderSide: const BorderSide(color: Colors.white)),
          )),
    );
  }

  Widget ListCard(Map<String, dynamic> mp) {
    return Card(
      color: const Color.fromRGBO(0, 0, 0, 0),
      child: Container(
        height: 226,
        width: MediaQuery.of(context).size.width - 20,
        alignment: Alignment.centerLeft,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: const Color.fromRGBO(41, 41, 41, 1),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              //   Row(
              //     mainAxisAlignment: MainAxisAlignment.start,
              //     children: [
              //       const Text(
              //         "Employee ID : ",
              //         style: TextStyle(
              //             color: Color.fromRGBO(134, 97, 255, 1),
              //             fontSize: 18,
              //             fontWeight: FontWeight.bold),
              //       ),
              //       Text(
              //         mp["id"].toString(),
              //         style: const TextStyle(color: Colors.white, fontSize: 18),
              //       ),
              //     ],
              //   ),
              //   GestureDetector(
              //     onTap: () => null,
              //     child: Icon(
              //       Icons.edit,
              //       color: Color.fromRGBO(134, 97, 255, 1),
              //     ),
              //   )
              // ]),
              // const SizedBox(
              //   height: 5,
              // ),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.start,
              //   children: [
              //     const Text(
              //       "Name : ",
              //       style: TextStyle(
              //           color: Color.fromRGBO(134, 97, 255, 1),
              //           fontSize: 18,
              //           fontWeight: FontWeight.bold),
              //     ),
              //     Flexible(
              //       child: Text(
              //         "${mp["salutation"] == "None" ? "" : "${mp["salutation"]} "}${mp["firstName"]}${mp["lastName"] == "" ? "" : " ${mp["lastName"]}"}",
              //         style: const TextStyle(color: Colors.white, fontSize: 18),
              //         softWrap: false,
              //         overflow: TextOverflow.fade,
              //       ),
              //       fit: FlexFit.loose,
              //     )
              //   ],
              // ),
              // const SizedBox(
              //   height: 5,
              // ),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.start,
              //   children: [
              //     const Text(
              //       "Department : ",
              //       style: TextStyle(
              //           color: Color.fromRGBO(134, 97, 255, 1),
              //           fontSize: 18,
              //           fontWeight: FontWeight.bold),
              //     ),
              //     Text(
              //       mp["department"],
              //       style: const TextStyle(color: Colors.white, fontSize: 18),
              //     ),
              //   ],
              // ),
              // const SizedBox(
              //   height: 5,
              // ),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.start,
              //   children: [
              //     const Text(
              //       "Direct Manager : ",
              //       style: TextStyle(
              //           color: Color.fromRGBO(134, 97, 255, 1),
              //           fontSize: 18,
              //           fontWeight: FontWeight.bold),
              //     ),
              //     Text(
              //       mp["directManager"],
              //       style: const TextStyle(color: Colors.white, fontSize: 18),
              //     ),
              //   ],
              // ),
              // const SizedBox(
              //   height: 5,
              // ),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.start,
              //   children: [
              //     const Text(
              //       "Email : ",
              //       style: TextStyle(
              //           color: Color.fromRGBO(134, 97, 255, 1),
              //           fontSize: 18,
              //           fontWeight: FontWeight.bold),
              //     ),
              //     Flexible(
              //       child: Text(
              //         mp["emailWork"],
              //         style: const TextStyle(color: Colors.white, fontSize: 18),
              //         softWrap: false,
              //         overflow: TextOverflow.fade,
              //       ),
              //       fit: FlexFit.loose,
              //     )
              //   ],
              // ),
              // const SizedBox(
              //   height: 5,
              // ),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.start,
              //   children: [
              //     const Text(
              //       "Job Title : ",
              //       style: TextStyle(
              //           color: Color.fromRGBO(134, 97, 255, 1),
              //           fontSize: 18,
              //           fontWeight: FontWeight.bold),
              //     ),
              //     Flexible(
              //       child: Text(
              //         mp["jobTitle"],
              //         style: const TextStyle(color: Colors.white, fontSize: 18),
              //         softWrap: false,
              //         overflow: TextOverflow.fade,
              //       ),
              //       fit: FlexFit.loose,
              //     )
              //   ],
              // ),
              // const SizedBox(
              //   height: 5,
              // ),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.start,
              //   children: [
              //     const Text(
              //       "Phone : ",
              //       style: TextStyle(
              //           color: Color.fromRGBO(134, 97, 255, 1),
              //           fontSize: 18,
              //           fontWeight: FontWeight.bold),
              //     ),
              //     Text(
              //       mp["business"],
              //       style: const TextStyle(color: Colors.white, fontSize: 18),
              //     ),
              //   ],
              // ),
              // const SizedBox(
              //   height: 5,
              // ),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.start,
              //   children: [
              //     const Text(
              //       "City : ",
              //       style: TextStyle(
              //           color: Color.fromRGBO(134, 97, 255, 1),
              //           fontSize: 18,
              //           fontWeight: FontWeight.bold),
              //     ),
              //     Text(
              //       mp["city"],
              //       style: const TextStyle(color: Colors.white, fontSize: 18),
              //     ),
              //   ],
              // ),
            ],
          ),
        ),
      ),
    );
  }
}