import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:listapp/islemler/shared_pref.dart';
import 'package:listapp/screens/g%C3%B6revekle.dart';
import 'package:listapp/screens/girisformu.dart';

class AnaSayfa extends StatefulWidget {
  const AnaSayfa({super.key});

  @override
  State<AnaSayfa> createState() => _AnaSayfaState();
}

class _AnaSayfaState extends State<AnaSayfa> {
  String? mevcutkullaniciUidTutucu;
  @override
  void initState() {
    super.initState();
    mevcutkullaniciUidsiAl();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      appBar: AppBar(
        backgroundColor: Colors.orange.shade200,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.elliptical(40, 40))),
        title: Text("Yapılacaklar"),
        actions: [
          IconButton(
            onPressed: () async {
              await FirebaseAuth.instance
                  .signOut()
                  .then((value) => Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => GirisFormu(),
                      ),
                      (route) => false));
            },
            icon: Icon(Icons.exit_to_app),
          ),
        ],
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("Gorevler")
              .doc(mevcutkullaniciUidTutucu)
              .collection("Gorevlerim")
              .snapshots(),
          builder: (context,
              AsyncSnapshot<QuerySnapshot> veriTabanindanGelenVeriler) {
            if (veriTabanindanGelenVeriler.connectionState ==
                ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              final alinanVeri = veriTabanindanGelenVeriler.data!.docs;
              return ListView.builder(
                itemCount: veriTabanindanGelenVeriler.data!.docs.length,
                itemBuilder: (context, index) {
                  var eklemeZamani =
                      (alinanVeri[index]["tamZaman"] as Timestamp).toDate();
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(
                      visualDensity: VisualDensity.standard,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                      contentPadding: EdgeInsets.all(5),
                      tileColor: Colors.deepPurple.shade200,
                      title: Text(
                        "Hedef : ${alinanVeri[index]["ad"]}",
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                          "Son Tarih : ${alinanVeri[index]["sonTarih"]} ",
                          style: TextStyle(
                              fontSize: 13, fontWeight: FontWeight.bold)),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: () {
                              String documentId = alinanVeri[index].id;
                              _showEditDialog(
                                  documentId,
                                  alinanVeri[index]["ad"],
                                  alinanVeri[index]["sonTarih"]);
                              // Düzenleme işlemi için kod buraya eklenecek
                            },
                            icon: Icon(Icons.edit),
                            color: Colors.green,
                          ),
                          IconButton(
                            onPressed: () {
                              String documentId = alinanVeri[index].id;
                              _showDeleteConfirmationDialog(documentId);
                              // Silme işlemi için kod buraya eklenecek
                            },
                            icon: Icon(Icons.delete),
                            color: Colors.black,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        backgroundColor: Colors.deepPurple.shade300,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => GorevEkle(),
            ),
          );
        },
      ),
    );
  }

  void mevcutkullaniciUidsiAl() async {
    FirebaseAuth yetki = FirebaseAuth.instance;
    var mevcutKullanici = await yetki.currentUser;
    setState(() {
      mevcutkullaniciUidTutucu = mevcutKullanici!.uid;
    });
  }

  void _showDeleteConfirmationDialog(String documentId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Emin misiniz?"),
          content: Text("Bu görevi silmek istediğinizden emin misiniz?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // İptal butonu
              },
              child: Text("İptal"),
            ),
            TextButton(
              onPressed: () {
                _deleteTask(documentId); // Silme işlemini gerçekleştirme
                Navigator.pop(context); // Onay butonu
              },
              child: Text("Sil"),
            ),
          ],
        );
      },
    );
  }

  void _deleteTask(String documentId) async {
    try {
      await FirebaseFirestore.instance
          .collection("Gorevler")
          .doc(mevcutkullaniciUidTutucu)
          .collection("Gorevlerim")
          .doc(documentId)
          .delete();
      Fluttertoast.showToast(msg: "Görev Başarıyla Silindi.");
    } catch (e) {
      print("Silme işlemi başarısız: $e");
      Fluttertoast.showToast(msg: "Görev Silinirken Bir Hata Oluştu.");
    }
  }

  void _showEditDialog(
      String documentId, String currentTaskName, String datetasktime) {
    TextEditingController taskNameController =
        TextEditingController(text: currentTaskName);
    TextEditingController tarihkontrol =
        TextEditingController(text: datetasktime);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Görevi Düzenle"),
          content: Column(
            children: [
              TextField(
                controller: taskNameController,
                decoration: InputDecoration(hintText: "Yeni Görev"),
              ),
              SizedBox(
                height: 15,
              ),
              TextField(
                controller: tarihkontrol,
                decoration: InputDecoration(hintText: "Yeni Tarih"),
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101),
                  );
                  if (pickedDate != null) {
                    String formattedDate =
                        DateFormat('yyyy-MM-dd').format(pickedDate);
                    setState(() {
                      tarihkontrol.text = formattedDate;
                    });
                  }
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // İptal butonu
              },
              child: Text("İptal"),
            ),
            TextButton(
              onPressed: () {
                String newTaskName = taskNameController.text.trim();
                String newdate = tarihkontrol.text.trim();
                if (newTaskName.isNotEmpty || newdate.isNotEmpty) {
                  _editTask(documentId, newTaskName,
                      newdate); // Düzenleme işlemini gerçekleştirme
                  Navigator.pop(context); // Onay butonu
                } else {
                  Fluttertoast.showToast(
                      msg: "Lütfen yeni görev adını ve/ya tarih girin.");
                }
              },
              child: Text("Kaydet"),
            ),
          ],
        );
      },
    );
  }

  void _editTask(String documentId, String newTaskName, String newdate) async {
    try {
      await FirebaseFirestore.instance
          .collection("Gorevler")
          .doc(mevcutkullaniciUidTutucu)
          .collection("Gorevlerim")
          .doc(documentId)
          .update({"ad": newTaskName, "sonTarih": newdate}); // dikkat
      Fluttertoast.showToast(msg: "Görev Başarıyla Güncellendi.");
    } catch (e) {
      print("Güncelleme işlemi başarısız: $e");
      Fluttertoast.showToast(msg: "Görev Güncellenirken Bir Hata Oluştu.");
    }
  }
}
