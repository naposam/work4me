import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:http/http.dart' as http;
import 'package:newpro/pages/login.dart';
import 'package:shared_preferences/shared_preferences.dart';
class ScreenTestPage extends StatefulWidget {

  @override
  _ScreenTestPageState createState() => _ScreenTestPageState();
}

class _ScreenTestPageState extends State<ScreenTestPage> {
String usernameId="";
Future getUser()async{
  SharedPreferences preferences = await SharedPreferences.getInstance();
  setState(() {
    usernameId=preferences.getString('username');
  });
}

  List <dynamic> userDetails=[];
  Future <dynamic> getUserData()async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if (preferences.getString('username') != null) {
      var userCheck=preferences.getString('username');
      var dataUrl = Uri.parse("http://192.168.8.100/jobbackend/test.php");
      var response = await http.post(
          dataUrl, body: {'username': userCheck});
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        setState(() {
          userDetails = data;
        });
      }

    }
     print(userDetails);

  }
  @override
  void initState() {
    super.initState();
    getUserData();
    getUser();

  }
  @override  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(usernameId !=''? usernameId:''),
      ),
      body: ListView.builder(
                itemCount: userDetails.length,
                itemBuilder: (context,index){
                  return NewUserDetails(
                    firstName:userDetails[index]["fname"],
                    lastName: userDetails[index]['lname'],
                    middleName: userDetails[index]['mname'],
                    picture: 'http://192.168.8.100/jobbackend/uploads/${userDetails[index]['picture']}',
                    phoneNumber: userDetails[index]["phone_number"],
                    userName: userDetails[index]['username'],
                    jobCate: userDetails[index]['jobcate'],
                  );

                }),



    );
  }
}
class NewUserDetails extends StatefulWidget {
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
  final picture;
  NewUserDetails(
      {this.firstName,
        this.userName,
        this.gender,
        this.jobCate,
        this.lastName,
        this.lid,
        this.middleName,
        this.phoneNumber,
        this.status,
        this.uid,
        this.picture,
      });

  @override
  _NewUserDetailsState createState() => _NewUserDetailsState();
}
class _NewUserDetailsState extends State<NewUserDetails> {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(

          children: [
            Text("${widget.jobCate}"),
          ],
        ),
      );

  }
}

