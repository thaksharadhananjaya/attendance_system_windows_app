
// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

class ComfirmDailogBox extends StatelessWidget {
  final Widget yesButton;
  final Icon icon;


  const ComfirmDailogBox({Key key, @required this.yesButton, @required  this.icon}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Constants.padding),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: contentBox(context),
    );
  }

  Stack contentBox(context) {
    return Stack(
      children: <Widget>[
        Container(
          width: 360,
          padding: const EdgeInsets.only(
              left: Constants.padding,
              top: Constants.avatarRadius + Constants.padding,
              right: Constants.padding,
              bottom: Constants.padding),
          margin: const EdgeInsets.only(top: Constants.avatarRadius),
          decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: Colors.white,
              borderRadius: BorderRadius.circular(Constants.padding),
              boxShadow: const [
                BoxShadow(
                    color: Colors.black, offset: Offset(0, 10), blurRadius: 10),
              ]),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const Text(
                'Are you sure ?',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
                maxLines: 1,
              ),
              const SizedBox(
                height: 15,
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                        height: 32,
                        width: 75,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            color: Colors.red[300]),
                        child: yesButton),
                    const SizedBox(
                      width: 25,
                    ),
                    Container(
                      height: 32,
                      width: 75,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          color: Colors.green),
                      child: FlatButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text(
                            "No",
                            style: TextStyle(fontSize: 17, color: Colors.white),
                          )),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Positioned(
          left: Constants.padding,
          right: Constants.padding,
          child: CircleAvatar(
            backgroundColor: Colors.white,
            radius: Constants.avatarRadius,
            child: CircleAvatar(
              backgroundColor: Colors.red,
              radius: 45,
              child: ClipRRect(
                  borderRadius:
                      const BorderRadius.all(Radius.circular(Constants.avatarRadius)),
                  child: icon,
            )),
          ),
        ),
      ],
    );
  }
}

class Constants {
  Constants._();

  static const double padding = 16.0;
  static const double avatarRadius = 50.0;
}
