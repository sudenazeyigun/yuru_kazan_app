// ignore_for_file: prefer_const_constructors
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';

import 'package:yuru_kazan_app/main.dart';
import 'package:yuru_kazan_app/sign_in_page.dart';
import 'package:page_transition/page_transition.dart';

void main() {
  runApp(MaterialApp(
    home: Splash(),
  ));
}

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 4,),
     () {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SignInPage(),
          ));
    });
  }

  @override
  Widget build(BuildContext context) {
    
    return AnimatedSplashScreen(
      
      splash: Column(
        children: [
          
          Image.asset("assets/logo_4.gif"),
          
        ],
      ),
      nextScreen: const SignInPage(),
      splashIconSize: 400,

     
    );
  }
}
