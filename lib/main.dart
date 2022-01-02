
import 'package:flutter/material.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:newpro/components/dashboard.dart';
import 'package:newpro/model/auth.dart';
import 'package:newpro/pages/chooseTabs.dart';
import 'package:newpro/pages/login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'model/biometric.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  //dynamic token = FlutterSession().get('token');
  SharedPreferences preferences = await SharedPreferences.getInstance();
  var username = preferences.getString('username');
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.purpleAccent,
        accentColor: Colors.purple
    ),
    home: username == null ? ChooseScreenTabs():DashBoardScreen(),
  ));
}



