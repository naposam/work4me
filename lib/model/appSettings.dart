import 'dart:convert';
import 'dart:ui';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:newpro/pages/chooseTabs.dart';
import 'package:newpro/pages/login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'icon.dart';
 class AppSettings extends StatefulWidget {
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
   AppSettings({this.uid,
     this.picture,
     this.jobCate,
     this.firstName,
     this.middleName,
     this.userName,
     this.phoneNumber,
     this.lastName,
     this.status,
     this.gender,
     this.lid});
 
   @override
   _AppSettingsState createState() => _AppSettingsState();
 }
 
 class _AppSettingsState extends State<AppSettings> {
   String usernameId="";
   bool loading = true;
   List<dynamic> searchList = [];
   List<dynamic> userDetails = [];


   Future<dynamic> getUserData() async {
     SharedPreferences preferences = await SharedPreferences.getInstance();
     if (preferences.getString('username') != null) {
       var userCheck = preferences.getString('username');
       var dataUrl = Uri.parse("https://ultdev.org/jobbackend/test.php");
       var response = await http.post(dataUrl, body: {'username': userCheck});
       if (response.statusCode == 200) {
         var data = jsonDecode(response.body);
         setState(() {
           userDetails = data;
         });
       }
     }
     //print(userDetails);
   }
   Future getUser()async{
     SharedPreferences preferences = await SharedPreferences.getInstance();
     setState(() {
       usernameId=preferences.getString('username');
     });
   }
   Future logOut() async {
     SharedPreferences preferences = await SharedPreferences.getInstance();

     preferences.remove('username');
     Navigator.push(
         context, MaterialPageRoute(builder: (context) => ChooseScreenTabs()));
   }
   Widget menuDrawer(){
     return Drawer(
       child: Material(
         // color: Color.fromRGBO(200, 150, 205, 1),
         child: ListView(
           children: [
             DrawerHeader(
               decoration: BoxDecoration(
                 gradient: LinearGradient(
                     begin: Alignment.topLeft,
                     end: Alignment.bottomRight,
                     colors: [Colors.purple, Colors.purpleAccent]),
                 borderRadius: BorderRadius.only(
                   bottomLeft: Radius.circular(50),
                   bottomRight: Radius.circular(50),
                 ),
               ),
               child: ListView.builder(
                   scrollDirection: Axis.vertical,
                   shrinkWrap: true,
                   itemCount: userDetails.length,
                   itemBuilder: (context, index) {
                     return new ListTile(
                       title: Column(
                         children: [
                           Padding(
                             padding: const EdgeInsets.all(8.0),
                             child: CircleAvatar(
                               //child:  Icon(Icons.person,)
                               backgroundImage: NetworkImage(
                                   'https://ultdev.org/jobbackend/uploads/${userDetails[index]['picture']}'),
                             ),
                           ),
                           Text(
                             usernameId != '' ? "$usernameId" : "",
                             style: TextStyle(color: Colors.white),
                           ),
                           Text(
                             userDetails[index]['fname'] +
                                 ' ' +
                                 userDetails[index]['lname'],
                             style: TextStyle(color: Colors.white),
                           ),
                         ],
                       ),
                     );
                   }),
             ),
             ListTile(
               onTap: () {
                 Navigator.pop(context);
               },
               leading: Icon(
                 Icons.home,
                 color: Colors.purple,
               ),
               title: Text(
                 "Home",
                 style: TextStyle(color: Colors.purple),
               ),
             ),
             ListView.builder(
                 scrollDirection: Axis.vertical,
                 shrinkWrap: true,
                 itemCount: userDetails.length,
                 itemBuilder: (context, i) {
                   return new ListTile(
                     onTap: () {
                       // Navigator.push(
                       //     context,
                       //     MaterialPageRoute(
                       //         builder: (context) => ChangeUserPassword(
                       //           firstname: userDetails[i]['fname'],
                       //           lastname: userDetails[i]['lname'],
                       //           uid: userDetails[i]['uid'],
                       //           picture:
                       //           'https://ultdev.org/jobbackend/uploads/${userDetails[i]['picture']}',
                       //         )));
                     },
                     leading: Icon(
                       Icons.lock,
                       color: Colors.purple,
                     ),
                     title: Text(
                       "Change Password",
                       style: TextStyle(color: Colors.purple),
                     ),
                   );
                 }),
             Divider(
               color: Colors.grey,
               height: 0.5,
             ),
             ListTile(
               onTap: () {
                 // Navigator.pushReplacement(context,
                 //     MaterialPageRoute(builder: (context) => ScreenTabs()));
               },
               leading: Icon(
                 Icons.settings,
                 color: Colors.purple,
               ),
               title: Text(
                 "Settings",
                 style: TextStyle(color: Colors.purple),
               ),
             ),
             Divider(
               color: Colors.grey,
               height: 0.5,
             ),
             ListTile(
               onTap: () {},
               leading: Icon(
                 Icons.share,
                 color: Colors.purple,
               ),
               title: Text(
                 "Share",
                 style: TextStyle(color: Colors.purple),
               ),
             ),
             ListTile(
               onTap: () {
                 logOut();
               },
               leading: Icon(
                 Icons.lock_open,
                 color: Colors.purple,
               ),
               title: Text(
                 "Logout",
                 style: TextStyle(color: Colors.purple),
               ),
             ),
             Divider(
               color: Colors.grey,
               height: 100,
             ),
           ],
         ),
       ),
     );

         }
   @override
  void initState() {
    super.initState();
    getUser();
    getUserData();
  }
   @override
   Widget build(BuildContext context) {
     return Scaffold(
       appBar: AppBar(
         iconTheme: IconThemeData(color: Colors.white),
         backgroundColor: Colors.purpleAccent,
         elevation: 1,
       title: Text(usernameId,),
         centerTitle: true,
       ),
         drawer: menuDrawer(),
       body: Stack(
         children: <Widget>[
           Container(
             height: MediaQuery
                 .of(context)
                 .size
                 .height,
             width: MediaQuery
                 .of(context)
                 .size
                 .width,
             child: SvgPicture.asset(background, fit: BoxFit.cover,),
           ),
           Padding(
             padding: const EdgeInsets.only(top: 50, left: 20, right: 20),
             child: SingleChildScrollView(
               scrollDirection: Axis.vertical,
               child: Column(
                 crossAxisAlignment: CrossAxisAlignment.start,
                 children: <Widget>[


                   SizedBox(
                     height: 40,
                   ),
                   Row(
                     children: <Widget>[
                       ClipRRect(
                         borderRadius: BorderRadius.circular(25),
                         child: BackdropFilter(
                           filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                           child: GestureDetector(
                             onTap: () {

                             },
                             child: Container(
                               height: 200,
                               width: 160,
                               decoration: BoxDecoration(
                                   borderRadius: BorderRadius.circular(25),
                                   color: Color(0xff8E8FC9).withOpacity(0.3)
                               ),
                               child: Column(
                                 mainAxisAlignment: MainAxisAlignment.center,
                                 children: <Widget>[
                                   SvgPicture.asset(icon_General,width: 50,height: 52,),
                                   SizedBox(
                                     height: 30,
                                   ),
                                   Text(
                                     "General",
                                     style: TextStyle(
                                         fontSize: 23,
                                         fontWeight: FontWeight.w600,
                                         color: Color(0xff289FF3)
                                     ),
                                   ),
                                 ],
                               ),
                             ),
                           ),
                         ),
                       ),
                       SizedBox(
                         width: 32,
                       ),
                       ClipRRect(
                         borderRadius: BorderRadius.circular(25),
                         child: BackdropFilter(
                           filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                           child: GestureDetector(
                             onTap: () {

                             },
                             child: Container(
                               height: 200,
                               width: 160,
                               decoration: BoxDecoration(
                                   borderRadius: BorderRadius.circular(25),
                                   color: Color(0xff8E8FC9).withOpacity(0.3)
                               ),
                               child: Column(
                                 mainAxisAlignment: MainAxisAlignment.center,
                                 children: <Widget>[
                                   SvgPicture.asset(info,width: 50,height: 52,),
                                   SizedBox(
                                     height: 30,
                                   ),
                                   Text(
                                     "User Info",
                                     style: TextStyle(
                                         fontSize: 23,
                                         fontWeight: FontWeight.w600,
                                         color: Color(0xff7B52FE)
                                     ),
                                   ),
                                 ],
                               ),
                             ),
                           ),
                         ),
                       ),
                     ],
                   ),
                   SizedBox(
                     height: 30,
                   ),
                   Row(
                     children: <Widget>[
                       ClipRRect(
                         borderRadius: BorderRadius.circular(25),
                         child: BackdropFilter(
                           filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                           child: GestureDetector(
                             onTap: () {

                             },
                             child: Container(
                               height: 200,
                               width: 160,
                               decoration: BoxDecoration(
                                   borderRadius: BorderRadius.circular(25),
                                   color: Color(0xff8E8FC9).withOpacity(0.3)
                               ),
                               child: Column(
                                 mainAxisAlignment: MainAxisAlignment.center,
                                 children: <Widget>[
                                   SvgPicture.asset(update,width: 50,height: 52,),
                                   SizedBox(
                                     height: 30,
                                   ),
                                   Text(
                                     "Update ",
                                     style: TextStyle(
                                         fontSize: 23,
                                         fontWeight: FontWeight.w600,
                                         color: Color(0xffFF44DE)
                                     ),
                                   ),
                                 ],
                               ),
                             ),
                           ),
                         ),
                       ),
                       SizedBox(
                         width: 32,
                       ),
                       ClipRRect(
                         borderRadius: BorderRadius.circular(25),
                         child: BackdropFilter(
                           filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                           child: GestureDetector(
                             onTap: () {

                             },
                             child: Container(
                               height: 200,
                               width: 160,
                               decoration: BoxDecoration(
                                   borderRadius: BorderRadius.circular(25),
                                   color: Color(0xff8E8FC9).withOpacity(0.3)
                               ),
                               child: Column(
                                 mainAxisAlignment: MainAxisAlignment.center,
                                 children: <Widget>[
                                   SvgPicture.asset(settings,width: 50,height: 52,),
                                   SizedBox(
                                     height: 30,
                                   ),
                                   Text(
                                     "Settings",
                                     style: TextStyle(
                                         fontSize: 23,
                                         fontWeight: FontWeight.w600,
                                         color: Color(0xffFF8D45)
                                     ),
                                   ),
                                 ],
                               ),
                             ),
                           ),
                         ),
                       ),
                     ],
                   ),
                   SizedBox(
                     height: 30,
                   ),
                   Row(
                     children: <Widget>[
                       ClipRRect(
                         borderRadius: BorderRadius.circular(25),
                         child: BackdropFilter(
                           filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                           child: GestureDetector(
                             onTap: () {

                             },
                             child: Container(
                               height: 200,
                               width: 160,
                               decoration: BoxDecoration(
                                   borderRadius: BorderRadius.circular(25),
                                   color: Color(0xff8E8FC9).withOpacity(0.3)
                               ),
                               child: Column(
                                 mainAxisAlignment: MainAxisAlignment.center,
                                 children: <Widget>[
                                   SvgPicture.asset(notification,width: 50,height: 52,),
                                   SizedBox(
                                     height: 30,
                                   ),
                                   Text(
                                     "Notification",
                                     style: TextStyle(
                                         fontSize: 23,
                                         fontWeight: FontWeight.w600,
                                         color: Color(0xffFF4D4D)
                                     ),
                                   ),
                                 ],
                               ),
                             ),
                           ),
                         ),
                       ),
                       SizedBox(
                         width: 32,
                       ),
                       ClipRRect(
                         borderRadius: BorderRadius.circular(25),
                         child: BackdropFilter(
                           filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                           child: GestureDetector(
                             onTap: () {

                             },
                             child: Container(
                               height: 200,
                               width: 160,
                               decoration: BoxDecoration(
                                   borderRadius: BorderRadius.circular(25),
                                   color: Color(0xff8E8FC9).withOpacity(0.3)
                               ),
                               child: Column(
                                 mainAxisAlignment: MainAxisAlignment.center,
                                 children: <Widget>[
                                   SvgPicture.asset(phone,width: 50,height: 52,),
                                   SizedBox(
                                     height: 30,
                                   ),
                                   Text(
                                     "Contact",
                                     style: TextStyle(
                                         fontSize: 23,
                                         fontWeight: FontWeight.w600,
                                         color: Color(0xff1DCA4D)
                                     ),
                                   ),
                                 ],
                               ),
                             ),
                           ),
                         ),
                       ),
                     ],
                   ),

                 ],
               ),
             ),
           ),

         ],
       ),
     );

   }


 }
 