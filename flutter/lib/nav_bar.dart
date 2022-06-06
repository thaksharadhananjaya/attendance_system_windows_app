// ignore_for_file: deprecated_member_use

import 'package:attended/pages/about.dart';
import 'package:attended/pages/home.dart';
import 'package:attended/pages/user.dart';
import 'package:flutter/material.dart';

import 'pages/scan.dart';

class NavBar extends StatefulWidget {
  const NavBar({Key key}) : super(key: key);

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  int index = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          bulidSideBar(),
          SizedBox(
            width: MediaQuery.of(context).size.width - 80,
            child: index == 0 ? const User() : const About(),
          ),
        ],
      ),
    );
  }

  Container bulidSideBar() {
    return Container(
      color: const Color(0xFF600026),
      width: 80,
      child: Column(
        children: [
          buildNavBtn(() {
            setState(() {
              index = 0;
            });
          }, Icons.group, "Guest", 0),
          buildNavBtn(() {
            setState(() {
              index = 1;
            });
          }, Icons.info, "About", 1),
          buildNavBtn(() {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const Home()),
            );
          }, Icons.logout, "Logout", 2),
        ],
      ),
    );
  }

  // ignore: deprecated_member_use
  FlatButton buildNavBtn(
      Function onPress, IconData icon, String label, int order) {
    return FlatButton(
      color: index == order ? Colors.black12 : const Color(0xFF600026),
      onPressed: () => onPress(),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Icon(
              icon,
              color: Colors.white,
              size: 50,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 24),
            child: Text(
              label,
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold),
            ),
          )
        ],
      ),
    );
  }
}
