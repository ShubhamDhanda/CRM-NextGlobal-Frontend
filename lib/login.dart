// import 'package:crm/services/remote_services.dart';
// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// class LoginPage extends StatefulWidget {
//   const LoginPage({Key? key}) : super(key: key);
//
//   @override
//   State<LoginPage> createState() => _LoginPageState();
// }
//
// enum ButtonState { init, submitting }
//
// class _LoginPageState extends State<LoginPage> {
//   TextEditingController nameController = TextEditingController();
//   TextEditingController passwordController = TextEditingController();
//   final RemoteServices _apiClient = RemoteServices();
//   var isLoading = false;
//   bool isAnimating = true;
//   ButtonState state = ButtonState.init;
//   bool passwordVisible = false;
//   final snackBar1 = const SnackBar(
//     content: Text('Wrong Credentials'),
//     backgroundColor: Colors.red,
//   );
//   final snackBar2 = const SnackBar(
//     content: Text('Something Went Wrong!'),
//     backgroundColor: Colors.red,
//   );
//   final snackBar3 = const SnackBar(
//     content: Text('Please enter the Fields!'),
//     backgroundColor: Colors.red,
//   );
//
//   void _login() async {
//     try{
//       setState(() {
//         isLoading = true;
//       });
//
//       if(validate() == true){
//         dynamic res = await _apiClient.login(
//           nameController.text,
//           passwordController.text,
//         );
//
//         if (res["success"] == true) {
//           final SharedPreferences prefs = await SharedPreferences.getInstance();
//
//           prefs.setString("auth-token", res['auth']);
//           prefs.setString("email", res["user"]["emailWork"]);
//           prefs.setInt("id", res["user"]["employeeId"]);
//           prefs.setString('isLoggedIn', res['user']['department']);
//
//           switch (res['user']['department']) {
//             case "Admin":
//               Navigator.pushReplacementNamed(context, "/admin");
//               break;
//             case "Supplier":
//               Navigator.pushReplacementNamed(context, "/supplier");
//               break;
//             case "Logistics":
//               Navigator.pushReplacementNamed(context, "/logistics");
//               break;
//             case "Sales":
//               Navigator.pushReplacementNamed(context, "/finance");
//               break;
//             case "Manager":
//               Navigator.pushReplacementNamed(context, "/manager");
//               break;
//             case "Engineer":
//               Navigator.pushReplacementNamed(context, "/engineer");
//               break;
//             case "IT":
//               Navigator.pushReplacementNamed(context, "/it");
//               break;
//           }
//         } else if(res["success"] == false){
//           ScaffoldMessenger.of(context).showSnackBar(snackBar1);
//         }
//       }
//     } catch(e) {
//       print(e);
//       ScaffoldMessenger.of(context).showSnackBar(snackBar2);
//     } finally{
//       setState(() {
//         isLoading = false;
//       });
//
//       await Future.delayed(const Duration(seconds: 2));
//       ScaffoldMessenger.of(context).hideCurrentSnackBar();
//     }
//   }
//
//   bool validate() {
//     if(nameController.text=="" || passwordController.text==""){
//       ScaffoldMessenger.of(context).showSnackBar(snackBar3);
//       return false;
//     }
//
//     return true;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final isInit = isAnimating || state == ButtonState.init;
//     final buttonWidth = MediaQuery.of(context).size.width;
//
//     return Scaffold(
//       backgroundColor: Colors.black,
//       body: Padding(
//           padding: const EdgeInsets.symmetric(vertical: 50.0, horizontal: 30.0),
//           child: ListView(
//             children: <Widget>[
//               Container(
//                   alignment: Alignment.center,
//                   padding: const EdgeInsets.all(10),
//                   child: const Text(
//                     'Welcome Back!',
//                     style: TextStyle(
//                         color: Colors.white,
//                         fontWeight: FontWeight.w500,
//                         fontSize: 45),
//                   )),
//               Container(
//                 padding: const EdgeInsets.fromLTRB(10, 120, 10, 10),
//                 child: TextField(
//                   cursorColor: Colors.white,
//                   style: const TextStyle(color: Colors.white),
//                   keyboardType: TextInputType.text,
//                   controller: nameController,
//                   decoration: const InputDecoration(
//                       enabledBorder: OutlineInputBorder(
//                           borderSide: BorderSide(color: Colors.white)),
//                       focusedBorder: OutlineInputBorder(
//                           borderSide: BorderSide(color: Colors.white)),
//                       labelText: 'Email ID',
//                       labelStyle: TextStyle(
//                         color: Colors.white,
//                       )),
//                 ),
//               ),
//               Container(
//                 padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
//                 child: TextField(
//                   cursorColor: Colors.white,
//                   obscureText: !passwordVisible,
//                   style: const TextStyle(color: Colors.white),
//                   controller: passwordController,
//                   decoration: InputDecoration(
//                       suffixIcon: IconButton(
//                         icon: Icon(passwordVisible ? Icons.visibility : Icons.visibility_off, color: Colors.white, ),
//                         onPressed: () {
//                           setState(() {
//                             passwordVisible = !passwordVisible;
//                           });
//                         },
//                       ),
//                       enabledBorder: const OutlineInputBorder(
//                           borderSide: BorderSide(color: Colors.white)),
//                       focusedBorder: const OutlineInputBorder(
//                           borderSide: BorderSide(color: Colors.white)),
//                       labelText: 'Password',
//                       labelStyle: const TextStyle(
//                         color: Colors.white,
//                       )),
//                 ),
//               ),
//               Container(
//                 height: 100,
//                 padding: const EdgeInsets.fromLTRB(90, 50, 90, 0),
//                 child: AnimatedContainer(
//                     duration: const Duration(milliseconds: 300),
//                     onEnd: () => setState(() {
//                       isAnimating = !isAnimating;
//                     }),
//                     width: state == ButtonState.init ? buttonWidth : 70,
//                     height: 60,
//                     child: isInit ? buildButton() : circularContainer()),
//               )
//             ],
//           )
//       ),
//     );
//   }
//
//   Widget buildButton() => ElevatedButton(
//     style: ButtonStyle(
//         backgroundColor: MaterialStateProperty.all(const Color.fromRGBO(134, 97, 255, 1))
//     ),
//     onPressed: isLoading ? null : () async {
//       setState(() {
//         state = ButtonState.submitting;
//       });
//       _login();
//       setState(() {
//         state = ButtonState.init;
//       });
//     },
//     child: const Text('Login'),
//   );
//
//   Widget circularContainer() {
//     const color = const Color.fromRGBO(134, 97, 255, 1);
//     return Container(
//       decoration: const BoxDecoration(shape: BoxShape.circle, color: color),
//       child: const Center(
//         child: CircularProgressIndicator(
//           color: Colors.white,
//         ),
//       ),
//     );
//   }
// }















import 'package:crm/services/remote_services.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

enum ButtonState { init, submitting }

class _LoginPageState extends State<LoginPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final RemoteServices _apiClient = RemoteServices();
  var isLoading = false;
  bool isAnimating = true;
  ButtonState state = ButtonState.init;
  bool passwordVisible = false;
  final snackBar1 = const SnackBar(
    content: Text('Wrong Credentials'),
    backgroundColor: Colors.red,
  );
  final snackBar2 = const SnackBar(
    content: Text('Something Went Wrong!'),
    backgroundColor: Colors.red,
  );
  final snackBar3 = const SnackBar(
    content: Text('Please enter the Fields!'),
    backgroundColor: Colors.red,
  );

  void _login() async {
    try {
      setState(() {
        isLoading = true;
      });

      if (validate() == true) {
        print(nameController.text);
        print(passwordController.text);
        dynamic res = await _apiClient.login(
          nameController.text,
          passwordController.text,
        );

        if (res["success"] == true) {
          final SharedPreferences prefs = await SharedPreferences.getInstance();

          prefs.setString("auth-token", res['auth']);
          prefs.setString("email", res["user"]["emailWork"]);
          prefs.setInt("id", res["user"]["employeeId"]);
          prefs.setString('isLoggedIn', res['user']['department']);

          switch (res['user']['department']) {
            case "Admin":
              Navigator.pushReplacementNamed(context, "/admin");
              break;
            case "Supplier":
              Navigator.pushReplacementNamed(context, "/supplier");
              break;
            case "Logistics":
              Navigator.pushReplacementNamed(context, "/logistics");
              break;
            case "Sales":
              Navigator.pushReplacementNamed(context, "/finance");
              break;
            case "Manager":
              Navigator.pushReplacementNamed(context, "/manager");
              break;
            case "Engineer":
              Navigator.pushReplacementNamed(context, "/engineer");
              break;
            case "IT":
              Navigator.pushReplacementNamed(context, "/it");
              break;
          }
        } else if (res["success"] == false) {
          ScaffoldMessenger.of(context).showSnackBar(snackBar1);
        }
      }
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(snackBar2);
    } finally {
      setState(() {
        isLoading = false;
      });

      await Future.delayed(const Duration(seconds: 2));
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
    }
  }

  bool validate() {
    if (nameController.text == "" || passwordController.text == "") {
      ScaffoldMessenger.of(context).showSnackBar(snackBar3);
      return false;
    }

    return true;
  }



  Widget build(BuildContext context) {
      final isInit = isAnimating || state == ButtonState.init;
      final buttonWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Container(
          constraints: BoxConstraints(
            maxWidth: MediaQuery
                .of(context)
                .size
                .width,
            maxHeight: MediaQuery
                .of(context)
                .size
                .height,
          ),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.blue[900]!,
                Colors.blue[700]!,
              ],
              begin: Alignment.topLeft,
              end: Alignment.centerRight,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 36.0, horizontal: 24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Login",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 42.0,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      SizedBox(
                        height: 5.0,
                      ),
                      Text(
                        "Welcome Back",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
                          fontWeight: FontWeight.w400,
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 5,
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30.0),
                        topRight: Radius.circular(30.0),
                      )),
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextField(
                          keyboardType: TextInputType.emailAddress,
                          controller: nameController,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Color(0xFFE7EDEB),
                            hintText: "Email",
                            prefixIcon: Icon(
                              Icons.mail,
                              color: Colors.grey[600],
                            ),
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        TextField(
                          obscureText: !passwordVisible,
                          controller: passwordController,
                          decoration: InputDecoration(
                            suffixIcon: IconButton(
                            icon: Icon(passwordVisible ? Icons.visibility : Icons.visibility_off, color: Colors.black, ),
                              onPressed: () {
                                setState(() {
                                  passwordVisible = !passwordVisible;
                                });
                              },
                            ),
                            filled: true,
                            fillColor: Color(0xFFE7EDEB),
                            hintText: "password",
                            prefixIcon: Icon(
                              Icons.lock,
                              color: Colors.grey[600],
                            ),
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 50.0,
                        ),
                        Container(
                          width: double.infinity,
                          // padding: const EdgeInsets.fromLTRB(90, 50, 90, 0),
                          child: AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              onEnd: () =>
                                  setState(() {
                                    isAnimating = !isAnimating;
                                  }),
                              width: state == ButtonState.init
                                  ? buttonWidth
                                  : 70,
                              height: 60,
                              child: isInit
                                  ? buildButton()
                                  : circularContainer()),
                        ),
                        SizedBox(
                          height: 80.0,
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildButton() =>
      ElevatedButton(
        onPressed: isLoading ? null : () async {
          setState(() {
            state = ButtonState.submitting;
          });
          _login();
          setState(() {
            state = ButtonState.init;
          });
        },
        // onPressed: () {},
        // shape: RoundedRectangleBorder(
        //   borderRadius: BorderRadius.circular(8.0),
        // ),
        // color: Colors.blue[600],
        child: Padding(
          padding:
          const EdgeInsets.symmetric(vertical: 18.0),
          child: Text(
            "Login",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18.0,
            ),
          ),
        ),
      );

//
  Widget circularContainer() {
    const color = const Color.fromRGBO(134, 97, 255, 1);
    return Container(
      decoration: const BoxDecoration(shape: BoxShape.circle, color: color),
      child: const Center(
        child: CircularProgressIndicator(
          color: Colors.white,
        ),
      ),
    );
  }
}

