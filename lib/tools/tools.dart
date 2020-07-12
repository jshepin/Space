import 'package:flutter/material.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

Color colorFromHex(String hexColor) {
  final hexCode = hexColor.replaceAll('#', '');
  return Color(int.parse('FF$hexCode', radix: 16));
}

 Future<String> getColor() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //print("got color ${Colors.green[500].toString().substring(6, 16)}");
    return prefs.getString("color") ?? Colors.green[500].toString().substring(6, 16);
  }
  
  Future<List<String>> getTravelers() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getStringList("travelers") ?? ["false","false","false","false","false","false","false","false",];
}

 Future<List<String>> getShowHalfPeriods() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getStringList("halfPeriods") ?? ["false","false","false","false","false","false","false","false",];
}
