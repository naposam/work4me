import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:newpro/model/icon.dart';
import 'package:newpro/pages/user_register.dart';

class ChooseUserType extends StatefulWidget {
  const ChooseUserType({Key? key}) : super(key: key);

  @override
  _ChooseUserTypeState createState() => _ChooseUserTypeState();
}

class _ChooseUserTypeState extends State<ChooseUserType> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: SvgPicture.asset(
            background,
            fit: BoxFit.cover,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 50.0, left: 80),
          child: Text(
            "CHOOSE YOUR OPTION",
            style:
                TextStyle(color: Colors.white60, fontFamily: 'nasalization',fontSize: 20,fontWeight: FontWeight.w100),
          ),
        ),
        Center(
          child: Container(
            height: 200,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.amber,
              gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [Colors.pinkAccent, Colors.purple]),
            ),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    TextButton.icon(
                        onPressed: () {},
                        icon: Icon(
                          Icons.work_outline_sharp,
                          size: 40,
                          color: Colors.white,
                        ),
                        label: Text(
                          'Work4Me',
                          style: TextStyle(color: Colors.white),
                        )),
                    TextButton.icon(
                        onPressed: () {
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>UserRegistrationPage()));
                        },
                        icon: Icon(
                          Icons.work,
                          size: 40,
                          color: Colors.white,
                        ),
                        label: Text(
                          'Work4Me Artisans',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ))
                  ],
                ),
              ),
            ),
          ),
        ),
      ]),
    );
  }
}
