import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:newpro/pages/form_helper.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_toastr/flutter_toastr.dart';
import 'package:newpro/pages/login.dart';
import 'package:newpro/pages/update_details.dart';
class UserRegistrationPage extends StatefulWidget {
  const UserRegistrationPage({Key? key}) : super(key: key);

  @override
  _UserRegistrationPageState createState() => _UserRegistrationPageState();
}

class _UserRegistrationPageState extends State<UserRegistrationPage> {
  final _scaffoldkey = GlobalKey<ScaffoldState>();
   GlobalKey<FormState> globalKey = GlobalKey<FormState>();
  bool isApiCallProcess = false;
  bool hidePassword = true;
  bool hideConfirmPassword = true;
  String _phone="";
  String _email="";
  String _pass="";
  String _conpwd="";
  String _exp="";

  Future register()async{
    var  ADD_URL ="https://ultdev.org/jobbackend/user_reg.php";
      final response = await http.post(Uri.parse(ADD_URL),body: {
        "phone_number": _phone,
        "username": _email,
        "password": _pass,

      });
      if(response.body.isNotEmpty) {
        var data = jsonDecode(response.body);


        if(data == "Error"){
          FlutterToastr.show("The Username Has Been Taken ",
            context,
            duration: FlutterToastr.lengthLong,
            position:  FlutterToastr.bottom,
            backgroundColor: Colors.red,
          );
        }else{
          FlutterToastr.show("Registration Successful ",
            context,
            duration: FlutterToastr.lengthLong,
            position:  FlutterToastr.bottom,
            backgroundColor: Colors.green,
          );
          Navigator.push(context, MaterialPageRoute(builder: (context)=>UpdateUserDetails(
            uid: data[0]["uid"],
            lid: data[0]["lid"],

          )));


        }



    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      backgroundColor: Colors.grey.shade200,
      key: _scaffoldkey,
      body: ProgressHUD(
        child: registerUISetup(),

      ),
    ));
  }
  Widget registerUISetup(){
    return new SingleChildScrollView(
      child: new Form(
        key: globalKey,
          child: _registerUI(context)),
    );
  }
  Widget _registerUI(BuildContext context){
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
       Container(
         width: MediaQuery.of(context).size.width,
         height: MediaQuery.of(context).size.height/3.5,
         decoration: BoxDecoration(
           gradient: LinearGradient(
             begin: Alignment.topCenter,
             end: Alignment.bottomCenter,
             colors: [
               Colors.purple,
               Colors.purple
             ]
           ),
           borderRadius: BorderRadius.only(
             bottomRight: Radius.circular(150),
           ),

         ),
         child: Column(
           mainAxisAlignment: MainAxisAlignment.center,
           // crossAxisAlignment: CrossAxisAlignment.center,
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
            child: Text("User SignUp",style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 25,
            ),),
          ),
        ),
        FormHelper.inputFieldWidget(
            context,
            Icon(Icons.phone_android),
            "phone",
            "Phone",
            (onValidateVal){
              if(onValidateVal.isEmpty){
                return "Mobile cannot be empty";
              }
              return null;
            },
          (onSavedVal){
          _phone=onSavedVal.toString().trim();
          },
          initialValue: "",
          isNumeric: true,
        ),
        Padding(
          padding: const EdgeInsets.only(top: 20),
          child: FormHelper.inputFieldWidget(
            context,
            Icon(Icons.email),
            "email",
            "Email",
                (onValidateVal){
              if(onValidateVal.isEmpty){
                return "Email cannot be empty";
              }
              return null;
            },
                (onSavedVal){
              _email=onSavedVal.toString().trim();

            },
            initialValue: "",
          ),
        ),
        // Padding(padding: const EdgeInsets.only(top: 20),
        //   child: FormHelper.inputFieldWidget(
        //       context,
        //       Icon(Icons.format_list_numbered),
        //       "Number of Year of Experience",
        //       "Number of Year of Experience",
        //       (onValidateVal){
        //         if(onValidateVal.isEmpty){
        //           return "Enter Your Number of Years of Experience";
        //         }
        //         return null;
        //       },
        //       (onSavedVal){
        //        _exp=onSavedVal.toString().trim();
        //       },
        //     initialValue: "",
        //     isNumeric: true,
        //   ),
        // ),
        Padding(
          padding: const EdgeInsets.only(top: 20),
          child: FormHelper.inputFieldWidget(
            context,
            Icon(Icons.lock),
            "password",
            "Password",
                (onValidateVal){
              if(onValidateVal.isEmpty){
                return "Password cannot be empty";
              }
              return null;
            },
                (onSavedVal){
              _pass=onSavedVal.toString().trim();

            },
            initialValue: "",
              obscureText: hidePassword,
              suffixIcon: IconButton(
                  color: Colors.redAccent.withOpacity(0.4),
                  onPressed: (){
                    setState(() {
                      hidePassword=!hidePassword;
                    });
                  },
                  icon: Icon(hidePassword ? Icons.visibility_off: Icons.visibility)),
            onChange: (val){
              _pass=val!;
            }

          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 20),
          child: FormHelper.inputFieldWidget(
            context,
            Icon(Icons.email),
            "confirmpassword",
            "Confirm Password",
                (onValidateVal){
              if(onValidateVal.isEmpty){
                return "Confirm Password cannot be empty";
              }
              if(_pass != _conpwd){
                return "Password Do not Match";
              }
              return null;
            },
                (onSavedVal){
              _conpwd= onSavedVal.toString().trim();

            },
            initialValue: "",
              obscureText: hideConfirmPassword,
              suffixIcon: IconButton(
                color: Colors.redAccent.withOpacity(0.4),
                  onPressed: (){
                  setState(() {
                    hideConfirmPassword=!hideConfirmPassword;
                  });
                  },
                  icon: Icon(hideConfirmPassword ? Icons.visibility_off: Icons.visibility)),
            onChange: (val){
              _conpwd=val;
            }
          ),
        ),
        SizedBox(height: 20,),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 15.0),
              child: new Center(
                child: FormHelper.saveButton(
                    "Register",
                    (){
                  if(validateAndSave()){
                    register();
                  }
                    }),
              ),
            ),
            SizedBox(width: 10,),
            // Padding(
            //   padding: const EdgeInsets.only(bottom: 15.0),
            //   child: new Center(
            //     child: FormHelper.buttonNext("Login",
            //         (){
            //       Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginScreen()));
            //         }),
            //   ),
            // )
          ],
        )
      ],
    );

  }
  bool validateAndSave(){
    final form= globalKey.currentState;
    if(form!.validate()){
      form.save();
      return true;
    }
    else{
      return false;
    }
  }
}
