import 'package:crm/admin/drawer.dart';
import 'package:flutter/material.dart';

class PendingRequests extends StatefulWidget {
  const PendingRequests({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _PendingRequestsState();
}

class _PendingRequestsState extends State<PendingRequests> {
  var requests = [
    [
      1,
      "lakshayrose0000@gmail.com",
      "Sales",
      "Employee ID",
      "Excel",
      "2022-08-24"
    ],
    [
      1,
      "lakshayrose0000@gmail.com",
      "Sales",
      "Employee ID",
      "Excel",
      "2022-08-24"
    ],
    [
      1,
      "lakshayrose0000@gmail.com",
      "Sales",
      "Employee ID",
      "Excel",
      "2022-08-24"
    ],
    [
      1,
      "lakshayrose0000@gmail.com",
      "Sales",
      "Employee ID",
      "Excel",
      "2022-08-24"
    ],
  ];

  @override
  Widget build(context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Pending Requests"),
          titleTextStyle: const TextStyle(color: Colors.white, fontSize: 24),
          backgroundColor: Colors.black,
        ),
        drawer: const NavDrawerWidget(
          name: '/pendingRequests',
        ),
        body: dashboard());
  }

  Widget dashboard() {
    return Container(
        color: const Color.fromRGBO(0, 0, 0, 1),
        child: Padding(
            padding:
            const EdgeInsets.symmetric(horizontal: 5.0),
            child: ListView.builder(
              itemCount: requests.length,
              prototypeItem: ListCard(requests.first),
              itemBuilder: (context, index) {
                return ListCard(requests[index]);
              },
            )
        )
    );
  }

  Widget ListCard(List c) {
    return Card(
      color: const Color.fromRGBO(0, 0, 0, 0),
      child: Container(
        height: 224,
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
                    "Employee ID : ",
                    style: TextStyle(
                        color: Color.fromRGBO(134, 97, 255, 1),
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    c[0].toString(),
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
                    c[1],
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
                    "Request Department : ",
                    style: TextStyle(
                        color: Color.fromRGBO(134, 97, 255, 1),
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    c[2],
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
                    "Request : ",
                    style: TextStyle(
                        color: Color.fromRGBO(134, 97, 255, 1),
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    c[3],
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
                    "File Format : ",
                    style: TextStyle(
                        color: Color.fromRGBO(134, 97, 255, 1),
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    c[4],
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
                    "Date : ",
                    style: TextStyle(
                        color: Color.fromRGBO(134, 97, 255, 1),
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    c[5],
                    style: const TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ],
              ),
              const SizedBox(
                height: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                      onPressed: () {

                      },
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(Color.fromRGBO(134, 97, 255, 1)),
                          padding: MaterialStateProperty.all(EdgeInsets.symmetric(horizontal: 20))
                      ),
                      child: const Text(
                        "Approve",
                        style: TextStyle(
                            color: Colors.white
                        ),
                      )
                  ),
                  const SizedBox(width: 20,),
                  TextButton(
                      onPressed: () {

                      },
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(Color.fromRGBO(0, 0, 0, 0.3)),
                          padding: MaterialStateProperty.all(EdgeInsets.symmetric(horizontal: 35, vertical: 12))
                      ),
                      child: const Text(
                        "Deny",
                        style: TextStyle(
                            color: Colors.white
                        ),
                      )
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