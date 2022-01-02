
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:newpro/components/dashboard.dart';
import 'package:newpro/pages/login.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
class FingerprintApp extends StatefulWidget {
  final userName;
  final firstName;
  final lastName;
  final middleName;
  final uid;
  final lid;
  final phoneNumber;
  final status;
  final jobCate;
  final gender;
  FingerprintApp(
      {this.firstName,
        this.userName ,
        this.gender,
        this.jobCate,
        this.lastName,
        this.lid,
        this.middleName,
        this.phoneNumber,
        this.status,
        this.uid});

  @override
  _FingerprintAppState createState() => _FingerprintAppState();
}

class _FingerprintAppState extends State<FingerprintApp> {
  LocalAuthentication auth = LocalAuthentication();
  bool _canCheckBiometric=true;
  List <BiometricType> _availableBiometrics=[];
  String authorized ="Not authorized";
  //start here
  // List <dynamic> userDetails=[];
  //
  // Future <dynamic> getUserData()async {
  //   SharedPreferences preferences = await SharedPreferences.getInstance();
  //   if (preferences.getString('username') != null) {
  //     var userCheck=preferences.getString('username');
  //     var dataUrl = Uri.parse("http://192.168.8.100/jobbackend/test.php");
  //     var response = await http.post(
  //         dataUrl, body: {'username': userCheck});
  //     if (response.statusCode == 200) {
  //       var data = jsonDecode(response.body);
  //       setState(() {
  //         userDetails = data;
  //       });
  //     }
  //
  //   }
  //   print(userDetails);
  //
  // }
  Future <void> _checkBiometric()async{
    bool canCheckBiometric= true;
    try{
      canCheckBiometric = await auth.canCheckBiometrics;

    }on PlatformException catch (e){
      print(e);
    }
    if(!mounted) return;
    setState(() {
 _canCheckBiometric = canCheckBiometric;
    });
  }

  Future <void> _getAvailableBiometric()async{
    List <BiometricType> availableBiometric = [];
     try{
       availableBiometric = await auth.getAvailableBiometrics();

     }on PlatformException catch (e){
       print(e);
     }
     setState(() {
       _availableBiometrics = availableBiometric;
     });
  }

  Future <void> _authenticate()async{
    bool authenticated= false;
    try{
      authenticated = await auth.authenticateWithBiometrics(localizedReason: "Scan your Finger to authentic",
        useErrorDialogs: true,
      stickyAuth: true,
      );


    }on PlatformException catch (e){
      print(e);
    }
    if(!mounted) return;
    setState(() {
      authorized = authenticated ? "Authorized success" : "Failed to authenticate";
      if(authenticated){
        Navigator.push(context, MaterialPageRoute(builder: (context)=>DashBoardScreen()));
      }
      print(authorized);
    });
  }
  @override
  void initState() {
    super.initState();
    _checkBiometric();
   _getAvailableBiometric();
    _authenticate();

  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      backgroundColor: Color(0xFF3C3E52),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0,horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Text("Work4Me",style: TextStyle(color: Colors.white,fontSize: 48.0),),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 50.0,),
              child: Column(
                children: [
                  Image.asset('images/finger.png',width: 120.0,),
                  Text('Fingerprint Auth', style: TextStyle(
                    color: Colors.white,
                    fontSize: 22.0,
                    fontWeight: FontWeight.bold
                  ),),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 15.0,),
                    width: 150.0,
                    child: Text("Authenticate using your fingerprint",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                      color: Colors.white,
                        height: 1.5

                    ),),

                  ),

                ],
              ),
            )
          ],
        ),
      ),
    ));
  }
}
