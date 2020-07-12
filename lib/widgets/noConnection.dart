import 'package:flutter/material.dart';

class Offline extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    bool dark = MediaQuery.of(context).platformBrightness == Brightness.dark;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
            color: dark ? Color(0xff202225) : Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey[400],
                blurRadius: dark ? 1 : 8.0,
              ),
            ],
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
          ),
          width: double.infinity,
          height: 187,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                    child: Image.asset(
                      "assets/spaceman.png",
                      height: 150,
                    ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "You've officially made it to space. No internet here",
                  style: TextStyle(fontSize: 15, fontFamily: "sans"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
