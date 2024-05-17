import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class GorevEkle extends StatefulWidget {
  const GorevEkle({super.key});

  @override
  State<GorevEkle> createState() => _GorevEkleState();
}

class _GorevEkleState extends State<GorevEkle> {
  bool butonkontrol = false;
  TextEditingController adAlici = TextEditingController();
  TextEditingController tarihAlici = TextEditingController();

  void goreveklekontrol() {
    setState(() {
      butonkontrol = adAlici.text.isNotEmpty && tarihAlici.text.isNotEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Görev Ekle"),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(8),
            child: TextFormField(
              onChanged: (value) {
                goreveklekontrol();
              },
              controller: adAlici,
              decoration: InputDecoration(
                  labelText: "Görev : ", border: OutlineInputBorder()),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8),
            child: TextFormField(
              onChanged: (value) {
                goreveklekontrol();
              },
              controller: tarihAlici,
              decoration: InputDecoration(
                labelText: "Son Tarih : ",
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(8),
            height: 70,
            width: double.infinity,
            child: ElevatedButton(
                onPressed: butonkontrol
                    ? () {
                        veriEkle();
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange.shade200),
                child: Text(
                  "Görev Ekle",
                  style: TextStyle(fontSize: 20),
                )),
          )
        ],
      ),
    );
  }

  void veriEkle() async {
    FirebaseAuth yetki = FirebaseAuth.instance;
    var mevcutKullanici = await yetki.currentUser;

    String uidTutucu = mevcutKullanici!.uid;
    var zamanTutucu = DateTime.now();

    await FirebaseFirestore.instance
        .collection("Gorevler")
        .doc(uidTutucu)
        .collection("Gorevlerim")
        .doc(zamanTutucu.toString())
        .set({
      "ad": adAlici.text,
      "sonTarih": tarihAlici.text,
      "zaman": zamanTutucu.toString(),
   
      "tamZaman": zamanTutucu
    });
    Fluttertoast.showToast(msg: "Görev Başarıyla Eklendi.");
    adAlici.clear();
    tarihAlici.clear();
  }
}
