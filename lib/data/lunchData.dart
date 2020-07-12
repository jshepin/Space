import 'package:http/http.dart';
import 'package:html/parser.dart';
import 'package:html/dom.dart';
import 'package:space/widgets/lunchMenu.dart';
import 'package:connectivity/connectivity.dart';

LunchData cachedLunchData;
int parseNum(s) {
  var result = "";
  for (var x = 0; x < s.length; x++) {
    if (s[x] == "0" ||
        s[x] == "1" ||
        s[x] == "2" ||
        s[x] == "3" ||
        s[x] == "4" ||
        s[x] == "5" ||
        s[x] == "6" ||
        s[x] == "7" ||
        s[x] == "8" ||
        s[x] == "9") {
      result += s[x];
    }
  }
  return num.parse(result);
}

Future<LunchData> getLunchData() async {
  List<LunchCategory> categories = [];

  var connectivityResult = await (Connectivity().checkConnectivity());

  if (cachedLunchData != null) {
    //print("using cached lunch data");
    return cachedLunchData;
  } else {
    // Make API call to Hackernews homepage
    List<LunchItem> lunch = [];
    try {
      if (connectivityResult == ConnectivityResult.mobile ||
          connectivityResult == ConnectivityResult.wifi) {
        print("REQUESTING LUNCH DATA");

        var client = Client();
        Response response = await client.get(
            'https://www.d125.org/students/food-servicelunch-menu/latest-menu');

        // Use html parser
        var document = parse(response.body);
        var lunchDays = document.querySelectorAll('.fsElement');

        List<Map<String, dynamic>> linkMap = [];

        for (var day in lunchDays) {
          var header = day.querySelector('header > .fsElementTitle > a');
          if (header != null) {
            if (parseNum(header.text) == DateTime.now().day) {
              print("FOund day${DateTime.now().day}");
              List<Element> foods =
                  day.querySelectorAll('.fsElementContent > p');
              //List<Element> categories = day.querySelectorAll('.fsElementContent > p > strong');
              for (var food in foods) {
                linkMap.add({
                  'title': food.text,
                });
              }

              var s = linkMap[0]['title'].toString();

              List<Text> foodsArray = s
                  .split('\n')
                  .map((String text) => Text(text.toString()))
                  .toList();

              foodsArray.forEach((x) => categories.add(new LunchCategory(
                  x
                      .toString()
                      .substring(1, (x.toString().indexOf(':')))
                      .replaceAll("\"", ""),
                  "")));
              foodsArray.forEach((y) => foodsArray[foodsArray.indexOf(y)] =
                  Text(y
                      .toString()
                      .substring(y.toString().indexOf(":") + 1)
                      .replaceAll("\"", "")));

              //print("foo");

              //List<String> t = [];

              for (int x = 0; x < foodsArray.length; x++) {
                lunch.add(LunchItem(foodsArray[x].data));

                //t.add("boo");
              }
              //categories = categories.toSet().toList();

              //categories.forEach((element) { print("category "+ element.name);});
              cachedLunchData = new LunchData(lunch, categories);
              //return cachedLunchData;
            }
          }
        }
      } else {
        print("NO CONNEXTION");
      }
    } catch (e) {}
    cachedLunchData = new LunchData(lunch, categories);
    return cachedLunchData;
  }
}
