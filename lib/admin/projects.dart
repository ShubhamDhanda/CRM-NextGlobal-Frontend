import 'package:crm/admin/drawer.dart';
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
  bool dataLoaded = false;
  final snackBar1 = SnackBar(
    content: Text('Something Went Wrong'),
    backgroundColor: Colors.red,
  );
  List<Map<String, dynamic>> projects = [];
  List<Map<String, dynamic>> search = [];

  @override
  void initState() {
    super.initState();
    _getData();
  }

  void _getData() async {
    dynamic res = await apiClient.getAllProjects();

    if(res?["success"] == true){
      projects.clear();
      search.clear();
      for(var i=0;i<res["res"].length;i++){
        var e = res["res"][i];

        Map<String, dynamic> mp = {};
        mp["id"] = e["Project_ID"]==null ? "" : e["Project_ID"].toString();
        mp["name"] = e["Project_Name"]==null ? "" : e["Project_Name"].toString();
        mp["dateCreated"] = e["Date_Created"]==null ? "" : DateFormat("yyyy-MM-dd").parse(e["Date_Created"]).add(Duration(days: 1)).toString().substring(0, 10);
        mp["dueDate"] = e["Project_Due_Date"]==null ? "" : DateFormat("yyyy-MM-dd").parse(e["Project_Due_Date"]).add(Duration(days: 1)).toString().substring(0, 10);
        mp["stage"] = e["Project_Stage"]==null ? "" : e["Project_Stage"].toString();
        mp["followupNotes"] = e["Follow_Up_Notes"]==null ? "" : e["Follow_Up_Notes"].toString();
        mp["nextFollowup"] = e["Next_Follow_up"]==null ? "" : DateFormat("yyyy-MM-dd").parse(e["Next_Follow_up"]).add(Duration(days: 1)).toString().substring(0, 10);
        mp["tentClosing"] = e["Tentative_Closing"]==null ? "" : DateFormat("yyyy-MM-dd").parse(e["Tentative_Closing"]).add(Duration(days: 1)).toString().substring(0, 10);
        mp["employee"] = e["Employee"]==null ? "" : e["Employee"].toString();
        mp["quantity"] = e["Product_Qty"]==null ? "" : e["Product_Qty"].toString();
        mp["specified"] = e["Product_Specified"]==null ? "" : e["Product_Specified"].toString();
        mp["value"] = e["Project_Value"]==null ? "" : e["Project_Value"].toString();
        mp["consultant"] = e["Consultant"]==null ? "" : e["Consultant"].toString();
        mp["city"] = e["City"]==null ? "" : e["City"].toString();
        mp["province"] = e["Province"]==null ? "" : e["Province"].toString();
        mp["department"] = e["Department"]==null ? "" : e["Department"].toString();
        mp["assignedTo"] = e["Assigned_To"]==null ? "" : e["Assigned_To"].toString();
        mp["contractor"] = e["Contractor"]==null ? "" : e["Contractor"].toString();
        mp["distributor"] = e["Distributor"]==null ? "" : e["Distributor"].toString();
        projects.add(mp);
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(snackBar1);
    }

    search.addAll(projects);

    setState(() {
      dataLoaded = true;
    });

    await Future.delayed(Duration(seconds: 2));
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
  }

  void _onSearchChanged(String text) async {
    setState(() {
      dataLoaded = false;
    });
    search.clear();

    if(text.isEmpty){
      search.addAll(projects);
    }else{
      projects.forEach((e) {
        if(e["name"].toString().toLowerCase().contains(text.toLowerCase()) || (int.tryParse(text)!=null && e["id"] == int.parse(text))){
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
          title: Text("Projects"),
          titleTextStyle: const TextStyle(color: Colors.white, fontSize: 24),
          backgroundColor: Colors.black,
        ),
        drawer: const NavDrawerWidget(
          name: '/projects',
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
                searchBar(),
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

  Widget searchBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
      child: TextField(
          cursorColor: Colors.white,
          controller: searchController,
          onChanged: _onSearchChanged,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.search, color: Colors.white,),
            hintText: "Search",
            hintStyle: const TextStyle(color: Color.fromRGBO(255, 255, 255, 0.5)),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(40.0),
                borderSide: const BorderSide(color: Colors.white)
            ),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(40.0),
                borderSide: const BorderSide(color: Colors.white)
            ),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(40.0),
                borderSide: const BorderSide(color: Colors.white)
            ),
          )
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
                    "Assigned To : ",
                    style: TextStyle(
                        color: Color.fromRGBO(134, 97, 255, 1),
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  Flexible(
                    fit: FlexFit.loose,
                    child: Text(
                      mp["assignedTo"],
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