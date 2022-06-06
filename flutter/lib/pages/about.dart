import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class About extends StatelessWidget {
  const About({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Attendence System v1.0 (2022 - May)",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
        ),
        const Text(
          "Developed By Thakshara Dhananjaya",
          style: TextStyle(fontSize: 15),
        ),
       
        const Text(
          "+94776591828",
          style: TextStyle(fontSize: 15),
        ),
         const SizedBox(
          height: 14,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              width: 16,
            ),
            InkWell(
              onTap: () async {
                // ignore: deprecated_member_use
                await launch('https://www.linkedin.com/in/thakshara',
                    forceSafariVC: false, forceWebView: false);
              },
              child: const FaIcon(
                FontAwesomeIcons.linkedin,
                size: 30,
                color: Color(0xff0077b5),
              ),
            ),
            const SizedBox(
              width: 16,
            ),
            InkWell(
              onTap: () async {
                await launch('mailto:thaksharadhananjaya@gmail.com',
                    forceSafariVC: false, forceWebView: false);
              },
              child: const FaIcon(
                Icons.email,
                size: 32,
                color: Colors.orange,
              ),
            ),
          ],
        )
      ],
    );
  }
}
