

import 'package:flutter/material.dart';

 Widget appBarCustom=Container(

  decoration: BoxDecoration(
   gradient: LinearGradient(colors: [Color(int.parse("0xff2193b0")),Color(int.parse("0xff6dd5ed"))])
  ),

);
 const String appName="LogThat";
 const kTextColor = Color(0xFF757575);
OutlineInputBorder outlineInputBorder() {
 return OutlineInputBorder(
  borderRadius: BorderRadius.circular(15),
  borderSide: BorderSide(color: kTextColor),
 );
}
