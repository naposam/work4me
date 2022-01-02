import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UpdateHelper{
  static Widget inputFieldWidget(
      BuildContext context,
      Icon icon,
      String keyName,
      String labelName,
      TextEditingController controller,
      Widget ? suffixIcon,

      ){
    return Container(
      padding: EdgeInsets.only(left: 20, right: 20),
      child: TextFormField(
       controller: controller,
        style: TextStyle(fontSize: 18,),
        decoration: InputDecoration(
            hintStyle: TextStyle(fontWeight: FontWeight.bold,fontSize: 15),
            hintText: labelName,
            labelText: keyName,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide(
                  color: Theme.of(context).primaryColor,
                  width: 1
              ),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.0),
              borderSide: BorderSide(
                  color: Theme.of(context).primaryColor,
                  width: 1
              ),

            ),
            suffixIcon: suffixIcon,
            prefixIcon: Padding(
              padding: EdgeInsets.only(left: 30,right: 10),
              child: IconTheme(
                data: IconThemeData(color: Theme.of(context).primaryColor),
                child: icon,
              ),
            )
        ),
      ),
    );
  }
  static Widget saveButton(
      String buttonText,
      Function onTap,
      ) {
    return Container(height: 50, width: 150,child: GestureDetector(
      onTap: (){
        onTap();
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.white,
            style: BorderStyle.solid,
            width: 1.0,
          ),
          color: Colors.purpleAccent,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Text(
                buttonText,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1

                ),
              ),
            )
          ],
        ),
      ),
    ),);
  }


  static Widget buttonNext(
      String buttonText,
      Function onTap,
      ) {
    return Container(height: 50, width: 100,child: GestureDetector(
      onTap: (){
        onTap();
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.white,
            style: BorderStyle.solid,
            width: 1.0,
          ),
          color: Colors.purpleAccent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Text(
                buttonText,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1

                ),
              ),
            )
          ],
        ),
      ),
    ),);
  }
}