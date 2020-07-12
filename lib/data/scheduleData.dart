import 'package:space/widgets/countdown.dart';
import 'dart:io';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:connectivity/connectivity.dart';

List<Schedule> cachedSchedules = [];
bool gotten = false;

class Schedule {
  String name;
  List<String> modes = [];
  List<List<Period>> periods = []; //contains start-end time and label
  Schedule(this.name, this.modes, this.periods);
}

Future<List<Schedule>> getSchedules() async {
  var connectivityResult = await (Connectivity().checkConnectivity());

  if (cachedSchedules.length == 0 && !gotten) {
    gotten = true;

    try {
      if (connectivityResult == ConnectivityResult.mobile ||
          connectivityResult == ConnectivityResult.wifi) {
        Db db = new Db(
            "mongodb://spaceAdmin:nega5897@ds361998.mlab.com:61998/stevensondotspace");

        await db.open();
        var coll = db.collection('schedules');
        var res = await coll.findOne();
        db.close();
        var data = res['data'];

        for (int x = 0; x < data.length; x++) {
          //for every schedule
          var scheduleName = data[x]['name'];
          if (scheduleName != "Finals") {
            List<List<Period>> periods = [];
            List<String> modes = [];

            for (int y = 0; y < data[x]['modes'].length; y++) {
              //for every mode
              String modeName = data[x]['modes'][y]['name'];
              List<Period> periodGroup = [];

              modes.add(modeName);
              for (int z = 0; z < data[x]['modes'][y]['start'].length; z++) {
                //for every class Period
                String startTime = data[x]['modes'][y]['start'][z];
                String endTime = data[x]['modes'][y]['end'][z];
                if (startTime.length == 4) {
                  startTime = "0" + startTime;
                }

                if (endTime.length == 4) {
                  endTime = "0" + endTime;
                }
                ////print(int.parse(startTime.substring(0,2)) % 12);
                ////print(startTime.substring(2));
                //int firstStartNumbers = int.parse(startTime.substring(0, 2));
                //int firstEndNumbers = int.parse(endTime.substring(0, 2));
                //startTime = firstStartNumbers != 12
                //    ? (firstStartNumbers % 12).toString() + startTime.substring(2)
                //    : startTime;
                //endTime = firstEndNumbers != 12
                //    ? (firstEndNumbers % 12).toString() + endTime.substring(2)
                //    : endTime;
                //if (startTime.length == 4) {
                //  startTime = "0" + startTime;
                //}

                //if (endTime.length == 4) {
                //  endTime = "0" + endTime;
                //}
                String label = data[x]['modes'][y]['periods'][z];
                Period period = new Period("$startTime-$endTime", label);
                periodGroup.add(period);
              }

              periods.add(periodGroup);
            }
            cachedSchedules.add(new Schedule(scheduleName, modes, periods));
          }
        }
      }
    } on SocketException catch (_) {}
    return cachedSchedules;
  } else {
    //print("using cached schedules");
    return cachedSchedules;
  }

  //}on SocketException catch(e){
  //return Alert("","","",false);
}

List<List<Period>> getSchedule(String inputName) {
  if (cachedSchedules.length == 0) {
    getSchedules();
    for (int x = 0; x < cachedSchedules.length; x++) {
      Schedule schedule = cachedSchedules[x];
      String name = schedule.name;
      if (name.toLowerCase() == inputName.toLowerCase()) {
        return schedule.periods;
      }
    }
  }
  return [];
}

List<Period> getScheduleWithMode(String inputName, String modeName) {
  if (cachedSchedules.length == 0) {
    getSchedules();
  } else {
    //print(modeName);
    for (int x = 0; x < cachedSchedules.length; x++) {
      Schedule schedule = cachedSchedules[x];
      String name = schedule.name;
      //print("name is " + name);
      //if (name.toLowerCase() == inputName.toLowerCase()) {
      if (name.toLowerCase() == inputName.toLowerCase()) {
        for (int y = 0; y < schedule.modes.length; y++) {
          //for mode in schedule
          if (schedule.modes[y].toLowerCase() == modeName.toLowerCase()) {
            //print(schedule.periods[y]);
            return schedule.periods[y];
          }
        }
      }
    }
  }
  return [];
}

List<String> getAllSchedules() {
  List<String> schedules = [];
  if (cachedSchedules.length == 0) {
    getSchedules();
  } else {
    for (int x = 0; x < cachedSchedules.length; x++) {
      Schedule schedule = cachedSchedules[x];
      String name = schedule.name;
      schedules.add(name);
    }
  }
  return schedules;
}

List<String> getModes(String inputName) {
  if (cachedSchedules.length == 0) {
    getSchedules();
  } else {
    for (int x = 0; x < cachedSchedules.length; x++) {
      Schedule schedule = cachedSchedules[x];
      String name = schedule.name;
      if (name.toLowerCase() == inputName.toLowerCase()) {
        return schedule.modes;
      }
    }
  }
  return [];
}
