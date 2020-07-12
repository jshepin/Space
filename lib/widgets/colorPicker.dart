import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:space/data/calanderData.dart';
import 'package:space/main.dart';
import 'package:space/tools/tools.dart';
import 'package:space/widgets/flutter_hsvcolor_picker.dart';
import 'package:space/widgets/btmnavbar.dart';

import 'countdown.dart';

class Picker extends StatefulWidget {
  @override
  _PickerState createState() => _PickerState();
}

//Color c = Colors.green;

Color selectedColor;

class _PickerState extends State<Picker> {
  @override
  Widget build(BuildContext context) {
    bool dark = MediaQuery.of(context).platformBrightness == Brightness.dark;
    return Scaffold(
      backgroundColor: dark ? Color(0xff2f3136) : Colors.white,
      bottomNavigationBar: BtmBar(),
      body: SafeArea(
        child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 10, bottom: 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        "Colors",
                        style: TextStyle(fontSize: 37),
                      ),
                      IconButton(
                        onPressed: () async {
                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          await prefs.setString("color",
                              Colors.green[500].toString().substring(6, 16));

                          Navigator.push(
                            context,
                            PageTransition(
                              type: PageTransitionType.fade,
                              duration: Duration(milliseconds: 200),
                              child: TestPage(false),
                            ),
                          );
                        },
                        icon: Icon(
                          Icons.refresh,
                          size: 30,
                        ),
                      )
                    ],
                  ),
                ),
                Divider(),
                FutureBuilder<String>(
                    future: getColor(),
                    builder: (context, colorSnapshot) {
                      selectedColor = Color(int.parse(colorSnapshot.data));
                      //print("sdfas");
                      //print(colorSnapshot.data);
                      if (colorSnapshot.data != null &&
                          colorSnapshot.data.length > 0) {
                        return Column(
                          children: <Widget>[
                            ColorPicker(
                                color: Color(int.parse(colorSnapshot.data)),
                                onChanged: (Color c) async {
                                  setState(() {
                                    selectedColor = c;
                                  });
                                  print(
                                      "got color ${c.toString().substring(9, 16)}");
                                  SharedPreferences prefs =
                                      await SharedPreferences.getInstance();
                                  await prefs.setString(
                                      "color", c.toString().substring(6, 16));
                                }),
                            FutureBuilder<List<CalanderEvent>>(
                                future: getCalanderData(),
                                builder: (context, snapshot) {
                                  if (snapshot.data != null) {
                                    return Padding(
                                      padding: const EdgeInsets.only(
                                          bottom: 3.0,
                                          left: 10,
                                          right: 10,
                                          top: 5),
                                      child: Container(
                                          decoration: BoxDecoration(
                                            boxShadow: [
                                              BoxShadow(
                                                  color: Colors.grey[200],
                                                  blurRadius: 10)
                                            ],
                                            color: Color(
                                                int.parse(colorSnapshot.data)),
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(10),
                                            ),
                                          ),
                                          // color: Colors.black,

                                          child: Column(
                                            children: <Widget>[
                                              Container(
                                                height: 15,
                                              ),
                                              IgnorePointer(
                                                  child: WeekCountdown(
                                                      snapshot.data)),
                                            ],
                                          )),
                                    );
                                  } else {
                                    return Container();
                                  }
                                })
                          ],
                        );
                      } else {
                        return Container();
                      }
                    }),

                // Container(
                //   child: SizedBox(
                //     height: 460,
                //     //width: 300,
                //     //color: Colors.red,
                //     child: Transform.scale(
                //       alignment: Alignment.topCenter,
                //       scale: 0.5,
                //       child: new TestPage(true),
                //     ),
                //   ),
                // )
              ],
            )),
      ),
    );
  }
}
