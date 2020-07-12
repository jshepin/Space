import 'dart:async';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:space/tools/tools.dart';
import 'package:space/data/scheduleData.dart';
import 'package:recase/recase.dart';
import 'package:confetti/confetti.dart';
import 'dart:math';

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}

String selectedMode = "";
String scheduleType = "";
int confettis = 0;
String stringify(int number) {
  switch (number) {
    case 1:
      return "First";
    case 2:
      return "Second";
    case 3:
      return "Third";
    case 4:
      return "Fourth";
    case 5:
      return "Fifth";
    case 6:
      return "Sixth";
    case 7:
      return "Seventh";
    case 8:
      return "Eighth";
    case 9:
      return "Ninth";
    default:
      return "";
  }
}

class WeekCountdown extends StatefulWidget {
  final data;
  WeekCountdown(this.data);
  @override
  State<StatefulWidget> createState() => _WeekCountdownState();
}

class Period {
  String name;
  String time;
  Period(this.time, this.name);
}

class _WeekCountdownState extends State<WeekCountdown> {
  Timer _timer;
  DateTime _currentTime;
  bool _useWholePeriods;
  List<Schedule> _schedules;
  var _travelers;

  ConfettiController _controllerCenter;
  ConfettiController _controllerCenterRight;
  ConfettiController _controllerCenterLeft;
  ConfettiController _controllerTopCenter;
  ConfettiController _controllerBottomCenter;

  @override
  void initState() {
    _controllerCenter =
        ConfettiController(duration: const Duration(seconds: 2));
    _controllerCenterRight =
        ConfettiController(duration: const Duration(seconds: 2));
    _controllerCenterLeft =
        ConfettiController(duration: const Duration(seconds: 2));
    _controllerTopCenter =
        ConfettiController(duration: const Duration(seconds: 2));
    _controllerBottomCenter =
        ConfettiController(duration: const Duration(seconds: 2));

    super.initState();
    _currentTime = DateTime.now();
    _useWholePeriods = true;

    _timer = Timer.periodic(Duration(milliseconds: 100), _onTimeChange);
  }

  @override
  void dispose() {
    _controllerCenter.dispose();
    _controllerCenterRight.dispose();
    _controllerCenterLeft.dispose();
    _controllerTopCenter.dispose();
    _controllerBottomCenter.dispose();
    _timer.cancel();
    super.dispose();
  }

  void _onTimeChange(Timer timer) {
    getSchedules().then((schedules) {
      getPref().then((result) {
        getTravelers().then((travelers) {
          setState(() {
            _useWholePeriods = result;
            _currentTime = DateTime.now();
            _travelers = travelers;
            _schedules = _schedules;
          });
        });
      });
      // If we need to rebuild the widget with the resulting data,
      // make sure to use `setState`
    });
  }

  Future<bool> getPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool("wholePeriods") ?? true;
  }

  @override
  Widget build(BuildContext context) {
    bool lateArrival = false;
    bool noSchool = false;
    bool dark = MediaQuery.of(context).platformBrightness == Brightness.dark;
    selectedMode = selectedMode == ""
        ? (getModes("standard schedule").length > 0
            ? getModes("standard schedule")[0]
            : "")
        : selectedMode;
    scheduleType = scheduleType == "" ? "standard schedule" : scheduleType;
    List<Period> periods = [];
    //print("widget is ${widget.data}");
    if (widget.data.length == 0) {
      scheduleType = "standard schedule";
      periods = getScheduleWithMode(scheduleType, selectedMode);
    } else {
      //print("widget legnth is ${widget.data.length}");
      for (int x = 0; x < widget.data.length; x++) {
        //print("got day ${widget.data[x].startTime.day}");
        if (widget.data[x].startTime.day == DateTime.now().day) {
          //print("got a day");
          var n = widget.data[x].name.toLowerCase(); //name of todays event
          if (n.contains("late") && n.contains("arrival")) {
            // if(true) {
            lateArrival = true;
            scheduleType = "late arrival";
            periods = getScheduleWithMode(scheduleType, selectedMode);
          } else if ((n.contains("no") && n.contains("schoool")) ||
              (n.contains("non") && n.contains("attendance")) ||
              (n.contains("institute") && n.contains("day") ||
                  widget.data[x].color.contains("FD0808"))) {
            //}else if(widget.data[x].color.contains("FD0808")){
            noSchool = true;
          } else if (n.contains("assembly")) {
            //} else if (true) {

            scheduleType = "pm assembly";
            periods = getScheduleWithMode(scheduleType, selectedMode);

            //print("Assembly");
            //pmAssembly = true;
          } else if (n.contains("activity") && n.contains("period")) {
            scheduleType = "activity period";
            periods = getScheduleWithMode(scheduleType, selectedMode);

            //print("avtivity period");
            //activityPeriod = true;
          } else if (n.contains("early") && n.contains("dismissal")) {
            //}else if(true){
            scheduleType = "early dismissal";
            periods = getScheduleWithMode(scheduleType, selectedMode);

            //print("eraly dismissel");
            //earlyDismissal = true;
            //} else if (true) {
          } else if (n.contains("exam") || n.contains("final")) {
            scheduleType = "finals";
            periods = [
              Period("08:30-09:21", "Finals"),
              Period("09:26-10:13", "Finals"),
              Period("10:18-11:05", "Finals"),
            ];
          } else {
            scheduleType = "standard schedule";
            periods = getScheduleWithMode(scheduleType, selectedMode);
          }
        }
      }
    }

    if (periods.length == 0) {
      scheduleType = "standard schedule";
      periods = getScheduleWithMode(scheduleType, selectedMode);
    }

    //print(_travelers);
    var inSchool = false;
    //print("SDF");

    //weekendTimeLeft();
    if (isWeekend() || noSchool) {
      return generateClock(
          weekendTimeLeft(lateArrival),
          context,
          DateTime.now(),
          DateTime.now(),
          DateTime.now(),
          0.0,
          false,
          false,
          _useWholePeriods,
          _controllerCenterRight);
    } else {
      //scheduleType = "standard schedule";
      //        periods = getScheduleWithMode(scheduleType, selectedMode);
      //print("periods length is ${periods.length}");

      for (int x = 0; x < periods.length; x++) {
        var t = periods[x];
        var startHour = t.time.substring(0, 2);
        var startMinute = t.time.substring(3, 5);

        var endHour = t.time.substring(6, 8);
        var endMinute = t.time.substring(9, 11);

        var startPeriod = DateTime.parse(
            "${DateTime.now().year}-0${DateTime.now().month}-${DateTime.now().day < 10 ? "0" : ""}${DateTime.now().day} $startHour:$startMinute:00");
        //print(startPeriod);

        var endPeriod = DateTime.parse(
            "${DateTime.now().year}-0${DateTime.now().month}-${DateTime.now().day < 10 ? "0" : ""}${DateTime.now().day} $endHour:$endMinute:00");
        if (x < (periods.length - 1)) {
          var nextT = periods[x + 1];
          var nextStartHour = nextT.time.substring(0, 2);
          var nextStartMinute = nextT.time.substring(3, 5);

          //var nextEndHour = nextT.time.substring(6, 8);
          //var nextEndMinute = nextT.time.substring(9, 11);

          var nextStartPeriod = DateTime.parse(
              "${DateTime.now().year}-0${DateTime.now().month}-${DateTime.now().day < 10 ? "0" : ""}${DateTime.now().day} $nextStartHour:$nextStartMinute:00");

          //var nextEndPeriod = DateTime.parse(
          //    "${DateTime.now().year}-0${DateTime.now().month}-${DateTime.now().day < 10 ? "0" : ""}${DateTime.now().day} $nextEndHour:$nextEndMinute:00");

          final remainingNextPeriod = nextStartPeriod.difference(_currentTime);
          var travelerTime = nextStartPeriod.add(Duration(minutes: 3));
          final remainingTravelerBell = travelerTime.difference(_currentTime);
          final fromLastPeriod = endPeriod.difference(_currentTime);
          if (remainingNextPeriod.inSeconds > 0 &&
              fromLastPeriod.inSeconds <= 0) {
            //print("start of next period $nextStartPeriod");
            //print("end of last period  $endPeriod");
            final periodLength = nextStartPeriod.difference(endPeriod);
            var percentage =
                remainingNextPeriod.inSeconds / periodLength.inSeconds;
            //var percentage = 0.5;
            final hours =
                remainingNextPeriod.inHours - remainingNextPeriod.inDays * 24;
            final minutes = remainingNextPeriod.inMinutes -
                remainingNextPeriod.inHours * 60;
            final seconds = remainingNextPeriod.inSeconds -
                remainingNextPeriod.inMinutes * 60;

            final travelerMinutes = remainingTravelerBell.inMinutes -
                remainingTravelerBell.inHours * 60;
            final travelerSeconds = remainingTravelerBell.inSeconds -
                remainingTravelerBell.inMinutes * 60;
            //print("it is periods $x");
            bool traveler;
            //if (!_useWholePeriods) {
            if (scheduleType.toLowerCase() == "standard schedule") {
              traveler = false;
            } else {
              print(x);
              //print(_travelers[x]);
              traveler = _travelers[x] == "true" ? true : false;
            }

            var colon = ":";
            final formattedRemaining =
                '${hours == 0 ? "" : hours}${hours > 0 ? colon : ""}${hours > 0 && minutes < 10 ? "0" : ""}$minutes:${seconds < 10 ? "0" : ""}$seconds ${traveler && _useWholePeriods ? travelerMinutes : ""}${traveler && _useWholePeriods ? ":" : ""}${traveler && _useWholePeriods ? (travelerSeconds < 10 ? "0" : "") : ""}${traveler && _useWholePeriods ? travelerSeconds : ""}';
            return generateClock(
                formattedRemaining,
                context,
                endPeriod,
                nextStartPeriod,
                Period("", "Passing"),
                percentage,
                true,
                true,
                _useWholePeriods,
                _controllerCenterRight);
          }
        }
        //print("schedule typ is $scheduleType");
        final remaining = endPeriod.difference(_currentTime);
        final timeUntil = startPeriod.difference(_currentTime);
        if (remaining.inSeconds > 0 && timeUntil.inSeconds <= 0) {
          inSchool = true;
          final periodLength = endPeriod.difference(startPeriod);
          var percentage = remaining.inSeconds / periodLength.inSeconds;
          final hours = remaining.inHours - remaining.inDays * 24;
          final minutes = remaining.inMinutes - remaining.inHours * 60;
          final seconds = remaining.inSeconds - remaining.inMinutes * 60;
          var colon = ":";
          //print(seconds);
          if (minutes == 0 && seconds == 1) {
            confettis = 1;
          }
          final formattedRemaining =
              '${hours == 0 ? "" : hours}${hours > 0 ? colon : ""}${hours > 0 && minutes < 10 ? "0" : ""}$minutes:${seconds < 10 ? "0" : ""}$seconds';
          return generateClock(
              formattedRemaining,
              context,
              startPeriod,
              endPeriod,
              t,
              percentage,
              true,
              true,
              _useWholePeriods,
              _controllerCenterRight);
        }
      }
      if (!inSchool) {
        return generateClock(
            "Tomorrow",
            context,
            DateTime.now(),
            DateTime.now(),
            DateTime.now(),
            0.0,
            false,
            false,
            _useWholePeriods,
            _controllerCenterRight);
      }
    }
  }
}

String weekendTimeLeft(bool lateArrival) {
  var monday = calculateStartOfNextWeek(DateTime.now(), lateArrival);
  final remaining = monday.difference(DateTime.now());
  final days = remaining.inHours / 24;
  final hours = remaining.inHours - (remaining.inDays * 24);
  final minutes = remaining.inMinutes - remaining.inHours * 60;
  final seconds = remaining.inSeconds - remaining.inMinutes * 60;
  var colon = ":";
  if (days.floor() > 0) {
    final formattedRemaining =
        '${days.floor()} Day${days.floor() > 1 ? "s" : ""}';
    return formattedRemaining;
  } else {
    final formattedRemaining =
        '${days.floor() > 0 ? "0" : ""}${days.floor() > 0 ? days.floor() : ""}${days.floor() > 0 ? colon : ""}${hours == 0 ? "" : hours}${hours > 0 ? colon : ""}${hours > 0 && minutes < 10 ? "0" : ""}$minutes:${seconds < 10 ? "0" : ""}$seconds';
    return formattedRemaining;
  }
}

DateTime calculateStartOfNextWeek(DateTime time, bool lateArrival) {
  final daysUntilNextWeek = 8 - time.weekday;
  return DateTime(time.year, time.month, time.day + daysUntilNextWeek,
      lateArrival ? 10 : 8, 30);
}

bool isWeekend() {
  if (DateTime.now().weekday == 5 ||
      DateTime.now().weekday == 6 ||
      DateTime.now().weekday == 7) {
    return true;
  }
  return false;
}

Widget generateClock(formattedRemaining, context, startPeriod, endPeriod, t,
    percentage, showTimes, inSchool, wholePeriods, controller) {
  if (confettis > 0) {
    confettis--;
    controller.play();
  }
  bool dark = MediaQuery.of(context).platformBrightness == Brightness.dark;
  return AnimatedSwitcher(
    duration: Duration(milliseconds: 300),
    child: Column(
      children: <Widget>[
        Stack(
          children: <Widget>[
            Positioned(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 15.0, top: 0),
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(155),
                      ),
                      color: MediaQuery.of(context).platformBrightness ==
                              Brightness.dark
                          ? Color(0xff2f3136)
                          : Colors.white),
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                    child: CircularPercentIndicator(
                      radius: 270.0,
                      animation: true,
                      animateFromLastPercent: true,
                      animationDuration: 400,
                      circularStrokeCap: CircularStrokeCap.round,
                      lineWidth: 5.0,
                      percent: percentage,
                      center: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          FutureBuilder<String>(
                              future: getColor(),
                              builder: (context, colorSnapshot) {
                                if (colorSnapshot.data != null &&
                                    colorSnapshot.data.length > 0) {
                                  List<Color> colors = [];
                                  colors.add(
                                      Color(int.parse(colorSnapshot.data)));
                                  return Container(
                                      height: 0,
                                      child: Align(
                                        alignment: Alignment.topCenter,
                                        child: ConfettiWidget(
                                            confettiController: controller,
                                            blastDirection: (3 / 2) *
                                                pi, // radial value - LEFT
                                            particleDrag:
                                                0.05, // apply drag to the confetti
                                            //maximumSize: Size( 0.01,0.01),
                                            emissionFrequency:
                                                0.05, // how often it should emit
                                            numberOfParticles:
                                                20, // number of particles to emit
                                            gravity:
                                                0.2, // gravity - or fall speed
                                            shouldLoop: false,
                                            colors: colors),
                                      ));
                                } else {
                                  return Container();
                                }
                              }),

                          //FlatButton(
                          //  child: Text("sdaf"),
                          //  onPressed: () {
                          //    print("showing ocnfettu");
                          //    controller.play();
                          //  },
                          //  //child: _display('blast')),f
                          //),
                          Padding(
                            padding: EdgeInsets.only(top: 20),
                            child: Center(
                              child: Container(
                                width: 80,
                                child: Image.asset(
                                  "assets/patriot.png",
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: showTimes
                                ? EdgeInsets.all(5.0)
                                : EdgeInsets.only(top: 24),
                            child: Text(formattedRemaining,
                                style: TextStyle(
                                    fontSize: showTimes ? 50 : 35,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: 'sans',
                                    color: MediaQuery.of(context)
                                                .platformBrightness ==
                                            Brightness.dark
                                        ? Colors.white
                                        : Colors.grey[600])),
                          ),
                          Padding(
                              padding: showTimes
                                  ? EdgeInsets.all(5)
                                  : EdgeInsets.only(top: 14),
                              child: Text(
                                showTimes
                                    ? ((t.name.length == 1 && isNumeric(t.name))
                                        ? stringify(int.parse(t.name))
                                        : t.name)
                                    : "No School",
                                style: TextStyle(
                                    fontSize: showTimes ? 23 : 22,
                                    fontFamily: "sans"),
                              )),
                        ],
                      ),
                      backgroundColor: dark ? Color(0xff2f3136) : Colors.white,
                      progressColor:
                          dark ? Color(0xff85929E) : Colors.grey[350],
                      //dark ? Color(0xff5D6D7E  ) : Colors.grey[350],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        inSchool
            ? Column(
                children: <Widget>[
                  //Container(
                  //  width: 200,
                  //    padding:
                  //        EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  //    decoration: BoxDecoration(
                  //        color: Colors.white,
                  //        borderRadius: BorderRadius.circular(10)),
                  //    child: Center(child: Text(scheduleType, style: TextStyle(fontSize: 17, fontFamily: "sans"),))),

                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          //Text(scheduleType),

                          getModes(scheduleType).length > 1
                              ? Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 5),
                                  decoration: BoxDecoration(
                                      color: dark
                                          ? Color(0xff2f3136)
                                          : Colors.white,
                                      borderRadius: BorderRadius.circular(10)),
                                  child: DropdownButton<String>(
                                    isDense: true,
                                    value: selectedMode,
                                    items: getModes(scheduleType)
                                        .map((String value) {
                                      return new DropdownMenuItem<String>(
                                        value: value,
                                        child: new Text(
                                          value,
                                          style: TextStyle(
                                              fontSize: 17, fontFamily: "sans"),
                                        ),
                                      );
                                    }).toList(),
                                    onChanged: (_) async {
                                      var prefs =
                                          await SharedPreferences.getInstance();
                                      await prefs.setString("selectedMode", _);
                                      selectedMode = _;
                                    },
                                    underline: SizedBox(),
                                  ))
                              : Container(
                                  height: 0,
                                ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: dark ? Color(0xff2f3136) : Colors.white,
                      boxShadow: [
                        BoxShadow(
                          offset: Offset(-10, 0),
                          color: Colors.grey[500],
                          blurRadius: dark ? 1 : 6,
                        ),
                      ],
                    ),
                    height: 70,
                    width: double.infinity,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        showTimes
                            ? Padding(
                                padding: const EdgeInsets.only(top: 2),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      "${startPeriod.hour > 12 ? startPeriod.hour - 12 : startPeriod.hour}:${startPeriod.minute < 10 ? "0" : ""}${startPeriod.minute}",
                                      style: TextStyle(
                                          fontSize: 25, fontFamily: "sans"),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 3),
                                      child: Icon(Icons.arrow_forward,
                                          size: 22,
                                          color: dark
                                              ? Colors.white
                                              : Colors.black),
                                    ),
                                    //Image.asset("assets/line.png",height: 45,color: Colors.black,),
                                    Text(
                                      "${endPeriod.hour > 12 ? endPeriod.hour - 12 : endPeriod.hour}:${endPeriod.minute < 10 ? "0" : ""}${endPeriod.minute}",
                                      style: TextStyle(
                                          fontSize: 25, fontFamily: "sans"),
                                    ),
                                  ],
                                ),
                              )
                            : Container(),
                        Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: Text(
                            scheduleType.titleCase,
                            style: TextStyle(fontSize: 18, fontFamily: "sans"),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )
            : Container()
      ],
    ),
  );
}
//}

bool isNumeric(String s) {
  if (s == null) {
    return false;
  }
  return double.parse(s, (e) => null) != null;
}
