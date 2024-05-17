import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:listapp/screens/girisformu.dart';

class SifreYenileme extends StatefulWidget {
  const SifreYenileme({super.key});

  @override
  State<SifreYenileme> createState() => _SifreYenilemeState();
}

class _SifreYenilemeState extends State<SifreYenileme> {
  TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future passwordReset() async {
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: _emailController.text.trim());
      AwesomeDialog(
              dismissOnTouchOutside: false,
              autoHide: Duration(seconds: 2),
              context: context,
              dialogType: DialogType.success,
              animType: AnimType.topSlide,
              title: "Başarılı.",
              desc:
                  "Şifrenizi yenilemek için mail adresinize bağlantı gönderildi.")
          .show()
          .then(
            (value) => Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => GirisFormu(),
                ),
                (route) => false),
          );
    } on FirebaseAuthException catch (e) {
      print(e);
      AwesomeDialog(
              dismissOnTouchOutside: false,
              autoHide: Duration(seconds: 2),
              context: context,
              dialogType: DialogType.error,
              animType: AnimType.topSlide,
              title: "Üzgünüm.",
              desc: "Şifrenizi yenilemek için geçerli bir mail adresi giriniz.")
          .show();

      _emailController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Şifrenizi yenilemek için geçerli google hesabı giriniz."),
            SizedBox(
              height: 15,
            ),
            TextFormField(
              controller: _emailController,
              obscureText: false,
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                labelText: "Email",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    passwordReset();
                  },
                  child: Text("Gönder"),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => GirisFormu(),
                        ));
                  },
                  child: Text("Giriş Sayfası"),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
