import 'package:crm/services/remote_services.dart';
import 'package:flutter/material.dart';

class FilterCompetitorDialog extends StatefulWidget{
  List<String> cat, prevCat;

  FilterCompetitorDialog({Key? key, required this.cat, required this.prevCat}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _FilterCompetitorDialogState(cats: cat, prevCat: prevCat);
}

class _FilterCompetitorDialogState extends State<FilterCompetitorDialog> {
  List<String>  selectedCat = [];
  List<String>  prevCat,prev = [];
  int switcher = 0;
  List<String> depts = [], cats = [];

  final snackBar1 = const SnackBar(
    content: Text('Something Went Wrong!'),
    backgroundColor: Colors.red,
  );

  _FilterCompetitorDialogState(
      {required this.cats, required this.prevCat}){
    selectedCat.addAll(prevCat);
  }

  @override
  Widget build(context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          leading: GestureDetector(
            child: Icon(Icons.close),
            onTap: () => Navigator.pop(context, {"Categories" : prev}),
          ),
          title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Center(child: Text("Filter List")),
                GestureDetector(
                    onTap: (){
                      Navigator.pop(context, {"Categories" : selectedCat});
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
          categories(),
        ],
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