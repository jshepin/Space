import 'package:flutter/material.dart';


class Authenticate extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
            Text("Welcome to Space",style: TextStyle(fontSize: 28,fontFamily: 'comfortaa'),),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Text("For your and others safety, please authenticate you are a Stevenson student.",textAlign: TextAlign.center,),
            )
        ],
      ),
          )),
    );
  }
}
