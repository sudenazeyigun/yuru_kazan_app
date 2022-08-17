// ignore_for_file: prefer_const_constructors
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yuru_kazan_app/auth.dart';
import 'package:yuru_kazan_app/home.dart';
import 'package:yuru_kazan_app/user_model.dart';
import 'firebase_options.dart';
import 'package:flutter_pw_validator/flutter_pw_validator.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive_flutter/hive_flutter.dart';

class EmailPasswordLoginPage extends StatefulWidget {
  EmailPasswordLoginPage({Key? key}) : super(key: key);

  @override
  State<EmailPasswordLoginPage> createState() => _EmailPasswordLoginPageState();
}

class _EmailPasswordLoginPageState extends State<EmailPasswordLoginPage> {
  bool isChecked = false;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isChecked = false;
  UserModel _userModel = new UserModel();
  FirebaseAuth auth = FirebaseAuth.instance;
  AuthService _authService = AuthService();
  User? user;
  @override
  Widget build(BuildContext context) {
    future:
    Firebase.initializeApp();
    Hive.initFlutter();

    return Scaffold(
      appBar: AppBar(
        title: Text("Oturum Aç"),
      ),
      body: SingleChildScrollView(
        child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 150,
                  ),
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
                      prefixIcon: Icon(Icons.password),
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
                      minWidth: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.fromLTRB(10.0, 15.0, 10.0, 15.0),
                      onPressed: () {
                        var check = false;
                        check = _userModel.emailSifreKontrolLogin(
                            _emailController.text, _passwordController.text);
                        if (_emailController.text.isEmpty) {
                          Fluttertoast.showToast(
                              msg: "Email kısmı boş bırakılamaz!",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.CENTER,
                              timeInSecForIosWeb: 3,
                              backgroundColor: Colors.blueGrey,
                              textColor: Colors.white,
                              fontSize: 16.0);
                        }
                        if (_passwordController.text.isEmpty) {
                          Fluttertoast.showToast(
                              msg: "Şifre kısmı boş bırakılamaz",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.CENTER,
                              timeInSecForIosWeb: 3,
                              backgroundColor: Colors.blueGrey,
                              textColor: Colors.white,
                              fontSize: 16.0);
                        }
                        if (check) {
                          signinmethod();
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Home(user: user!),
                              ));
                        }
                      },
                      child: Text(
                        "Giriş Yap",
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

  void signinmethod() {
    _authService
        .signIn(_emailController.text, _passwordController.text)
        .then((value) {});
    user = auth.currentUser;
  }
}
