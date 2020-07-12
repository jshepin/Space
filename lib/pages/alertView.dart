import 'package:flutter/material.dart';
import 'package:space/widgets/alert.dart';

class AlertView extends StatelessWidget {
  String color;
  AlertView(this.color);
  @override
  Widget build(BuildContext context) {
    bool dark = MediaQuery.of(context).platformBrightness == Brightness.dark;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: dark ? Color(0xff2f3136) : Colors.white,
      //appBar: AppBar(
      //  elevation: 0,
      //  centerTitle: true,
      //  brightness: Brightness.light, // status bar brightness

      //  leading: IconButton(
      //    onPressed: () {
      //      Navigator.pop(context);

      //    },
      //    icon: Icon(
      //      Icons.arrow_back,
      //      color:
      //          dark
      //              ? Colors.white
      //              : Colors.black,
      //    ),
      //  ),
      //  backgroundColor:
      //      dark
      //          ? Color(0xff2f3136)
      //          : Colors.white,
      //  title: Text(
      //    "",
      //    style: TextStyle(fontSize: 26, color: dark ? Colors.white : Colors.black,fontFamily: "sans"),
      //  ),
      //),

      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 35, left: 8, bottom: 3),
            child: Align(
              alignment: Alignment.topLeft,
              child: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.arrow_back, size: 30)),
            ),
          ),
          Container(
            //color: Colors.blue,
            child: FutureBuilder<Alert>(
              future: getAlert(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if (!snapshot.data.show) {
                    return Container();
                  }
                  return Padding(
                    padding: const EdgeInsets.only(
                        left: 12, right: 12, top: 6, bottom: 6),
                    child: Column(
                      children: <Widget>[
                        Container(
                          // width: 300,

                          // width: double.infinity,
                          //height: 150,
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey[400],
                                blurRadius:
                                    MediaQuery.of(context).platformBrightness ==
                                            Brightness.dark
                                        ? 1
                                        : 8.0,
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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 0, top: 8, bottom: 1),
                                        child: Text(
                                          "Feb 27",
                                          style: TextStyle(
                                              fontSize: 18,
                                              color: Colors.grey[600]),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 12, top: 3, bottom: 1),
                                        child: Text(
                                          "8:07 AM",
                                          style: TextStyle(
                                              fontSize: 18, color: Colors.grey),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 5.0),
                                        child: Text("${snapshot.data.title}",
                                            style: TextStyle(
                                                color: Color(int.parse(color)),
                                                fontSize: 23,
                                                fontFamily: "sans")),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
                                          height: 30,
                                          width: 80,
                                          decoration: BoxDecoration(
                                            color: Colors.grey[200],
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(15),
                                            ),
                                          ),
                                          child: Center(
                                              child: Text(
                                            "Dismiss",
                                            style: TextStyle(
                                                fontSize: 17,
                                                color: Colors.black,
                                                fontFamily: "sans"),
                                          )),
                                        ),
                                      )
                                    ],
                                  )
                                ],
                              ),
                              Divider(
                                  thickness: 1, color: Color(int.parse(color))),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 10, right: 10, top: 3, bottom: 15),
                                child: Text(
                                  "${snapshot.data.description}",
                                  style: TextStyle(fontSize: 20),
                                ),
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
        ],
      ),
    );
  }
}
