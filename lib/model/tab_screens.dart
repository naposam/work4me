import 'package:flutter/material.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:newpro/components/dashboard.dart';
import 'package:newpro/components/user_call.dart';

class ScreenTabs extends StatefulWidget {
  const ScreenTabs({Key? key}) : super(key: key);

  @override
  _ScreenTabsState createState() => _ScreenTabsState();
}

class _ScreenTabsState extends State<ScreenTabs> {
  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final tabs = [
     DashBoardScreen(),
     CallUser(),

      Center(
        child: Container(
          color: Colors.blue.withOpacity(0.5),
          child: Center(
              child: Text(
                "settings",
                style: TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                ),
              )),
        ),
      ),
    ];
    return Scaffold(
      body: tabs[currentIndex],
      bottomNavigationBar: BottomNavyBar(
        selectedIndex: currentIndex,
        showElevation: true,
        itemCornerRadius: 15,
        curve: Curves.easeIn,
        onItemSelected: (index) => setState(() {
          currentIndex = index;
        }),
        items: [
          BottomNavyBarItem(
            icon: Icon(Icons.apps),
            title: Text('Home'),
            activeColor: Colors.red,
            textAlign: TextAlign.center,
          ),
          BottomNavyBarItem(
            icon: Icon(Icons.call),
            title: Text('Users'),
            activeColor: Colors.purpleAccent,
            textAlign: TextAlign.center,
          ),

          BottomNavyBarItem(
            icon: Icon(Icons.settings),
            title: Text('Settings'),
            activeColor: Colors.blue,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
