import 'package:flutter/material.dart';

class MenuItem {
  String name;
  double price;
  MenuItem(this.name, this.price);
}



class Menu extends StatelessWidget {
  String name;
  String image;
  var menu = [MenuItem("Eggs", 3.30)];
  Menu(this.name, this.image);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        title: Text(
          "$name",
          style: TextStyle(
              fontSize: 30, fontWeight: FontWeight.w400, color: Colors.black),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(8),
        child: Column(
          children: <Widget>[],
        ),
      ),
    );
  }
}
