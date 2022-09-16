import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yuru_kazan_app/map/order_traking_page.dart';
import 'package:yuru_kazan_app/screens/home.dart';
import 'package:yuru_kazan_app/services/auth_service.dart';
import 'package:yuru_kazan_app/model/user_model.dart';
import '../map/firebase_options.dart';
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
  bool? isLogin = false;

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
                      onPressed: () async {
                        var check = true;

                        if (check == true) {
                          await signinmethod();
                        }

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
                              msg: "Şifre kısmı boş bırakılamaz!",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.CENTER,
                              timeInSecForIosWeb: 3,
                              backgroundColor: Colors.blueGrey,
                              textColor: Colors.white,
                              fontSize: 16.0);
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

  Future signinmethod() async {
    try {
      await auth.signInWithEmailAndPassword(
          email: _emailController.text, password: _passwordController.text);
      Navigator.push(
          context, MaterialPageRoute(builder: (_) => Home(user: user!)));
    } on FirebaseException catch (e) {
      Fluttertoast.showToast(
          msg: "Email veya şifre hatalı!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 3,
          backgroundColor: Colors.blueGrey,
          textColor: Colors.white,
          fontSize: 16.0);
    }

    user = auth.currentUser;
  }
}
