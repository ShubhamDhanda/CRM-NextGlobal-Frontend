import 'package:crm/admin/drawer.dart';
import 'package:crm/services/remote_services.dart';
import 'package:flutter/material.dart';

class Shippers extends StatefulWidget {
  const Shippers({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ShippersState();
}

class _ShippersState extends State<Shippers> {
  var apiClient = RemoteServices();
  bool dataLoaded = false;
  final snackBar1 = SnackBar(
    content: Text('Something Went Wrong'),
    backgroundColor: Colors.red,
  );

  List<Map<String, dynamic>> shippers = [];
  List<Map<String, dynamic>> search = [];

  @override
  void initState() {
    super.initState();
    _getData();
  }

  void _getData() async {
    dynamic res = await apiClient.getAllShippers();

    if (res?["success"] == true) {

      for(var i=0;i<res["res"].length;i++){
        var e = res["res"][i];

        Map<String, dynamic> mp = {};
        mp["id"] = e["ID"];
        mp["company"] = e["Company"];
        mp["lastName"] = e["Last_Name"];
        mp["firstName"] = e["First_Name"];
        mp["email"] = e["Email"];
        mp["jobTitle"] = e["Job_title"];
        mp["business"] = e["Business_Phone"];
        mp["home"] = e["Home_Phone"];
        mp["mobile"] = e["Mobile_Phone"];
        mp["fax"] = e["Fax_Number"];
        mp["address"] = e["Address"];
        mp["city"] = e["City"];
        mp["state"] = e["State"];
        mp["zip"] = e["ZIP"];
        mp["country"] = e["Country"];
        mp["webpage"] = e["Web_Page"];
        mp["notes"] = e["Notes"];
        mp["attachments"] = e["Attachments"];
        shippers.add(mp);
        search.add(mp);
      }
    } else {
        ScaffoldMessenger.of(context).showSnackBar(snackBar1);
    }

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
      search.addAll(shippers);
      setState(() {
        dataLoaded = true;
      });
      return;
    }
    shippers.forEach((e) {
      if(e["firstName"].toString().toLowerCase().contains(text) || e["lastName"]!.toString().toLowerCase().contains(text) || (e["firstName"] + " " + e["lastName"]!).toString().toLowerCase().contains(text) || (int.tryParse(text)!=null && e["id"] == int.parse(text)) || e["company"].toString().toLowerCase().contains(text.toLowerCase())){
        search.add(e);
      }
    });

    setState(() {
      dataLoaded = true;
    });
  }

  @override
  Widget build(context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Shippers"),
          titleTextStyle: const TextStyle(color: Colors.white, fontSize: 24),
          backgroundColor: Colors.black,
        ),
        drawer: const NavDrawerWidget(
          name: '/shippers',
        ),
        body: dashboard());
  }

  Widget dashboard() {
    return Container(
        color: const Color.fromRGBO(0, 0, 0, 1),
        child: Padding(
            padding:
            const EdgeInsets.symmetric(horizontal: 5.0),
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
                      "No Shippers Found",
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
                  ),
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
        height: 197,
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
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Text(
                    "Shipper ID : ",
                    style: TextStyle(
                        color: Color.fromRGBO(134, 97, 255, 1),
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    mp["id"]==null ? "" : mp["id"].toString(),
                    style: const TextStyle(color: Colors.white, fontSize: 18),
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
                    "Name : ",
                    style: TextStyle(
                        color: Color.fromRGBO(134, 97, 255, 1),
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "${mp["firstName"] ?? ""} ${mp["lastName"] ?? ""}",
                    style: const TextStyle(color: Colors.white, fontSize: 18),
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
                    "Company : ",
                    style: TextStyle(
                        color: Color.fromRGBO(134, 97, 255, 1),
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    mp["company"]==null ? "" : mp["company"].toString(),
                    style: const TextStyle(color: Colors.white, fontSize: 18),
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
                    "Email : ",
                    style: TextStyle(
                        color: Color.fromRGBO(134, 97, 255, 1),
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    mp["email"]==null ? "" : mp["email"].toString(),
                    style: const TextStyle(color: Colors.white, fontSize: 18),
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
                    "Job Title : ",
                    style: TextStyle(
                        color: Color.fromRGBO(134, 97, 255, 1),
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    mp["jobTitle"]==null ? "" : mp["jobTitle"].toString(),
                    style: const TextStyle(color: Colors.white, fontSize: 18),
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
                    "Phone : ",
                    style: TextStyle(
                        color: Color.fromRGBO(134, 97, 255, 1),
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    mp["business"]==null ? "" : mp["business"].toString(),
                    style: const TextStyle(color: Colors.white, fontSize: 18),
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
                    "City : ",
                    style: TextStyle(
                        color: Color.fromRGBO(134, 97, 255, 1),
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    mp["city"]==null ? "" : mp["city"].toString(),
                    style: const TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}