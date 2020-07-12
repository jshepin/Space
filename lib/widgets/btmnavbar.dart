import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:space/pages/settings.dart';
import 'package:space/tools/tools.dart';
import 'package:space/widgets/colorPicker.dart';
import 'package:space/pages/classManager.dart';
import 'package:space/main.dart';
import 'package:page_transition/page_transition.dart';

class BtmBar extends StatefulWidget {
  @override
  _BtmBarState createState() => _BtmBarState();
}

int _selectedIndex = 0;

class _BtmBarState extends State<BtmBar> {
  void _onItemTapped({int index, var colorSnapshot}) {
    setState(() {
      _selectedIndex = index;
    });
    if (index == 0) {
      Navigator.push(
        context,
        PageTransition(
          type: PageTransitionType.fade,
          duration: Duration(milliseconds: 200),
          child: TestPage(false),
        ),
      );

      // Navigator.push(
      // context, MaterialPageRoute(builder: (context) => TestPage(false)));
    }
    if (index == 1) {
      Navigator.push(
        context,
        PageTransition(
          type: PageTransitionType.fade,
          duration: Duration(milliseconds: 200),
          child: ClassManager(Color(int.parse(colorSnapshot.data))),
        ),
      );
      // Navigator.push(
      // context,
      // MaterialPageRoute(
      // builder: (context) =>
      // ClassManager(Color(int.parse(colorSnapshot.data)))));
    }
    if (index == 2) {
      Navigator.push(
        context,
        PageTransition(
          type: PageTransitionType.fade,
          duration: Duration(milliseconds: 200),
          child: Picker(),
        ),
      );
      // Navigator.push(
      // context, MaterialPageRoute(builder: (context) => Picker()));
    }
    if (index == 3) {
      Navigator.push(
        context,
        PageTransition(
          type: PageTransitionType.fade,
          duration: Duration(milliseconds: 200),
          child: Settings(),
        ),
      );

      // Navigator.push(
      // context, MaterialPageRoute(builder: (context) => Settings()));
    }
  }

  @override
  Widget build(BuildContext context) {
    bool dark = MediaQuery.of(context).platformBrightness == Brightness.dark;
    Color color = dark ? Colors.black : Colors.white;
    return FutureBuilder<String>(
        future: getColor(),
        builder: (c, colorSnapshot) {
          if (colorSnapshot.data != null) {
            return BottomNavigationBar(
                type: BottomNavigationBarType.shifting,
                elevation: 0,
                selectedItemColor: Color(int.parse(colorSnapshot.data)),
                unselectedItemColor: dark ? Colors.white : Colors.black,

                //backgroundColor: Colors.red,
                //fixedColor: Colors.red,
                items: const <BottomNavigationBarItem>[
                  BottomNavigationBarItem(
                    icon: Icon(Icons.home),
                    title: Text('Home'),
                  ),
                  //BottomNavigationBarItem(
                  //  icon: Icon(Icons.business),
                  //  title: Text('Business'),
                  //),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.school),
                    title: Text('Schedules'),
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.colorize),
                    title: Text('Colors'),
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.settings),
                    title: Text('Settings'),
                  ),
                ],
                currentIndex: _selectedIndex,
                onTap: (a) {
                  _onItemTapped(index: a, colorSnapshot: colorSnapshot);
                });
          } else {
            return Container();
          }
        });
  }
}
