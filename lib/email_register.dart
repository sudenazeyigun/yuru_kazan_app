// ignore_for_file: prefer_const_constructors
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:yuru_kazan_app/auth.dart';
import 'package:yuru_kazan_app/email_login.dart';
import 'package:yuru_kazan_app/sign_in_page.dart';
import 'firebase_options.dart';
import 'package:yuru_kazan_app/user_model.dart';
import 'package:yuru_kazan_app/home.dart';

class EmailPasswordRegisterPage extends StatefulWidget {
  EmailPasswordRegisterPage({Key? key}) : super(key: key);
  @override
  State<EmailPasswordRegisterPage> createState() =>
      _EmailPasswordRegisterPageState();
}

class _EmailPasswordRegisterPageState extends State<EmailPasswordRegisterPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _surnameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  late String emailHataMesaji;
  late String sifreHataMesaji;

  AuthService _authService = AuthService();
  UserModel _userModel = UserModel();
  @override
  Widget build(BuildContext context) {
    future:
    Firebase.initializeApp();

    return Scaffold(
      appBar: AppBar(
        title: Text("Kayıt Ol"),
      ),
      body: SingleChildScrollView(
        child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 100,
                  ),
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.person_add_alt_1_rounded),
                      hintText: "Ad",
                      labelText: "Ad",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 8),
                  TextFormField(
                    controller: _surnameController,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.person_add_alt_1_outlined),
                      hintText: "Soyad",
                      labelText: "Soyad",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 8),
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.mail),
                      hintText: "Email",
                      labelText: "Email",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 8),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.password_sharp),
                      hintText: "Şifre",
                      labelText: "Şifre",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Material(
                    elevation: 5.0,
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.blue,
                    child: FlatButton(
                    //sss  
                      minWidth: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.fromLTRB(10.0, 15.0, 10.0, 15.0),
                      onPressed: () {
                        var check = false;
                        check = _userModel.emailSifreKontrolRegister(
                            _emailController.text,
                            _passwordController.text,
                            _nameController.text,
                            _surnameController.text); //true

                        if (_nameController.text.isEmpty) {
                          
                          Fluttertoast.showToast(
                              msg: "Ad kısmı boş bırakılamaz!",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.CENTER,
                              timeInSecForIosWeb: 3,
                              backgroundColor: Colors.blueGrey,
                              textColor: Colors.white,
                              fontSize: 16.0);
                               onPressed() => {};
                        }
                        if (_surnameController.text.isEmpty) {
                          Fluttertoast.showToast(
                              msg: "Soyad kısmı boş bırakılamaz",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.CENTER,
                              timeInSecForIosWeb: 3,
                              backgroundColor: Colors.blueGrey,
                              textColor: Colors.white,
                              fontSize: 16.0);
                        }
                        if (!_emailController.text.contains('@')) {
                          Fluttertoast.showToast(
                              msg:
                                  "Geçersiz formatta bir email adresi girdiniz!",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.CENTER,
                              timeInSecForIosWeb: 3,
                              backgroundColor: Colors.blueGrey,
                              textColor: Colors.white,
                              fontSize: 16.0);
                        }
                        if (_passwordController.text.length < 6) {
                          Fluttertoast.showToast(
                              msg: "Şifreniz en az 6 karakterden oluşmalı!",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.CENTER,
                              timeInSecForIosWeb: 3,
                              backgroundColor: Colors.blueGrey,
                              textColor: Colors.white,
                              fontSize: 16.0);
                        }

                        if (check) {
                          _authService
                              .createPerson(
                                  _nameController.text,
                                  _surnameController.text,
                                  _emailController.text,
                                  _passwordController.text)
                              .then((value) {
                            return Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        EmailPasswordLoginPage()));
                          });
                        }
                      },
                      child: Text(
                        "Kayıt Ol",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white, fontStyle: FontStyle.normal),
                      ),
                    ),
                  ),
                ],
              ),
            )),
      ),
    );
  }
}
