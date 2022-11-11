import 'package:crm/admin/drawer.dart';
import 'package:crm/dialogs/filter_employee_dialog.dart';
import 'package:crm/dialogs/filter_project_dialog.dart';
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
  bool dataLoaded = false, filtersLoaded = false;
  final snackBar1 = const SnackBar(
    content: Text('Something Went Wrong'),
    backgroundColor: Colors.red,
  );

  List<Map<String, dynamic>> budgets = [], search = [], filtered = [];
  List<String> selectedCat = [], selectedDept = [], dept = [], cat = [];

  @override
  void initState() {
    super.initState();
    _getData();
    _getFilters();
  }

  void _getData() async {
    try {
      setState(() {
        dataLoaded = false;
      });
      dynamic res = await apiClient.getBudgets();
      budgets.clear();

      for (var i = 0; i < res["res"].length; i++) {
        var e = res["res"][i];

        Map<String, dynamic> mp = {};

        mp["budgetId"] = e["Budget_ID"];
        mp["cityId"] = e["City_ID"];
        mp["departmentId"] = e["Department_ID"];
        mp["projectCatId"] = e["Project_Cat_ID"];
        mp["projectName"] = e["Project_Name"] ?? "";
        mp["budgetCategory"] = e["Budget_Category"] ?? "";
        mp["budgetAmount"] = e["Budget_Amount"] ?? "0";
        mp["city"] = e["City"];
        mp["province"] = e["Province"];
        mp["country"] = e["Country"];
        mp["department"] = e["Department"];
        mp["projectCategory"] = e["Project_Category"];

        budgets.add(mp);
        search.add(mp);
        filtered.add(mp);
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

  void _getFilters() async {
    try{
      setState(() {
        filtersLoaded = false;
      });

      dynamic res = await apiClient.getDepartments();
      dynamic res2 = await apiClient.getProjectCategories();

      for(var e in res["res"]){
        dept.add(e["Department"]);
      }

      for(var e in res2["res"]){
        cat.add(e["Project_Category"]);
      }
    } catch(e) {
      ScaffoldMessenger.of(context).showSnackBar(snackBar1);
    } finally{
      setState(() {
        filtersLoaded = true;
      });

      await Future.delayed(const Duration(seconds: 2));
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
    }
  }

  void _onSearchChanged(String text) async {
    setState(() {
      dataLoaded = false;
    });
    search.clear();

    if (text.isEmpty) {
      search.addAll(filtered);
    } else {
      filtered.forEach((e) {
        if (e["projectName"]
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
                      children: [searchBar(), filterButton()],
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
                        "No Budgets Found",
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

  Widget filterButton() {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
      child: ElevatedButton(
        onPressed: !filtersLoaded ? null : () {
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
                  FilterProjectDialog(cat: cat, dept: dept, prevCat: selectedCat, prevDept: selectedDept)).then((value) {
            filtered.clear();
            Map<String, List<String>> mp = value as Map<String, List<String>>;

            selectedCat = mp["Categories"] ?? [];
            selectedDept = mp["Departments"] ?? [];

            if (selectedDept.isEmpty && selectedCat.isEmpty) {
              filtered.addAll(budgets);
            } else {
              budgets.forEach((e) {
                if (selectedCat.contains(e["projectCategory"]) || selectedDept.contains(e["department"])) {
                  filtered.add(e);
                }
              });
            }

            _onSearchChanged(searchController.text);
          });
        },
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(
                const Color.fromRGBO(134, 97, 255, 1)),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40.0),
                ))),
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Icon(Icons.filter_alt),
        ),
      ),
    );
  }

  Widget ListCard(Map<String, dynamic> mp) {
    return Card(
      color: const Color.fromRGBO(0, 0, 0, 0),
      child: Container(
        height: 200,
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
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Text(
                      "Budget ID : ",
                      style: TextStyle(
                          color: Color.fromRGBO(134, 97, 255, 1),
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      mp["budgetId"].toString(),
                      style: const TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () => null,
                  child: Icon(
                    Icons.edit,
                    color: Color.fromRGBO(134, 97, 255, 1),
                  ),
                )
              ]),
              const SizedBox(
                height: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Text(
                    "Design/Product : ",
                    style: TextStyle(
                        color: Color.fromRGBO(134, 97, 255, 1),
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  Flexible(
                    fit: FlexFit.loose,
                    child: Text(
                      mp["budgetCategory"],
                      style: const TextStyle(color: Colors.white, fontSize: 18),
                      softWrap: false,
                      overflow: TextOverflow.fade,
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Text(
                    "City : ",
                    style: TextStyle(
                        color: Color.fromRGBO(134, 97, 255, 1),
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  Flexible(
                    fit: FlexFit.loose,
                    child: Text(
                      mp["city"],
                      style: const TextStyle(color: Colors.white, fontSize: 18),
                      softWrap: false,
                      overflow: TextOverflow.fade,
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Text(
                    "Department : ",
                    style: TextStyle(
                        color: Color.fromRGBO(134, 97, 255, 1),
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  Flexible(
                    fit: FlexFit.loose,
                    child: Text(
                      mp["department"],
                      style: const TextStyle(color: Colors.white, fontSize: 18),
                      softWrap: false,
                      overflow: TextOverflow.fade,
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Text(
                    "Category : ",
                    style: TextStyle(
                        color: Color.fromRGBO(134, 97, 255, 1),
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  Flexible(
                    fit: FlexFit.loose,
                    child: Text(
                      mp["projectCategory"],
                      style: const TextStyle(color: Colors.white, fontSize: 18),
                      softWrap: false,
                      overflow: TextOverflow.fade,
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Text(
                    "Project Name : ",
                    style: TextStyle(
                        color: Color.fromRGBO(134, 97, 255, 1),
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  Flexible(
                    fit: FlexFit.loose,
                    child: Text(
                      mp["projectName"],
                      style: const TextStyle(color: Colors.white, fontSize: 18),
                      softWrap: false,
                      overflow: TextOverflow.fade,
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Text(
                    "Budget Amount : ",
                    style: TextStyle(
                        color: Color.fromRGBO(134, 97, 255, 1),
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  Flexible(
                    fit: FlexFit.loose,
                    child: Text(
                      "\$ ${mp["budgetAmount"]}",
                      style: const TextStyle(color: Colors.white, fontSize: 18),
                      softWrap: false,
                      overflow: TextOverflow.fade,
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}