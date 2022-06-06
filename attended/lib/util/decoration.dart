import 'package:flutter/material.dart';


class CustomDecoration {
  final String label;
  const CustomDecoration({ Key key, @required this.label});

  static InputDecoration decoration(String label) {
    return InputDecoration(
        labelText: label,
        counterText: "",
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.black87)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8));
  }

  static InputDecoration decorationTextAria(String label) {
    return InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.black87)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8));
  }

  static InputDecoration decorationDropDown(String label, String text) {
    return InputDecoration(
        labelText: text != null ? label : null,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.black87)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8));
  }

  /* static BoxDecoration decorationButton() {
    return BoxDecoration(
        color: color,
        borderRadius: new BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
              color: color[400], blurRadius: 12.0, spreadRadius: 0.2)
        ]);
  } */
}
