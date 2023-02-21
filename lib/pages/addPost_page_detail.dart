// import 'dart:io';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:pretty_qr_code/pretty_qr_code.dart';
// import 'package:readmore/readmore.dart';
// import 'package:path/path.dart' as Path;
// import 'package:ticket_widget/ticket_widget.dart';
//
// import '../main.dart';
//
// class page_detail extends StatefulWidget {
//   page_detail({
//     Key? key,
//     required var imagesList,
//     required this.locationventeSelected,
//     required this.user,
//     required this.typeSelected,
//     required this.itemController,
//     required this.priceController,
//     required this.telContactController,
//     //required this.generaleController,
//     required this.descriptionController,
//     //required this.code,
//   })  : _imagesList = imagesList,
//
//         //**************
//         super(key: key);
//
//   final List? _imagesList;
//   final User? user;
//   final bool locationventeSelected;
//   String typeSelected;
//   String itemController;
//   String priceController;
//   String telContactController;
//   // String generaleController;
//   String descriptionController;
//   // String code;
//
//   @override
//   State<page_detail> createState() => _page_detailState();
// }
//
// class _page_detailState extends State<page_detail> {
//   String _typeSelected = '';
//   bool uploading = false; //**************************************************
//   double val = 0;
//   late firebase_storage.Reference ref;
//   final user = FirebaseAuth.instance.currentUser;
//   CollectionReference imgRef =
//       FirebaseFirestore.instance.collection('Products');
//   CollectionReference userRef = FirebaseFirestore.instance.collection('Users');
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         backgroundColor: Colors.blueGrey.shade100,
//         body: CustomScrollView(
//             shrinkWrap: true,
//             scrollDirection: Axis.vertical,
//             slivers: [
//               SliverAppBar(
//                 pinned: true,
//                 floating: false,
//                 // leading: Icon(
//                 //   Icons.close,
//                 //   color: Colors.black,
//                 // ),
//                 title: Text(
//                   widget.typeSelected.isEmpty
//                       ? 'ItemTitleVide'
//                       : widget.typeSelected.toString().toUpperCase(),
//                   style: const TextStyle(
//                       fontSize: 15,
//                       color: Colors.yellowAccent,
//                       fontWeight: FontWeight.bold,
//                       fontFamily: 'oswald'),
//                 ),
//                 expandedHeight: 250,
//                 //stretch: true,
//                 flexibleSpace: FlexibleSpaceBar(
//                   stretchModes: const <StretchMode>[
//                     StretchMode.zoomBackground,
//                     StretchMode.blurBackground,
//                     StretchMode.fadeTitle,
//                   ],
//                   background: ShaderMask(
//                     shaderCallback: (rect) {
//                       return const LinearGradient(
//                         begin: Alignment.topCenter,
//                         end: Alignment.bottomCenter,
//                         colors: [Colors.transparent, Colors.black],
//                       ).createShader(
//                           Rect.fromLTRB(0, 0, rect.width, rect.height));
//                     },
//                     blendMode: BlendMode.darken,
//                     child: Image.file(
//                       File(widget._imagesList!.first.path),
//                       fit: BoxFit.cover,
//                     ),
//                   ),
//                   centerTitle: true,
//                   title: Padding(
//                     padding:
//                         const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
//                     child: Text(
//                       widget.itemController.isEmpty
//                           ? 'Item Vide'
//                           : widget.itemController.toString().toUpperCase(),
//                       overflow: TextOverflow.ellipsis,
//                       style: const TextStyle(
//                           fontSize: 15,
//                           color: Colors.white70,
//                           fontWeight: FontWeight.bold,
//                           fontFamily: 'oswald'),
//                     ),
//                   ),
//                 ),
//               ),
//               SliverToBoxAdapter(
//                 child: Visibility(
//                   visible: widget._imagesList!.length <= 1 ? false : true,
//                   child: Container(
//                     padding: const EdgeInsets.only(top: 5),
//                     height: 100,
//                     width: MediaQuery.of(context).size.width,
//                     child: Center(
//                       child: ListView.builder(
//                         itemCount: widget._imagesList!.length - 1,
//                         scrollDirection: Axis.horizontal,
//                         shrinkWrap: true,
//                         itemBuilder: (BuildContext context, int i) {
//                           return Card(
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(6),
//                             ),
//                             clipBehavior: Clip.hardEdge,
//                             elevation: 3,
//                             child: ShaderMask(
//                               shaderCallback: (rect) {
//                                 return const
//                                     //   const LinearGradient(
//                                     //   begin: Alignment.topCenter,
//                                     //   end: Alignment.bottomCenter,
//                                     //   colors: [Colors.transparent, Colors.black],
//                                     // )
//                                     RadialGradient(
//                                   colors: [Colors.transparent, Colors.black45],
//                                   tileMode: TileMode.clamp,
//                                   focalRadius: 1,
//                                   radius: 1,
//                                   stops: [0.1, 1],
//                                   center: Alignment.center,
//                                 ).createShader(Rect.fromLTRB(
//                                         0, 0, rect.width, rect.height));
//                               },
//                               blendMode: BlendMode.darken,
//                               child: Image.file(
//                                 File(
//                                   widget._imagesList![i + 1].path,
//                                 ),
//                                 fit: BoxFit.cover,
//                               ),
//                             ),
//                           );
//                         },
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//               SliverToBoxAdapter(
//                 child: Padding(
//                   padding:
//                       const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
//                   child: TicketWidget(
//                       color: Colors.white,
//                       width: 350,
//                       height: 500,
//                       isCornerRounded: true,
//                       padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
//                       child: TicketData(
//                           // code: widget.code,
//                           imagesList: widget._imagesList,
//                           locationventeSelected: widget.locationventeSelected,
//                           user: widget.user,
//                           typeSelected: widget.typeSelected,
//                           itemController: widget.itemController,
//                           priceController: widget.priceController,
//                           telContactController: widget.telContactController,
//                           //generaleController: widget.generaleController,
//                           descriptionController: widget.descriptionController)),
//                 ),
//               ),
//               SliverToBoxAdapter(
//                 child: Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 20),
//                   child: ReadMoreText(
//                     widget.descriptionController.toUpperCase(),
//                     trimLines: 3,
//                     colorClickableText: Colors.pink,
//                     trimMode: TrimMode.Line,
//                     textAlign: TextAlign.justify,
//                     trimCollapsedText: 'Plus',
//                     trimExpandedText: '  Moins',
//                     moreStyle: const TextStyle(
//                         fontSize: 14, fontFamily: 'oswald', color: Colors.blue),
//                     lessStyle: const TextStyle(
//                         fontSize: 14, fontFamily: 'oswald', color: Colors.red),
//                     style: const TextStyle(
//                         fontSize: 14,
//                         fontFamily: 'oswald',
//                         color: Colors.black87),
//                   ),
//                 ),
//               ),
//               // SliverToBoxAdapter(
//               //   child: Padding(
//               //     padding: const EdgeInsets.only(top: 12.0, right: 20.0),
//               //     child: Row(
//               //       children: [
//               //         Text(widget.position!.longitude.toString(),
//               //           style: TextStyle(fontFamily: 'oswald'),),
//               //         Text(widget.position!.latitude.toString(),
//               //           style: TextStyle(fontFamily: 'oswald'),),
//               //       ],
//               //     ),
//               //
//               //   ),
//               // ),
//               SliverToBoxAdapter(
//                 child: ElevatedButton(
//                   style: ButtonStyle(
//                     backgroundColor: MaterialStateProperty.all(Colors.green),
//                     foregroundColor: MaterialStateProperty.all(Colors.white),
//                     //minimumSize: MaterialStateProperty.all(const Size(200, 40)),
//                   ),
//                   onPressed: () async {
//                     // setState(() {
//                     //   //uploading = true;
//                     //   //const hotel_rent();
//                     //   const main_in();
//                     // });
//                     if (uploading) return;
//                     setState(() => uploading = true);
//                     // await Future.delayed(Duration(seconds: 5));
//                     // setState(() => uploading = false);
//
//                     uploadFile().whenComplete(() =>
//                         Navigator.push(context, MaterialPageRoute(builder: (_) {
//                           return verifi_auth();
//                         })));
//                   },
//                   child: uploading == false
//                       ? const Text('Publier')
//                       : Center(
//                           child: CircularProgressIndicator(),
//                           /*child: Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             crossAxisAlignment: CrossAxisAlignment.center,
//                             children: [
//                               CircularProgressIndicator(),
//                               SizedBox(
//                                 width: 24,
//                               ),
//                               Text('Sending...')
//                             ],
//                           ),*/
//                         ),
//                 ),
//               )
//             ]));
//   }
//
//   Future uploadFile() async {
//     int i = 1;
//
//     //String code = widget.code;
//     String typeSelected = widget.typeSelected;
//     bool locationvente = widget.locationventeSelected;
//     String userID = widget.user!.uid;
//     String item = widget.itemController;
//     int price = int.parse(widget.priceController);
//     String telContact = widget.telContactController;
//     String description = widget.descriptionController;
//     int likes = int.parse(widget.priceController);
//     String? userEmail = widget.user?.email;
//     String? userAvatar = widget.user?.photoURL;
//     String? userDisplayName = widget.user!.displayName;
//     List usersLike = ['sans'];
//     int userAge = 20;
//     int userItemsNbr = 0;
//     int userPhone = 0687451524;
//     String userSex = 'mal';
//     bool userState = true;
//
//     var now = DateTime.now().millisecondsSinceEpoch;
//     List<String> imageFiles = []; //****************
//
//     var _image = widget._imagesList!;
//     for (var img in _image) {
//       setState(() {
//         val = i / _image.length;
//       });
//       ref = firebase_storage.FirebaseStorage.instance
//           .ref()
//           .child('images/${Path.basename(img.path)}');
//
//       await ref.putFile(img).whenComplete(() async {
//         //*****************************************
//         await ref.getDownloadURL().then((value) {
//           imageFiles.add(value);
//           i++;
//         });
//       });
//     }
//
//     imgRef.add({
//       //   'code': code,
//       'type': locationvente,
//       'userID': userID,
//       'themb': imageFiles.first,
//       'imageUrls': imageFiles,
//       "item": item,
//       'price': price, // + '.00 dzd ',
//       'category': typeSelected,
//       'createdAt': Timestamp.now(), //now.toString(),
//       'Description': description,
//       'likes': likes,
//       'usersLike': usersLike,
//       'dateDebut': DateTime.now().add(const Duration(days: 3)),
//       'dateFin': DateTime.now().add(const Duration(days: 11)),
//     });
//     // userRef.doc(user!.uid).set({
//     //   'userID': userID,
//     //   'userEmail': userEmail,
//     //  // 'userAvatar': userAvatar,
//     //   'UcreatedAt': Timestamp.now(), //now.toString(),
//     //   'userDisplayName': userDisplayName,
//     //   'userAge': userAge,
//     //   'userItemsNbr': FieldValue.increment(1),
//     //   'userPhone': userPhone,
//     //   'userSex': userSex,
//     //   'userState': userState,
//     // }, SetOptions(merge: true));
//   }
// }
//
// //
// // class Verification_Page extends StatefulWidget {
// //   Verification_Page({
// //     Key? key,
// //     required var imagesList,
// //     required this.locationventeSelected,
// //     required this.user,
// //     required this.typeSelected,
// //     required this.itemController,
// //     required this.priceController,
// //     required this.telContactController,
// //     required this.generaleController,
// //     required this.descriptionController,
// //   })  : _imagesList = imagesList,
// //
// //   //**************
// //         super(key: key);
// //
// //   final List? _imagesList;
// //   final User? user;
// //   String locationventeSelected;
// //   String typeSelected;
// //   String itemController;
// //   String priceController;
// //   String telContactController;
// //   String generaleController;
// //   String descriptionController;
// //
// //   @override
// //   State<Verification_Page> createState() => _Verification_PageState();
// // }
// //
// // class _Verification_PageState extends State<Verification_Page> {
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       backgroundColor: Colors.blueGrey,
// //       appBar: AppBar(
// //         title: Text(
// //           'Aperçu Avant Poster'.toUpperCase(),
// //           style: const TextStyle(
// //               fontSize: 20, fontFamily: 'oswald', color: Colors.black87),
// //         ),
// //       ),
// //       body: Column(
// //         children: <Widget>[
// //           Padding(
// //             padding: const EdgeInsets.only(top: 8),
// //             child: Text(
// //               'Vérifier votre annonce avant validation'.toUpperCase(),
// //               style: const TextStyle(
// //                   fontSize: 16, fontFamily: 'oswald', color: Colors.black87),
// //               textAlign: TextAlign.justify,
// //             ),
// //           ),
// //           Expanded(
// //             flex: 1,
// //             child: Center(
// //               child: ListView.builder(
// //                 itemCount: widget._imagesList!.length,
// //                 scrollDirection: Axis.horizontal,
// //                 shrinkWrap: true,
// //                 itemBuilder: (BuildContext context, int i) {
// //                   return Container(
// //                     padding: const EdgeInsets.all(8),
// //                     width: 85,
// //                     child: Image.file(
// //                       File(
// //                         widget._imagesList![i].path,
// //                       ),
// //                       fit: BoxFit.cover,
// //                     ),
// //                   );
// //                 },
// //               ),
// //             ),
// //           ),
// //           Padding(
// //             padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 15),
// //             child: TicketWidget(
// //                 color: Colors.white,
// //                 width: 350,
// //                 height: 500,
// //                 isCornerRounded: true,
// //                 padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
// //                 child: TicketData(
// //                   imagesList: widget._imagesList,
// //                   locationventeSelected: widget.locationventeSelected,
// //                   user: widget.user,
// //                   typeSelected: widget.typeSelected,
// //                   itemController: widget.itemController,
// //                   priceController: widget.priceController,
// //                   telContactController: widget.telContactController,
// //                   generaleController: widget.generaleController,
// //                   descriptionController: widget.descriptionController,
// //                   position: widget.position,
// //                 )),
// //           ),
// //           // Expanded(
// //           //    child: ListView(
// //           //       shrinkWrap: true,
// //           //       children: [
// //           //         Padding(
// //           //           padding: const EdgeInsets.only(left: 20),
// //           //           child: Text(
// //           //             widget.locationventeSelected.toString().toUpperCase(),
// //           //             style: TextStyle(
// //           //                 fontSize: 14,
// //           //                 fontFamily: 'oswald',
// //           //                 color: Colors.black87),
// //           //             overflow: TextOverflow.ellipsis,
// //           //           ),
// //           //         ),
// //           //         Padding(
// //           //           padding: const EdgeInsets.only(left: 20),
// //           //           child: Text(
// //           //             'je suis une ' +
// //           //                 widget.typeSelected.toString().toUpperCase(),
// //           //             style: TextStyle(
// //           //                 fontSize: 14,
// //           //                 fontFamily: 'oswald',
// //           //                 color: Colors.black87),
// //           //             overflow: TextOverflow.ellipsis,
// //           //           ),
// //           //         ),
// //           //         Padding(
// //           //           padding: const EdgeInsets.only(left: 20),
// //           //           child: Text(
// //           //             widget.itemController.toUpperCase(),
// //           //             style: TextStyle(
// //           //                 fontSize: 14,
// //           //                 fontFamily: 'oswald',
// //           //                 color: Colors.black87),
// //           //             overflow: TextOverflow.ellipsis,
// //           //           ),
// //           //         ),
// //           //         Padding(
// //           //           padding: const EdgeInsets.only(left: 20),
// //           //           child: Text(
// //           //             widget.priceController + '.00 DZD'.toUpperCase(),
// //           //             style: TextStyle(
// //           //                 fontSize: 14,
// //           //                 fontFamily: 'oswald',
// //           //                 color: Colors.black87),
// //           //             overflow: TextOverflow.ellipsis,
// //           //           ),
// //           //         ),
// //           //         Padding(
// //           //           padding: const EdgeInsets.only(left: 20),
// //           //           child: Text(
// //           //             widget.telContactController.toUpperCase(),
// //           //             style: TextStyle(
// //           //                 fontSize: 14,
// //           //                 fontFamily: 'oswald',
// //           //                 color: Colors.black87),
// //           //             overflow: TextOverflow.ellipsis,
// //           //           ),
// //           //         ),
// //           //         Padding(
// //           //           padding: const EdgeInsets.only(left: 20),
// //           //           child: Text(
// //           //             widget.generaleController.toUpperCase(),
// //           //             style: TextStyle(
// //           //                 fontSize: 14,
// //           //                 fontFamily: 'oswald',
// //           //                 color: Colors.black87),
// //           //             overflow: TextOverflow.ellipsis,
// //           //           ),
// //           //         ),
// //           //         Padding(
// //           //           padding: const EdgeInsets.all(20.0),
// //           //           child: ReadMoreText(
// //           //             widget.descriptionController.toUpperCase(),
// //           //             trimLines: 3,
// //           //             colorClickableText: Colors.pink,
// //           //             trimMode: TrimMode.Line,
// //           //             textAlign: TextAlign.justify,
// //           //             trimCollapsedText: 'Plus',
// //           //             trimExpandedText: '  Moins',
// //           //             moreStyle: TextStyle(
// //           //                 fontSize: 14, fontFamily: 'oswald', color: Colors.blue),
// //           //             lessStyle: TextStyle(
// //           //                 fontSize: 14, fontFamily: 'oswald', color: Colors.red),
// //           //             style: TextStyle(
// //           //                 fontSize: 14,
// //           //                 fontFamily: 'oswald',
// //           //                 color: Colors.black87),
// //           //           ),
// //           //
// //           //           // Text(
// //           //           //     widget.descriptionController.toUpperCase(),
// //           //           //     style: TextStyle(
// //           //           //         fontSize: 14, fontFamily: 'oswald', color: Colors.black87),
// //           //           //     overflow: TextOverflow.ellipsis,
// //           //           //     textAlign: TextAlign.justify,
// //           //           //   ),
// //           //         ),
// //           //       ],
// //           //     ),
// //           //  ),
// //
// //           // Expanded(
// //           //   flex: 1,
// //           //   child: Padding(
// //           //     padding: const EdgeInsets.fromLTRB(30, 10, 30, 10),
// //           //     child: ElevatedButton(
// //           //         style: ButtonStyle(
// //           //           backgroundColor: MaterialStateProperty.all(Colors.green),
// //           //           foregroundColor: MaterialStateProperty.all(Colors.white),
// //           //           minimumSize: MaterialStateProperty.all(const Size(200, 40)),
// //           //         ),
// //           //         onPressed: () {
// //           //           setState(() {
// //           //             //uploading = true;
// //           //             //const hotel_rent();
// //           //             const main_in();
// //           //           });
// //           //           // uploadFile().whenComplete(() =>
// //           //           //     Navigator.push(context, MaterialPageRoute(builder: (_) {
// //           //           //       return main_in();
// //           //           //     })));
// //           //         },
// //           //         child: const Text('Publier')),
// //           //   ),
// //           // ),
// //         ],
// //       ),
// //     );
// //   }
// // }
//
// class TicketData extends StatelessWidget {
//   TicketData({
//     Key? key,
//     required var imagesList,
//     required this.locationventeSelected,
//     required this.user,
//     required this.typeSelected,
//     required this.itemController,
//     required this.priceController,
//     required this.telContactController,
//     // required this.generaleController,
//     required this.descriptionController,
//     // required code,
//   })  : _imagesList = imagesList,
//
//         //**************
//         super(key: key);
//
//   final List? _imagesList;
//   final User? user;
//   final bool locationventeSelected;
//   String typeSelected;
//   String itemController;
//   String priceController;
//   String telContactController;
//   //String generaleController;
//   String descriptionController;
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Container(
//               width: 120.0,
//               height: 25.0,
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(30.0),
//                 border: Border.all(width: 1.0, color: Colors.green),
//               ),
//               child: const Center(
//                 child: Text(
//                   'Business Class',
//                   style: TextStyle(color: Colors.green, fontFamily: 'oswald'),
//                 ),
//               ),
//             ),
//             Row(
//               children: const [
//                 Text(
//                   'LHR',
//                   style: TextStyle(
//                       color: Colors.black,
//                       fontWeight: FontWeight.bold,
//                       fontFamily: 'oswald'),
//                 ),
//                 Padding(
//                   padding: EdgeInsets.only(left: 8.0),
//                   child: Icon(
//                     Icons.flight_takeoff,
//                     color: Colors.pink,
//                   ),
//                 ),
//                 Padding(
//                   padding: EdgeInsets.only(left: 8.0),
//                   child: Text(
//                     'ISL',
//                     style: TextStyle(
//                         color: Colors.black,
//                         fontWeight: FontWeight.bold,
//                         fontFamily: 'oswald'),
//                   ),
//                 )
//               ],
//             )
//           ],
//         ),
//         Padding(
//           padding: const EdgeInsets.only(top: 15),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             crossAxisAlignment: CrossAxisAlignment.end,
//             children: [
//               const Expanded(
//                 child: Text(
//                   'Flight Ticket',
//                   style: TextStyle(
//                       color: Colors.black,
//                       fontSize: 22.0,
//                       fontWeight: FontWeight.bold,
//                       fontFamily: 'oswald'),
//                 ),
//               ),
//               Expanded(
//                 child: Text(
//                   '$priceController.00 DZD',
//                   style: const TextStyle(
//                       fontFamily: 'oswald',
//                       fontWeight: FontWeight.bold,
//                       fontSize: 18,
//                       color: Colors.green),
//                   overflow: TextOverflow.ellipsis,
//                   textAlign: TextAlign.end,
//                 ),
//               ),
//             ],
//           ),
//         ),
//         Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Padding(
//               padding: const EdgeInsets.only(top: 12.0, right: 20.0),
//               child: ticketDetailsWidget(
//                   'Passengers',
//                   itemController.toString().toUpperCase(),
//                   'Date',
//                   '28-08-2022'),
//             ),
//             Padding(
//               padding: const EdgeInsets.only(top: 12.0, right: 20.0),
//               child: ticketDetailsWidget('Flight', '76836A45', 'Gate', '66B'),
//             ),
//             Padding(
//               padding: const EdgeInsets.only(top: 12.0, right: 20.0),
//               child: ticketDetailsWidget(
//                   'Class', typeSelected.toString(), 'Seat', '21B'),
//             ),
//           ],
//         ),
//         Padding(
//           padding: const EdgeInsets.only(
//               top: 10.0, left: 30.0, right: 30.0, bottom: 10),
//           child: Center(
//             child: PrettyQr(
//               data: 'guedouar sidi mohammed ramzi',
//               size: 150,
//             ),
//           ),
//         ),
//         Center(
//           child: Text(
//             '+213 ${telContactController.toUpperCase()}',
//             style: const TextStyle(color: Colors.black, fontFamily: 'oswald'),
//           ),
//         ),
//         const SizedBox(height: 5),
//         const Center(
//             child: Text(
//           'Developer: instagram.com/DholaSain',
//           style: TextStyle(fontFamily: 'oswald'),
//         )),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             SizedBox(
//               width: 5,
//             ),
//           ],
//         ),
//       ],
//     );
//   }
// }
//
// Widget ticketDetailsWidget(String firstTitle, String firstDesc,
//     String secondTitle, String secondDesc) {
//   return Row(
//     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//     children: [
//       Expanded(
//         child: Padding(
//           padding: const EdgeInsets.only(left: 20.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: <Widget>[
//               Text(
//                 firstTitle,
//                 style:
//                     const TextStyle(color: Colors.grey, fontFamily: 'oswald'),
//               ),
//               Padding(
//                 padding: const EdgeInsets.only(top: 4.0),
//                 child: Text(
//                   firstDesc,
//                   overflow: TextOverflow.ellipsis,
//                   style: const TextStyle(
//                       color: Colors.green, fontFamily: 'oswald'),
//                 ),
//               )
//             ],
//           ),
//         ),
//       ),
//       Padding(
//         padding: const EdgeInsets.only(left: 20.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.end,
//           children: [
//             Text(
//               secondTitle,
//               style: const TextStyle(color: Colors.grey, fontFamily: 'oswald'),
//             ),
//             Padding(
//               padding: const EdgeInsets.only(top: 4.0),
//               child: Text(
//                 secondDesc,
//                 style:
//                     const TextStyle(color: Colors.black, fontFamily: 'oswald'),
//               ),
//             )
//           ],
//         ),
//       )
//     ],
//   );
// }

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:readmore/readmore.dart';
import 'package:path/path.dart' as Path;
import 'package:ticket_widget/ticket_widget.dart';

import '../main.dart';

class page_detail extends StatefulWidget {
  page_detail({
    Key? key,
    required var imagesList,
    required this.locationventeSelected,
    required this.user,
    required this.typeSelected,
    required this.itemController,
    required this.priceController,
    required this.telContactController,
    required this.descriptionController,
  })  : _imagesList = imagesList,

        //**************
        super(key: key);

  final List? _imagesList;
  final User? user;
  String locationventeSelected;
  String typeSelected;
  String itemController;
  String priceController;
  String telContactController;
  String descriptionController;

  @override
  State<page_detail> createState() => _page_detailState();
}

class _page_detailState extends State<page_detail> {
  String _typeSelected = '';
  bool uploading = false; //**************************************************
  double val = 0;
  late firebase_storage.Reference ref;
  final user = FirebaseAuth.instance.currentUser;
  CollectionReference imgRef =
      FirebaseFirestore.instance.collection('Products');
  CollectionReference userRef = FirebaseFirestore.instance.collection('Users');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.blueGrey.shade100,
        body: CustomScrollView(
            shrinkWrap: false,
            scrollDirection: Axis.vertical,
            slivers: [
              SliverAppBar(
                pinned: true,
                floating: false,
                // leading: Icon(
                //   Icons.close,
                //   color: Colors.black,
                // ),
                title: Text(
                  widget.typeSelected.isEmpty
                      ? 'ItemTitleVide'
                      : widget.typeSelected.toString().toUpperCase(),
                  style: const TextStyle(
                      fontSize: 15,
                      color: Colors.yellowAccent,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'oswald'),
                ),
                expandedHeight: 250,
                //stretch: true,
                flexibleSpace: FlexibleSpaceBar(
                  stretchModes: const <StretchMode>[
                    StretchMode.zoomBackground,
                    StretchMode.blurBackground,
                    StretchMode.fadeTitle,
                  ],
                  background: ShaderMask(
                    shaderCallback: (rect) {
                      return const LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.transparent, Colors.black],
                      ).createShader(
                          Rect.fromLTRB(0, 0, rect.width, rect.height));
                    },
                    blendMode: BlendMode.darken,
                    child: Image.file(
                      File(widget._imagesList!.first.path),
                      fit: BoxFit.cover,
                    ),
                  ),
                  centerTitle: true,
                  title: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                    child: Text(
                      widget.itemController.isEmpty
                          ? 'Item Vide'
                          : widget.itemController.toString().toUpperCase(),
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontSize: 15,
                          color: Colors.white70,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'oswald'),
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Visibility(
                  visible: widget._imagesList!.length <= 1 ? false : true,
                  child: Container(
                    padding: const EdgeInsets.only(top: 5),
                    height: 100,
                    width: MediaQuery.of(context).size.width,
                    child: Center(
                      child: ListView.builder(
                        itemCount: widget._imagesList!.length - 1,
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        itemBuilder: (BuildContext context, int i) {
                          return Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                            clipBehavior: Clip.hardEdge,
                            elevation: 3,
                            child: ShaderMask(
                              shaderCallback: (rect) {
                                return const
                                    //   const LinearGradient(
                                    //   begin: Alignment.topCenter,
                                    //   end: Alignment.bottomCenter,
                                    //   colors: [Colors.transparent, Colors.black],
                                    // )
                                    RadialGradient(
                                  colors: [Colors.transparent, Colors.black45],
                                  tileMode: TileMode.clamp,
                                  focalRadius: 1,
                                  radius: 1,
                                  stops: [0.1, 1],
                                  center: Alignment.center,
                                ).createShader(Rect.fromLTRB(
                                        0, 0, rect.width, rect.height));
                              },
                              blendMode: BlendMode.darken,
                              child: Image.file(
                                File(
                                  widget._imagesList![i + 1].path,
                                ),
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                  child: TicketWidget(
                      color: Colors.white,
                      width: 350,
                      height: 500,
                      isCornerRounded: true,
                      padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                      child: TicketData(
                          locationventeSelected: widget.locationventeSelected,
                          user: widget.user,
                          typeSelected: widget.typeSelected,
                          itemController: widget.itemController,
                          priceController: widget.priceController,
                          telContactController: widget.telContactController,
                          descriptionController: widget.descriptionController)),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: ReadMoreText(
                    widget.descriptionController.toUpperCase(),
                    trimLines: 3,
                    colorClickableText: Colors.pink,
                    trimMode: TrimMode.Line,
                    textAlign: TextAlign.justify,
                    trimCollapsedText: 'Plus',
                    trimExpandedText: '  Moins',
                    moreStyle: const TextStyle(
                        fontSize: 14, fontFamily: 'oswald', color: Colors.blue),
                    lessStyle: const TextStyle(
                        fontSize: 14, fontFamily: 'oswald', color: Colors.red),
                    style: const TextStyle(
                        fontSize: 14,
                        fontFamily: 'oswald',
                        color: Colors.black87),
                  ),
                ),
              ),
              // SliverToBoxAdapter(
              //   child: Padding(
              //     padding: const EdgeInsets.only(top: 12.0, right: 20.0),
              //     child: Row(
              //       children: [
              //         Text(widget.position!.longitude.toString(),
              //           style: TextStyle(fontFamily: 'oswald'),),
              //         Text(widget.position!.latitude.toString(),
              //           style: TextStyle(fontFamily: 'oswald'),),
              //       ],
              //     ),
              //
              //   ),
              // ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(60, 20, 60, 60),
                  child: uploading == false
                      ? ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.green),
                            foregroundColor:
                                MaterialStateProperty.all(Colors.white),
                            minimumSize:
                                MaterialStateProperty.all(const Size(200, 40)),
                          ),
                          onPressed: () async {
                            // setState(() {
                            //   //uploading = true;
                            //   //const hotel_rent();
                            //   const main_in();
                            // });
                            if (uploading) return;
                            setState(() => uploading = true);
                            // await Future.delayed(Duration(seconds: 5));
                            // setState(() => uploading = false);

                            uploadFile().whenComplete(() => Navigator.push(
                                    context, MaterialPageRoute(builder: (_) {
                                  return verifi_auth();
                                })));
                          },
                          child: uploading == false
                              ? const Text('Publier')
                              : Center(
                                  child: CircularProgressIndicator(),
                                  /*child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                CircularProgressIndicator(),
                                SizedBox(
                                  width: 24,
                                ),
                                Text('Sending...')
                              ],
                            ),*/
                                ),
                        )
                      : ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.transparent),
                            foregroundColor:
                                MaterialStateProperty.all(Colors.white),
                            minimumSize:
                                MaterialStateProperty.all(const Size(40, 40)),
                          ),
                          onPressed: () async {},
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),
                ),
              ),
            ]));
  }

  Future uploadFile() async {
    int i = 1;
    String typeSelected = widget.typeSelected;
    String locationvente = widget.locationventeSelected;
    String userID = widget.user!.uid;
    String item = widget.itemController;
    int price = int.parse(widget.priceController);
    String telContact = widget.telContactController;
    String description = widget.descriptionController;
    int likes = int.parse(widget.priceController);
    String? userEmail = widget.user?.email;
    String? userAvatar = widget.user?.photoURL;
    String? userDisplayName = widget.user!.displayName;
    List usersLike = ['sans'];
    int userAge = 20;
    int userItemsNbr = 0;
    int userPhone = 0687451524;
    String userSex = 'mal';
    bool userState = true;
    //Position? position = widget.position;
    // GeoPoint? GeoPosition =
    //GeoPoint(widget.position!.latitude, widget.position!.longitude);

    var now = DateTime.now().millisecondsSinceEpoch;
    List<String> imageFiles = []; //****************

    var _image = widget._imagesList!;
    for (var img in _image) {
      setState(() {
        val = i / _image.length;
      });
      ref = firebase_storage.FirebaseStorage.instance
          .ref()
          .child('images/${Path.basename(img.path)}');

      await ref.putFile(img).whenComplete(() async {
        //*****************************************
        await ref.getDownloadURL().then((value) {
          imageFiles.add(value);
          i++;
        });
      });
    }

    imgRef.add({
      'type': locationvente,
      'userID': userID,
      'themb': imageFiles.first,
      'imageUrls': imageFiles,
      "item": item,
      'price': price, // + '.00 dzd ',
      'category': typeSelected,
      'createdAt': Timestamp.now(), //now.toString(),
      'Description': description,
      'likes': likes,
      'usersLike': usersLike,
      'dateDebut': DateTime.now().add(const Duration(days: 3)),
      'dateFin': DateTime.now().add(const Duration(days: 11)),
      'levelItem': '',
    });
    // userRef.doc(user!.uid).set({
    //   'userID': userID,
    //   'userEmail': userEmail,
    //  // 'userAvatar': userAvatar,
    //   'UcreatedAt': Timestamp.now(), //now.toString(),
    //   'userDisplayName': userDisplayName,
    //   'userAge': userAge,
    //   'userItemsNbr': FieldValue.increment(1),
    //   'userPhone': userPhone,
    //   'userSex': userSex,
    //   'userState': userState,
    // }, SetOptions(merge: true));
  }
}

class TicketData extends StatelessWidget {
  TicketData({
    Key? key,
    required this.locationventeSelected,
    required this.user,
    required this.typeSelected,
    required this.itemController,
    required this.priceController,
    required this.telContactController,
    required this.descriptionController,
  }) :

        //**************
        super(key: key);

  final User? user;
  String locationventeSelected;
  String typeSelected;
  String itemController;
  String priceController;
  String telContactController;
  String descriptionController;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: 120.0,
              height: 25.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30.0),
                border: Border.all(width: 1.0, color: Colors.green),
              ),
              child: const Center(
                child: Text(
                  'Business Class',
                  style: TextStyle(color: Colors.green, fontFamily: 'oswald'),
                ),
              ),
            ),
            Row(
              children: const [
                Text(
                  'LHR',
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'oswald'),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 8.0),
                  child: Icon(
                    Icons.flight_takeoff,
                    color: Colors.pink,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 8.0),
                  child: Text(
                    'ISL',
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'oswald'),
                  ),
                )
              ],
            )
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(top: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Expanded(
                child: Text(
                  'Flight Ticket',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 22.0,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'oswald'),
                ),
              ),
              Expanded(
                child: Text(
                  '$priceController.00 DZD',
                  style: const TextStyle(
                      fontFamily: 'oswald',
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.green),
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.end,
                ),
              ),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 12.0, right: 20.0),
              child: ticketDetailsWidget(
                  'Passengers',
                  itemController.toString().toUpperCase(),
                  'Date',
                  '28-08-2022'),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 12.0, right: 20.0),
              child: ticketDetailsWidget('Flight', '76836A45', 'Gate', '66B'),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 12.0, right: 20.0),
              child: ticketDetailsWidget(
                  'Class', typeSelected.toString(), 'Seat', '21B'),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(
              top: 10.0, left: 30.0, right: 30.0, bottom: 10),
          child: Center(
            child: PrettyQr(
              data: 'guedouar sidi mohammed ramzi',
              size: 150,
            ),
          ),
        ),
        Center(
          child: Text(
            '+213 ${telContactController.toUpperCase()}',
            style: const TextStyle(color: Colors.black, fontFamily: 'oswald'),
          ),
        ),
        const SizedBox(height: 5),
        const Center(
            child: Text(
          'Developer: instagram.com/DholaSain',
          style: TextStyle(fontFamily: 'oswald'),
        )),
      ],
    );
  }
}

Widget ticketDetailsWidget(String firstTitle, String firstDesc,
    String secondTitle, String secondDesc) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Expanded(
        child: Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                firstTitle,
                style:
                    const TextStyle(color: Colors.grey, fontFamily: 'oswald'),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Text(
                  firstDesc,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      color: Colors.green, fontFamily: 'oswald'),
                ),
              )
            ],
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(left: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              secondTitle,
              style: const TextStyle(color: Colors.grey, fontFamily: 'oswald'),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Text(
                secondDesc,
                style:
                    const TextStyle(color: Colors.black, fontFamily: 'oswald'),
              ),
            )
          ],
        ),
      )
    ],
  );
}
