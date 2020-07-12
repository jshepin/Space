import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:space/tools/tools.dart';
import 'package:space/widgets/alert.dart';
import 'package:space/widgets/countdown.dart';
import 'package:space/widgets/lunchMenu.dart';
import 'package:space/widgets/noConnection.dart';
import 'package:space/widgets/upcommingEvents.dart';
import 'package:space/widgets/weatherWidget.dart';
import 'package:space/widgets/btmnavbar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'data/calanderData.dart';
import 'package:confetti/confetti.dart';
import 'package:connectivity/connectivity.dart';

Future<bool> isOnline() async {
  var connectivityResult = await (Connectivity().checkConnectivity());

  return connectivityResult == ConnectivityResult.mobile ||
      connectivityResult == ConnectivityResult.wifi;
}

Future<bool> getPref(name) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getBool(name) ?? true;
}

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      darkTheme: ThemeData.dark(),
      builder: (context, child) {
        return ScrollConfiguration(
          behavior: MyBehavior(),
          child: child,
        );
      },
      debugShowCheckedModeBanner: false,
      title: 'Week Countdown',
      home: TestPage(false),
    );
  }
}

class TestPage extends StatefulWidget {
  bool display;
  TestPage(this.display);

  @override
  _TestPageState createState() => _TestPageState(display);
}

class _TestPageState extends State<TestPage> {
  bool display;
  _TestPageState(this.display);

  var lastMessage = "";
  var dismissAlert = false;

  ConfettiController _controllerCenter;
  ConfettiController _controllerCenterRight;
  ConfettiController _controllerCenterLeft;
  ConfettiController _controllerTopCenter;
  ConfettiController _controllerBottomCenter;

  final FirebaseMessaging _fcm = FirebaseMessaging();
  StreamSubscription iosSubscription;

  @override
  void initState() {
    _controllerCenter =
        ConfettiController(duration: const Duration(seconds: 10));
    _controllerCenterRight =
        ConfettiController(duration: const Duration(seconds: 10));
    _controllerCenterLeft =
        ConfettiController(duration: const Duration(seconds: 10));
    _controllerTopCenter =
        ConfettiController(duration: const Duration(seconds: 10));
    _controllerBottomCenter =
        ConfettiController(duration: const Duration(seconds: 10));

    super.initState();
    if (Platform.isIOS) {
      iosSubscription = _fcm.onIosSettingsRegistered.listen((data) {});

      _fcm.requestNotificationPermissions();
    }
    _fcm.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        if (lastMessage == "" ||
            lastMessage != message['notification']['title'].toLowerCase()) {
          lastMessage = message['notification']['title'].toLowerCase();
          Platform.isIOS
              ? showDialog(
                  barrierDismissible: true,
                  context: context,
                  builder: (context) => CupertinoAlertDialog(
                    title: Text(message['notification']['title']),
                    content: Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: Text(message['notification']['body']),
                    ),
                    actions: <Widget>[
                      FlatButton(
                        child: Text('Dismiss'),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ],
                  ),
                )
              : showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    content: ListTile(
                      title: Text(message['notification']['title']),
                      subtitle: Text(message['notification']['body']),
                    ),
                    actions: <Widget>[
                      FlatButton(
                        child: Text('Dismiss'),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ],
                  ),
                );
        }
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
      },
    );
  }

  @override
  void dispose() {
    _controllerCenter.dispose();
    _controllerCenterRight.dispose();
    _controllerCenterLeft.dispose();
    _controllerTopCenter.dispose();
    _controllerBottomCenter.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool dark = MediaQuery.of(context).platformBrightness == Brightness.dark;
    double width = MediaQuery.of(context).size.width;
    return display
        ? Scaffold(
            backgroundColor: dark ? Color(0xff2f3136) : Colors.white,
            body: SafeArea(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(0),
                child: Padding(
                  padding: const EdgeInsets.all(0.0),
                  child: Container(
                    child: FutureBuilder<String>(
                        future: getColor(),
                        builder: (context, colorSnapshot) {
                          if (colorSnapshot.data != null &&
                              colorSnapshot.data.length > 0) {
                            //setState(() {
                            //  c = Color(int.parse(colorSnapshot.data));
                            //});
                            return Column(
                              children: <Widget>[
                                FutureBuilder<List<CalanderEvent>>(
                                  future: getCalanderData(),
                                  builder: (context, snapshot) {
                                    if (snapshot.data != null) {
                                      return Column(
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 3.0),
                                            child: Container(
                                                width: double.infinity,
                                                // color: Colors.black,
                                                color: Color(int.parse(
                                                    colorSnapshot.data)),
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
                                          ),
                                          Center(
                                            child: Wrap(
                                              alignment: WrapAlignment.center,
                                              children: <Widget>[
                                                Container(
                                                  child: FutureBuilder<bool>(
                                                      future: getPref(
                                                          "showWeather"),
                                                      builder: (BuildContext
                                                              context,
                                                          AsyncSnapshot<bool>
                                                              snapshots) {
                                                        if (snapshots.data !=
                                                            null) {
                                                          if (snapshots.data) {
                                                            return Container(
                                                              width: width > 690
                                                                  ? 330
                                                                  : width < 508
                                                                      ? double
                                                                          .infinity
                                                                      : 400,
                                                              child: WeatherWidget(
                                                                  Color(int.parse(
                                                                      colorSnapshot
                                                                          .data))),
                                                            );
                                                          } else {
                                                            return Container();
                                                          }
                                                        } else {
                                                          return Container();
                                                        }
                                                      }),
                                                ),
                                                Container(
                                                  child: FutureBuilder<bool>(
                                                      future: getPref(
                                                          "showLunchMenu"),
                                                      builder: (BuildContext
                                                              context,
                                                          AsyncSnapshot<bool>
                                                              snapshots) {
                                                        if (snapshots.data !=
                                                            null) {
                                                          if (snapshots.data) {
                                                            return Container(
                                                              width: width > 690
                                                                  ? 330
                                                                  : width < 508
                                                                      ? double
                                                                          .infinity
                                                                      : 400,
                                                              child: LunchMenu(
                                                                Color(int.parse(
                                                                    colorSnapshot
                                                                        .data)),
                                                              ),
                                                            );
                                                          } else {
                                                            return Container(
                                                              width: 0,
                                                            );
                                                          }
                                                        } else {
                                                          return Container();
                                                        }
                                                      }),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      );
                                    } else {
                                      return Container();
                                    }
                                  },
                                ),
                              ],
                            );
                          } else {
                            return Container();
                          }
                        }),
                  ),
                ),
              ),
            ))
        : Scaffold(
            bottomNavigationBar: BtmBar(),
            backgroundColor: dark ? Color(0xff2f3136) : Colors.white,
            appBar: PreferredSize(
              preferredSize: Size(0, 0),
              child: FutureBuilder<String>(
                  future: getColor(),
                  builder: (context, colorSnapshot) {
                    if (colorSnapshot.data != null &&
                        colorSnapshot.data.length > 0) {
                      return AppBar(
                          //backgroundColor: color ?? Colors.blue,
                          backgroundColor: Color(int.parse(colorSnapshot.data)),
                          elevation: 0,
                          brightness: dark
                              ? Brightness.dark
                              : Brightness.dark //<--Here!!!

                          );
                    } else {
                      return Container();
                    }
                  }),
            ),
            body: SafeArea(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(0),
                child: Padding(
                  padding: const EdgeInsets.all(0.0),
                  child: Container(
                    child: FutureBuilder<String>(
                        future: getColor(),
                        builder: (context, colorSnapshot) {
                          if (colorSnapshot.data != null &&
                              colorSnapshot.data.length > 0) {
                            //setState(() {
                            //  c = Color(int.parse(colorSnapshot.data));
                            //});
                            return Column(
                              children: <Widget>[
                                FutureBuilder<List<CalanderEvent>>(
                                  future: getCalanderData(),
                                  builder: (context, snapshot) {
                                    if (snapshot.data != null) {
                                      return Column(
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 3.0),
                                            child: Container(
                                                width: double.infinity,
                                                // color: Colors.black,
                                                color: Color(int.parse(
                                                    colorSnapshot.data)),
                                                child: Column(
                                                  children: <Widget>[
                                                    Container(
                                                      height: 15,
                                                    ),
                                                    WeekCountdown(snapshot.data)
                                                  ],
                                                )),
                                          ),
                                          FutureBuilder<bool>(
                                              future: isOnline(),
                                              builder: (context, isOnline) {
                                                if (isOnline.data != null &&
                                                    !isOnline.data) {
                                                  return Offline();
                                                } else {
                                                  return Container();
                                                }
                                              }),
                                          Center(
                                            child: Wrap(
                                              alignment: WrapAlignment.center,
                                              children: <Widget>[
                                                !dismissAlert
                                                    ? AlertWidget(
                                                        colorSnapshot.data)
                                                    : Container(),
                                                Container(
                                                  child: FutureBuilder<bool>(
                                                      future: getPref(
                                                          "showWeather"),
                                                      builder: (BuildContext
                                                              context,
                                                          AsyncSnapshot<bool>
                                                              snapshots) {
                                                        if (snapshots.data !=
                                                            null) {
                                                          if (snapshots.data) {
                                                            return Container(
                                                              width: width > 690
                                                                  ? 330
                                                                  : width < 508
                                                                      ? double
                                                                          .infinity
                                                                      : 400,
                                                              child: WeatherWidget(
                                                                  Color(int.parse(
                                                                      colorSnapshot
                                                                          .data))),
                                                            );
                                                          } else {
                                                            return Container();
                                                          }
                                                        } else {
                                                          return Container();
                                                        }
                                                      }),
                                                ),
                                                Container(
                                                  child: FutureBuilder<bool>(
                                                      future: getPref(
                                                          "showLunchMenu"),
                                                      builder: (BuildContext
                                                              context,
                                                          AsyncSnapshot<bool>
                                                              snapshots) {
                                                        if (snapshots.data !=
                                                            null) {
                                                          if (snapshots.data) {
                                                            return Container(
                                                              width: width > 690
                                                                  ? 330
                                                                  : width < 508
                                                                      ? double
                                                                          .infinity
                                                                      : 400,
                                                              child: LunchMenu(
                                                                Color(int.parse(
                                                                    colorSnapshot
                                                                        .data)),
                                                              ),
                                                            );
                                                          } else {
                                                            return Container(
                                                              width: 0,
                                                            );
                                                          }
                                                        } else {
                                                          return Container();
                                                        }
                                                      }),
                                                ),
                                                Container(
                                                  child: FutureBuilder<bool>(
                                                      future: getPref(
                                                          "showCalendar"),
                                                      builder: (BuildContext
                                                              context,
                                                          AsyncSnapshot<bool>
                                                              snapshots) {
                                                        if (snapshots.data !=
                                                                null &&
                                                            snapshot.data
                                                                    .length >
                                                                0) {
                                                          if (snapshots.data) {
                                                            return Container(
                                                              width: width > 690
                                                                  ? 330
                                                                  : width < 508
                                                                      ? double
                                                                          .infinity
                                                                      : 400,
                                                              child: UpcommingEvents(
                                                                  snapshot.data,
                                                                  Color(int.parse(
                                                                      colorSnapshot
                                                                          .data))),
                                                            );
                                                          } else {
                                                            return Container();
                                                          }
                                                        } else {
                                                          return Container();
                                                        }
                                                      }),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      );
                                    } else {
                                      return Container();
                                    }
                                  },
                                ),
                              ],
                            );
                          } else {
                            return Container();
                          }
                        }),
                  ),
                ),
              ),
            ),
          );
  }
}

class WholeHalf extends StatelessWidget {
  const WholeHalf({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        width: 100,
        height: 30,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(4),
            ),
            color: Colors.white),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Container(
              width: 40,
              child: Center(child: Text("W")),
            ),
            Center(
              child: Container(
                width: 1,
                height: 60,
                child: VerticalDivider(
                  color: Colors.green,
                  thickness: 1,
                ),
              ),
            ),
            Container(
              width: 40,
              child: Center(child: Text("H")),
            ),
          ],
        ),
      ),
    );
  }
}
