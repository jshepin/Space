import 'package:http/http.dart';
import 'package:html/parser.dart';
import 'package:html/dom.dart';
import 'package:space/widgets/lunchMenu.dart';
import 'package:connectivity/connectivity.dart';

List<CalanderEvent> cachedEvents = [];

bool hasDay(s) {
  if (s.contains("Mon")) {
    return true;
  }
  if (s.contains("Tue")) {
    return true;
  }
  if (s.contains("Wed")) {
    return true;
  }
  if (s.contains("Thu")) {
    return true;
  }
  if (s.contains("Fri")) {
    return true;
  }
  if (s.contains("Sat")) {
    return true;
  }
  if (s.contains("Sun")) {
    return true;
  }
  return false;
}

class CalanderEvent {
  String name;
  String color;
  String location;
  DateTime startTime;
  DateTime endTime;
  String displayTime;
  CalanderEvent(this.name, this.color, this.location, this.startTime,
      this.endTime, this.displayTime);
}

Future<List<CalanderEvent>> getCalanderData() async {
  if (cachedEvents.length > 0) {
    //print("using cached events");
    return cachedEvents;
  } else {
    List<CalanderEvent> events = [];
    var client = Client();
    List<LunchItem> lunch = [];
    var connectivityResult = await (Connectivity().checkConnectivity());

    var link = "https://www.d125.org/calendar";
    //print(link);
    try {
      if (connectivityResult == ConnectivityResult.mobile ||
          connectivityResult == ConnectivityResult.wifi) {
        //print("REQUESTING CALENDAR DATA");
        Response response = await client.get(link);
        var document = parse(response.body);
        //print(document);
        List<Element> boxes = document.querySelectorAll('.fsCalendarDaybox');

        for (var box in boxes) {
          List<Element> eventListings = box.querySelectorAll('.fsCalendarInfo');
          if (eventListings.length > 0) {
            var d = box.querySelector('.fsCalendarDate');
            var year = num.parse(d.attributes['data-year']);
            var month = num.parse(d.attributes['data-month']) + 1;
            var day = num.parse(d.attributes['data-day']);
            if (1 == 1) {
              //if (DateTime.now().day <= day) {
              for (var event in eventListings) {
                Element titleElement =
                    event.querySelector('.fsCalendarEventTitle');
                var title = titleElement.text;

                Element locationElement = event.querySelector('.fsLocation');
                var location =
                    locationElement == null ? "" : locationElement.text;
                Element colorDotElement =
                    event.querySelector('.fsElementEventColorIcon');
                var color = colorDotElement == null
                    ? "FFFFFF"
                    : colorDotElement.attributes['style'].substring(
                        colorDotElement.attributes['style'].length - 6,
                        colorDotElement.attributes['style'].length);

                Element timeElement = event.querySelector('.fsTimeRange');
                int startMinute;
                int endMinute;
                int startHour;
                int endHour;
                var startMeridian;
                var endMeridian;
                var startTime;
                var displayTime;
                var endTime;
                if (timeElement == null) {
                  startTime = "";
                  endTime = "";
                  startMeridian = "";
                  endMeridian = "";
                  displayTime = "";
                } else {
                  Element startTimeElement =
                      timeElement.querySelector('.fsStartTime');
                  Element endTimeElement = event.querySelector('.fsEndTime');
                  if (startTimeElement == null) {
                    startHour = 0;
                    startMinute = 0;
                    startMeridian = "";
                  } else {
                    startHour = int.parse(
                        startTimeElement.querySelector('.fsHour').text);
                    startMinute = int.parse(
                        startTimeElement.querySelector('.fsMinute').text);
                    startMeridian =
                        startTimeElement.querySelector('.fsMeridian').text;
                  }
                  if (endTimeElement == null) {
                    endMinute = 0;
                    endHour = 0;
                    endMeridian = "";
                  } else {
                    endHour =
                        int.parse(endTimeElement.querySelector('.fsHour').text);
                    endMinute = int.parse(
                        endTimeElement.querySelector('.fsMinute').text);
                    endMeridian =
                        endTimeElement.querySelector('.fsMeridian').text;
                  }

                  displayTime =
                      '$startHour:${startMinute < 10 ? "0" : ""}$startMinute${startMeridian == endMeridian ? "" : " "}${startMeridian == endMeridian ? "" : startMeridian} - $endHour:${endMinute < 10 ? "0" : ""}$endMinute $endMeridian';
                }
                if (endHour == null) {
                  endHour = 0;
                }
                if (endMinute == null) {
                  endMinute = 0;
                }
                if (endMeridian == null) {
                  endMeridian = "";
                }
                if (startHour == null) {
                  startHour = 0;
                }
                if (startMinute == null) {
                  startMinute = 0;
                }
                if (startMeridian == null) {
                  startMeridian = "";
                }
                if (startMeridian.contains("PM")) {
                  startHour += 12;
                }
                if (endMeridian.contains("PM")) {
                  endHour += 12;
                }
                startTime = DateTime.parse(
                    '$year-${month < 10 ? "0" : ""}$month-${day < 10 ? "0" : ""}$day ${startHour < 10 ? "0" : ""}$startHour:${startMinute < 10 ? "0" : ""}$startMinute:00');
                endTime = DateTime.parse(
                    '$year-${month < 10 ? "0" : ""}$month-${day < 10 ? "0" : ""}$day ${endHour < 10 ? "0" : ""}$endHour:${endMinute < 10 ? "0" : ""}$endMinute:00');

                if (startMinute == 0 && startHour == 0) {
                  endTime = endTime.add(Duration(days: 1));
                }

                events.add(new CalanderEvent(
                    title, color, location, startTime, endTime, displayTime));
              }
            }
          } else {}
        }
      }
    } catch (_) {}
    cachedEvents = events;
    if (cachedEvents == null) {
      print("no calender events");
      return [];
    }

    return cachedEvents;
  }
}
