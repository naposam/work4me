import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
class TopCard extends StatefulWidget {
  final firstname;
  TopCard({this.firstname});

  @override
  _TopCardState createState() => _TopCardState();
}

class _TopCardState extends State<TopCard> {
  bool loading=true;
  List <dynamic> postCard  =[];
  String isLikeOrDislike = "";


  Future showAllPost()async{
    var  userUrl ="https://ultdev.org/jobbackend/getUser.php";
    var response = await http.get(Uri.parse(userUrl),headers: {"Accept":"application/json"});
    if(response.statusCode==200){
      var data = jsonDecode(response.body);
      setState(() {
        loading=false;
        postCard=data;
      });
      return data;
    }

  }
  @override
  void initState() {

    super.initState();
    showAllPost();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      width: MediaQuery.of(context).size.width,
      // color: Colors.amber,

      child: loading ? Center(child: CircularProgressIndicator(),): ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: postCard.length,
          itemBuilder: (context,index){
            return  NewPostItem(
              uid: postCard[index]['uid'],
              firstname: postCard[index]['fname'],
              middleName: postCard[index]['mname'],
              lastname: postCard[index]['lname'],
              phoneNumber: postCard[index]['phone_number'],
              jobCate: postCard[index]['jobcate'],
              createdDate: postCard[index]['date_created'],
              isLike: postCard[index]['total_likes'],
              picture:'https://ultdev.org/jobbackend/uploads/${postCard[index]['picture']}',
            );



          }),
    );
  }
}
class NewPostItem extends StatefulWidget {
  final uid;
  final  firstname ;
  final middleName;
  final lastname;
  final phoneNumber;
  final jobCate;
  final createdDate;
  final picture;
  final isLike;


  NewPostItem({
    this.uid,
    this.firstname,
    this.middleName,
    this.lastname,
    this.phoneNumber,
    this.jobCate,
    this.createdDate,
  this.picture,
    this.isLike
  });



  @override
  _NewPostItemState createState() => _NewPostItemState();
}

class _NewPostItemState extends State<NewPostItem> {
  @override
  Widget build(BuildContext context) {
    return  Stack(
      children: [

        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            height: 200,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.amber,
              gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [Colors.pinkAccent,Colors.purple]),
            ),

          ),
        ),
        Positioned(
          top: 30,
          left: 30,
          child: CircleAvatar(
            radius: 30,

            //child: Icon(Icons.person),
            backgroundImage: NetworkImage(widget.picture),

          ),
        ),
        Positioned(
          top: 30,
          left:95,
          child:Text(widget.firstname + ' ' + widget.middleName +' '+ widget.lastname,style: TextStyle(
              color: Colors.white,
              // fontFamily: 'nasalization',
              fontWeight: FontWeight.bold,
            fontSize: 20,
          ),),
        ),
        Positioned(
          top: 30,
          left:150,
          child:Text('',style: TextStyle(
            color: Colors.grey.shade200,
            fontFamily: 'nasalization',

          ),),
        ),
        Positioned(
          top: 58,
          left:100,
          child:Icon(Icons.comment,color: Colors.white,),
        ),
        Positioned(
          top: 58,
          left:130,
          child:Text("10",style: TextStyle(
              color: Colors.white,
              fontFamily: 'nasalization',
              fontWeight: FontWeight.bold
          ),),
        ),
        Positioned(
          top: 100,
          left:140,
          child:Text(widget.jobCate,style: TextStyle(
              color: Colors.white,
              fontFamily: 'nasalization',
              fontWeight: FontWeight.bold,
            fontSize: 20,
          ),),
        ),
        Positioned(
          top: 45,
          left:170,
          child:IconButton(onPressed: ()async{
          print(widget.uid);
          },icon: Icon(Icons.thumb_up,color: Colors.white,),),
        ),
        Positioned(
          top: 58,
          left:208,
          child:Text(widget.isLike,style: TextStyle(
              color: Colors.white,
              fontFamily: 'nasalization',
              fontWeight: FontWeight.bold
          ),),
        ),
        Positioned(
          top: 100,
          left:30,
          child:Text(widget.createdDate,style: TextStyle(
              color: Colors.white,
              fontFamily: 'nasalization',
              fontWeight: FontWeight.bold
          ),),
        ),
        Positioned(
          top: 145,
          left:30,
          child:Icon(Icons.call,color: Colors.white,),
        ),
        Positioned(
          top: 150,
          left:60,
          child:InkWell(
            child: Text(widget.phoneNumber,style: TextStyle(
                color: Colors.grey.shade200,
                fontFamily: 'nasalization',
                fontWeight: FontWeight.bold,
              fontSize: 20,
            ),),
            onTap: ()async{

              await FlutterPhoneDirectCaller.directCall(widget.phoneNumber);
            },
          ),
        ),
        Positioned(
          top: 150,
          left:220,
          child:Icon(Icons.location_on_outlined,color: Colors.white,size: 25,),
        ),
        Positioned(
          top: 155,
          left:245,
          child:Text("Takoradi-Anaji",style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20

          ),),
        ),

      ],
    );
  }
}

