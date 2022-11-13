import 'package:crm/admin/drawer.dart';
import 'package:crm/dialogs/filter_project_dialog.dart';
import 'package:crm/dialogs/update_proposal_dialog.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../services/remote_services.dart';

class Proposals extends StatefulWidget{
  const Proposals({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ProposalsState();
}

class _ProposalsState extends State<Proposals>{
  TextEditingController searchController = TextEditingController();
  var apiClient = RemoteServices();
  bool dataLoaded = false, filtersLoaded = false;
  final snackBar1 = const SnackBar(
    content: Text('Something Went Wrong'),
    backgroundColor: Colors.red,
  );
  List<Map<String, dynamic>> proposals = [];
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
    dynamic res = await apiClient.getAllProposals();

    if(res?["success"] == true){
      proposals.clear();
      search.clear();
      for(var i=0;i<res["res"].length;i++){
        var e = res["res"][i];

        Map<String, dynamic> mp = {};
        mp["id"] = e["Proposal_ID"]==null ? "" : e["Proposal_ID"].toString();
        mp["projectName"] = e["Project_Name"]==null ? "" : e["Project_Name"].toString();
        mp["closingDeadline"] = e["Closing_Deadline"]==null ? "" : DateFormat("yyyy-MM-dd").parse(e["Closing_Deadline"]).add(Duration(days: 1)).toString().substring(0, 10);
        mp["questionDeadline"] = e["Question_Deadline"]==null ? "" : DateFormat("yyyy-MM-dd").parse(e["Question_Deadline"]).add(Duration(days: 1)).toString().substring(0, 10);
        mp["resultDate"] = e["Result_Date"]==null ? "" : DateFormat("yyyy-MM-dd").parse(e["Result_Date"]).add(Duration(days: 1)).toString().substring(0, 10);
        mp["bidStatus"] = e["Bid_Status"]==null ? "" : e["Bid_Status"].toString();
        mp["bidderPrice"] = e["Bidder_Price"]==null ? "" : e["Bidders"].toString();
        mp["bidders"] = e["Bidders"]==null ? "" : e["Project_Stage"].toString();
        mp["city"] = e["City"]==null ? "" : e["City"].toString();
        mp["cityId"] = e["CityID"]==null ? "" : e["CityID"].toString();
        mp["contractAdminPrice"] = e["Contract_Admin_Price"]==null ? "" : e["Contract_Admin_Price"].toString();
        mp["country"] = e["Country"]==null ? "" : e["Country"].toString();
        mp["designPrice"] = e["Design_Price"]==null ? "" : e["Design_Price"].toString();
        mp["managerName"] = e["Manager_Name"]==null ? "" : e["Manager_Name"].toString();
        mp["winningBidderName"] = e["Name"]==null ? "" : e["Name"].toString();
        mp["province"] = e["Province"]==null ? "" : e["Province"].toString();
        mp["provisionalItems"] = e["Provisional_Items"]==null ? "" : e["Provisional_Items"].toString();
        mp["status"] = e["Status"]==null ? "" : e["Status"].toString();
        mp["totalBid"] = e["Total_Bid"]==null ? "" : e["Total_Bid"].toString();
        mp["winningBidderId"] = e["Winning_Bidder_ID"]==null ? "" : e["Winning_Bidder_ID"].toString();
        mp["winningPrice"] = e["Winning_Price"]==null ? "" : e["Winning_Price"].toString();
        mp["subConsultantPrice"] = e["Sub_Consultant_Price"]==null ? "" : e["Sub_Consultant_Price"].toString();
        mp["planTakers"] = e["Plan_Takers"]==null ? "" : e["Plan_Takers"].toString();
        mp["projectManagerId"] = e["Project_Manager_ID"]==null ? "" : e["Project_Manager_ID"].toString();
        mp["department"] = e["Department"]==null ? "" : e["Department"].toString();
        mp["departmentId"] = e["Department_ID"]==null ? "" : e["Department_ID"].toString();
        mp["team"] = e["Team"]==null ? "" : e["Team"].toString();
        print(mp["city"]);
        proposals.add(mp);
        projectManager?.insert(i,mp["projectName"]);
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(snackBar1);
    }

    filtered.addAll(proposals);
    search.addAll(proposals);

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
    print(text);
    if(text.isEmpty){
      search.addAll(filtered);
    }else{
      filtered.forEach((e) {
        print(e["projectName"]);
        if(e["projectName"].toString().toLowerCase().startsWith(text.toLowerCase())){
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
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: Text("Proposals"),
          titleTextStyle: const TextStyle(color: Colors.white, fontSize: 24),
          backgroundColor: Colors.black,
        ),
        drawer: const NavDrawerWidget(
          name: '/proposals',
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
                        "No Proposals Found",
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
            selectedCat = mp["Categories"]!;
            selectedDept = mp["Departments"]!;
            if (selectedDept.isEmpty && selectedCat.isEmpty) {
              filtered.addAll(proposals);
            } else {
              proposals.forEach((e) {
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
        height: 280,
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
                        "Proposal ID : ",
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
                            pageBuilder: (context, animation, secondaryAnimation) => updateProposalDialog(mp: mp)
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
                    mp["projectName"],
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
                    "Closing Deadline : ",
                    style: TextStyle(
                        color: Color.fromRGBO(134, 97, 255, 1),
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  Flexible(
                    fit: FlexFit.loose,
                    child: Text(
                      mp["closingDeadline"],
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
                    "Result Date : ",
                    style: TextStyle(
                        color: Color.fromRGBO(134, 97, 255, 1),
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  Flexible(
                    fit: FlexFit.loose,
                    child: Text(
                      mp["resultDate"],
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
                    "Status : ",
                    style: TextStyle(
                        color: Color.fromRGBO(134, 97, 255, 1),
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  Flexible(
                    fit: FlexFit.loose,
                    child: Text(
                      mp["status"],
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
                    "Total Bid : ",
                    style: TextStyle(
                        color: Color.fromRGBO(134, 97, 255, 1),
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  Flexible(
                    fit: FlexFit.loose,
                    child: Text(
                      mp["totalBid"],
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
                      mp["managerName"],
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
                    "Winning Bidder : ",
                    style: TextStyle(
                        color: Color.fromRGBO(134, 97, 255, 1),
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  Flexible(
                    fit: FlexFit.loose,
                    child: Text(
                      mp["winningBidderName"],
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
                    "Winning Bid : ",
                    style: TextStyle(
                        color: Color.fromRGBO(134, 97, 255, 1),
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  Flexible(
                    fit: FlexFit.loose,
                    child: Text(
                      '\$ ' + mp["winningPrice"],
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
            ],
          ),
        ),
      ),
    );
  }
}