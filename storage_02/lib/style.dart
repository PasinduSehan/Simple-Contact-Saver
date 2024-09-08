import 'package:flutter/material.dart';

class apptextfeld {
  static InputDecoration main =
      InputDecoration(border: OutlineInputBorder(), hintText: 'contact name');

  static InputDecoration main2({hintText = 'enter your'}) {
    return InputDecoration(border: OutlineInputBorder(), hintText: hintText);
  }
}
