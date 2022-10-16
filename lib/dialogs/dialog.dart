import 'package:flutter/material.dart';

class DialogWidget extends StatefulWidget {
  final String hint;
  final TextInputType type;
  const DialogWidget({Key? key, required this.hint, required this.type }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _DialogWidgetState(hint: hint, type: type);

}

class _DialogWidgetState extends State<DialogWidget> {
  String hint;
  TextInputType type;
  TextEditingController controller = TextEditingController();
  TextEditingController emailController = TextEditingController();
  _DialogWidgetState({required this.hint, required this.type});

  @override
  Widget build(context) {
    return Dialog(
      backgroundColor: const Color.fromRGBO(41, 41, 41, 1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10)
      ),
      insetAnimationDuration: const Duration(milliseconds: 500),
      elevation: 10,
      child: Stack(
        fit: StackFit.loose,
        alignment: Alignment.center,
        children: <Widget>[
          Container(
            width: double.infinity,
            height: 294,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
              ),
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                const Text("Enter Details",
                  style: TextStyle(fontSize: 24, color: Colors.white),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20,),
                TextField(
                  cursorColor: Colors.white,
                  style: const TextStyle(color: Colors.white),
                  keyboardType: type,
                  controller: controller,
                  decoration: InputDecoration(
                      enabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                      focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                      labelText: hint,
                      labelStyle: const TextStyle(color: Colors.white,)
                  ),
                ),
                const SizedBox(height: 20,),
                TextField(
                  cursorColor: Colors.white,
                  style: const TextStyle(color: Colors.white),
                  keyboardType: TextInputType.emailAddress,
                  controller: emailController,
                  decoration: InputDecoration(
                      enabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                      focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                      labelText: "Email ID",
                      labelStyle: const TextStyle(color: Colors.white,)
                  ),
                ),
                const SizedBox(height: 20,),
                ElevatedButton(onPressed: () => Navigator.pop(context, false),
                  style: ElevatedButton.styleFrom(primary: const Color.fromRGBO(134, 97, 255, 1)),
                  child: const Text("Submit",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16
                    ),
                  ),
                )
              ],
            )
          ),
        ],
      )
    );
  }

}