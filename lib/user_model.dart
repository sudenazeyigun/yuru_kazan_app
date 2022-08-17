import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:yuru_kazan_app/email_login.dart';

class UserModel {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  late String emailHataMesaji;
  late String sifreHataMesaji;
  late String adHataMesaji;
  late String soyadHataMesaji;
  EmailPasswordLoginPage _emailPasswordLoginPage = EmailPasswordLoginPage();
  emailSifreKontrolRegister(
      String email, String sifre, String ad, String soyad) {
    var sonuc = true;
    if (sifre.length < 6) {
      sifreHataMesaji = "Şifreniz en az 6 karakterden oluşmalı";
      sonuc = false;
      return sonuc;
    }
    if (!email.contains('@')) {
      emailHataMesaji = "Geçersiz email adresi";
      sonuc = false;
      return sonuc;
    }
    if (ad.isEmpty) {
      adHataMesaji = "Ad kısmı boş bırakılamaz!";
      sonuc = false;
      return sonuc;
    }
    if (soyad.isEmpty) {
      soyadHataMesaji = "Soyad kısmı boş bırakılamaz!";
      sonuc = false;
      return sonuc;
    }

    return sonuc;
  }

  emailSifreKontrolLogin(String email, String sifre) {
    var sonuc = true;
    if (sifre.length < 6) {
      sifreHataMesaji = "Şifreniz en az 6 karakterden oluşmalı";
      sonuc = false;
      return sonuc;
    }
    if (!email.contains('@')) {
      emailHataMesaji = "Geçersiz email adresi";
      sonuc = false;
      return sonuc;
    }

    return sonuc;
  }
}
