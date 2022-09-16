import 'package:flutter/material.dart';
import 'package:yuru_kazan_app/screens/email_login.dart';
import 'package:yuru_kazan_app/screens/email_register.dart';
import 'package:yuru_kazan_app/main.dart';
// ignore_for_file: prefer_const_constructors

class SignInPage extends StatelessWidget {
  const SignInPage({Key? key}) : super(key: key);

  void _emailVeSifreIleGiris(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(
         fullscreenDialog: true,
          builder: (context) => EmailPasswordLoginPage()));
  }
  void _emailIleKaydol(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(
         fullscreenDialog: true,
          builder: (context) => EmailPasswordRegisterPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text("Giriş Ekranı"),
        elevation: 0,
      ),
      body: Container(
        color: Colors.white,
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SizedBox(
              height: 80,
            ),
            Image.asset(
              "assets/amblem-ana.png",
              width: 100,
              height: 100,
            ),
            SizedBox(
              height: 40,
            ),
            Text(
              "Oturum Açın",
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 32),
            ),
            SizedBox(
              height: 8,
            ),

           
            RaisedButton(
              onPressed: ()=> _emailVeSifreIleGiris(context) ,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
              ),
              child: Text(
                "Oturum Aç",
                style: TextStyle(color: Colors.white),
              ),
              color: Colors.blue,
            ),

            RaisedButton(
              onPressed: ()=> _emailIleKaydol(context)  ,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
              ),
              child: Text(
                "Kayıt Ol",
                style: TextStyle(color: Colors.white),
              ),
              color: Colors.blue,
            ),
          ],
        ),
      ),
    );
  }
}
