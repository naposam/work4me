import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_toastr/flutter_toastr.dart';
import 'package:newpro/pages/form_helper.dart';


class ChangeUserPassword extends StatefulWidget {
  final firstname;
  final lastname;
  final uid;
  final picture;
  ChangeUserPassword({this.firstname,this.lastname,this.uid,this.picture});
  @override
  _ChangeUserPasswordState createState() => _ChangeUserPasswordState();
}

class _ChangeUserPasswordState extends State<ChangeUserPassword> {
  final _scaffoldkey = GlobalKey<ScaffoldState>();
  GlobalKey<FormState> globalFormKey = GlobalKey<FormState>();
  String _pwd = "";
  String _pwdcom = "";
  bool hidePassword = true;
  bool hidePasswordConfirm = true;

  Future  changePassword()async {
      var dataUrl = Uri.parse("https://ultdev.org/jobbackend/ChangePassword.php");
      var response = await http.post(
          dataUrl, body: {'uid': widget.uid,'password':_pwd});
      if (response.statusCode == 200) {
        FlutterToastr.show("Update Success",
          context,
          duration: FlutterToastr.lengthLong,
          position:  FlutterToastr.bottom,
          backgroundColor: Colors.green,

        );
        Navigator.pop(context);
      }


  }




  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey.shade200,
        key: _scaffoldkey,
        body: _loginUISetup(context),
      ),
    );
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
                bottomLeft: Radius.circular(100),
                bottomRight: Radius.circular(100)
              )),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Spacer(),
              Align(
                alignment: Alignment.center,
                child:Image.network(
                  widget.picture,
                  fit: BoxFit.contain,
                  width: 140,
                ),

              ),
              Text(widget.firstname +" "+ widget.lastname,style: TextStyle(
                color: Colors.white,fontSize: 18
              ),),
              Spacer(),
            ],
          ),
        ),
        Center(
          child: Padding(
            padding: EdgeInsets.only(bottom: 20, top: 40),
            child: Text(
              "Change Password",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(bottom: 20),
          child: FormHelper.inputFieldWidget(
            context,
            Icon(Icons.lock),
            "New Password",
            "New Password",
                (onValidateVal) {
              if (onValidateVal.isEmpty) {
                return "New Password cannot be empty";
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
              onChange: (val){
                _pwd=val!;
              }
          ),
        ),
       
        Padding(
          padding: EdgeInsets.only(bottom: 20),
          child: FormHelper.inputFieldWidget(
            context,
            Icon(Icons.lock),
            "Confirm Password",
            "Confirm Password",
                (onValidateVal) {
              if (onValidateVal.isEmpty) {
                return "Password cannot be empty";
              }
              if(_pwd != _pwdcom){
                return "Password Do not Match";
              }
              return null;
            },
                (onSavedVal) {
              _pwdcom = onSavedVal.toString().trim();
            },
            initialValue: "",
            obscureText: hidePasswordConfirm,
            suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    hidePasswordConfirm = !hidePasswordConfirm;
                  });
                },
                color: Colors.pinkAccent.withOpacity(0.4),
                icon: Icon(
                    hidePasswordConfirm ? Icons.visibility_off : Icons.visibility)),
              onChange: (val){
                _pwdcom=val!;
              }
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
              child: FormHelper.saveButton("Change", () {
                if (validateAndSave()) {
                 changePassword();
                  print("New Password: $_pwd");
                  print("old Password: $_pwdcom");
                }
              }),
            ),
            SizedBox(
              width: 10,
            ),
            new Center(
              child: FormHelper.buttonCancel("Cancel", () {
                Navigator.pop(context);
              }),
            )
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


