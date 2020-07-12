import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';
import 'package:add_2_calendar/add_2_calendar.dart';
import 'package:shared_preferences/shared_preferences.dart';

String toMonth(m) {
  if (m == 1) {
    return "Jan";
  }
  if (m == 2) {
    return "Feb";
  }
  if (m == 3) {
    return "March";
  }
  if (m == 4) {
    return "April";
  }
  if (m == 5) {
    return "May";
  }
  if (m == 6) {
    return "June";
  }
  if (m == 7) {
    return "July";
  }
  if (m == 8) {
    return "Aug";
  }
  if (m == 9) {
    return "Sepember";
  }
  if (m == 10) {
    return "Oct";
  }
  if (m == 11) {
    return "Nov";
  }
  if (m == 12) {
    return "Dec";
  }
}

Future<bool> showCalendarReminders() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getBool("calendarReminders") ?? true;
}

class UpcommingEvents extends StatelessWidget {
  var data;
  var color;
  UpcommingEvents(this.data, this.color);
  final GlobalKey<ScaffoldState> scaffoldState = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Container(
      //color: Colors.purple,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.grey[400],
                blurRadius: MediaQuery.of(context).platformBrightness == Brightness.dark ? 1:8,
              ),
            ],
            color: MediaQuery.of(context).platformBrightness == Brightness.dark ? Color(0xff2f3136) : Colors.white,
            borderRadius: BorderRadius.all(
              Radius.circular(20),
            ),
          ),
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Text(
                  "Upcomming Events",
                  style: TextStyle(fontSize: 23, fontFamily: "sans"),
                ),
              ),
              Divider(
                color: color,
                thickness: 1,
              ),
              FutureBuilder<bool>(
                future: showCalendarReminders(),
                builder: (BuildContext context, AsyncSnapshot<bool> snapshots) {
                  if (snapshots.data != null) {
                    return Container(
                      height: 300,
                      margin: EdgeInsets.only(bottom: 10),
                      child: ListView.builder(
                        itemCount: data.length ,
                        itemBuilder: (BuildContext ctxt, int Index) {
                          return Padding(
                            padding: const EdgeInsets.only(
                                left: 8, right: 8, bottom: 8),
                            child: Container(
                              width: double.infinity,
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Container(
                                      decoration: BoxDecoration(
                                        color: MediaQuery.of(context).platformBrightness == Brightness.dark ? Color(0xFF202225) : Colors.grey[200],
                                        //border: Border.all(color: Colors.red,width: 1.3),
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(9),
                                        ),
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 8.0),
                                            child: Text(
                                              "${data[Index].startTime.day}",
                                              style: TextStyle(fontSize: 27,fontFamily: "sans"),
                                            ),
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 4),
                                            child: Text(
                                                "${toMonth(data[Index].startTime.month)}",
                                                style: TextStyle(fontSize: 15,fontFamily: "sans")),
                                          ),
                                        ],
                                      ),
                                      height:
                                          data[Index].location == "" ? 70 : 90,
                                      width: 55,
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(15),
                                        ),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 8, top: 0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            SingleChildScrollView(
                                              scrollDirection: Axis.horizontal,
                                              child: Container(
                                                child: Row(
                                                  children: <Widget>[
                                                    Text(
                                                      "${data[Index].name}",
                                                      style:
                                                          TextStyle(fontSize: 21),
                                                      maxLines: 2,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                    data[Index].location.length >
                                                            0
                                                        ? Container()
                                                        : snapshots.data
                                                            ? Tooltip(
                                                                message:
                                                                    "Open in calender app",
                                                                child: IconButton(
                                                                  iconSize: 26,
                                                                  icon: Icon(
                                                                    Icons
                                                                        .add_alert,
                                                                    color: color,
                                                                  ),
                                                                  onPressed: () {
                                                                    Event event =
                                                                        Event(
                                                                      title:
                                                                          '${data[Index].name}',
                                                                      //description: 'example',
                                                                      timeZone:
                                                                          "GMT-${Platform.isIOS?5:6}",


                                                                      location:
                                                                          '${data[Index].location}',
                                                                      startDate: data[
                                                                              Index]
                                                                          .startTime,
                                                                      endDate: data[
                                                                              Index]
                                                                          .endTime,
                                                                      allDay:
                                                                          false,
                                                                    );

                                                                    //print(data[
                                                                    //        Index]
                                                                    //    .startTime);
                                                                    Add2Calendar
                                                                        .addEvent2Cal(
                                                                            event);
                                                                  },
                                                                ),
                                                              )
                                                            : Container()
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Container(
                                              height: data[Index].location == ""
                                                  ? 0
                                                  : 60,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Padding(
                                                    padding:
                                                        EdgeInsets.only(top: 4),
                                                    child: Text(
                                                        "${data[Index].location}",
                                                        style: TextStyle(
                                                            fontSize: 18)),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        EdgeInsets.only(top: 4),
                                                    child: Text(
                                                        "${data[Index].displayTime}",
                                                        style: TextStyle(
                                                            fontSize: 18,)),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    data[Index].location.length > 0
                                        ? snapshots.data
                                            ? Tooltip(
                                                message: "Open in calender app",
                                                child: IconButton(
                                                  icon: Icon(
                                                    Icons.add_alert,
                                                    color: color,
                                                  ),
                                                  padding: EdgeInsets.all(0),
                                                  onPressed: () {
                                                    Event event = Event(
                                                      title:
                                                          '${data[Index].name}',
                                                      //description: 'example',
                                                      timeZone: "GMT-${Platform.isIOS?5:6}",
                                                      location:
                                                          '${data[Index].location}',
                                                      startDate:
                                                          data[Index].startTime,
                                                      endDate:
                                                          data[Index].endTime,
                                                    );

                                                    print(data[Index].startTime);
                                                    Add2Calendar.addEvent2Cal(
                                                        event);
                                                  },
                                                ),
                                              )
                                            : Container()
                                        : Container(),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
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
      ),
    );
  }
}

