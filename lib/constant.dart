
import 'package:flutter/material.dart';

const kTextFieldDecoration = InputDecoration(
  labelStyle: TextStyle(
    fontSize: 14.0,
    color: Colors.black,
  ),
  hintText: 'Enter a value',
  hintStyle: TextStyle(color: Colors.black, fontSize: 12.0,  decorationColor: Colors.transparent, decoration: TextDecoration.none),
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  focusedBorder: InputBorder.none,
  enabledBorder: InputBorder.none,
  errorBorder: InputBorder.none,
  disabledBorder: InputBorder.none,
  // border: OutlineInputBorder(
  //   borderRadius: BorderRadius.all(Radius.circular(32.0)),
  // ),
  // enabledBorder: OutlineInputBorder(
  //   borderSide: BorderSide(color: Color(0xFF00BFA5), width: 1.0),
  //   borderRadius: BorderRadius.all(Radius.circular(32.0)),
  // ),
  // focusedBorder: OutlineInputBorder(
  //   borderSide: BorderSide(color: Color(0xFF00BFA5), width: 2.0),
  //   borderRadius: BorderRadius.all(Radius.circular(32.0)),
  // ),
);

final kLabelTextStyle = TextStyle(
    color: Colors.red.shade400,
    fontSize: 30.0,
    fontWeight: FontWeight.w600,
    // decoration: TextDecoration.underline
);
