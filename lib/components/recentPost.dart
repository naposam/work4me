import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RecentPostItem extends StatefulWidget {
  const RecentPostItem({Key? key}) : super(key: key);

  @override
  _RecentPostItemState createState() => _RecentPostItemState();
}

class _RecentPostItemState extends State<RecentPostItem> {
  bool loading = true;
  List<dynamic> recentPost = [];
  Future recentPostData() async {
    var fetchUrl = Uri.parse("https://ultdev.org/jobbackend/getRecently.php");
    var response =
        await http.get(fetchUrl, headers: {"Accept": "application/json"});
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      setState(() {
        loading = false;
        recentPost = data;
      });
      return data;
    }
  }

  @override
  void initState() {
    super.initState();
    recentPostData();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      child:  loading? Center(child: CircularProgressIndicator(),): ListView.builder(
          itemCount: recentPost.length,
          itemBuilder: (context, index) {
            return RecentItem(
              uid: recentPost[index]["uid"],
              firstname: recentPost[index]['fname'],
              lastname: recentPost[index]['lname'],
              middleName: recentPost[index]['mname'],
              date: recentPost[index]['date_created'],
              image:
                  'https://ultdev.org/jobbackend/uploads/${recentPost[index]['picture']}',
              jobCate: recentPost[index]["jobcate"],
              phone: recentPost[index]['phone_number'],
            );
          }),
    );
  }
}

class RecentItem extends StatefulWidget {
  final uid;
  final firstname;
  final lastname;
  final middleName;
  final date;
  final jobCate;
  final phone;
  final image;

  RecentItem(
      {this.uid,
      this.lastname,
      this.image,
      this.firstname,
      this.date,
      this.jobCate,
      this.phone,
      this.middleName});

  @override
  _RecentItemState createState() => _RecentItemState();
}

class _RecentItemState extends State<RecentItem> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                  onTap: () async{
                    await FlutterPhoneDirectCaller.directCall(widget.phone);
                    // Navigator.push(context, MaterialPageRoute(
                    //     builder: (context)=>PostDetails(
                    //       image: widget.image,
                    //       author: widget.author,
                    //       title: widget.title,
                    //       postDate: widget.date,
                    //       body: widget.body,
                    //     )));
                  },
                  child: Container(
                      width: 300,
                      child: Text(
                        widget.jobCate,
                        style: TextStyle(fontSize: 20),
                      ))),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                     widget.firstname +" "+ widget.middleName +" "+ widget.lastname,
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child:
                      Text(widget.date, style: TextStyle(color: Colors.grey)),
                ),

              ],
            ),

          ],
        ),
        Container(
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Image.network(
              widget.image,
              height: 70,
              width: 70,
            ),
          ),
        ),
      ],
    );
  }
}
