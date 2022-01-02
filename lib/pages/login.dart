
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:newpro/components/ScreenTabs.dart';
import 'package:newpro/components/dashboard.dart';
import 'package:newpro/model/appSettings.dart';
import 'package:newpro/pages/chooseTabs.dart';
import 'package:newpro/pages/form_helper.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_toastr/flutter_toastr.dart';
import 'package:newpro/pages/user_register.dart';
import 'package:newpro/screens/choose.dart';
import 'package:shared_preferences/shared_preferences.dart';




class LoginScreen extends StatefulWidget {
 //const LoginScreen({Key? key}) : super(key: key);


  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _scaffoldkey = GlobalKey<ScaffoldState>();
  GlobalKey<FormState> globalFormKey = GlobalKey<FormState>();
  String _username = "";
  String _pwd = "";
  bool hidePassword = true;


  Future loginUser() async {
    final loginUrl =
        Uri.parse("https://ultdev.org/jobbackend/user_login.php");
    final response = await http
        .post(loginUrl, body: {"username": _username, "password": _pwd});
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      if (data == "Error") {
        FlutterToastr.show(
          "Invalid Username or Password",
          context,
          duration: FlutterToastr.lengthLong,
          position: FlutterToastr.bottom,
          backgroundColor: Colors.red,
        );
      } else if (data[0]['status'] == "Admin") {
        SharedPreferences preferences = await SharedPreferences.getInstance();
        preferences.setString("username", _username);
        FlutterToastr.show(
          "Login Successful",
          context,
          duration: FlutterToastr.lengthLong,
          position: FlutterToastr.bottom,
          backgroundColor: Colors.green,
        );
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>ScreenTabs()));
      } else {
       // await FlutterSession().set("token", _username);
        SharedPreferences preferences = await SharedPreferences.getInstance();
        preferences.setString("username", _username);


        FlutterToastr.show(
          "Login Successful",
          context,
          duration: FlutterToastr.lengthLong,
          position: FlutterToastr.bottom,
          backgroundColor: Colors.green,
        );


          Navigator.push(context, MaterialPageRoute(builder: (context) =>
              DashBoardScreen(
                userName: data[0]["username"],
                firstName: data[0]["fname"],
                lastName: data[0]["lname"],
                middleName: data[0]["mname"],
                uid: data[0]["uid"],
                lid: data[0]["lid"],
                phoneNumber: data[0]["phone_number"],
                status: data[0]["status"],
                jobCate: data[0]["jobcate"],
                gender: data[0]["gender"],
                  picture:'https://ultdev.org/jobbackend/uploads/${data[0]['picture']}'
              )));



      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.grey.shade200,
      key: _scaffoldkey,
      body: _loginUISetup(context),
    ));
  }

  Widget _loginUISetup(BuildContext context) {
    return new SingleChildScrollView(
      child: new Container(
        child: new Form(
          key: globalFormKey,
          child: _loginUI(context),
        ),
      ),
    );
  }

  Widget _loginUI(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height / 3.5,
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.purple,
                    Colors.purple,
                  ]),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(150),
              )),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Spacer(),
              Align(
                alignment: Alignment.center,
                child: Image.asset(
                  'images/log.png',
                  fit: BoxFit.contain,
                  width: 140,
                ),
              ),
              Spacer(),
            ],
          ),
        ),
        Center(
          child: Padding(
            padding: EdgeInsets.only(bottom: 20, top: 40),
            child: Text(
              "Login",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(bottom: 20, top: 20),
          child: FormHelper.inputFieldWidget(
            context,
            Icon(Icons.verified_user),
            "Username",
            "Username",
            (onValidateVal) {
              if (onValidateVal.isEmpty) {
                return "Username cannot be empty";
              }
              return null;
            },
            (onSavedVal) {
              _username = onSavedVal.toString().trim();
            },
          ),
        ),
        Padding(
          padding: EdgeInsets.only(bottom: 20),
          child: FormHelper.inputFieldWidget(
            context,
            Icon(Icons.lock),
            "Password",
            "Password",
            (onValidateVal) {
              if (onValidateVal.isEmpty) {
                return "Password cannot be empty";
              }
              return null;
            },
            (onSavedVal) {
              _pwd = onSavedVal.toString().trim();
            },
            initialValue: "",
            obscureText: hidePassword,
            suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    hidePassword = !hidePassword;
                  });
                },
                color: Colors.pinkAccent.withOpacity(0.4),
                icon: Icon(
                    hidePassword ? Icons.visibility_off : Icons.visibility)),
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            new Center(
              child: FormHelper.saveButton("Login", () {
                if (validateAndSave()) {
                  loginUser();
                  print("Username: $_username");
                  print("Password: $_pwd");
                }
              }),
            ),
            SizedBox(
              width: 10,
            ),
            // new Center(
            //   child: FormHelper.buttonNext("Register", () {
            //     Navigator.push(
            //         context,
            //         MaterialPageRoute(
            //             builder: (context) =>  ChooseScreenTabs()));
            //   }),
            // )
          ],
        )
      ],
    );
  }

  bool validateAndSave() {
    final form = globalFormKey.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    }
    return false;
  }
}
