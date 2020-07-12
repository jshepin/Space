import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'dart:io';
import 'package:space/pages/alertView.dart';
import 'package:space/secret/secret.dart';

class Alert {
  String title;
  String description;
  String color;
  bool show;
  Alert(this.title, this.description, this.color, this.show);
}

Future<Alert> getAlert() async {
  try {
    final result = await InternetAddress.lookup('google.com');
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      Db db = new Db(getMongoDB());

      await db.open();
      var coll = db.collection('alerts');
      var res = await coll.findOne();
      db.close();
      if (res == null) {
        return Alert("", "", "", false);
      }
      return Alert(res['title'], res['description'], res['color'], true);
    }
  } on SocketException catch (_) {}

  //}on SocketException catch(e){
  //return Alert("","","",false);
}

//}

class AlertWidget extends StatelessWidget {
  String color;
  AlertWidget(this.color);
  @override
  Widget build(BuildContext context) {
    bool dark = MediaQuery.of(context).platformBrightness == Brightness.dark;
    double width = MediaQuery.of(context).size.width;
    return Container(
      //color: Colors.blue,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 0),
        child: FutureBuilder<Alert>(
          future: getAlert(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (!snapshot.data.show) {
                return Container();
              }
              return Padding(
                padding:
                    const EdgeInsets.only(left: 8, right: 8, top: 4, bottom: 4),
                child: Column(
                  children: <Widget>[
                    Container(
                      // width: 300,
                      height: 40,
                      // width: double.infinity,
                      //height: 150,
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey[400],
                            blurRadius: dark ? 1 : 8.0,
                          ),
                        ],
                        color: dark ? Color(0xff2f3136) : Colors.white,
                        borderRadius: BorderRadius.all(
                          Radius.circular(20),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 10, top: 2),
                                child: Icon(Icons.notification_important),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 5),
                                child: Text("${snapshot.data.title}",
                                    style: TextStyle(
                                        color: Color(int.parse(
                                            color)), //colorFromHex(snapshot.data.color),
                                        fontSize: 20,
                                        fontFamily: "sans")),
                              ),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Container(
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                AlertView(color)));
                                  },
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(3, 3, 0, 3),
                                    child: Container(
                                      height: 40,
                                      width: 80,
                                      decoration: BoxDecoration(
                                        color: dark
                                            ? Color(0xff202225)
                                            : Colors.grey[200],
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(25),
                                        ),
                                      ),
                                      child: Center(
                                          child: Text(
                                        "View",
                                        style: TextStyle(
                                            fontSize: 17,
                                            color: dark
                                                ? Colors.white
                                                : Colors.black,
                                            fontFamily: "sans"),
                                      )),
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                AlertView(color)));
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(3.0),
                                    child: Container(
                                      height: 40,
                                      width: 40,
                                      decoration: BoxDecoration(
                                        color: dark
                                            ? Color(0xff202225)
                                            : Colors.grey[200],
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(25),
                                        ),
                                      ),
                                      child: Center(child: Icon(Icons.close)),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                ),
              );
            } else {
              return Text("");
            }
          },
        ),
      ),
    );
  }
}
