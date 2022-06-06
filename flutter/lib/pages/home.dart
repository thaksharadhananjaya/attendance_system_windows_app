import 'package:attended/pages/login.dart';
import 'package:attended/pages/scan.dart';
import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  const Home({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF600026),
      body: SizedBox(
        width: double.maxFinite,
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            Align(alignment: Alignment.topCenter,
            child: Image.asset("assets/logo.png", width: 250, height: 200,),),
            const Center(child: Scan()),
            Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: IconButton(
                      hoverColor: Colors.transparent,
                      tooltip: "Login",
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Login()),
                        );
                      },
                      icon: const Icon(
                        Icons.login,
                        size: 30,
                        color: Colors.white,
                      )),
                ))
          ],
        ),
      ),
    );
  }
  
}
