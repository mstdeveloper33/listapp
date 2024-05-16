import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:listapp/screens/girisformu.dart';

class KayitFormuEkrani extends StatefulWidget {
  const KayitFormuEkrani({Key? key}) : super(key: key);

  @override
  _KayitFormuEkraniState createState() => _KayitFormuEkraniState();
}

class _KayitFormuEkraniState extends State<KayitFormuEkrani> {
  bool isButtonEnabled = false;

  // E-posta, parola ve ad kontrolcüleri
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController nameController = TextEditingController();

  // Kayıt butonunu etkinleştirme / devre dışı bırakma
  void checkFormStatus() {
    setState(() {
      isButtonEnabled = emailController.text.isNotEmpty &&
          passwordController.text.isNotEmpty &&
          nameController.text.isNotEmpty;
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
              Icons.person_add_alt_1,
              size: 100,
            ),
            SizedBox(
              height: 40,
            ),
            Text(
              "Hoşgeldin",
              style: TextStyle(color: Colors.grey.shade700, fontSize: 16),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: EdgeInsets.all(8),
              child: TextFormField(
                controller: nameController,
                onChanged: (value) {
                  checkFormStatus();
                },
                decoration: InputDecoration(
                  labelText: "Kullanıcı Adı",
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8),
              child: TextFormField(
                controller: emailController,
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
                controller: passwordController,
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
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: isButtonEnabled
                      ? () {
                          kayitOl();
                        }
                      : null,
                  child: Text("Kayıt Ol"),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => GirisFormu(),
                        ),
                        (route) => false);
                  },
                  child: Text("Zaten mevcut bir hesabım var."),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  void kayitOl() async {
    if (passwordController.text.length < 6) {
      Fluttertoast.showToast(msg: 'Şifreniz en az 6 karakter olmalıdır.');
      return;
    }

    if (!emailController.text.contains('@gmail.com')) {
      Fluttertoast.showToast(msg: 'Geçerli bir Gmail adresi giriniz.');
      return;
    }
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      // Başarılı kayıt durumunda, giriş ekranına yönlendir
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => GirisFormu()),
      );
      String kullaniciId = userCredential.user!.uid;

      await FirebaseFirestore.instance
          .collection("Kullanicilar")
          .doc(kullaniciId)
          .set({
        "kullaniciAdi": nameController.text.trim(),
        "email": emailController.text.trim()
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        Fluttertoast.showToast(
            msg: 'Zayıf parola. Daha güçlü bir parola seçin.');
      } else if (e.code == 'email-already-in-use') {
        Fluttertoast.showToast(msg: 'Bu email adresi zaten kullanılıyor.');
      }
    } catch (e) {
      print(e);
    }
  }
}
