import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:space/tools/tools.dart';
import 'package:space/widgets/btmnavbar.dart';

class GenerateColors extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

Future<bool> getPref(name) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getBool(name) ?? true;
}

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  _SettingsState();
  bool showLunchMenu = true;
  bool showCalendar = true;
  bool showWeather = true;
  bool calendarReminders = true;
  bool imperialUnits = true;
  bool showLunchPricing = true;

  var colors = [
    ["#F44336", "#E53935", "#D32F2F"],
    ["#9C27B0", "#8E24AA"]
  ];
  changeSetting(name, setTo) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(name, setTo);
  }

  @override
  Widget build(BuildContext context) {
    bool dark = MediaQuery.of(context).platformBrightness == Brightness.dark;
    return Scaffold(
        bottomNavigationBar: BtmBar(),
        resizeToAvoidBottomInset: false,
        backgroundColor: dark ? Color(0xff2f3136) : Colors.white,
        // appBar: AppBar(
        //   leading: Container(),
        //   centerTitle: true,
        //   //brightness: !dark
        //   //    ? Brightness.light
        //   //    : Brightness.dark, // status bar brightness

        //   backgroundColor: dark ? Color(0xff2f3136) : Colors.white,
        //   title: Text(
        //     "Settings",
        //     style: TextStyle(
        //         fontSize: 26,
        //         color: dark ? Colors.white : Colors.black,
        //         fontFamily: "sans"),
        //   ),
        // ),
        body: SafeArea(
          child: SingleChildScrollView(
              child: FutureBuilder<String>(
                  future: getColor(),
                  builder: (context, colorSnapshot) {
                    if (colorSnapshot.data != null &&
                        colorSnapshot.data.length > 0) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 10, bottom: 0),
                                child: Text(
                                  "Settings",
                                  style: TextStyle(fontSize: 37),
                                ),
                              ),
                              Divider(),
                              Container(
                                child: Column(
                                  children: <Widget>[
                                    Column(
                                      children: <Widget>[
                                        FutureBuilder<bool>(
                                            future: getPref("showWeather"),
                                            builder: (BuildContext context,
                                                AsyncSnapshot<bool> snapshots) {
                                              if (snapshots.data != null) {
                                                return Container(
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: <Widget>[
                                                      Row(
                                                        children: <Widget>[
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    left: 8.0),
                                                            child: Icon(
                                                                Icons.wb_sunny),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    left: 8),
                                                            child: Text(
                                                              "Weather",
                                                              style: TextStyle(
                                                                  fontSize: 18),
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                      Platform.isIOS
                                                          ? CupertinoSwitch(
                                                              value: snapshots
                                                                  .data,
                                                              onChanged:
                                                                  (value) {
                                                                setState(() {
                                                                  changeSetting(
                                                                      "showWeather",
                                                                      value);
                                                                  showWeather =
                                                                      value;
                                                                });
                                                              },
                                                            )
                                                          : Switch(
                                                              activeColor:
                                                                  Colors.blue,
                                                              value: snapshots
                                                                  .data,
                                                              onChanged:
                                                                  (value) {
                                                                setState(() {
                                                                  changeSetting(
                                                                      "showWeather",
                                                                      value);
                                                                  showWeather =
                                                                      value;
                                                                });
                                                              },
                                                            )
                                                    ],
                                                  ),
                                                );
                                              } else {
                                                return Container();
                                              }
                                            }),
                                        FutureBuilder<bool>(
                                            future: getPref("imperialUnits"),
                                            builder: (BuildContext context,
                                                AsyncSnapshot<bool> snapshots) {
                                              if (snapshots.data != null) {
                                                return Container(
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: <Widget>[
                                                      Row(
                                                        children: <Widget>[
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    left: 8.0),
                                                            child: Text(
                                                              "°F",
                                                              style: TextStyle(
                                                                  fontSize: 20),
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    left: 8),
                                                            child: Text(
                                                              "Imperial Units",
                                                              style: TextStyle(
                                                                  fontSize: 18),
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                      Platform.isIOS
                                                          ? CupertinoSwitch(
                                                              value: snapshots
                                                                  .data,
                                                              onChanged:
                                                                  (value) {
                                                                setState(() {
                                                                  changeSetting(
                                                                      "imperialUnits",
                                                                      value);
                                                                  imperialUnits =
                                                                      value;
                                                                });
                                                              },
                                                            )
                                                          : Switch(
                                                              activeColor:
                                                                  Colors.blue,
                                                              value: snapshots
                                                                  .data,
                                                              onChanged:
                                                                  (value) {
                                                                setState(() {
                                                                  changeSetting(
                                                                      "imperialUnits",
                                                                      value);
                                                                  imperialUnits =
                                                                      value;
                                                                });
                                                              },
                                                            ),
                                                    ],
                                                  ),
                                                );
                                              } else {
                                                return Container();
                                              }
                                            }),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Column(children: <Widget>[
                                FutureBuilder<bool>(
                                  future: getPref("showCalendar"),
                                  builder: (BuildContext context,
                                      AsyncSnapshot<bool> snapshots) {
                                    if (snapshots.data != null) {
                                      return Container(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Row(
                                              children: <Widget>[
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 8.0),
                                                  child: Icon(
                                                      Icons.calendar_today),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 8),
                                                  child: Text(
                                                    "Calender",
                                                    style:
                                                        TextStyle(fontSize: 18),
                                                  ),
                                                )
                                              ],
                                            ),
                                            Platform.isIOS
                                                ? CupertinoSwitch(
                                                    value: snapshots.data,
                                                    onChanged: (value) {
                                                      setState(() {
                                                        changeSetting(
                                                            "showCalendar",
                                                            value);
                                                        showCalendar = value;
                                                      });
                                                    },
                                                  )
                                                : Switch(
                                                    activeColor: Colors.blue,
                                                    value: snapshots.data,
                                                    onChanged: (value) {
                                                      setState(() {
                                                        changeSetting(
                                                            "showCalendar",
                                                            value);
                                                        showCalendar = value;
                                                      });
                                                    },
                                                  ),
                                          ],
                                        ),
                                      );
                                    } else {
                                      return Container();
                                    }
                                  },
                                ),
                                Container(
                                  child: Column(
                                    children: <Widget>[
                                      FutureBuilder<bool>(
                                        future: getPref("calendarReminders"),
                                        builder: (BuildContext context,
                                            AsyncSnapshot<bool> snapshots) {
                                          if (snapshots.data != null) {
                                            return AbsorbPointer(
                                                absorbing:
                                                    showCalendar ? false : true,
                                                child: Container(
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: <Widget>[
                                                      Row(
                                                        children: <Widget>[
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    left: 8.0),
                                                            child: Icon(Icons
                                                                .notifications),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    left: 8),
                                                            child: Text(
                                                              "Event Reminders",
                                                              style: TextStyle(
                                                                  fontSize: 18),
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                      Platform.isIOS
                                                          ? CupertinoSwitch(
                                                              value: snapshots
                                                                  .data,
                                                              onChanged:
                                                                  (value) {
                                                                setState(() {
                                                                  changeSetting(
                                                                      "calendarReminders",
                                                                      value);
                                                                  calendarReminders =
                                                                      value;
                                                                });
                                                              },
                                                            )
                                                          : Switch(
                                                              activeColor:
                                                                  Colors.blue,
                                                              value: snapshots
                                                                  .data,
                                                              onChanged:
                                                                  (value) {
                                                                setState(() {
                                                                  changeSetting(
                                                                      "calendarReminders",
                                                                      value);
                                                                  calendarReminders =
                                                                      value;
                                                                });
                                                              },
                                                            ),
                                                    ],
                                                  ),
                                                ));
                                          } else {
                                            return Container();
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ]),
                              Column(children: <Widget>[
                                Container(
                                  child: Column(
                                    children: <Widget>[
                                      FutureBuilder<bool>(
                                        future: getPref("showLunchMenu"),
                                        builder: (BuildContext context,
                                            AsyncSnapshot<bool> snapshots) {
                                          if (snapshots.data != null) {
                                            return AbsorbPointer(
                                                absorbing:
                                                    showCalendar ? false : true,
                                                child: Container(
                                                  //height: 49,
                                                  //color: dark
                                                  //    ? Color(0xff202225)
                                                  //    : Colors.white,
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: <Widget>[
                                                      Row(
                                                        children: <Widget>[
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    left: 8.0),
                                                            child: Icon(Icons
                                                                .restaurant_menu),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    left: 8),
                                                            child: Text(
                                                              "Lunch Menu",
                                                              style: TextStyle(
                                                                  fontSize: 18),
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                      Platform.isIOS
                                                          ? CupertinoSwitch(
                                                              value: snapshots
                                                                  .data,
                                                              onChanged:
                                                                  (value) {
                                                                setState(() {
                                                                  changeSetting(
                                                                      "showLunchMenu",
                                                                      value);
                                                                  showLunchMenu =
                                                                      value;
                                                                });
                                                              },
                                                            )
                                                          : Switch(
                                                              activeColor:
                                                                  Colors.blue,
                                                              value: snapshots
                                                                  .data,
                                                              onChanged:
                                                                  (value) {
                                                                setState(() {
                                                                  changeSetting(
                                                                      "showLunchMenu",
                                                                      value);
                                                                  showLunchMenu =
                                                                      value;
                                                                });
                                                              },
                                                            ),
                                                    ],
                                                  ),
                                                ));
                                          } else {
                                            return Container();
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                //customDivider(),

                                Container(
                                  child: Column(
                                    children: <Widget>[
                                      FutureBuilder<bool>(
                                        future: getPref("showLunchPricing"),
                                        builder: (BuildContext context,
                                            AsyncSnapshot<bool> snapshots) {
                                          if (snapshots.data != null) {
                                            return Container(
                                              //height: 49,
                                              //color: dark
                                              //    ? Color(0xff202225)
                                              //    : Colors.white,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: <Widget>[
                                                  Row(
                                                    children: <Widget>[
                                                      Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 8.0),
                                                          child: Row(
                                                            children: <Widget>[
                                                              Text(
                                                                r"""$""",
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        17,
                                                                    color: Colors
                                                                            .grey[
                                                                        500]),
                                                              ),
                                                              Text(
                                                                r"""$""",
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        17,
                                                                    color: Colors
                                                                            .grey[
                                                                        600]),
                                                              ),
                                                              Text(
                                                                r"""$""",
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        17,
                                                                    color: Colors
                                                                            .grey[
                                                                        800]),
                                                              ),
                                                            ],
                                                          )),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(left: 8),
                                                        child: Text(
                                                          "Lunch Pricing",
                                                          style: TextStyle(
                                                              fontSize: 18),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                  Platform.isIOS
                                                      ? CupertinoSwitch(
                                                          value: snapshots.data,
                                                          onChanged: (value) {
                                                            setState(() {
                                                              changeSetting(
                                                                  "showLunchPricing",
                                                                  value);
                                                              showLunchPricing =
                                                                  value;
                                                            });
                                                          },
                                                        )
                                                      : Switch(
                                                          activeColor:
                                                              Colors.blue,
                                                          value: snapshots.data,
                                                          onChanged: (value) {
                                                            setState(() {
                                                              changeSetting(
                                                                  "showLunchPricing",
                                                                  value);
                                                              showLunchPricing =
                                                                  value;
                                                            });
                                                          },
                                                        ),
                                                ],
                                              ),
                                            );
                                          } else {
                                            return Container();
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ]),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 2, right: 2, top: 8),
                                child: Column(
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          bottom: 12.0, left: 2, top: 0),
                                      child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            "Traveler Bell",
                                            style: TextStyle(fontSize: 18),
                                          )),
                                    ),
                                    Container(
                                        width: double.infinity,
                                        child: Container(
                                          child: Padding(
                                            padding: const EdgeInsets.all(0.0),
                                            child: FutureBuilder<List<String>>(
                                                future: getTravelers(),
                                                builder: (BuildContext context,
                                                    AsyncSnapshot<List<String>>
                                                        snapshots) {
                                                  List<String> travelers =
                                                      snapshots.data;

                                                  if (snapshots.data != null) {
                                                    return new GridView.count(
                                                      padding:
                                                          EdgeInsets.all(0),
                                                      shrinkWrap: true,
                                                      physics:
                                                          const NeverScrollableScrollPhysics(),
                                                      crossAxisCount:
                                                          (MediaQuery.of(context)
                                                                      .size
                                                                      .width /
                                                                  100)
                                                              .round(),
                                                      children: List.generate(
                                                          snapshots
                                                                  .data.length -
                                                              1, (index) {
                                                        return Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 3,
                                                                  right: 3,
                                                                  top: 6,
                                                                  bottom: 2),
                                                          child: Container(
                                                            height: 40,
                                                            decoration: BoxDecoration(
                                                                boxShadow: [
                                                                  BoxShadow(
                                                                      color: Colors
                                                                              .grey[
                                                                          350],
                                                                      blurRadius:
                                                                          dark
                                                                              ? 1
                                                                              : 3),
                                                                ],
                                                                borderRadius: BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            10)),
                                                                color: dark
                                                                    ? Color(
                                                                        0xff2f3136)
                                                                    : Colors
                                                                        .white),
                                                            child: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: <
                                                                  Widget>[
                                                                Container(
                                                                  height: 25,
                                                                  //width: 40,
                                                                  decoration: BoxDecoration(
                                                                      borderRadius:
                                                                          BorderRadius.all(Radius.circular(
                                                                              27)),
                                                                      color: Color(
                                                                          int.parse(
                                                                              colorSnapshot.data))),
                                                                  child:
                                                                      Padding(
                                                                    padding:
                                                                        const EdgeInsets.fromLTRB(
                                                                            7,
                                                                            1.9,
                                                                            7,
                                                                            3),
                                                                    child: Text(
                                                                      "${index + 1}-${index + 2}",
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              18,
                                                                          color: Colors
                                                                              .white,
                                                                          fontFamily:
                                                                              "sans"),
                                                                    ),
                                                                  ),
                                                                ),
                                                                Container(
                                                                  child:
                                                                      Transform
                                                                          .scale(
                                                                    scale: 1.2,
                                                                    child:
                                                                        Checkbox(
                                                                      activeColor: Color(int.parse(colorSnapshot
                                                                              .data))
                                                                          .withOpacity(
                                                                              0.7),
                                                                      value: snapshots.data[index] ==
                                                                              "true"
                                                                          ? true
                                                                          : false,
                                                                      onChanged:
                                                                          (newValue) async {
                                                                        setState(
                                                                          () {
                                                                            travelers[index] = newValue
                                                                                ? "true"
                                                                                : "false";
                                                                          },
                                                                        );
                                                                        SharedPreferences
                                                                            prefs =
                                                                            await SharedPreferences.getInstance();
                                                                        await prefs.setStringList(
                                                                            "travelers",
                                                                            travelers);
                                                                      },
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        );
                                                      }),
                                                    );
                                                  } else {
                                                    return Container();
                                                  }
                                                }),
                                          ),
                                        ))
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    } else {
                      return Container();
                    }
                  })),
        ));
    //);
  }
}

void _showDialog(context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        content: new Text(
          "Show the bell icon next to calendar events to easily open that event in the calander app. Reminders are never automatically created.",
          style: TextStyle(fontSize: 18, height: 1.4),
        ),
        actions: <Widget>[
          new FlatButton(
            child: new Text("Close"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}

class Setting extends StatelessWidget {
  IconData icon;
  String title;
  String data;
  Setting({this.title, this.data, this.icon});

  @override
  Widget build(BuildContext context) {
    bool dark = MediaQuery.of(context).platformBrightness == Brightness.dark;

    return Container(
      height: 49,
      color: dark ? Color(0xff202225) : Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Icon(icon),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Text(
                  title,
                  style: TextStyle(fontSize: 18),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}

class CustomDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        height: 1,
        child: Divider(
          color: Colors.grey,
        ));
  }
}
