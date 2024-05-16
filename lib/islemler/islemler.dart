//  Container(
//                     margin: EdgeInsets.fromLTRB(10, 5, 10, 3),
//                     height: 90,
//                     decoration: BoxDecoration(
//                       color: Colors.blueGrey,
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                     child: Padding(
//                       padding: EdgeInsets.all(8),
//                       child: Row(
//                         children: [
//                           Flexible(
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               mainAxisAlignment: MainAxisAlignment.start,
//                               children: [
//                                 Flexible(
//                                   child: Text(
//                                     alinanVeri[index]["ad"],
//                                     style: TextStyle(
//                                         fontSize: 20,
//                                         fontWeight: FontWeight.bold),
//                                   ),
//                                 ),
//                                 SizedBox(
//                                   height: 7,
//                                 ),
//                                 Text(
//                                   DateFormat.yMd()
//                                       .add_jm()
//                                       .format(eklemeZamani)
//                                       .toString(),
//                                 ),
//                               ],
//                             ),
//                           ),
//                           Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             mainAxisAlignment: MainAxisAlignment.start,
//                             children: [
//                               Text(
//                                 alinanVeri[index]["sonTarih"],
//                                 style: TextStyle(
//                                     fontSize: 18, fontWeight: FontWeight.bold),
//                               ),
//                             ],
//                           ),
//                           IconButton(
//                             onPressed: () async {
//                               await FirebaseFirestore.instance
//                                   .collection("Gorevler")
//                                   .doc(mevcutkullaniciUidTutucu)
//                                   .collection("Gorevlerim")
//                                   .doc(
//                                     alinanVeri[index]["zaman"],
//                                   )
//                                   .delete();
//                             },
//                             icon: Icon(Icons.delete),
//                           ),
//                         ],
//                       ),
//                     ),
//                   );