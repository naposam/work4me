import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:newpro/pages/login.dart';
import 'package:newpro/pages/update_helper.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_toastr/flutter_toastr.dart';

class UpdateUserDetails extends StatefulWidget {
  final uid;
  final lid;
  UpdateUserDetails(
      {
        this.lid,
        this.uid});

  @override
  _UpdateUserDetailsState createState() => _UpdateUserDetailsState();
}

class _UpdateUserDetailsState extends State<UpdateUserDetails> {
  TextEditingController fname= TextEditingController();
  TextEditingController lastname= TextEditingController();
  TextEditingController mname= TextEditingController();
  String ? selectedCategory ;
  List <dynamic> categoryItem=[];

  String ? selectedJobCategory ;
  List <dynamic> jobCategory=[];
  File ? _image;
  final ImagePicker _picker = ImagePicker();

  //pic
  Future choiceImage()async{
    var pickedImage =await _picker.getImage(source: ImageSource.gallery);
    setState(() {
      _image=File(pickedImage!.path);
    });
  }

  //getting users gender
  Future getAllCategory()async{
    final URL="https://ultdev.org/jobbackend/getgender.php";
    var response = await http.get(Uri.parse(URL));
    if(response.statusCode==200){
      var jsonData= jsonDecode(response.body);
      setState(() {
        categoryItem= jsonData;
      });
    }
    print(categoryItem);
  }
//getting job category
  Future getAllJobCategory()async{
    final jobUl="https://ultdev.org/jobbackend/getJobCategory.php";
    var response = await http.get(Uri.parse(jobUl));
    if(response.statusCode==200){
      var jsonData= jsonDecode(response.body);
      setState(() {
        jobCategory= jsonData;
      });
    }
    print(jobCategory);
  }

  //update users details
  Future updateUser()async{
      var uri=Uri.parse("https://ultdev.org/jobbackend/updateuser.php");
      var request = http.MultipartRequest("POST",uri);
      request.fields["fname"]=fname.text;
        request.fields["lname"]=lastname.text;
        request.fields["mname"]=mname.text;
        request.fields["gender"]=selectedCategory.toString();
        request.fields["jobcat"]= selectedJobCategory.toString();
        request.fields["uid"]= widget.uid;
      var pic = await http.MultipartFile.fromPath("image", _image!.path,filename: _image!.path);
      request.files.add(pic);
      var response = await request.send();

      if(response.statusCode==200){
        FlutterToastr.show("Update Success",
          context,
          duration: FlutterToastr.lengthLong,
          position:  FlutterToastr.bottom,
          backgroundColor: Colors.green,
        );
        Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginScreen()));

      }
    }
  @override
  void initState() {
    super.initState();
    getAllCategory();
    getAllJobCategory();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        title: Text("Personal Info"),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),

    body: ListView(
      children: [
   Padding(
     padding: const EdgeInsets.only(top: 15.0),
     child: UpdateHelper.inputFieldWidget(
         context,
         Icon(Icons.verified_user),
         "First name",
         "FirstName",
         fname,
         Icon(Icons.person)),
   ),
        Padding(
          padding: const EdgeInsets.only(top: 15.0),
          child: UpdateHelper.inputFieldWidget(

              context,
              Icon(Icons.verified_user),
              "Last name",
              "FirstName",
              lastname,
              Icon(Icons.person)),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 15.0),
          child: UpdateHelper.inputFieldWidget(

              context,
              Icon(Icons.verified_user),
              "Other name",
              "FirstName",
              mname,
              Icon(Icons.person)),
        ),

        Padding(
          padding: const EdgeInsets.only(left: 30, right: 30,top: 20),
          child: DropdownButton(

            isExpanded: true,
            value: selectedCategory,
            hint: Text("Select Gender"),
            items: categoryItem.map((category){
              return DropdownMenuItem(

                child: Text(category['gname']),
                value: category['gname'],
              );
            }).toList(),
            onChanged: (newValue){
              setState(() {
                selectedCategory=newValue as String?;
              });
            },),
        ),
        Center(
          child: Padding(
            padding: const EdgeInsets.only(left: 30, right: 30,top: 20),
            child: DropdownButton(
              isExpanded: true,
              value: selectedJobCategory,
              hint: Text("Select Job Category"),
              items: jobCategory.map((job){
                return DropdownMenuItem(

                  child: Text(job['cname']),
                  value: job['cname'],
                );
              }).toList(),
              onChanged: (newAddedValue){
                setState(() {
                  selectedJobCategory=newAddedValue as String?;
                });
              },),
          ),
        ),
        IconButton(onPressed: (){choiceImage();}, icon: Icon(Icons.image,size: 50,)),
        Container(
          child: _image == null ? Center(child: Text("No Image Selected")): Image.file(_image!),width: 80,height: 80,),
        Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: Center(
            child: UpdateHelper.saveButton(
                "Update",
                (){
                  updateUser();
                  print("${widget.uid}");
                }),
          ),
        ),

      ],
    ),
    );
  }

}
