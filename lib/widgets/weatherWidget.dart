import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';

var weatherData1;
var weatherData2;

class NowWeather {
  int temp;
  String description;
  String icon;
  bool show;
  NowWeather({this.show, this.temp, this.description, this.icon});
  factory NowWeather.fromJson(Map<String, dynamic> json) {
    return NowWeather(
        icon: json['weather'][0]['icon'],
        description: json['weather'][0]['description'],
        temp: ((json['main']['temp'] - 273.15) * (9 / 5) + 32).round(),
        show: true);
  }
}

class Weather {
  int currentTemp;
  String currentDescription;
  String currentIcon;
  int futureTemp;
  String futureDescription;
  String futureIcon;
  bool show;
  bool oneDay;
  Weather(
      {this.show,
      this.currentTemp,
      this.currentDescription,
      this.currentIcon,
      this.futureTemp,
      this.futureDescription,
      this.futureIcon,
      this.oneDay});
  factory Weather.fromJson(Map<String, dynamic> json) {
    var tomorrow = DateTime.now().add(Duration(days: 1, hours: 0));
    for (int x = 0; x < json['list'].length; x++) {
      var weatherDate = DateTime.parse(json['list'][x]['dt_txt']);
      if (weatherDate.day == tomorrow.day) {
        //print(weatherDate.day);
        //print(tomorrow.day);
        //print("true");
        if (x == 0) {
          //print("shoudl show one");
          return Weather(
              currentIcon: json['list'][0]['weather'][0]['icon'],
              currentTemp:
                  ((json['list'][0]['main']['temp'] - 273.15) * (9 / 5) + 32)
                      .round(),
              currentDescription: json['list'][0]["weather"][0]["description"],
              show: true,
              oneDay: true);
        }

        //print("should show two");
        return Weather(
            currentIcon: json['list'][0]['weather'][0]['icon'],
            currentTemp:
                ((json['list'][0]['main']['temp'] - 273.15) * (9 / 5) + 32)
                    .round(),
            currentDescription: json['list'][0]["weather"][0]["description"],
            show: true,
            futureDescription: json['list'][x]["weather"][0]["description"],
            futureIcon: json['list'][x]['weather'][0]['icon'],
            futureTemp:
                ((json['list'][x]['main']['temp'] - 273.15) * (9 / 5) + 32)
                    .round(),
            oneDay: false);
      }
    }
  }
}

Future<NowWeather> fetchNowWeather() async {
  if (weatherData1 != null) {
    //print("using cached weather 1");
    return weatherData1;
  } else {
    try {
      //print("FETCHING WEATHER DATA 1");
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        //print('connected');
        final response = await http.get(
            'http://api.openweathermap.org/data/2.5/weather?q=lincolnshire,US&appid=b8905f222fb7b37b95525e6c5295d744');
        if (response.statusCode == 200) {
          //print("successes");
          weatherData1 = NowWeather.fromJson(json.decode(response.body));
          return weatherData1;
        } else {
          //print("faileded");

          NowWeather(temp: 0, description: "", show: false);
        }
      } else {
        //print('not connectedsafa');
        NowWeather(temp: 0, description: "", show: false);
      }
    } on SocketException catch (_) {
      //print('not connectedasdf');
      NowWeather(temp: 0, description: "", show: false);
    }
  }
}

Future<Weather> fetchWeather() async {
  if (weatherData2 != null) {
    //print("using cached weather 2");
    return weatherData2;
  } else {
    try {
      //print("FETCHING WEATHER DATA 2");

      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        //print('connected');
        final response = await http.get(
            'http://api.openweathermap.org/data/2.5/forecast?q=lincolnshire,US&appid=b8905f222fb7b37b95525e6c5295d744');
        if (response.statusCode == 200) {
          //print("success");
          weatherData2 = Weather.fromJson(json.decode(response.body));
          //return Weather.fromJson(json.decode(response.body));
          return weatherData2;
        } else {
          //print("failed");

          NowWeather(temp: 0, description: "", show: false);
        }
      }
    } on SocketException catch (_) {
      //print('not connected');
      NowWeather(temp: 0, description: "", show: false);
    }
  }
}

String caseWord(s) {
  String newString = "";
  for (int x = 0; x < s.length; x++) {
    if (x == 0) {
      newString = s[0].toUpperCase();
    } else if (s.substring(x - 1, x) == " ") {
      newString = newString + s.substring(x, x + 1).toUpperCase();
    } else {
      newString = newString + s.substring(x, x + 1);
    }
  }
  return newString;
}

Future<bool> getPref() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getBool('imperialUnits') ?? true;
}

class CurrentWeather extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder<NowWeather>(
        future: fetchNowWeather(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.show == true) {
              return Column(
                children: <Widget>[
                  Container(
                      height: 90,
                      child: Image.asset(
                          "assets/weatherIcons/${snapshot.data.icon}.png",color: MediaQuery.of(context).platformBrightness == Brightness.dark ? Colors.white : Colors.black,),),
                  Text("${caseWord(snapshot.data.description)}",
                      style: TextStyle(fontSize: 20)),
                  Padding(
                    padding: const EdgeInsets.only(top: 9.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        FutureBuilder<bool>(
                            future: getPref(),
                            builder: (BuildContext context,
                                AsyncSnapshot<bool> snapshots) {
                              if (snapshots.data != null) {
                                if (snapshots.data) {
                                  return Text(
                                    "${snapshot.data.temp}°F",
                                    style: TextStyle(fontSize: 21),
                                  );
                                } else {
                                  return Text(
                                    "${((snapshot.data.temp - 32) * (5 / 9)).round()}°C",
                                    style: TextStyle(fontSize: 21),
                                  );
                                }
                              } else {
                                return Container(
                                  child: Text("ASFSAD"),
                                );
                              }
                            }),
                        //Text(
                        //  "${snapshot.data.temp}°F / ",
                        //  style: TextStyle(fontSize: 20),
                        //),
                        //Text(
                        //  "${((snapshot.data.temp - 32) * (5 / 9)).round()}°C",
                        //  style: TextStyle(fontSize: 18),
                        //),
                      ],
                    ),
                  )
                ],
              );
            } else {
              return Text("nada");
            }
          } else if (snapshot.hasError) {
            return Text("asdf");
          }
          return Container();
        },
      ),
    );
  }
}

class WeatherWidget extends StatelessWidget {
  var color;
  WeatherWidget(this.color);
  @override
  Widget build(BuildContext context) {
    return Container(
      //color: Colors.pink,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 0),
        child: FutureBuilder<Weather>(
          future: fetchWeather(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data.show == true) {
                return Padding(
                  padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
                  child: Container(
                    height: 250,
                    width: double.infinity,
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
                    child: Container(
                      child: SingleChildScrollView(
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(top: 11),
                              child: Text(
                                "Weather",
                                style: TextStyle(
                                   fontSize: 23, fontFamily: "sans"),
                              ),
                            ),
                            Divider(
                              thickness: 1,
                              color: color,
                            ),
                            Container(
                                child: snapshot.data.oneDay
                                    ? nightWeather(snapshot, context)
                                    : dayWeather(snapshot, context)),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              } else {
                return Text("nada");
              }
            } else if (snapshot.hasError) {
              return Text("asdf");
            }
            return Container();
          },
        ),
      ),
    );
  }

  Widget nightWeather(snapshot, context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 9.0),
              child: Text(
                "Current",
               style: TextStyle(fontSize: 21,  fontFamily: 'sans'),
              ),
            ),
            CurrentWeather(),
          ],
        ),
        SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 9.0),
                child: Text(
                  "Tomorrow",
                  style: TextStyle(fontSize: 21, fontFamily: 'sans')
                  
                ),
              ),
              Container(
                  height: 90,
                  child: Image.asset(
                      "assets/weatherIcons/${snapshot.data.currentIcon}.png",color: MediaQuery.of(context).platformBrightness == Brightness.dark ? Colors.white : Colors.black,)),
              Text("${caseWord(snapshot.data.currentDescription)}",
                  style: TextStyle(fontSize: 20)),
              Padding(
                padding: const EdgeInsets.only(top: 9.0),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      FutureBuilder<bool>(
                          future: getPref(),
                          builder: (BuildContext context,
                              AsyncSnapshot<bool> snapshots) {
                            if (snapshots.data != null) {
                              if (snapshots.data) {
                                return Text(
                                  "${snapshot.data.currentTemp}°F",
                                  style: TextStyle(fontSize: 21),
                                );
                              } else {
                                return Text(
                                  "${((snapshot.data.currentTemp - 32) * (5 / 9)).round()}°C",
                                  style: TextStyle(fontSize: 21),
                                );
                              }
                            } else {
                              return Container(
                                child: Text("ASFSAD"),
                              );
                            }
                          }),
                      //Text(
                      //  "${snapshot.data.currentTemp}°F / ",
                      //  style: TextStyle(fontSize: 20),
                      //),
                      //Text(
                      //  "${((snapshot.data.currentTemp - 32) * (5 / 9)).round()}°C",
                      //  style: TextStyle(fontSize: 18),
                      //),
                    ]),
              )
            ],
          ),
        ),
      ],
    );
  }

  dayWeather(snapshot, context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 9.0),
              child: Text(
                "Today",
               style: TextStyle(fontSize: 21, fontFamily: 'sans')
              ),
            ),
            Container(
                height: 90,
                child: Image.asset(
                    "assets/weatherIcons/${snapshot.data.currentIcon}.png",color: MediaQuery.of(context).platformBrightness == Brightness.dark ? Colors.white : Colors.black,)),
            Text("${caseWord(snapshot.data.currentDescription)}",
                style: TextStyle(fontSize: 20)),
            Padding(
              padding: const EdgeInsets.only(top: 12.0),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    FutureBuilder<bool>(
                        future: getPref(),
                        builder: (BuildContext context,
                            AsyncSnapshot<bool> snapshots) {
                          if (snapshots.data != null) {
                            if (snapshots.data) {
                              return Text(
                                "${snapshot.data.currentTemp}°F",
                                style: TextStyle(fontSize: 21),
                              );
                            } else {
                              return Text(
                                "${((snapshot.data.currentTemp - 32) * (5 / 9)).round()}°C",
                                style: TextStyle(fontSize: 21),
                              );
                            }
                          } else {
                            return Container(
                              child: Text("ASFSAD"),
                            );
                          }
                        }),
                  ]),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(right: 0.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 9.0),
                child: Text(
                  "Tomorrow",
                  style: TextStyle(fontSize: 21, fontFamily: 'sans')
                ),
              ),
              Container(
                  height: 90,
                  child: Image.asset(
                      "assets/weatherIcons/${snapshot.data.futureIcon}.png",color: MediaQuery.of(context).platformBrightness == Brightness.dark ? Colors.white : Colors.black,)),
              Text("${caseWord(snapshot.data.futureDescription)}",
                  style: TextStyle(fontSize: 20)),
              Padding(
                padding: const EdgeInsets.only(top: 12.0),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      FutureBuilder<bool>(
                          future: getPref(),
                          builder: (BuildContext context,
                              AsyncSnapshot<bool> snapshots) {
                            if (snapshots.data != null) {
                              if (snapshots.data) {
                                return Text(
                                  "${snapshot.data.currentTemp}°F",
                                  style: TextStyle(fontSize: 21),
                                );
                              } else {
                                return Text(
                                  "${((snapshot.data.currentTemp - 32) * (5 / 9)).round()}°C",
                                  style: TextStyle(fontSize: 21),
                                );
                              }
                            } else {
                              return Container(
                                child: Text("ASFSAD"),
                              );
                            }
                          }),
                    ]),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
