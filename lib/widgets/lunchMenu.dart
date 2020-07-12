import 'package:flutter/material.dart';
import 'package:space/data/lunchData.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LunchData {
  List<LunchItem> lunchItems;
  List<LunchCategory> categories;
  LunchData(this.lunchItems, this.categories);
}

class LunchItem {
  String name;
  LunchItem(this.name);
}

class LunchCategory {
  String name;
  String price;
  LunchCategory(this.name, this.price);
}

Future<bool> showLunchPricing() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getBool("showLunchPricing") ?? true;
}

class LunchMenu extends StatelessWidget {
  var color;
  LunchMenu(this.color);
  @override
  Widget build(BuildContext context) {
    return Container(
      //color: Colors.green,
      //child: Padding(
      //  padding: const EdgeInsets.only(left: 8, right: 8, bottom: 0, top: 0),
      child: Column(
        children: <Widget>[
          //Container(
          //  width: double.infinity,
          //  decoration: BoxDecoration(
          //    boxShadow: [
          //      BoxShadow(
          //        color: Colors.grey[400],
          //        blurRadius: MediaQuery.of(context).platformBrightness ==
          //                Brightness.dark
          //            ? 1
          //            : 8,
          //      ),
          //    ],
          //    color:
          //        MediaQuery.of(context).platformBrightness == Brightness.dark
          //            ? Color(0xff2f3136)
          //            : Colors.white,
          //    borderRadius: BorderRadius.all(
          //      Radius.circular(20),
          //    ),
          //  ),
          //child: Column(
          //mainAxisAlignment: MainAxisAlignment.start,
          //crossAxisAlignment: CrossAxisAlignment.center,
          //children: <Widget>[
          FutureBuilder<LunchData>(
            future: getLunchData(),
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.data.lunchItems.length > 0) {
                //var categories = DateTime.now().weekday == 1
                //    ? [
                //        LunchCategory("International Station", r"$4/5.00"),
                //        LunchCategory("Comfort Food", r"$3.00"),
                //        LunchCategory("Mindful Menu", r"$4.00"),
                //        LunchCategory("Meatless Monday", r"$4.00"),
                //        LunchCategory("Sides", r"$4.00"),
                //        LunchCategory("Soups", r"$2.50")
                //      ]
                //    : [
                //        LunchCategory("International Station", r"$4/5.00"),
                //        LunchCategory("Comfort Food", r"$3.00"),
                //        LunchCategory("Mindful Menu", r"$4.00"),
                //        LunchCategory("Sides", r"$4.00"),
                //        LunchCategory("Soups", r"$2.50")
                //      ];

                return Padding(
                  padding: const EdgeInsets.only(
                      left: 8, right: 8, bottom: 4, top: 4),
                  child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey[400],
                            blurRadius:
                                MediaQuery.of(context).platformBrightness ==
                                        Brightness.dark
                                    ? 1
                                    : 8,
                          ),
                        ],
                        color: MediaQuery.of(context).platformBrightness ==
                                Brightness.dark
                            ? Color(0xff2f3136)
                            : Colors.white,
                        borderRadius: BorderRadius.all(
                          Radius.circular(20),
                        ),
                      ),
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Text(
                              "Lunch",
                              style: TextStyle(
                                  fontSize: 23,
                                  fontFamily: "sans",
                                  fontWeight: FontWeight.w400),
                            ),
                          ),
                          Divider(
                            color: color,
                            thickness: 1,
                          ),
                          Container(
                            //height: 298,
                            margin: EdgeInsets.only(bottom: 10),
                            child: ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: snapshot.data.categories.length,
                                itemBuilder: (BuildContext ctxt, int Index) {
                                  return Column(
                                    children: <Widget>[
                                      Index != 0
                                          ? Divider(
                                              thickness: 1,
                                              color: color,
                                            )
                                          : Container(),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 4),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            Spacer(),
                                            Text(
                                              snapshot
                                                  .data.categories[Index].name,
                                              style: TextStyle(
                                                  color: color,
                                                  fontSize: 17,
                                                  fontFamily: "sans"),
                                            ),
                                            Expanded(
                                              child: Align(
                                                alignment:
                                                    Alignment.centerRight,
                                                child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            right: 5),
                                                    child: FutureBuilder<bool>(
                                                        future:
                                                            showLunchPricing(),
                                                        builder: (BuildContext
                                                                context,
                                                            AsyncSnapshot<bool>
                                                                snapshots) {
                                                          if (snapshots.data !=
                                                              null) {
                                                            if (snapshots
                                                                .data) {
                                                              return Container(
                                                                height: 19,
                                                                decoration: BoxDecoration(
                                                                    color:
                                                                        color,
                                                                    borderRadius:
                                                                        BorderRadius.all(
                                                                            Radius.circular(13))),
                                                                child: Padding(
                                                                  padding: const EdgeInsets
                                                                          .symmetric(
                                                                      horizontal:
                                                                          5,
                                                                      vertical:
                                                                          2),
                                                                  child: Text(
                                                                    snapshot
                                                                        .data
                                                                        .categories[
                                                                            Index]
                                                                        .price,
                                                                    style:
                                                                        TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                    ),
                                                                  ),
                                                                ),
                                                              );
                                                            } else {
                                                              return Container();
                                                            }
                                                          } else {
                                                            return Container();
                                                          }
                                                        })),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 2),
                                        child: Text(
                                          snapshot.data.lunchItems[Index].name
                                              .replaceAll(",", "\n"),
                                          style: TextStyle(
                                            color: MediaQuery.of(context)
                                                        .platformBrightness ==
                                                    Brightness.dark
                                                ? Colors.white
                                                : Colors.black,
                                            fontSize: 19,
                                            height: 1.4,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ],
                                  );
                                }),
                          ),
                        ],
                      )),
                );
              } else {
                return Container();
              }
            },
          ),
          //],
          //),
          //)
        ],
      ),
      //),
    );
  }
}
