import 'package:flutter/material.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:newpro/pages/login.dart';
import 'package:newpro/pages/user_register.dart';
import 'package:newpro/screens/choose.dart';
class ChooseScreenTabs extends StatefulWidget {
  const ChooseScreenTabs({Key? key}) : super(key: key);

  @override
  _ChooseScreenTabsState createState() => _ChooseScreenTabsState();
}

class _ChooseScreenTabsState extends State<ChooseScreenTabs> {
  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final tabs = [
      LoginScreen(),
      UserRegistrationPage(),

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
            icon: Icon(Icons.login_outlined),
            title: Text('Login'),
            activeColor: Colors.red,
            textAlign: TextAlign.center,
          ),
          BottomNavyBarItem(
            icon: Icon(Icons.person),
            title: Text('Register'),
            activeColor: Colors.purpleAccent,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
