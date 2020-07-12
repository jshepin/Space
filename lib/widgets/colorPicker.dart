import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:space/main.dart';
import 'package:space/tools/tools.dart';
import 'package:space/widgets/flutter_hsvcolor_picker.dart';
import 'package:space/widgets/btmnavbar.dart';

class Picker extends StatefulWidget {
  @override
  _PickerState createState() => _PickerState();
}

//Color c = Colors.green;

class _PickerState extends State<Picker> {
  @override
  Widget build(BuildContext context) {
    bool dark = MediaQuery.of(context).platformBrightness == Brightness.dark;
    return Scaffold(
      backgroundColor: dark ? Color(0xff2f3136) : Colors.white,
      bottomNavigationBar: BtmBar(),
      body: Container(
        child: Padding(
            padding: const EdgeInsets.fromLTRB(8, 30, 8, 0),
            child: Column(
              children: <Widget>[
                FutureBuilder<String>(
                    future: getColor(),
                    builder: (context, colorSnapshot) {
                      //print("sdfas");
                      //print(colorSnapshot.data);
                      if (colorSnapshot.data != null &&
                          colorSnapshot.data.length > 0) {
                        return ColorPicker(
                            color: Color(int.parse(colorSnapshot.data)),
                            onChanged: (Color c) async {
                              print(
                                  "got color ${c.toString().substring(9, 16)}");
                              //setState(() {
                              //});
                              SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                              await prefs.setString(
                                  "color", c.toString().substring(6, 16));
                            });
                      } else {
                        return Container();
                      }
                    }),
                Container(
                  child: SizedBox(
                    height: 460,
                    //width: 300,
                    //color: Colors.red,
                    child: Transform.scale(
                      alignment: Alignment.topCenter,
                      scale: 0.5,
                      child: new TestPage(true),
                    ),
                  ),
                )
              ],
            )),
      ),
    );
  }
}
