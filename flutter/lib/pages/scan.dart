import 'dart:async';
import 'dart:convert';

import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_listener/flutter_barcode_listener.dart';
import 'package:http/http.dart' as http;
import '../config.dart';
import 'package:visibility_detector/visibility_detector.dart';

class Scan extends StatefulWidget {
  const Scan({Key key}) : super(key: key);

  @override
  State<Scan> createState() => _ScanState();
}

class _ScanState extends State<Scan> {
  bool visible;
  var data = null;

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      onVisibilityChanged: (VisibilityInfo info) {
        visible = info.visibleFraction > 0;
      },
      key: const Key('visible-detector-key'),
      child: BarcodeKeyboardListener(
        bufferDuration: const Duration(milliseconds: 200),
        onBarcodeScanned: (qrcode) {
          if (!visible) return;

          if (data == null) {
            attend(qrcode);
          }
        },
        child: data == null
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 300,
                    width: 300,
                    margin: const EdgeInsets.only(top: 32),
                    decoration: BoxDecoration(
                      
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Image.asset("assets/scan.gif"),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  const Text(
                    "Scaning...",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 26,
                        color: Colors.white),
                  ),
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 300,
                    width: 250,
                    margin: const EdgeInsets.only(top: 120),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          width: 16, color: const Color(0xFF600026)),
                      boxShadow: const [
                        BoxShadow(
                            blurRadius: 10,
                            spreadRadius: 10,
                            color: Color(0xFFe40d62))
                      ],
                        color: primeryColor,
                        image: data['img'].toString() == "0"
                            ? DecorationImage(
                                fit: BoxFit.fill,
                                image: NetworkImage(
                                    "https://ajstyle.lk/attend/images/${data['id']}.jpg"))
                            : null),
                    child: Visibility(
                      visible: data["img"].toString() == "1",
                      child: const Icon(
                        Icons.person,
                        color: Colors.white,
                        size: 120,
                      ),
                    ),
                  ),const SizedBox(height: 24,),
                  Text(
                    data["name"].toString().toUpperCase(),
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                        color: Colors.white),
                  ),
                  Text(
                    data["id"].toString().padLeft(6, '0'),
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                        color: Colors.white),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(
                        Icons.done,
                        color: Colors.green,
                      ),
                      Text(
                        " Attended",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                            color: Colors.green),
                      ),
                    ],
                  ),
                ],
              ),
      ),
    );
  }

  void attend(String qr) async {
    try {
      String path = "$url/attend.php";

      final response =
          await http.post(Uri.parse(path), body: {"key": accessKey, "id": qr});

      if (response.statusCode == 201) {
        data = jsonDecode(response.body);
        if (data.toString() != "0") {
          setState(() {});
          Timer(const Duration(milliseconds: 3500), () {
            setState(() {
              data = null;
            });
          });
        } else {
          data = null;
          Flushbar(
            message: 'Already Attended!',
            messageColor: Colors.red,
            backgroundColor: Colors.black,
            duration: const Duration(seconds: 3),
            icon: const Icon(
              Icons.warning_rounded,
              color: Colors.red,
            ),
          ).show(context);
        }
      }
    } catch (e) {
      Flushbar(
        message: 'No internet connection !',
        messageColor: Colors.red,
        backgroundColor: Colors.black,
        duration: const Duration(seconds: 3),
        icon: const Icon(
          Icons.warning_rounded,
          color: Colors.red,
        ),
      ).show(context);
    }
  }
}
