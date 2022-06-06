import 'package:another_flushbar/flushbar.dart';
import 'package:attended/config.dart';
import 'package:attended/nav_bar.dart';
import 'package:flutter/material.dart';

class Login extends StatelessWidget {
  Login({Key key}) : super(key: key);
  FocusNode focusNodePass = FocusNode();
  TextEditingController textEditingControllerUser = TextEditingController();
  TextEditingController textEditingControllerPass = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: primeryColor,
      ),
      body: buildLogin(context),
    );
  }

  Widget buildLogin(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 400,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
                margin: const EdgeInsets.only(bottom: 24),
                alignment: Alignment.centerLeft,
                child: const Text(
                  'Login to admin account',
                  style: TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.bold,
                      fontSize: 22),
                )),

            // User Name
            TextFormField(
              maxLength: 20,
              autofocus: true,
              controller: textEditingControllerUser,
              decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.person),
                  hintText: 'User Name',
                  counter: const Text(''),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Colors.black87)),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 8)),
              onFieldSubmitted: (text) {
                focusNodePass.requestFocus();
              },
            ),
            const SizedBox(
              height: 20,
            ),
            // Password
            TextFormField(
              maxLength: 8,
              focusNode: focusNodePass,
              controller: textEditingControllerPass,
              obscureText: true,
              decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.lock),
                  hintText: 'Password',
                  counter: const Text(''),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Colors.black87)),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 8)),
              onFieldSubmitted: (text) => login(context),
            ),
            const SizedBox(
              height: 40,
            ),

            // Loging Buttons
            SizedBox(
              width: 180,
              height: 50,

              // ignore: deprecated_member_use
              child: FlatButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                color: primeryColor,
                child: const Text(
                  'Login',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                onPressed: ()=>login(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void login(BuildContext context) {  String user = textEditingControllerUser.text;
                String pass = textEditingControllerPass.text;
                if (user == "admin" && pass == "1234") {
                  Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const NavBar()),
            );
                }else if(user.isEmpty && pass.isEmpty){
                  Flushbar(
                    message: 'Enter Username & Password !',
                    messageColor: Colors.red,
                    messageSize: 18,
                    duration: const Duration(seconds: 4),
                    icon: const Icon(
                      Icons.warning_rounded,
                      color: Colors.red,
                    ),
                  ).show(context);
                }
                else if(user.isEmpty){
                  Flushbar(
                    message: 'Enter Username !',
                    messageColor: Colors.red,
                    messageSize: 18,
                    duration: const Duration(seconds: 4),
                    icon: const Icon(
                      Icons.warning_rounded,
                      color: Colors.red,
                    ),
                  ).show(context);
                }else if(pass.isEmpty){
                  Flushbar(
                    message: 'Enter Password !',
                    messageColor: Colors.red,
                    messageSize: 18,
                    duration: const Duration(seconds: 4),
                    icon: const Icon(
                      Icons.warning_rounded,
                      color: Colors.red,
                    ),
                  ).show(context);
                } else {
                  Flushbar(
                    message: 'Wrong user name or password !',
                    messageColor: Colors.red,
                    messageSize: 18,
                    duration: const Duration(seconds: 4),
                    icon: const Icon(
                      Icons.warning_rounded,
                      color: Colors.red,
                    ),
                  ).show(context);
                }}
}
