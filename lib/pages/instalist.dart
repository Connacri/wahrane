// import 'dart:convert';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:geocoding/geocoding.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:intl/intl.dart' as intl;
// import 'package:marquee/marquee.dart';
// import 'package:flutterflow_paginate_firestore/widgets/bottom_loader.dart';
//
// import 'package:flutterflow_paginate_firestore/paginate_firestore.dart';
// import 'package:timeago/timeago.dart' as timeago;
// import 'package:http/http.dart' as http;
// import 'package:wahrane/pages/views_classes.dart';
//
// import 'ProfileOthers.dart';
// import 'item_details-statefull.dart';
//
// class instalist extends StatefulWidget {
//   const instalist({Key? key}) : super(key: key);
//
//   @override
//   State<instalist> createState() => _instalistState();
// }
//
// class _instalistState extends State<instalist> {
//   late int? direction = meteoList.first['wind']['deg'];
//
//   @override
//   void initState() {
//     super.initState();
//     _determinePosition();
//     Geolocator.getCurrentPosition();
//     placemarks;
//     _getMeteo();
//   }
//
//   final userm = FirebaseAuth.instance.currentUser;
//   final bool _enabled = true;
//
//   final Future<QuerySnapshot> _TopAgenceFuture = FirebaseFirestore.instance
//       .collection('Products')
//       .where('category', isEqualTo: 'Agence')
//       .limit(3)
//       .get();
//
//   final Future<QuerySnapshot> _TopHotelFuture = FirebaseFirestore.instance
//       .collection('Products')
//       .where('category', isEqualTo: 'Hotel')
//       //.limit(3)
//       .get();
//
//   final Future<QuerySnapshot> _TopResidenceFuture = FirebaseFirestore.instance
//       .collection('Products')
//       .where('category', isEqualTo: 'Residence')
//       .limit(3)
//       .get();
//
//   final Future<QuerySnapshot> _TopSponsorFuture = FirebaseFirestore.instance
//       .collection('Products')
//       .where('category', isEqualTo: 'Autres')
//       .limit(3)
//       .get();
//
//   final PageStorageBucket _bucket = PageStorageBucket();
//
//   Position? position;
//   Position? _position;
//   Position? position2;
//   List<Placemark> placemarks = [];
//   String? _isoCountryCode;
//   String? _country;
//   String? _administrativeArea;
//   String? _locality;
//   String? _street;
//   String? _subLocality;
//
//   Future<Position?> _determinePosition() async {
//     bool serviceEnabled;
//     LocationPermission permission;
//
//     // Test if location services are enabled.
//     serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     if (!serviceEnabled) {
//       // Location services are not enabled don't continue
//       // accessing the position and request users of the
//       // App to enable the location services.
//       return Future.error('Location services are disabled.');
//     }
//
//     permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//       if (permission == LocationPermission.denied) {
//         // Permissions are denied, next time you could try
//         // requesting permissions again (this is also where
//         // Android's shouldShowRequestPermissionRationale
//         // returned true. According to Android guidelines
//         // your App should show an explanatory UI now.
//         return Future.error('Location permissions are denied');
//       }
//     }
//
//     if (permission == LocationPermission.deniedForever) {
//       // Permissions are denied forever, handle appropriately.
//       return Future.error(
//           'Location permissions are permanently denied, we cannot request permissions.');
//     }
//
//     // When we reach here, permissions are granted and we can
//     // continue accessing the position of the device.
//     //return await Geolocator.getCurrentPosition();
//     Position position = await Geolocator.getCurrentPosition(
//             desiredAccuracy: LocationAccuracy.high) //;
//         .then((value) => value);
//     setState(() {
//       _position = position;
//     });
//
//     List<Placemark> placemarks =
//         await placemarkFromCoordinates(position.latitude, position.longitude);
//     //_position!.latitude, _position!.longitude);
//
//     if (mounted) {
//       setState(() {
//         _position = position;
//         _isoCountryCode = placemarks.first.isoCountryCode ?? '';
//
//         _country =
//             placemarks.first.country == null ? '' : placemarks.first.country!;
//
//         _administrativeArea = placemarks.first.administrativeArea == null
//             ? ''
//             : placemarks.first.administrativeArea!;
//         _locality =
//             placemarks.first.locality == null ? '' : placemarks.first.locality!;
//         _street =
//             placemarks.first.street == null ? '' : placemarks.first.street!;
//         _subLocality = placemarks.first.subLocality == null
//             ? ''
//             : placemarks.first.street!;
//       });
//     }
//     print('latitude');
//     print(position.latitude);
//     print('longitude');
//     print(position.longitude);
//
//     print(placemarks[0].locality); //Ain El Turk
//     print(placemarks.length);
//     return null;
//   }
//
//   List meteoList = [];
//
//   Future _getMeteo() async {
//     // var urlMeteo =
//     //     //'https://api.meteo-concept.com/api/forecast/daily/periods?token=f70afd8eda4e451db5b1c1f36ba7057bfc455dc981630b028c5bdf2fc7d43c9a';
//     // 'https://api.openweathermap.org/data/2.5/weather?q={city name}&appid=dffcbee085bb56d1bc8cca47f58c727a';
// //'https://api.openweathermap.org/data/2.5/weather?lat=35.7351998&lon=-0.7730788&appid=dffcbee085bb56d1bc8cca47f58c727a';
// //
// //     var urlMeteo =
// //         'https://api.openweathermap.org/data/2.5/weather?lat={lat}&lon={lon}&appid={API key}';
//     Position position2 = await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.high);
//
//     final queryParameters = {
//       'lat': position2.latitude.toString(),
//       'lon': position2.longitude.toString(),
//       'appid': 'dffcbee085bb56d1bc8cca47f58c727a',
//       'lang': 'fr',
//       'units': 'metric'
//     };
//     final urlMeteov = Uri.https(
//         'api.openweathermap.org', '/data/2.5/weather', queryParameters);
//     final response = await http.get(urlMeteov);
//     var responseBody = jsonDecode(response.body);
//     print('XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX');
//     print(responseBody.toString());
//     print('XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX');
//
//     setState(() {
//       meteoList.add(responseBody);
//     });
//     print(meteoList.toString());
//     print(meteoList[0]['weather']);
//     print(meteoList.length);
//     print('00000000000000000000000000000000000000000000000000000000000');
//     print(meteoList[0]['wind']['deg']);
//     print('latitude2');
//     print(position2.latitude);
//     print('longitude2');
//     print(position2.longitude);
//     print(meteoList[0]['weather'][0]['icon']);
//     //
//     // final String iconcode = '10d';
//     // final icon = Uri.https(
//     //     'openweathermap.org/img/wn/','10d', '@2x.png' );
//   }
//
//   List<int> myListDegrees = [
//     349,
//     350,
//     351,
//     352,
//     353,
//     354,
//     355,
//     356,
//     357,
//     358,
//     360,
//     0,
//     1,
//     2,
//     3,
//     4,
//     5,
//     6,
//     7,
//     8,
//     9,
//     10,
//     11,
//     12
//   ];
//   final textPub =
//       'Le Lorem Ipsum est simplement du faux texte employé dans la composition et la mise en page avant impression. Le Lorem Ipsum est le faux texte standard de l\'imprimerie depuis les années 1500, quand un imprimeur anonyme assembla ensemble des morceaux de texte pour réaliser un livre spécimen de polices de texte. Il n\'a pas fait que survivre cinq siècles, mais s\'est aussi adapté à la bureautique informatique, sans que son contenu n\'en soit modifié. Il a été popularisé dans les années 1960 grâce à la vente de feuilles Letraset contenant des passages du Lorem Ipsum, et, plus récemment, par son inclusion dans des applications de mise en page de texte, comme Aldus PageMaker.';
//   final textPubArab =
//       'لكن لعل أول مشكلة ستواجهك مع هذا البرنامج، وتحديدًا بعد تثبيته مباشرًة وبدأ اختبار الكتابة باللغة العربية على صورة ما من خلاله، هي ظهور الحروف بشكل متقطع أو بعيدة عن بعضها البعض بشكل مشابه لطريقة الكتابة الخاصة باللغات اللاتينية، غير أن الكتابة موجهة من اليسار إلى اليمين، وهو ما لا يجعلك تشعر بالارتياح عند الكتابة – بل تكون مشكلة كبري إذا كنت تستخدم البرنامج دائمًا لتصميم صورًا تحتوي على نصوص، لذلك يجب ان تبحث عن الحل فى أسرع وقت وإلا لن يكون للبرنامج فائدة.';
//
//   @override
//   Widget build(BuildContext context) {
//     // Add french messages
//     timeago.setLocaleMessages('fr', timeago.FrMessages());
//
//     return Scaffold(
//       body: PageStorage(
//         bucket: _bucket,
//         child: PaginateFirestore(
//           header: SliverToBoxAdapter(
//             child: ListView(
//               padding: EdgeInsets.zero,
//               physics: const NeverScrollableScrollPhysics(),
//               shrinkWrap: true,
//               children: [
//                 SliderH(TopHotelFuture: _TopHotelFuture, enabled: _enabled),
//                 Padding(
//                   padding: const EdgeInsets.all(18.0),
//                   child: Card(
//                     child: meteoList.isEmpty
//                         ? null //const Center(child: LinearProgressIndicator())
//                         : Padding(
//                             padding: const EdgeInsets.only(left: 30),
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.start,
//                               children: [
//                                 Padding(
//                                   padding: const EdgeInsets.all(15.0),
//                                   child: Column(
//                                     children: [
//                                       CircleAvatar(
//                                         backgroundColor: Colors.grey,
//                                         backgroundImage: NetworkImage(
//                                           //'http://openweathermap.org/img/wn/10d@2x.png',
//                                           'http://openweathermap.org/img/wn/${meteoList.first['weather'][0]['icon']}@2x.png',
//                                         ),
//                                       ),
//                                       Text(
//                                         '${meteoList.first['main']['temp']}°C',
//                                         style: const TextStyle(
//                                             fontFamily: 'Oswald'),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                                 Column(
//                                   mainAxisAlignment: MainAxisAlignment.start,
//                                   children: [
//                                     Row(
//                                       children: [
//                                         const Icon(
//                                           Icons.location_on,
//                                           size: 13,
//                                         ),
//                                         Text(
//                                           // 'toress ',
//                                           //$_street,
//                                           '$_locality  ',
//                                           style: const TextStyle(
//                                               fontFamily: 'oswald', fontSize: 13
//                                               //fontSize: 13,
//                                               ),
//                                           textAlign: TextAlign.center,
//                                         ),
//                                         Text(
//                                           // ${meteoList[indexM]['main']['temp']}°C '
//                                           '${meteoList.first['weather'][0]['description']}',
//                                           style: const TextStyle(
//                                               fontFamily: 'Oswald'),
//                                         ),
//                                       ],
//                                     ),
//                                     Text(
//                                       'Vitesse du Vent : ${double.parse((meteoList.first['wind']['speed']).toStringAsFixed(2))} Nœud ',
//                                       // * 3.6).toStringAsFixed(2))} Km/h ',
//                                       style:
//                                           const TextStyle(fontFamily: 'Oswald'),
//                                     ),
//                                     direction == null
//                                         ? Text(
//                                             'Direction : ${meteoList.first['wind']['deg']}°',
//                                             style: const TextStyle(
//                                                 fontFamily: 'Oswald'),
//                                           )
//                                         : Row(
//                                             children: [
//                                               Text(
//                                                 'Direction : ${meteoList.first['wind']['deg']}° ',
//                                                 style: const TextStyle(
//                                                     fontFamily: 'Oswald'),
//                                               ),
//                                               Text(
//                                                 directionVent(direction)
//                                                     .toString(),
//                                                 style: const TextStyle(
//                                                     fontFamily: 'Oswald'),
//                                               ),
//                                             ],
//                                           ),
//                                   ],
//                                 ),
//                               ],
//                             ),
//                           ),
//                   ),
//                 ),
//                 // Meteo
//
//                 SizedBox(
//                     height: 20,
//                     child: Marquee(
//                       text: textPub.toUpperCase(),
//                       style: TextStyle(fontFamily: 'oswald'),
//                       blankSpace: 10,
//                       fadingEdgeStartFraction: 0.5,
//                       fadingEdgeEndFraction: 0.5,
//                       velocity: 100,
//                     )),
//                 Container(
//                   color: Colors.blueGrey,
//                   child: SizedBox(
//                       height: 20,
//                       child: Marquee(
//                         text: textPub.toUpperCase(),
//                         style: TextStyle(
//                             fontFamily: 'oswald', color: Colors.white),
//                         blankSpace: 10,
//                         fadingEdgeStartFraction: 0.5,
//                         fadingEdgeEndFraction: 0.5,
//                         velocity: 50,
//                       )),
//                 ),
//                 WidgetMarqueeArab(textPubArab: textPubArab),
//
//                 Top_Hotel(TopHotelFuture: _TopHotelFuture),
//                 Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Column(
//                     children: [
//                       const Top_Title(
//                           toptitle: 'Top Résidence',
//                           toptitle2: 'Flash',
//                           CustomColorSpan: Colors.green,
//                           toptitle3: 'Vente',
//                           CustomColorSpan2: Colors.black,
//                           CustomIcon: Icons.arrow_forward_ios_sharp),
//                       TopWidget(TopFuture: _TopResidenceFuture),
//                     ],
//                   ),
//                 ), // ListView Horizontal Filtered Top Résidence
//                 Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Column(
//                     children: [
//                       const Top_Title(
//                           toptitle: 'Top Agence',
//                           toptitle2: 'Best',
//                           CustomColorSpan: Colors.deepPurple,
//                           toptitle3: 'Choice',
//                           CustomColorSpan2: Colors.red,
//                           CustomIcon: Icons.arrow_forward_ios_sharp),
//                       TopWidget(TopFuture: _TopAgenceFuture),
//                     ],
//                   ),
//                 ),
//                 // Padding(
//                 //   padding: const EdgeInsets.all(8.0),
//                 //   child: Column(
//                 //     children: [
//                 //       FutureBuilder<QuerySnapshot>(
//                 //         future: _TopSponsorFuture,
//                 //         builder: (BuildContext context,
//                 //             AsyncSnapshot<QuerySnapshot> snapshot) {
//                 //           if (snapshot.hasError) {
//                 //             return const Text('Something went wrong');
//                 //           }
//                 //
//                 //           if (snapshot.connectionState ==
//                 //               ConnectionState.waiting) {
//                 //             return Shimmer.fromColors(
//                 //                 baseColor: Colors.grey.shade300,
//                 //                 highlightColor: Colors.grey.shade100,
//                 //                 enabled: _enabled,
//                 //                 child: Container()); //Text("Loading");
//                 //           }
//                 //
//                 //           return ListView(
//                 //             shrinkWrap: true,
//                 //             scrollDirection: Axis.vertical,
//                 //             physics: const NeverScrollableScrollPhysics(),
//                 //             children: snapshot.data!.docs
//                 //                 .map((DocumentSnapshot document) {
//                 //               Map<String, dynamic> data =
//                 //                   document.data()! as Map<String, dynamic>;
//                 //               return Card(
//                 //                 clipBehavior: Clip.antiAlias,
//                 //                 elevation: 5,
//                 //                 child: Column(
//                 //                   children: [
//                 //                     ListTile(
//                 //                       leading: CircleAvatar(
//                 //                         backgroundImage:
//                 //                             NetworkImage(data['themb']),
//                 //                       ),
//                 //                       /*Icon(Icons.add_a_photo_rounded),*/
//                 //                       title: Text(
//                 //                         data['item'].toUpperCase(),
//                 //                         overflow: TextOverflow.ellipsis,
//                 //                         style: const TextStyle(
//                 //                           color: Colors.blue,
//                 //                           fontWeight: FontWeight.normal,
//                 //                           fontSize: 15,
//                 //                           fontFamily: 'Oswald',
//                 //                         ),
//                 //                       ),
//                 //                       subtitle: Text(
//                 //                         '${data['price']}.00 DZD',
//                 //                         overflow: TextOverflow.ellipsis,
//                 //                         style: const TextStyle(
//                 //                           color: Colors.redAccent,
//                 //                           fontWeight: FontWeight.bold,
//                 //                           fontSize: 15,
//                 //                           fontFamily: 'Oswald',
//                 //                         ),
//                 //                       ),
//                 //                     ),
//                 //                     ShaderMask(
//                 //                       shaderCallback: (rect) {
//                 //                         return const LinearGradient(
//                 //                           begin: Alignment.topCenter,
//                 //                           end: Alignment.bottomCenter,
//                 //                           colors: [
//                 //                             Colors.transparent,
//                 //                             Colors.black
//                 //                           ],
//                 //                         ).createShader(Rect.fromLTRB(
//                 //                             0, 0, rect.width, rect.height));
//                 //                       },
//                 //                       blendMode: BlendMode.darken,
//                 //                       child: CachedNetworkImage(
//                 //                         fit: BoxFit.cover,
//                 //                         imageUrl: data['themb'],
//                 //                         /*placeholder: (context, url) => Center(
//                 //                       child: CircularProgressIndicator(),
//                 //                     ),*/
//                 //                         errorWidget: (context, url, error) =>
//                 //                             const Icon(Icons.error),
//                 //                       ),
//                 //                     ),
//                 //                     Padding(
//                 //                       padding: const EdgeInsets.all(16.0),
//                 //                       child: Text(
//                 //                         'Greyhound divisively hello coldly wonderfully marginally far upon excluding.'
//                 //                             .toUpperCase(),
//                 //                         //overflow: TextOverflow.ellipsis,
//                 //                         style: TextStyle(
//                 //                           color: Colors.black.withOpacity(0.6),
//                 //                           fontWeight: FontWeight.normal,
//                 //                           fontSize: 15,
//                 //                           fontFamily: 'Oswald',
//                 //                         ),
//                 //                       ),
//                 //                     ),
//                 //                     ButtonBar(
//                 //                       alignment: MainAxisAlignment.start,
//                 //                       children: [
//                 //                         MaterialButton(
//                 //                           textColor: const Color(0xFF005DFF),
//                 //                           onPressed: () {
//                 //                             // Perform some action
//                 //                           },
//                 //                           child: Text(
//                 //                             'ACTION 1'.toUpperCase(),
//                 //                             //overflow: TextOverflow.ellipsis,
//                 //                             style: const TextStyle(
//                 //                               //color: Colors.black.withOpacity(0.6),
//                 //                               fontWeight: FontWeight.bold,
//                 //                               fontSize: 15,
//                 //                               fontFamily: 'Oswald',
//                 //                             ),
//                 //                           ),
//                 //                         ),
//                 //                         MaterialButton(
//                 //                           textColor: const Color(0xFFFF0000),
//                 //                           onPressed: () {
//                 //                             // Perform some action
//                 //                           },
//                 //                           child: Text(
//                 //                             'ACTION 2'.toUpperCase(),
//                 //                             //overflow: TextOverflow.ellipsis,
//                 //                             style: const TextStyle(
//                 //                               //color: Colors.black.withOpacity(0.6),
//                 //                               fontWeight: FontWeight.normal,
//                 //                               fontSize: 15,
//                 //                               fontFamily: 'Oswald',
//                 //                             ),
//                 //                           ),
//                 //                         ),
//                 //                       ],
//                 //                     ),
//                 //                     /* Image.network('https://images.unsplash.com/photo-1481349518771-20055b2a7b24?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=939&q=80'),*/
//                 //                   ],
//                 //                 ),
//                 //               );
//                 //             }).toList(),
//                 //           );
//                 //         },
//                 //       ),
//                 //     ],
//                 //   ),
//                 // ), // ListView Horizontal Filtered Top Product
//               ],
//             ),
//           ),
//           footer: const SliverToBoxAdapter(child: Center(child: Text('Fin.'))),
//           itemsPerPage: 10000,
//           isLive: true,
//           //scrollController: _scrollController,
//           itemBuilderType: PaginateBuilderType.listView,
//           query: FirebaseFirestore.instance
//               .collection('Products')
//               .orderBy('createdAt', descending: true),
//           bottomLoader: const BottomLoader(),
//           itemBuilder: (BuildContext, documentSnapshots, index) {
//             var data = documentSnapshots[index].data() as Map?;
//             String /*var*/ dataid = documentSnapshots[index].id;
//
//             final docidd = data!['userID']; //dataid.toString();
//             print(docidd);
//
//             // final DocumentReference _userRef_Document =
//             //     FirebaseFirestore.instance.collection('Users').doc(docidd.trim());
//
//             print(data['price']);
//             print(
//                 '/////////////////////////////////////********/////////////////////////////////////////////');
//             return data == null
//                 ? const Text(
//                     'Error in data',
//                     style: TextStyle(
//                         fontSize: 20,
//                         fontWeight: FontWeight.bold,
//                         fontFamily: 'Oswald'),
//                   )
//                 : InkWell(
//                     child: like_instagram(
//                       data: data,
//                       user: userm,
//                       isLiked:
//                           data['usersLike'].toString().contains(userm!.uid),
//                       docid: dataid,
//                       docidd: docidd.toString(),
//                     ),
//                     onTap: () async {
//                       await Navigator.push(context,
//                           MaterialPageRoute(builder: (BuildContext) {
//                         return Hero(
//                           tag: 'Hero_Items',
//                           child: item_details_statefull(
//                             data: data,
//                             user: userm,
//                             isLiked: data['usersLike']
//                                 .toString()
//                                 .contains(userm!.uid),
//                             docid: dataid,
//                             docidd: docidd.toString(),
//                           ),
//                         );
//                       }));
//                     },
//                   );
//           },
//         ),
//       ),
//     );
//   }
//
//   directionVent(direction) {
//     if (direction >= 0 && direction < 22.5) {
//       return 'Nord N';
//     }
//     if (direction >= 22.5 && direction < 45) {
//       return 'Nord NNE';
//     }
//     if (direction >= 45 && direction < 67.5) {
//       return 'Nord NE';
//     }
//     if (direction >= 67.5 && direction < 90) {
//       return 'Est ENE';
//     }
//     if (direction >= 90 && direction < 112.5) {
//       return 'Est E';
//     }
//     if (direction >= 112.5 && direction < 135) {
//       return 'Est ESE';
//     }
//     if (direction >= 135 && direction < 157.5) {
//       return 'Sud SE';
//     }
//     if (direction >= 157.5 && direction < 180) {
//       return 'Sud SSE';
//     }
//     if (direction >= 180 && direction < 202.5) {
//       return 'Sud S';
//     }
//     if (direction >= 202.5 && direction < 225) {
//       return 'Sud SSW';
//     }
//     if (direction >= 225 && direction < 247.5) {
//       return 'Sud SW';
//     }
//     if (direction >= 247.5 && direction < 270) {
//       return 'Ouest WSW';
//     }
//     if (direction >= 270 && direction < 292.5) {
//       return 'Ouest W';
//     }
//     if (direction >= 292.5 && direction < 315) {
//       return 'Ouest WNW';
//     }
//     if (direction >= 315 && direction < 337.5) {
//       return 'Nord NW';
//     }
//     if (direction >= 337.5 && direction <= 360) {
//       return 'Nord NNW';
//     }
//     print(
//         'METEOMETEOMETEOMETEOMETEOMETEOMETEOMETEOMETEOMETEOMETEOMETEOMETEOMETEOMETEOMETEOMETEO');
//     //print(directionVent(direction).toString());
//   }
// }
//
// class WidgetMarqueeArab extends StatelessWidget {
//   const WidgetMarqueeArab({
//     Key? key,
//     required this.textPubArab,
//   }) : super(key: key);
//
//   final String textPubArab;
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       color: Colors.black,
//       child: SizedBox(
//           height: 40,
//           child: Marquee(
//             text: textPubArab.toUpperCase(),
//             style: TextStyle(color: Colors.amber),
//             blankSpace: 10,
//             fadingEdgeStartFraction: 0.5,
//             fadingEdgeEndFraction: 0.5,
//             velocity: 30,
//             textDirection: TextDirection.rtl,
//           )),
//     );
//   }
// }
//
// class item_detail extends StatelessWidget {
//   item_detail({
//     Key? key,
//     required Map? data,
//     required this.docid,
//     required this.user,
//     required this.isLiked,
//     required this.docidd,
//   })  : datam = data,
//         //**************
//         super(key: key);
//
//   final Map? datam;
//   final User? user;
//   String docid;
//   bool isLiked;
//   String docidd;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Card(
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(6),
//         ),
//         elevation: 5,
//         clipBehavior: Clip.antiAliasWithSaveLayer,
//         child: Container(
//           child: Column(
//             children: [
//               Expanded(
//                 flex: 3,
//                 child: Stack(
//                   fit: StackFit.expand,
//                   children: [
//                     ShaderMask(
//                       shaderCallback: (rect) {
//                         return const
//                             //   const LinearGradient(
//                             //   begin: Alignment.topCenter,
//                             //   end: Alignment.bottomCenter,
//                             //   colors: [Colors.transparent, Colors.black],
//                             // )
//                             RadialGradient(
//                           colors: [Colors.transparent, Colors.black87],
//                           tileMode: TileMode.clamp,
//                           focalRadius: 1,
//                           radius: 1,
//                           stops: [0.1, 1],
//                           center: Alignment.center,
//                         ).createShader(
//                                 Rect.fromLTRB(0, 0, rect.width, rect.height));
//                       },
//                       blendMode: BlendMode.darken,
//                       child: CachedNetworkImage(
//                         fit: BoxFit.cover,
//                         imageUrl: datam!['themb'],
//                       ),
//                     ),
//                     Container(
//                         padding: const EdgeInsets.fromLTRB(0, 10, 05, 0),
//                         //alignment: Alignment.topLeft,
//                         child: datam!['category'] == 'Hotel'
//                             ? CategoryColors(
//                                 datam!, Colors.blue, Colors.white, Icons.hotel)
//                             : datam!['category'] == 'Agence'
//                                 ? CategoryColors(datam!, Colors.red,
//                                     Colors.white, Icons.account_balance)
//                                 : datam!['category'] == 'Residence'
//                                     ? CategoryColors(datam!, Colors.green,
//                                         Colors.white, Icons.apartment)
//                                     : datam!['category'] == 'Autres'
//                                         ? CategoryColors(
//                                             datam!,
//                                             Colors.deepPurple,
//                                             Colors.white,
//                                             Icons.category)
//                                         : CategoryColors(datam!, Colors.black54,
//                                             Colors.amber, Icons.attach_money)
//
//                         // sponsors
//                         ), // category
//                     Container(
//                       alignment: Alignment.bottomCenter,
//                       child: ListTile(
//                         dense: true,
//                         title: Text(
//                           datam!['item'].toUpperCase(),
//                           overflow: TextOverflow.ellipsis,
//                           style: const TextStyle(
//                             color: Colors.white,
//                             fontWeight: FontWeight.normal,
//                             fontSize: 15,
//                             fontFamily: 'Oswald',
//                           ),
//                         ),
//                         subtitle: Text(
//                           datam!['code'].toUpperCase(),
//                           overflow: TextOverflow.ellipsis,
//                           style: const TextStyle(
//                             color: Colors.amber,
//                             fontWeight: FontWeight.bold,
//                             fontSize: 12,
//                             fontFamily: 'Oswald',
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               Expanded(
//                 flex: 9,
//                 child: Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Row(
//                     children: [
//                       Expanded(
//                         flex: 3,
//                         child: Align(
//                           alignment: Alignment.bottomLeft,
//                           child: Text(
//                             '${datam!['price']}.00 DZD',
//                             overflow: TextOverflow.ellipsis,
//                             style: const TextStyle(
//                               color: Colors.black54,
//                               fontWeight: FontWeight.bold,
//                               fontSize: 14,
//                               fontFamily: 'Oswald',
//                             ),
//                           ),
//                         ),
//                       ),
//                       // price
//                       Align(
//                         alignment: Alignment.bottomRight,
//                         child: Text(
//                           intl.NumberFormat.compact(locale: 'fr_IN')
//                               .format(datam!['likes']),
//                           overflow: TextOverflow.ellipsis,
//                           style:
//                               datam!['usersLike'].toString().contains(user!.uid)
//                                   ? const TextStyle(
//                                       color: Colors.red,
//                                       fontWeight: FontWeight.normal,
//                                       fontSize: 12,
//                                       fontFamily: 'Oswald',
//                                     )
//                                   : const TextStyle(
//                                       color: Colors.blue,
//                                       fontWeight: FontWeight.normal,
//                                       fontSize: 12,
//                                       fontFamily: 'Oswald',
//                                     ),
//                         ),
//                       ),
//
//                       // like_class(dataid: dataid, data: _data,),
//                       ///////////////////////////////////
//                       // Padding(
//                       //   padding: const EdgeInsets.fromLTRB(2, 0, 0, 0),
//                       //   child: datam!['usersLike'].toString().contains(user.uid)
//                       //       ? Icon(
//                       //     FontAwesomeIcons.solidHeart,
//                       //     color: Colors.redAccent,
//                       //     size: 15,
//                       //   )
//                       //       : Icon(
//                       //     FontAwesomeIcons.heart,
//                       //     color: Colors.blue,
//                       //     size: 15,
//                       //   ),
//                       // ),
//                       ///////////////////////////////////
//                       // user == null
//                       //     ? IconButtonWidget1(
//                       //               IconVar: FontAwesomeIcons.solidHeart,
//                       //               likecolor: Colors.grey,
//                       //               function: () {
//                       //                 Navigator.of(context).push(MaterialPageRoute(
//                       //                     builder: (context) => MainPageAuth()));
//                       //               },
//                       //               likes: _data!['likes'],
//                       //             )
//                       //
//                       //
//                       //     : _data!['usersLike'].toString().contains(user.uid)
//                       //         ? IconButtonWidget1(
//                       //                   IconVar: FontAwesomeIcons.solidHeart,
//                       //                   likecolor: Colors.red,
//                       //                   function: () async {
//                       //                     //final user = FirebaseAuth.instance.currentUser;
//                       //                     FirebaseFirestore.instance
//                       //                         .collection('Products')
//                       //                         .doc(dataid)
//                       //                         .update({
//                       //                       'likes': FieldValue.increment(-1),
//                       //   buttonSize = 30          'usersLike':
//                       //                           FieldValue.arrayRemove([user.uid]),
//                       //                     });
//                       //                   },
//                       //                   likes: _data!['likes'],
//                       //                 )
//                       //         : IconButtonWidget1(
//                       //                   IconVar: FontAwesomeIcons.heart,
//                       //                   likecolor: Colors.blue,
//                       //                   function: () async {
//                       //                     //final user = FirebaseAuth.instance.currentUser;
//                       //                     FirebaseFirestore.instance
//                       //                         .collection('Products')
//                       //                         .doc(dataid)
//                       //                         .update({
//                       //                       'likes': FieldValue.increment(1),
//                       //                       'usersLike':
//                       //                           FieldValue.arrayUnion([user.uid]),
//                       //                     });
//                       //                   },
//                       //                   likes: _data!['likes'],
//                       //                 ),
//                       ////////////////////////////////////////////////////////////////
//                       // _data!['usersLike'].toString().contains(user!.uid)
//                       //     ? LikeButton(
//                       //         size: 20,
//                       //         circleColor: CircleColor(
//                       //             start: Color(0xffdc1b4e), end: Color(0xffb71c1c)),
//                       //         bubblesColor: BubblesColor(
//                       //           dotPrimaryColor: Color(0xffea0c0c),
//                       //           dotSecondaryColor: Color(0xffb71c1c),
//                       //         ),
//                       //         likeBuilder: (bool isLiked) {
//                       //           return Icon(
//                       //             FontAwesomeIcons.solidHeart,
//                       //             color: Colors.redAccent,
//                       //             size: 20,
//                       //           );
//                       //         },
//                       //         //likeCount: _data!['likes'],
//                       //         onTap: onLikeButtonTapped,
//                       //       )
//                       //     : LikeButton(
//                       //         size: 20,
//                       //         circleColor: CircleColor(
//                       //             start: Color(0xff1d77de), end: Color(0xff431cb7)),
//                       //         bubblesColor: BubblesColor(
//                       //           dotPrimaryColor: Color(0xff0c38ea),
//                       //           dotSecondaryColor: Color(0xff1c31b7),
//                       //         ),
//                       //         likeBuilder: (bool isLiked) {
//                       //           return Icon(
//                       //             FontAwesomeIcons.heart,
//                       //             color: Colors.blue,
//                       //             size: 20,
//                       //           );
//                       //         },
//                       //         // likeCount:
//                       //         //   _data!['likes'],
//                       //         onTap: onDisLikeButtonTapped,
//                       //       )
//                       ///////////////////////////////////////////////////////////
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//
