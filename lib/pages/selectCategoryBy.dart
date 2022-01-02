import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
class SelectCategoryBy extends StatefulWidget {
  final categoryName;
  SelectCategoryBy({this.categoryName});


  @override
  _SelectCategoryByState createState() => _SelectCategoryByState();
}

class _SelectCategoryByState extends State<SelectCategoryBy> {
  List <dynamic> categoryByPost=[];
  bool loading=true;
  Future categoryByData()async{
    final URL_POST_CATEGORY="https://ultdev.org/jobbackend/categoryByUser.php";
    var response = await http.post(Uri.parse(URL_POST_CATEGORY),body:{"name": widget.categoryName,});
    if(response.statusCode==200){
      var data = jsonDecode(response.body);
      setState(() {
        loading=false;
        categoryByPost = data;
      });
    }

  }
  @override
  void initState() {
    super.initState();
    categoryByData();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: Text(widget.categoryName),
      ),
      body: Container(child: loading ? Center(child: CircularProgressIndicator(),): ListView.builder(
          itemCount: categoryByPost.length,
          itemBuilder: (context, index){
            return  NewPostItem(
              firstname: categoryByPost[index]['fname'],
              middleName: categoryByPost[index]['mname'],
              lastname: categoryByPost[index]['lname'],
              categoryName: categoryByPost[index]['jobcate'],
              phoneNumber: categoryByPost[index]['phone_number'],
              createdDate: categoryByPost[index]['date_created'],
              isLike: categoryByPost[index]['total_likes'],
              picture:'https://ultdev.org/jobbackend/uploads/${categoryByPost[index]['picture']}',


            );

          }),),
    );
  }
}
class NewPostItem extends StatefulWidget {
  final uid;
  final  firstname ;
  final middleName;
  final lastname;
  final phoneNumber;
  final categoryName;
  final createdDate;
  final isLike;
  final picture;


  NewPostItem({
    this.uid,
    this.firstname,
    this.middleName,
    this.lastname,
    this.phoneNumber,
    this.categoryName,
    this.createdDate,
    this.isLike,
    this.picture
  });

  // const NewPostItem({Key? key}) : super(key: key);

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
           // child: Icon(Icons.person),
            backgroundImage: widget.picture==null ? NetworkImage(''):NetworkImage(widget.picture),
            // backgroundImage: NetworkImage(widget.image),
          ),
        ),
        Positioned(
          top: 30,
          left:90,
          child:Text(widget.firstname + ' ' + widget.middleName +' '+ widget.lastname,style: TextStyle(
              color: Colors.white,

              fontWeight: FontWeight.bold,
              fontSize: 20
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
          child:Text(widget.categoryName,style: TextStyle(
              color: Colors.white,
              fontFamily: 'nasalization',
              fontWeight: FontWeight.bold,
              fontSize: 20
          ),),
        ),
        Positioned(
          top: 58,
          left:170,
          child:Icon(Icons.label,color: Colors.white,),
        ),
        Positioned(
          top: 58,
          left:200,
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
                fontSize: 20
            ),),
            onTap: ()async{
              await FlutterPhoneDirectCaller.callNumber(widget.phoneNumber);
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
