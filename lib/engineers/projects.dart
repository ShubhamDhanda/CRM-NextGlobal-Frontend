import 'package:crm/admin/drawer.dart';
import 'package:crm/dialogs/add_project_dialog.dart';
import 'package:crm/dialogs/filter_project_dialog.dart';
import 'package:crm/dialogs/update_project_dialog.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../services/remote_services.dart';

class Projects extends StatefulWidget{
  const Projects({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ProjectsState();
}

class _ProjectsState extends State<Projects>{
  TextEditingController searchController = TextEditingController();
  var apiClient = RemoteServices();
  bool dataLoaded = false, filtersLoaded = false;
  final snackBar1 = SnackBar(
    content: Text('Something Went Wrong'),
    backgroundColor: Colors.red,
  );
  List<Map<String, dynamic>> projects = [];
  List<Map<String, dynamic>> employees = [];
  List<Map<String, dynamic>> filtered = [];
  List<Map<String, dynamic>> search = [];
  List<String> projectManager=[];
  List<String> selectedCat = [], selectedDept = [], dept = [], cat = [];
  int price = 0;
  String name = "";

  @override
  void initState() {
    super.initState();
    _getData();
    _getFilters();
  }

  void _getData() async {
    dynamic res = await apiClient.getAllProjects();

    if(res?["success"] == true){
      projects.clear();
      search.clear();
      for(var i=0;i<res["res"].length;i++){
        var e = res["res"][i];

        Map<String, dynamic> mp = {};
        mp["id"] = e["Project_Id"]==null ? "" : e["Project_Id"].toString();
        mp["name"] = e["Project_Name"]==null ? "" : e["Project_Name"].toString();
        mp["dateCreated"] = e["Date_Created"]==null ? "" : DateFormat("yyyy-MM-dd").parse(e["Date_Created"]).add(Duration(days: 1)).toString().substring(0, 10);
        mp["dueDate"] = e["Project_Due_Date"]==null ? "" : DateFormat("yyyy-MM-dd").parse(e["Project_Due_Date"]).add(Duration(days: 1)).toString().substring(0, 10);
        mp["stage"] = e["Project_Stage"]==null ? "" : e["Project_Stage"].toString();
        mp["followupNotes"] = e["Follow_Up_Notes"]==null ? "" : e["Follow_Up_Notes"].toString();
        print(mp["followupNotes"]);
        mp["nextFollowup"] = e["Next_Follow_Up"]==null ? "" : DateFormat("yyyy-MM-dd").parse(e["Next_Follow_Up"]).add(Duration(days: 1)).toString().substring(0, 10);
        print(mp["nextFollowup"]);
        mp["tentClosing"] = e["Tentative_Closing"]==null ? "" : DateFormat("yyyy-MM-dd").parse(e["Tentative_Closing"]).add(Duration(days: 1)).toString().substring(0, 10);
        mp["value"] = e["Project_Value"]==null ? "" : e["Project_Value"].toString();
        mp["city"] = e["City"]==null ? "" : e["City"].toString();
        mp["province"] = e["Province"]==null ? "" : e["Province"].toString();
        mp["department"] = e["Department"]==null ? "" : e["Department"].toString();
        mp["projectManager"] = e["Project_Manager"]==null ? "" : e["Project_Manager"].toString();
        mp["distributor"] = e["Distributor"]==null ? "" : e["Distributor"].toString();
        mp["teamMembers"] = e["Team_Members"]==null ? "" : e["Team_Members"].toString();
        mp["status"] = e["Status"]==null ? "" : e["Status"].toString();
        mp["projectCategory"] = e["Project_Category"]==null ? "" : e["Project_Category"].toString();
        projects.add(mp);
        projectManager?.insert(i,name);
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(snackBar1);
    }

    filtered.addAll(projects);
    search.addAll(projects);

    setState(() {
      dataLoaded = true;
    });

    await Future.delayed(Duration(seconds: 2));
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
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

    if(text.isEmpty){
      search.addAll(filtered);
    }else{
      filtered.forEach((e) {
        if(e["name"].toString().toLowerCase().startsWith(text.toLowerCase())){
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
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Center(child: Text("Projects")),
              GestureDetector(
                onTap: () async {
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
                      pageBuilder: (context, animation, secondaryAnimation) => const AddProjectDialog()).then((value) {
                     if(value! == true){
                       _getData();
                     }
                  });
                },
                child: const Icon(
                  Icons.add,
                  color: Color.fromRGBO(134, 97, 255, 1),
                  size: 30,
                ),
              ),
            ],
          ),
          titleTextStyle: const TextStyle(color: Colors.white, fontSize: 24),
          backgroundColor: Colors.black,
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
                // searchBar(),
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
                        "No Projects Found",
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                        : Expanded(child: ListView.builder(
                      itemCount: search.length,
                      prototypeItem: ListCard(search.first),
                      itemBuilder: (context, index) {
                        return ListCard(search[index]);
                      },
                    ),)
                )
              ],
            )
        )
    );
  }

  // Widget searchBar() {
  //   return Container(
  //     padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
  //     child: TextField(
  //         cursorColor: Colors.white,
  //         controller: searchController,
  //         onChanged: _onSearchChanged,
  //         style: const TextStyle(color: Colors.white),
  //         decoration: InputDecoration(
  //           prefixIcon: Icon(Icons.search, color: Colors.white,),
  //           hintText: "Search",
  //           hintStyle: const TextStyle(color: Color.fromRGBO(255, 255, 255, 0.5)),
  //           border: OutlineInputBorder(
  //               borderRadius: BorderRadius.circular(40.0),
  //               borderSide: const BorderSide(color: Colors.white)
  //           ),
  //           enabledBorder: OutlineInputBorder(
  //               borderRadius: BorderRadius.circular(40.0),
  //               borderSide: const BorderSide(color: Colors.white)
  //           ),
  //           focusedBorder: OutlineInputBorder(
  //               borderRadius: BorderRadius.circular(40.0),
  //               borderSide: const BorderSide(color: Colors.white)
  //           ),
  //         )
  //     ),
  //   );
  // }

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
              pageBuilder: (context, animation, secondaryAnimation) => FilterProjectDialog(cat: cat, dept: dept, prevCat: selectedCat, prevDept: selectedDept)).then((value) {
            filtered.clear();
            Map<String, List<String>> mp = value as Map<String, List<String>>;
            selectedCat = mp["Categories"]!;
            selectedDept = mp["Departments"]!;
            if (selectedDept.isEmpty && selectedCat.isEmpty) {
              filtered.addAll(projects);
            } else {
              projects.forEach((e) {
                if (selectedCat.contains(e["projectCategory"]) || selectedDept.contains(e["department"])) {
                  filtered.add(e);
                }
              });
            }

            _onSearchChanged(searchController.text);
          });
        },
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Icon(Icons.filter_alt),
        ),
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(
                const Color.fromRGBO(134, 97, 255, 1)),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40.0),
                ))),
      ),
    );
  }


  Widget ListCard(Map<String, dynamic> mp) {
    return Card(
      color: const Color.fromRGBO(0, 0, 0, 0),
      child: Container(
        height: 247,
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Text(
                        "Project ID : ",
                        style: TextStyle(
                            color: Color.fromRGBO(134, 97, 255, 1),
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        mp["id"],
                        style: const TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () =>
                        showGeneralDialog(
                            context: context,
                            barrierDismissible: false,
                            transitionDuration: Duration(milliseconds: 500),
                            transitionBuilder: (context, animation, secondaryAnimation, child) {
                              const begin = Offset(0.0, 1.0);
                              const end = Offset.zero;
                              const curve = Curves.ease;

                              var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

                              return SlideTransition(
                                position: animation.drive(tween),
                                child: child,
                              );
                            },
                            pageBuilder: (context, animation, secondaryAnimation) => updateProjectDialog(mp: mp)
                        ).then((value) {
                          _getData();
                          setState(() {
                            dataLoaded = true;
                          });
                        })
                    ,
                    child: Icon(
                      Icons.edit,
                      color: Color.fromRGBO(134, 97, 255, 1),
                    ),
                  )

                ],
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
                  Flexible(child: Text(
                    mp["name"],
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                    softWrap: false,
                    overflow: TextOverflow.fade,
                  ),
                    fit: FlexFit.loose,)

                ],
              ),
              const SizedBox(
                height: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Text(
                    "Date Created : ",
                    style: TextStyle(
                        color: Color.fromRGBO(134, 97, 255, 1),
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    mp["dateCreated"],
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ],
              ),
              const SizedBox(
                height: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Text(
                    "Due Date : ",
                    style: TextStyle(
                        color: Color.fromRGBO(134, 97, 255, 1),
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  Flexible(
                    fit: FlexFit.loose,
                    child: Text(
                      mp["dueDate"],
                      style: const TextStyle(color: Colors.white, fontSize: 16),
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
                    "Project Stage : ",
                    style: TextStyle(
                        color: Color.fromRGBO(134, 97, 255, 1),
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  Flexible(
                    fit: FlexFit.loose,
                    child: Text(
                      mp["stage"],
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                      softWrap: false,
                      overflow: TextOverflow.fade,
                    ),)

                ],
              ),
              const SizedBox(
                height: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Text(
                    "Tentative Closing : ",
                    style: TextStyle(
                        color: Color.fromRGBO(134, 97, 255, 1),
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  Flexible(
                    fit: FlexFit.loose,
                    child: Text(
                      mp["tentClosing"],
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                      softWrap: false,
                      overflow: TextOverflow.fade,
                    ),
                  )

                ],
              ),const SizedBox(
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
                      style: const TextStyle(color: Colors.white, fontSize: 16),
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
                    "Project Manager: ",
                    style: TextStyle(
                        color: Color.fromRGBO(134, 97, 255, 1),
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  Flexible(
                    fit: FlexFit.loose,
                    child: Text(
                      mp["projectManager"],
                      style: const TextStyle(color: Colors.white, fontSize: 16),
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
                    "Project Value : ",
                    style: TextStyle(
                        color: Color.fromRGBO(134, 97, 255, 1),
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  Flexible(
                    fit: FlexFit.loose,
                    child: Text(
                      '\$ ' + mp["value"],
                      style: const TextStyle(color: Colors.white, fontSize: 16),
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