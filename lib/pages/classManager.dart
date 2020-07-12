import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:space/data/scheduleData.dart';
import 'package:space/widgets/btmnavbar.dart';

class ClassManager extends StatefulWidget {
  Color color;
  ClassManager(this.color);
  @override
  _ClassManagerState createState() => _ClassManagerState(color);
}

List<int> scheduleModes = [];

class _ClassManagerState extends State<ClassManager> {
  Color color;
  _ClassManagerState(this.color);
  @override
  Widget build(BuildContext context) {
    bool dark = MediaQuery.of(context).platformBrightness == Brightness.dark;
    return Scaffold(
      bottomNavigationBar: BtmBar(),
      resizeToAvoidBottomInset: false,
      backgroundColor: dark ? Color(0xff2f3136) : Colors.white,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 10, bottom: 0),
                  child: Text(
                    "Schedules",
                    style: TextStyle(fontSize: 37),
                  ),
                ),
                Divider(),
                //Container(
                //  child: Padding(
                //    padding: const EdgeInsets.only(top: 35, left: 8, bottom: 0),
                //    child: Align(
                //      alignment: Alignment.topLeft,
                //      child: IconButton(
                //          onPressed: () {
                //            Navigator.pop(context);
                //          },
                //          icon: Icon(Icons.arrow_back, size: 30)),
                //    ),
                //  ),
                //),
                FutureBuilder<List<Schedule>>(
                    future: getSchedules(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Column(
                          children: <Widget>[
                            //Text(snapshot.data[0].periods.toString()),
                            ListView.builder(
                                padding: EdgeInsets.all(0),
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: snapshot.data.length,
                                itemBuilder:
                                    (BuildContext ctxt, int scheduleIndex) {
                                  scheduleModes.add(0);
                                  return Container(
                                    child: Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 8),
                                        child: Column(
                                          children: <Widget>[
                                            Container(
                                              //decoration: BoxDecoration(
                                              //    boxShadow: [
                                              //      BoxShadow(
                                              //          color: Colors.grey[300],
                                              //          blurRadius:
                                              //              dark ? 0 : 6),
                                              //    ],
                                              //    borderRadius:
                                              //        BorderRadius.all(
                                              //            Radius.circular(8)),
                                              //    color: dark
                                              //        ? Color(0xff2f3136)
                                              //        : Colors.white),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        4, 6, 4, 6),
                                                child: Column(
                                                  children: <Widget>[
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: <Widget>[
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 6),
                                                          child: Text(
                                                            snapshot
                                                                .data[
                                                                    scheduleIndex]
                                                                .name
                                                                .toString(),
                                                            style: TextStyle(
                                                                fontSize: 24,
                                                                fontFamily:
                                                                    "sans"),
                                                          ),
                                                        ),
                                                        snapshot
                                                                    .data[
                                                                        scheduleIndex]
                                                                    .modes
                                                                    .length >
                                                                1
                                                            ? Container(
                                                                padding: EdgeInsets
                                                                    .symmetric(
                                                                        horizontal:
                                                                            10,
                                                                        vertical:
                                                                            5),
                                                                decoration: BoxDecoration(
                                                                    color: dark
                                                                        ? Color(
                                                                            0xff202225)
                                                                        : Colors.grey[
                                                                            100],
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            10)),
                                                                child:
                                                                    new DropdownButton<
                                                                        String>(
                                                                  underline:
                                                                      SizedBox(),
                                                                  isDense: true,
                                                                  value: snapshot
                                                                          .data[
                                                                              scheduleIndex]
                                                                          .modes[
                                                                      scheduleModes[
                                                                          scheduleIndex]],
                                                                  items: snapshot
                                                                      .data[
                                                                          scheduleIndex]
                                                                      .modes
                                                                      .map((String
                                                                          value) {
                                                                    return new DropdownMenuItem<
                                                                        String>(
                                                                      value:
                                                                          value,
                                                                      child: new Text(
                                                                          value),
                                                                    );
                                                                  }).toList(),
                                                                  onChanged:
                                                                      (_) {
                                                                    setState(
                                                                        () {
                                                                      scheduleModes[scheduleIndex] = snapshot
                                                                          .data[
                                                                              scheduleIndex]
                                                                          .modes
                                                                          .indexOf(
                                                                              _);
                                                                    });
                                                                  },
                                                                ))
                                                            : Container(
                                                                height: 0,
                                                              ),
                                                      ],
                                                    ),
                                                    Container(
                                                      height: 5,
                                                    ),
                                                    Container(
                                                      child: GridView.count(
                                                        padding:
                                                            EdgeInsets.all(0),
                                                        shrinkWrap: true,
                                                        physics:
                                                            const NeverScrollableScrollPhysics(),
                                                        crossAxisCount:
                                                            (MediaQuery.of(context)
                                                                        .size
                                                                        .width /
                                                                    120)
                                                                .round(),
                                                        children: List.generate(
                                                            snapshot
                                                                .data[
                                                                    scheduleIndex]
                                                                .periods[
                                                                    scheduleModes[
                                                                        scheduleIndex]]
                                                                .length,
                                                            (periodIndex) {
                                                          var startTime = snapshot
                                                              .data[
                                                                  scheduleIndex]
                                                              .periods[
                                                                  scheduleModes[
                                                                      scheduleIndex]]
                                                                  [periodIndex]
                                                              .time
                                                              .substring(0, 5);
                                                          var endTime = snapshot
                                                              .data[
                                                                  scheduleIndex]
                                                              .periods[
                                                                  scheduleModes[
                                                                      scheduleIndex]]
                                                                  [periodIndex]
                                                              .time
                                                              .substring(6);
                                                          var name = snapshot
                                                              .data[
                                                                  scheduleIndex]
                                                              .periods[
                                                                  scheduleModes[
                                                                      scheduleIndex]]
                                                                  [periodIndex]
                                                              .name;
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
                                                                        color: Colors.grey[
                                                                            350],
                                                                        blurRadius: dark
                                                                            ? 1
                                                                            : 3),
                                                                  ],
                                                                  borderRadius:
                                                                      BorderRadius.all(
                                                                          Radius.circular(
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
                                                                  name.length <
                                                                          3
                                                                      ? Container(
                                                                          height:
                                                                              40,
                                                                          width:
                                                                              40,
                                                                          decoration: BoxDecoration(
                                                                              borderRadius: BorderRadius.all(Radius.circular(25)),
                                                                              color: color),
                                                                          child: Center(
                                                                              child: Text(
                                                                            name,
                                                                            style: TextStyle(
                                                                                fontSize: 22,
                                                                                color: Colors.white,
                                                                                fontFamily: "sans"),
                                                                          )),
                                                                        )
                                                                      : Container(
                                                                          height:
                                                                              35,
                                                                          //width: 40,
                                                                          decoration: BoxDecoration(
                                                                              borderRadius: BorderRadius.all(Radius.circular(27)),
                                                                              color: color),
                                                                          child:
                                                                              Padding(
                                                                            padding: const EdgeInsets.fromLTRB(
                                                                                7,
                                                                                7,
                                                                                7,
                                                                                3),
                                                                            child:
                                                                                Text(
                                                                              name.replaceAll("!", ""),
                                                                              style: TextStyle(fontSize: 18, color: Colors.white, fontFamily: "sans"),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                  Padding(
                                                                    padding: const EdgeInsets
                                                                            .only(
                                                                        top: 6,
                                                                        bottom:
                                                                            2),
                                                                    child:
                                                                        Center(
                                                                      child:
                                                                          Text(
                                                                        startTime.substring(0, 1) ==
                                                                                "0"
                                                                            ? startTime.substring(1)
                                                                            : startTime,
                                                                        style: TextStyle(
                                                                            fontSize: 20,
                                                                            //color:
                                                                            //    Colors.black,
                                                                            fontFamily: "sans"),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Center(
                                                                    child: Text(
                                                                      endTime.substring(0, 1) ==
                                                                              "0"
                                                                          ? endTime
                                                                              .substring(1)
                                                                          : endTime,
                                                                      style: TextStyle(
                                                                          fontSize: 20,
                                                                          //color: Colors.black,
                                                                          fontFamily: "sans"),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          );
                                                        }),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        )),
                                  );
                                }),
                          ],
                        );
                      } else {
                        return Container();
                      }
                    })
              ],
            ),
          ),
        ),
      ),
    );
  }
}
