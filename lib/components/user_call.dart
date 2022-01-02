import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:intl/intl.dart';
import 'package:newpro/components/change_pass.dart';
import 'package:newpro/model/tab_screens.dart';
import 'package:newpro/pages/chooseTabs.dart';
import 'package:newpro/pages/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CallUser extends StatefulWidget {
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
  CallUser(
      {this.uid,
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
  _CallUserState createState() => _CallUserState();
}

class _CallUserState extends State<CallUser> {
  var curdate = DateFormat("d MMM y").format(DateTime.now());
  List<dynamic> userDetails = [];
  String usernameId = "";
  bool loading = true;
  List<dynamic> searchList = [];
  List<dynamic> callDetails = [];

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

  Future getUser() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      usernameId = preferences.getString('username');
    });
  }

  Future logOut() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    preferences.remove('username');
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => ChooseScreenTabs()));
  }

  Future getUserInfo() async {
    var userUrl = "https://ultdev.org/jobbackend/getUser.php";
    var response = await http
        .get(Uri.parse(userUrl), headers: {"Accept": "application/json"});
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      setState(() {
        loading = false;
        callDetails = data;
      });
      return data;
    }
  }
  //search start here
  Future showAllPost()async{
    var  dataFetch ="https://ultdev.org/jobbackend/getUser.php";
    var response = await http.get(Uri.parse(dataFetch),headers: {"Accept":"application/json"});
    if(response.statusCode==200){
      var data= jsonDecode(response.body);
      for(var i=0; i< data.length;i++){
        searchList.add(data[i]['jobcate']);
      }
      //return data;
    }

  }

  @override
  void initState() {
    super.initState();
    getUserData();
    getUser();
    getUserInfo();
    showAllPost();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.purpleAccent,
        elevation: 1,
        actions: [
          IconButton(
              onPressed: () {
                showSearch(context: context, delegate: SearchPost(list: searchList));
              },
              icon: Icon(Icons.search))
        ],
      ),
      drawer: Drawer(
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
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ChangeUserPassword(
                                      firstname: userDetails[i]['fname'],
                                      lastname: userDetails[i]['lname'],
                                      uid: userDetails[i]['uid'],
                                      picture:
                                          'https://ultdev.org/jobbackend/uploads/${userDetails[i]['picture']}',
                                    )));
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
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => ScreenTabs()));
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
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        child: loading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : ListView.builder(
          itemCount: callDetails.length,
            itemBuilder: (context, index) {
                return Card(
                  //color: Colors.primaries[Random().nextInt(Colors.primaries.length)],
                  child: ListTile(
                    leading: CircleAvatar(child: Text(callDetails[index]['fname'][0]),),
                    title: Text(callDetails[index]['fname']+' '+ callDetails[index]['lname']),
                    subtitle: Text(callDetails[index]['jobcate']),
                    trailing: IconButton(icon: Icon(Icons.call,size: 20,color: Colors.black87,),
                      onPressed: ()async{
                        await FlutterPhoneDirectCaller.directCall(callDetails[index]['phone_number']);
                      },),

                  ),
                );
              }),
      ),
    );
  }

}

//search
class SearchPost extends SearchDelegate <String>{
  List <dynamic> list;
  SearchPost({required this.list});
  List <dynamic> searchTitle  =[];
  List <dynamic> searchList  =[];

  Future showAllPost()async{
    var  fetchUrl ="https://ultdev.org/jobbackend/showAllJob.php";
    var response = await http.post(Uri.parse(fetchUrl),body:{'jobcate':query} );
    if(response.statusCode==200){
      var data= jsonDecode(response.body);
      return data;
    }
  }


  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: (){
            query = "";
            showSuggestions(context);

          },
          icon: Icon(Icons.close))
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        onPressed: (){
          // Navigator.pop(context);
          close(context, "");
        },
        icon: Icon(Icons.arrow_back));
  }

  @override
  Widget buildResults(BuildContext context) {
    return FutureBuilder<dynamic>(
        future: showAllPost(),
        builder: (context,snapshot){
          if(snapshot.hasData){
            return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (context,index){
                  var list = snapshot.data[index];
                  return Card(
                    child: ListTile(
                      leading: CircleAvatar(child: Text(list['fname'][0]),),
                      title: Text(list['fname']+' '+ list['lname']),
                      subtitle: Text(list['jobcate']),
                      trailing: IconButton(icon: Icon(Icons.call,size: 20,color: Colors.black87,),
                        onPressed: ()async{
                          await FlutterPhoneDirectCaller.directCall(list['phone_number']);
                        },),
                    ),
                  );
                });
          }
          return Center(child: CircularProgressIndicator());
        });
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    var listData= query.isEmpty ? list : list.where((element) => element.toLowerCase().contains(query)).toList();
    return listData.isEmpty ?  Center(child: Text("No Data found")):ListView.builder(

        itemCount: listData.length,
        itemBuilder: (context,index){
          return ListTile(
            onTap: (){
              query = listData[index];
              showResults(context);
            },
            title: Text(listData[index]),
            // trailing: IconButton(icon: Icon(Icons.call,size: 20,color: Colors.black87,),
            //   onPressed: ()async{
            //     await FlutterPhoneDirectCaller.directCall(listData[index]['phone_number']);
            //   },),

          );
        });
  }

}