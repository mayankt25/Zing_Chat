import 'package:flutter/material.dart';

const kSendButtonTextStyle = TextStyle(
  color: kAppColor,
  fontWeight: FontWeight.bold,
  fontSize: 18.0,
);

const kAppColor = Color(0xFF2B3595);
const kAppRegiColor = Color(0xFF1C2E46);
const kBackgroundColor = Color(0xFFF5F5F5);

const kMessageTextFieldDecoration = InputDecoration(
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  hintText: 'Type your message here...',
  hintStyle: TextStyle(
    color: Colors.grey,
  ),
  border: InputBorder.none,
);

const kMessageContainerDecoration = BoxDecoration(
  borderRadius: BorderRadius.only(
    topLeft: Radius.circular(20.0),
    topRight: Radius.circular(20.0),
  ),
  color: kBackgroundColor,
  border: Border(
    top: BorderSide(color: kAppColor, width: 2.0),
  ),
);

const kTextFieldDecoration = InputDecoration(
  hintStyle: TextStyle(
    color: Colors.grey,
  ),
  contentPadding:
  EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide:
    BorderSide(color: kAppColor, width: 1.0),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide:
    BorderSide(color: kAppColor, width: 2.0),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
);
