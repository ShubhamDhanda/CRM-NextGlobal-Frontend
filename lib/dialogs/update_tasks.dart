import 'package:crm/services/remote_services.dart';
import 'package:flutter/material.dart';

class UpdateTasksDialog extends StatefulWidget{
  UpdateTasksDialog({super.key, required this.mp});
  Map<String, dynamic> mp;
  @override
  State<StatefulWidget> createState() => _UpdateTasksDialogState(mp: mp);
}

class _UpdateTasksDialogState extends State<UpdateTasksDialog>{
  TextEditingController percent = TextEditingController();

  Map<String, dynamic> mp;
  bool posting = false;
  var apiClient = RemoteServices();

  final snackBar1 = SnackBar(
    content: Text('Something Went Wrong'),
    backgroundColor: Colors.red,
  );

  final snackBar2 = SnackBar(
    content: Text('Please Fill the Percentage!'),
    backgroundColor: Colors.red,
  );

  final snackBar3 = const SnackBar(
    content: Text('Task Updated Successfully!'),
    backgroundColor: Colors.green,
  );

  _UpdateTasksDialogState({required this.mp}){
    percent.text = mp["completed"].toString();
  }

  void _postData() async {
    try{
      if(percent.text!=""){
        setState(() {
          posting = true;
        });
        dynamic res = await apiClient.updateTask(mp["id"], percent.text);

        if(res["success"] == true){
          Navigator.pop(context, true);
          ScaffoldMessenger.of(context).showSnackBar(snackBar3);
        }
      }else{
        ScaffoldMessenger.of(context).showSnackBar(snackBar2);
      }
    } catch(e) {
      ScaffoldMessenger.of(context).showSnackBar(snackBar1);
    } finally{
      setState(() {
        posting = false;
      });

      await Future.delayed(Duration(seconds: 2));
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
    }

  }

  @override
  Widget build(context) {
    return Dialog(
        backgroundColor: const Color.fromRGBO(41, 41, 41, 1),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10)
        ),
        insetAnimationDuration: const Duration(milliseconds: 500),
        elevation: 10,
        child: SingleChildScrollView(
          child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                ),
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    const Text("Task Details",
                      style: TextStyle(fontSize: 24, color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20,),
                    Row(
                      children: [
                        const Text("Title : ",
                          style: TextStyle(fontSize: 18, color: const Color.fromRGBO(134, 97, 255, 1)),
                          textAlign: TextAlign.center,
                        ),
                        Text(mp["title"],
                          style: TextStyle(fontSize: 16, color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                    const SizedBox(height: 20,),
                    Row(
                      children: [
                        const Text("Priority : ",
                          style: TextStyle(fontSize: 18, color: const Color.fromRGBO(134, 97, 255, 1)),
                          textAlign: TextAlign.center,
                        ),
                        Text(mp["priority"],
                          style: TextStyle(fontSize: 16, color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                    const SizedBox(height: 20,),
                    Row(
                      children: [
                        const Text("Description : ",
                          style: TextStyle(fontSize: 18, color: const Color.fromRGBO(134, 97, 255, 1)),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                    const SizedBox(height: 5,),
                    Row(
                      children: [
                        LimitedBox(
                          maxWidth: MediaQuery.of(context).size.width-130,
                          child: Text(mp["description"],
                            style: TextStyle(fontSize: 16, color: Colors.white),
                            textAlign: TextAlign.left,
                            maxLines: 10,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20,),
                    Row(
                      children: [
                        const Text("Start Date : ",
                          style: TextStyle(fontSize: 18, color: const Color.fromRGBO(134, 97, 255, 1)),
                          textAlign: TextAlign.center,
                        ),
                        Text(mp["startDate"],
                          style: TextStyle(fontSize: 16, color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                    const SizedBox(height: 20,),
                    Row(
                      children: [
                        const Text("Due Date : ",
                          style: TextStyle(fontSize: 18, color: const Color.fromRGBO(134, 97, 255, 1)),
                          textAlign: TextAlign.center,
                        ),
                        Text(mp["dueDate"],
                          style: TextStyle(fontSize: 16, color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                    const SizedBox(height: 20,),
                    TextField(
                      cursorColor: Colors.white,
                      style: const TextStyle(color: Colors.white),
                      keyboardType: TextInputType.number,
                      controller: percent,
                      decoration: const InputDecoration(
                          enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                          focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                          hintText: "Percent Complete",
                          hintStyle: TextStyle(color: Color.fromRGBO(255, 255, 255, 0.5))
                      ),
                    ),
                    if (percent.text=="100") const Text("This will Complete the Task!",
                      style: TextStyle(fontSize: 12, color: Colors.red),
                      textAlign: TextAlign.left,
                    ),
                    const SizedBox(height: 20,),
                    ElevatedButton(onPressed: posting ? null : () => _postData(),
                      style: ElevatedButton.styleFrom(primary: const Color.fromRGBO(134, 97, 255, 1)),
                      child: const Text("Update Task",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16
                        ),
                      ),
                    )
                  ],
                )
            ),
        )
    );
  }

}