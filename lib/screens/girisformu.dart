import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:listapp/islemler/shared_pref.dart';
import 'package:listapp/screens/anasayfa.dart';
import 'package:listapp/screens/kayitekrani.dart';
import 'package:listapp/screens/sifre_yenileme.dart';

class GirisFormu extends StatefulWidget {
  const GirisFormu({Key? key}) : super(key: key);

  @override
  _GirisFormuState createState() => _GirisFormuState();
}

class _GirisFormuState extends State<GirisFormu> {
  bool isButtonEnabled = false;
  TextEditingController emailcontrol = TextEditingController();
  TextEditingController parolacontrol = TextEditingController();

  // Giriş butonunu etkinleştirme / devre dışı bırakma
  void checkFormStatus() {
    setState(() {
      isButtonEnabled =
          emailcontrol.text.isNotEmpty && parolacontrol.text.isNotEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 10,
            ),
            Icon(
              Icons.lock,
              size: 100,
            ),
            SizedBox(
              height: 40,
            ),
            Text(
              "Hoşgeldin Başlamak İçin Adım Atmaya Ne Dersin ?",
              style: TextStyle(color: Colors.grey.shade700, fontSize: 16),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: EdgeInsets.all(8),
              child: TextFormField(
                controller: emailcontrol,
                onChanged: (value) {
                  checkFormStatus();
                },
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  labelText: "Email Adresi",
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8),
              child: TextFormField(
                controller: parolacontrol,
                onChanged: (value) {
                  checkFormStatus();
                },
                obscureText: true,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  labelText: "Parola",
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SifreYenileme(),
                      ));
                },
                child: Text(
                  "Şifreni mi unuttun?",
                  style: TextStyle(color: Colors.blue.shade400),
                )),
            SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: isButtonEnabled
                      ? () {
                          girisYap();
                        }
                      : null,
                  child: Text("Giriş Yap"),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => KayitFormuEkrani(),
                        ));
                  },
                  child: Text("Kayıt Ol"),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  void girisYap() async {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return Center(
          child: CircularProgressIndicator(color: Colors.black),
        );
      },
    );
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailcontrol.text.trim(),
        password: parolacontrol.text.trim(),
      );

      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => AnaSayfa(),
          ),
          (route) => false);
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      AwesomeDialog(
        autoHide: Duration(seconds: 1),
        desc: "Email veya Şifre Hatalı",
        context: context,
      ).show();
      emailcontrol.clear();
      parolacontrol.clear();
    } catch (e) {
      print(e);
    }
  }
}
