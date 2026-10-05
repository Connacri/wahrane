import 'dart:math';
import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutterflow_paginate_firestore/widgets/bottom_loader.dart';
import 'package:flutterflow_paginate_firestore/widgets/empty_display.dart';
import 'package:flutterflow_paginate_firestore/widgets/empty_separator.dart';
import 'package:flutterflow_paginate_firestore/widgets/initial_loader.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutterflow_paginate_firestore/paginate_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:wahrane/features/home/profile_others_page.dart';
import 'package:wahrane/features/home/insta_page.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:wahrane/features/auth/auth_page.dart';
import 'package:wahrane/features/home/upload_random_page.dart';
import 'package:wahrane/features/home/profile_page.dart';
import 'package:wahrane/features/home/add_post_page.dart';
import 'package:wahrane/features/home/item_details_page.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class Collection1Data {
  final List<DocumentSnapshot> documents;

  Collection1Data(this.documents);
  Query<Object?> fromListOfDocumentSnapshots(List<DocumentSnapshot> documents) {
    return FirebaseFirestore.instance.collection('Products').where(
        FieldPath.documentId,
        whereIn: documents.map((d) => d.id).toList());
  }
}

class Collection3Data {
  final List<DocumentSnapshot> documents;

  Collection3Data(this.documents);
  Query<Object?> fromListOfDocumentSnapshots(List<DocumentSnapshot> documents) {
    return FirebaseFirestore.instance.collection('Caroussel').where(
        FieldPath.documentId,
        whereIn: documents.map((d) => d.id).toList());
  }
}

class Collection2Data {
  final List<DocumentSnapshot> documents;
  Collection2Data(this.documents);

  // Future<UserX?> getUserById(String userID) async {
  //   DocumentReference<Map<String, dynamic>> userRef =
  //       FirebaseFirestore.instance.collection('Users').doc(userID);
  //   DocumentSnapshot<Map<String, dynamic>> userDoc = await userRef.get();
  //   if (userDoc.exists) {
  //     return UserX.fromSnapshot(userDoc);
  //   } else {
  //     return null;
  //   }
  // }

  Stream<List<UserClass>> get users {
    final firestore = FirebaseFirestore.instance;
    final usersRef = firestore.collection('Users');
    return usersRef.snapshots().map((snapshot) {
      return snapshot.docs.map((document) {
        return UserClass.fromJson(document.data());
        // return UserClass.fromSnapshot(document);
      }).toList();
    });
  }
}

// class UserX {
//   final String avatar;
//   final double coins;
//   final Timestamp createdAt;
//   final String displayName;
//   final String email;
//   final String id;
//   final Timestamp lastActive;
//   final String levelUser;
//   final String plan;
//   final String role;
//   final bool state;
//   final String timeline;
//
//   UserX({
//     required this.avatar,
//     required this.coins,
//     required this.createdAt,
//     required this.displayName,
//     required this.email,
//     required this.id,
//     required this.lastActive,
//     required this.levelUser,
//     required this.plan,
//     required this.role,
//     required this.state,
//     required this.timeline,
//   });
//
//   factory UserX.fromSnapshot(DocumentSnapshot snapshot) {
//     return UserX(
//       avatar: snapshot['avatar'],
//       coins: snapshot['coins'] as double,
//       createdAt: snapshot['createdAt'] as Timestamp,
//       displayName: snapshot['displayName'],
//       email: snapshot['email'],
//       id: snapshot['id'],
//       lastActive: snapshot['lastActive'] as Timestamp,
//       levelUser: snapshot['levelUser'] as String,
//       plan: snapshot['plan'] as String,
//       role: snapshot['role'],
//       state: snapshot['state'] as bool,
//       timeline: snapshot['timeline'],
//     );
//   }
// }

class MyApp extends StatelessWidget {
  MyApp({Key? key, required this.userDoc}) : super(key: key);
  final dynamic userDoc;
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider<Collection1Data>(
          create: (_) => FirebaseFirestore.instance
              .collection("Products")
              .snapshots()
              .map((querySnapshot) => Collection1Data(querySnapshot.docs)),
          initialData: Collection1Data([]),
        ),
        StreamProvider<Collection2Data>(
          create: (_) => FirebaseFirestore.instance
              .collection("Users")
              .snapshots()
              .map((querySnapshot) => Collection2Data(querySnapshot.docs)),
          initialData: Collection2Data([]),
        ),
        StreamProvider<Collection3Data>(
          create: (_) => FirebaseFirestore.instance
              .collection("Caroussel")
              .snapshots()
              .map((querySnapshot) => Collection3Data(querySnapshot.docs)),
          initialData: Collection3Data([]),
        ),
      ],
      child: BottomNavigation(
        userDoc: userDoc,
      ),
      // child: Scaffold(
      //   body: SafeArea(
      //     child: Consumer<Collection1Data>(
      //       builder: (context, collection1Data, _) {
      //         if (collection1Data == null) return CircularProgressIndicator();
      //         return Consumer<Collection2Data>(
      //           builder: (context, collection2Data, _) {
      //             if (collection2Data == null)
      //               return CircularProgressIndicator();
      //             final combinedData = [
      //               ...collection1Data.documents,
      //               //...collection2Data.documents,
      //             ];
      //             return ListView.builder(
      //               shrinkWrap: true,
      //               itemCount: combinedData.length,
      //               itemBuilder: (context, index) {
      //                 final data = combinedData[index];
      //                 return Center(
      //                   child: ListTile(
      //                     title: Text(data["item"]),
      //                     // subtitle:
      //                     //     Text(data["price"].toString() ?? data['email']),
      //                   ),
      //                 );
      //               },
      //             );
      //           },
      //         );
      //       },
      //     ),
      //   ),
      // ),
    );
  }
}

// class BottomNavigation extends StatefulWidget {
//   BottomNavigation({Key? key, required this.userDoc}) : super(key: key);
//   final userDoc;
//
//   @override
//   _bottomNavigationState createState() {
//     return _bottomNavigationState();
//   }
// }
//
// class _bottomNavigationState extends State<BottomNavigation>
//     with AutomaticKeepAliveClientMixin {
//   @override
//   void initState() {
//     super.initState();
//   }
//
//   @override
//   void dispose() {
//     super.dispose();
//   }
//
//   int currentPageIndex = 0;
//   @override
//   Widget build(BuildContext context) {
//     super.build(context);
//     final uusers = Provider.of<Collection2Data>(context);
//     return Scaffold(
//         floatingActionButton: FloatingActionButton(
//           foregroundColor: Colors.transparent,
//           onPressed: () {
//             Navigator.push(context, MaterialPageRoute(builder: (_) {
//               return StepperWidget();
//             }));
//           },
//           child: const Icon(
//             FontAwesomeIcons.add,
//             color: Colors.black54,
//           ),
//         ),
//         bottomNavigationBar: NavigationBar(
//           height: 60,
//           onDestinationSelected: (int index) {
//             setState(() {
//               currentPageIndex = index;
//             });
//           },
//           selectedIndex: currentPageIndex,
//           destinations: <Widget>[
//             NavigationDestination(
//               icon: Icon(FontAwesomeIcons.home),
//               label: 'Home',
//             ),
//             NavigationDestination(
//               icon: Icon(FontAwesomeIcons.list),
//               label: 'Insta',
//             ),
//             NavigationDestination(
//               icon: ClipRRect(
//                   clipBehavior: Clip.hardEdge,
//                   borderRadius: BorderRadius.circular(50),
//                   child: CachedNetworkImage(
//                     imageUrl: widget.userDoc['avatar'],
//                     fit: BoxFit.cover,
//                     height: 30,
//                     width: 30,
//                   )),
//               label: widget.userDoc['displayName'],
//             ),
//           ],
//         ),
//         body: IndexedStack(
//           index: currentPageIndex,
//           children: [
//             HomeList(userDoc: widget.userDoc),
//             //Ouedkniss(),
//             InstaPage(
//               userDoc: widget.userDoc,
//             ),
//             Profile(),
//           ],
//         ));
//   }
//
//   @override
//   bool get wantKeepAlive => true;
// }

class BottomNavigation extends StatefulWidget {
  const BottomNavigation({Key? key, required this.userDoc}) : super(key: key);
  final userDoc;

  @override
  _bottomNavigationState createState() {
    return _bottomNavigationState();
  }
}

class _bottomNavigationState extends State<BottomNavigation> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  int currentPageIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // floatingActionButton:
      //      FloatingActionButton(
      //         foregroundColor: Colors.transparent,
      //         onPressed: () {
      //           Navigator.push(context, MaterialPageRoute(builder: (_) {
      //             return StepperWidget();
      //           }));
      //         },
      //         child: const Icon(
      //           FontAwesomeIcons.add,
      //           color: Colors.black54,
      //         ),
      //       )

      bottomNavigationBar: NavigationBar(
        height: 60,
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        selectedIndex: currentPageIndex,
        destinations: <Widget>[
          const NavigationDestination(
            icon: Icon(FontAwesomeIcons.home),
            label: 'Home',
          ),
          const NavigationDestination(
            icon: Icon(FontAwesomeIcons.list),
            label: 'Lives',
          ),
          // NavigationDestination(
          //   icon: Icon(FontAwesomeIcons.hotel),
          //   label: 'hotel_charts',
          // ),
          NavigationDestination(
            icon: ClipRRect(
                clipBehavior: Clip.hardEdge,
                borderRadius: BorderRadius.circular(50),
                child: CachedNetworkImage(
                  imageUrl: widget.userDoc['avatar'],
                  fit: BoxFit.cover,
                  height: 30,
                  width: 30,
                )),
            label: widget.userDoc['displayName'],
          ),
        ],
      ),
      body: <Widget>[
        HomeList(
          userDoc: widget.userDoc,
        ),
        InstaPage(
          userDoc: widget.userDoc,
        ),
        //HotelAvailability(),
        //HotelAvailabilityScreen(),
        const Profile(),
      ][currentPageIndex],
    );
  }
}

class HomeList extends StatelessWidget {
  const HomeList({Key? key, required this.userDoc}) : super(key: key);
  final userDoc;

  @override
  Widget build(BuildContext context) {
    var user = FirebaseAuth.instance.currentUser;
    final uusers = Provider.of<Collection2Data>(context);

    final iitem = Provider.of<Collection1Data>(context);

    final carouss = Provider.of<Collection3Data>(context);
    //final iiitem = iitem.goldItems;
    var premiumUsers = uusers.documents
        .where((element) => element['plan'] == 'premium')
        .toList();
    var itmCarous = carouss.documents
        // .where((element) => element['levelItem'] == 'carou')
        .toList();
    var itm = iitem.documents
        .where((element) => element['levelItem'] == 'gold')
        .toList();
    var itmm = iitem.documents
        .where((element) => element['levelItem'] == 'silver')
        .toList();
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        foregroundColor: Colors.transparent,
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) {
            return StepperWidget(
              ccollection: 'Products',
            );
          }));
        },
        child: const Icon(
          FontAwesomeIcons.add,
          color: Colors.black54,
        ),
      ),
      body: PaginateFirestore(
          header: SliverToBoxAdapter(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                user == null
                    ? Padding(
                        padding: const EdgeInsets.all(28.0),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 70.0),
                          child: Card(
                            // margin: const EdgeInsets.all(5),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            elevation: 5,
                            child: Stack(
                              children: [
                                ShaderMask(
                                  shaderCallback: (rect) {
                                    return const LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomLeft,
                                      colors: [
                                        Colors.transparent,
                                        Colors.black
                                      ],
                                    ).createShader(Rect.fromLTRB(
                                        0, 0, rect.width, rect.height));
                                  },
                                  blendMode: BlendMode.darken,
                                  child: Container(
                                    height: 50,
                                    decoration: const BoxDecoration(
                                      image: DecorationImage(
                                        image: CachedNetworkImageProvider(
                                          'https://firebasestorage.googleapis.com/v0/b/adventure-eb4ca.appspot.com/o/wall%2Fwall%20(4).jpg?alt=media&token=c5c01dca-4b32-4b9d-88fe-717e976ac2f5',
                                        ),
                                        fit: BoxFit.cover,
                                        alignment: Alignment.topCenter,
                                      ),
                                    ),
                                  ),
                                ),
                                Center(
                                  child: TextButton(
                                    onPressed: () {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const AuthPage()));
                                    },
                                    child: const Text(
                                      'Google Sign in',
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.white),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    : Container(),
                // Container(
                //   width: MediaQuery.of(context).size.width,
                //   height: 200,
                //   child: StreamBuilder<List<UserX>>(
                //     stream: uusers.users,
                //     builder: (context, snapshot) {
                //       if (snapshot.hasData) {
                //         final users = snapshot.data;
                //         return CarouselSlider.builder(
                //           itemCount: users!.length,
                //           itemBuilder: (BuildContext context, int index,
                //                   int pageViewIndex) =>
                //               //   Card(
                //               // // margin: const EdgeInsets.all(5),
                //               // shape: RoundedRectangleBorder(
                //               //     borderRadius: BorderRadius.circular(10)),
                //               // clipBehavior: Clip.antiAliasWithSaveLayer,
                //               // elevation: 5,
                //               // child:
                //               Stack(
                //             alignment: Alignment.center,
                //             children: [
                //               ShaderMask(
                //                 shaderCallback: (rect) {
                //                   return const LinearGradient(
                //                     begin: Alignment.topCenter,
                //                     end: Alignment.bottomLeft,
                //                     colors: [Colors.transparent, Colors.black],
                //                   ).createShader(Rect.fromLTRB(
                //                       0, 0, rect.width, rect.height));
                //                 },
                //                 blendMode: BlendMode.darken,
                //                 child: Container(
                //                   decoration: BoxDecoration(
                //                     image: DecorationImage(
                //                       image: CachedNetworkImageProvider(
                //                         'https://firebasestorage.googleapis.com/v0/b/adventure-eb4ca.appspot.com/o/wall%2Fwall%20(${index}).jpg?alt=media&token=c5c01dca-4b32-4b9d-88fe-717e976ac2f5',
                //                       ),
                //                       fit: BoxFit.cover,
                //                       alignment: Alignment.topCenter,
                //                     ),
                //                   ),
                //                 ),
                //               ),
                //               Container(
                //                 height: 250,
                //                 width: 100,
                //                 // decoration: BoxDecoration(
                //                 //   image: DecorationImage(
                //                 //     image: NetworkImage(
                //                 //       'https://firebasestorage.googleapis.com/v0/b/adventure-eb4ca.appspot.com/o/carre%2Fcarre%20(${inte}).jpg?alt=media&token=fbcb6223-39c8-4ed7-9b62-13acac60fe94',
                //                 //     ),
                //                 //     fit: BoxFit.cover,
                //                 //   ),
                //                 // ),
                //                 child: ClipRRect(
                //                   // make sure we apply clip it properly
                //                   child: BackdropFilter(
                //                     filter:
                //                         ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                //                     child: Container(
                //                       padding: EdgeInsets.all(15),
                //                       alignment: Alignment.center,
                //                       color: Colors.grey.withOpacity(0.1),
                //                     ),
                //                   ),
                //                 ),
                //               ),
                //               Padding(
                //                 padding: const EdgeInsets.only(top: 15.0),
                //                 child: Column(
                //                   mainAxisAlignment: MainAxisAlignment.center,
                //                   children: [
                //                     UnsplashAvatar(
                //                         UnsplashUrl: users[index].avatar),
                //                     // Container(
                //                     //   width: 90,
                //                     //   child: FittedBox(
                //                     //     child: RatingBar.builder(
                //                     //       initialRating: double.parse(
                //                     //           snapshot
                //                     //               .data!
                //                     //               .docs[index]
                //                     //                   ['userItemsNbr']
                //                     //               .toString()),
                //                     //       ignoreGestures: true,
                //                     //       minRating: 1,
                //                     //       direction: Axis.horizontal,
                //                     //       allowHalfRating: true,
                //                     //       itemCount: 5,
                //                     //       itemPadding:
                //                     //           EdgeInsets.symmetric(
                //                     //               horizontal: 4.0),
                //                     //       itemBuilder: (context, _) =>
                //                     //           Icon(
                //                     //         Icons.star,
                //                     //         color: Colors.amber,
                //                     //       ),
                //                     //       onRatingUpdate: (rating) {
                //                     //         print(rating);
                //                     //       },
                //                     //     ),
                //                     //   ),
                //                     // ),
                //                     Container(
                //                       width: 80,
                //                       height: 40,
                //                       child: FittedBox(
                //                         child: Text(
                //                           users[index]
                //                               .displayName
                //                               .toString()
                //                               .toUpperCase(),
                //                           style: TextStyle(
                //                               color: Colors.white70,
                //                               fontSize: 28,
                //                               fontWeight: FontWeight.bold),
                //                         ),
                //                       ),
                //                     ),
                //                     users[index].role == 'admin'
                //                         ? ShaderMask(
                //                             blendMode: BlendMode.srcIn,
                //                             shaderCallback: (Rect bounds) =>
                //                                 LinearGradient(
                //                                   colors: <Color>[
                //                                     Colors.red,
                //                                     Colors.yellowAccent,
                //                                     Color.fromRGBO(
                //                                         246, 132, 2, 1.0),
                //                                   ],
                //                                   begin: Alignment.topLeft,
                //                                   end: Alignment.bottomRight,
                //                                 ).createShader(bounds),
                //                             child: Text(
                //                               users[index]
                //                                   .role
                //                                   .toString()
                //                                   .toUpperCase(),
                //                               style: TextStyle(
                //                                   color: Colors.white,
                //                                   fontSize: 20,
                //                                   fontWeight: FontWeight.bold),
                //                             ))
                //                         : Text(
                //                             users[index]
                //                                 .role
                //                                 .toString()
                //                                 .toUpperCase(),
                //                             style: TextStyle(
                //                                 color: Colors.white,
                //                                 fontSize: 20,
                //                                 fontWeight: FontWeight.bold),
                //                           ),
                //                   ],
                //                 ),
                //               ),
                //             ],
                //           ),
                //           //  ),
                //           options: CarouselOptions(
                //             //height: 400,
                //
                //             aspectRatio: 16 / 9,
                //             viewportFraction: 1, //0.8,
                //             initialPage: 0,
                //             enableInfiniteScroll: true,
                //             reverse: false,
                //             autoPlay: true,
                //             autoPlayInterval: Duration(seconds: 5),
                //             autoPlayAnimationDuration:
                //                 Duration(milliseconds: 800),
                //             autoPlayCurve:
                //                 Curves.easeInToLinear, //.fastOutSlowIn,
                //             enlargeCenterPage: true,
                //             enlargeFactor: 0, // 0.3,
                //             //onPageChanged: callbackFunction,
                //             scrollDirection: Axis.horizontal,
                //           ),
                //         );
                //         //   ListView.builder(
                //         //   itemCount: users!.length,
                //         //   itemBuilder: (BuildContext context, int index) {
                //         //     return Text(users[index].name);
                //         //   },
                //         // );
                //       } else if (snapshot.hasError) {
                //         return Text('Error: ${snapshot.error}');
                //       }
                //       return Center(child: CircularProgressIndicator());
                //     },
                //   ),
                // ), // Caroussel
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 200,
                  child: CarouselSlider.builder(
                    itemCount: itmCarous.length,
                    itemBuilder:
                        (BuildContext context, int index, int pageViewIndex) =>
                            Stack(
                      alignment: Alignment.center,
                      children: [
                        ShaderMask(
                          shaderCallback: (rect) {
                            return const LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomLeft,
                              colors: [Colors.transparent, Colors.black],
                            ).createShader(
                                Rect.fromLTRB(0, 0, rect.width, rect.height));
                          },
                          blendMode: BlendMode.darken,
                          child: Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: CachedNetworkImageProvider(
                                  itmCarous[index]['themb'],
                                ),
                                fit: BoxFit.cover,
                                alignment: Alignment.topCenter,
                              ),
                            ),
                          ),
                        ),
                        // Container(
                        //   height: 250,
                        //   width: 100,
                        //   child: ClipRRect(
                        //     child: BackdropFilter(
                        //       filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                        //       child: Container(
                        //         padding: EdgeInsets.all(15),
                        //         alignment: Alignment.center,
                        //         color: Colors.grey.withOpacity(0.1),
                        //       ),
                        //     ),
                        //   ),
                        // ),
                        Padding(
                          padding: const EdgeInsets.only(top: 32.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              UnsplashAvatarProvider(
                                userID: itmCarous[index]['userID'],
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Text(
                                  itmCarous[index]['item']
                                      .toString()
                                      .toUpperCase(),
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      color: Colors.white70,
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    options: CarouselOptions(
                      aspectRatio: 16 / 9,
                      viewportFraction: 1, //0.8,
                      initialPage: 0,
                      enableInfiniteScroll: true,
                      reverse: false,
                      autoPlay: true,
                      autoPlayInterval: const Duration(seconds: 5),
                      autoPlayAnimationDuration: const Duration(milliseconds: 800),
                      autoPlayCurve: Curves.easeInToLinear, //.fastOutSlowIn,
                      enlargeCenterPage: true,
                      enlargeFactor: 0, // 0.3,
                      //onPageChanged: callbackFunction,
                      scrollDirection: Axis.horizontal,
                    ),
                  ),
                ), // Caroussel
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8.0, horizontal: 40),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Wallet',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: Colors.brown,
                            fontSize: 20,
                            fontWeight: FontWeight.w500),
                      ),
                      const Text(
                        'Coins : ',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: Colors.brown,
                            fontSize: 20,
                            fontWeight: FontWeight.w300),
                      ),
                      Text(
                        NumberFormat.currency(symbol: '', decimalDigits: 2)
                            .format(userDoc['coins']),
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            color: Colors.black54,
                            fontSize: 20,
                            fontWeight: FontWeight.w400),
                      ),
                    ],
                  ),
                ), // wallet
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 10),
                  child: Card(
                    // margin: const EdgeInsets.all(5),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    elevation: 2,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        ShaderMask(
                          shaderCallback: (rect) {
                            return const LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomLeft,
                              colors: [Colors.transparent, Colors.black],
                            ).createShader(
                                Rect.fromLTRB(0, 0, rect.width, rect.height));
                          },
                          blendMode: BlendMode.darken,
                          child: Container(
                            height: 50,
                            decoration: const BoxDecoration(
                              image: DecorationImage(
                                image: CachedNetworkImageProvider(
                                  'https://firebasestorage.googleapis.com/v0/b/adventure-eb4ca.appspot.com/o/wall%2Fwall%20(1).jpg?alt=media&token=c5c01dca-4b32-4b9d-88fe-717e976ac2f5',
                                ),
                                fit: BoxFit.cover,
                                alignment: Alignment.topCenter,
                              ),
                            ),
                          ),
                        ),
                        const Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Top',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    shadows: [
                                      Shadow(
                                        blurRadius: 10.0, // shadow blur
                                        color: Colors.black54, // shadow color
                                        offset: Offset(2.0,
                                            2.0), // how much shadow will be shown
                                      ),
                                    ],
                                    fontStyle: FontStyle.italic,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red),
                              ),
                              Text(
                                'Dealer',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    shadows: [
                                      Shadow(
                                        blurRadius: 10.0, // shadow blur
                                        color: Colors.black54, // shadow color
                                        offset: Offset(2.0,
                                            2.0), // how much shadow will be shown
                                      ),
                                    ],
                                    fontStyle: FontStyle.italic,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Container(
                //   padding: EdgeInsets.only(left: 6),
                //   width: MediaQuery.of(context).size.width,
                //   height: 200,
                //   child: StreamBuilder<List<UserX>>(
                //     stream: uusers.users,
                //     builder: (context, snapshot) {
                //       Random random = new Random();
                //       var i = random.nextInt(27);
                //       if (snapshot.hasData) {
                //         final users = snapshot.data;
                //         return ListView.builder(
                //           shrinkWrap: true,
                //           physics: BouncingScrollPhysics(),
                //           scrollDirection: Axis.horizontal,
                //           itemCount: users!.length,
                //           itemBuilder: (BuildContext context, int index) =>
                //               Card(
                //                 //  margin: const EdgeInsets.all(5),
                //                 shape: RoundedRectangleBorder(
                //                     borderRadius: BorderRadius.circular(50)),
                //                 clipBehavior: Clip.antiAliasWithSaveLayer,
                //                 elevation: 2,
                //                 child: Stack(
                //                   alignment: Alignment.center,
                //                   fit: StackFit.passthrough,
                //                   children: [
                //                     ShaderMask(
                //                       shaderCallback: (rect) {
                //                         return const LinearGradient(
                //                           begin: Alignment.topCenter,
                //                           end: Alignment.bottomLeft,
                //                           colors: [
                //                             Colors.transparent,
                //                             Colors.black
                //                           ],
                //                         ).createShader(Rect.fromLTRB(
                //                             0, 0, rect.width, rect.height));
                //                       },
                //                       blendMode: BlendMode.darken,
                //                       child: CachedNetworkImage(
                //                         width: 80,
                //                         height: 50,
                //                         fit: BoxFit.cover,
                //                         imageUrl:
                //                         'https://firebasestorage.googleapis.com/v0/b/adventure-eb4ca.appspot.com/o/carre%2Fcarre%20(${index + 1}).jpg?alt=media&token=68e384f1-bb64-47cf-a245-9f7f12202443',
                //                         errorWidget: (context, url, error) =>
                //                         const Icon(
                //                           Icons.error,
                //                           color: Colors.red,
                //                         ),
                //                       ),
                //                     ),
                //                     Padding(
                //                       padding: const EdgeInsets.only(top: 15.0),
                //                       child: Column(
                //                           mainAxisAlignment: MainAxisAlignment.end,
                //                           children: [
                //                             // Container(
                //                             //   width: 90,
                //                             //   child: FittedBox(
                //                             //     child: RatingBar.builder(
                //                             //       initialRating: double.parse(
                //                             //           snapshot
                //                             //               .data!
                //                             //               .docs[index]
                //                             //                   ['userItemsNbr']
                //                             //               .toString()),
                //                             //       ignoreGestures: true,
                //                             //       minRating: 1,
                //                             //       direction: Axis.horizontal,
                //                             //       allowHalfRating: true,
                //                             //       itemCount: 5,
                //                             //       itemPadding:
                //                             //           EdgeInsets.symmetric(
                //                             //               horizontal: 4.0),
                //                             //       itemBuilder: (context, _) =>
                //                             //           Icon(
                //                             //         Icons.star,
                //                             //         color: Colors.amber,
                //                             //       ),
                //                             //       onRatingUpdate: (rating) {
                //                             //         print(rating);
                //                             //       },
                //                             //     ),
                //                             //   ),
                //                             // ),
                //                             users[index].role == 'gold'
                //                                 ? ShaderMask(
                //                                 blendMode: BlendMode.srcIn,
                //                                 shaderCallback: (Rect bounds) =>
                //                                     LinearGradient(
                //                                       colors: <Color>[
                //                                         Colors.red,
                //                                         Colors.yellowAccent,
                //                                         Color.fromRGBO(
                //                                             246, 132, 2, 1.0),
                //                                       ],
                //                                       begin: Alignment.topLeft,
                //                                       end:
                //                                       Alignment.bottomRight,
                //                                     ).createShader(bounds),
                //                                 child: Text(
                //                                   users[index]
                //                                       .role
                //                                       .toString()
                //                                       .toUpperCase(),
                //                                   style: TextStyle(
                //                                       color: Colors.white,
                //                                       fontSize: 20,
                //                                       fontWeight:
                //                                       FontWeight.bold),
                //                                 ))
                //                                 : Text(
                //                               users[index]
                //                                   .role
                //                                   .toString()
                //                                   .toUpperCase(),
                //                               style: TextStyle(
                //                                   color: Colors.white,
                //                                   fontSize: 16,
                //                                   fontWeight:
                //                                   FontWeight.bold),
                //                             ),
                //                             Container(
                //                               width: 70,
                //                               height: 25,
                //                               child: FittedBox(
                //                                 child: Text(
                //                                   users[index]
                //                                       .displayName
                //                                       .toString()
                //                                       .toUpperCase(),
                //                                   style: TextStyle(
                //                                       color: Colors.white70,
                //                                       fontSize: 20,
                //                                       fontWeight: FontWeight.bold),
                //                                 ),
                //                               ),
                //                             ),
                //
                //                             Padding(
                //                               padding:
                //                               EdgeInsets.fromLTRB(0, 10, 0, 20),
                //                               child: Container(
                //                                 width: 50.0,
                //                                 height: 50.0,
                //                                 child: CachedNetworkImage(
                //                                   imageUrl: users[index].avatar,
                //                                   imageBuilder:
                //                                       (context, imageProvider) =>
                //                                       Container(
                //                                         decoration: BoxDecoration(
                //                                           shape: BoxShape.circle,
                //                                           image: DecorationImage(
                //                                               image: imageProvider,
                //                                               fit: BoxFit.cover),
                //                                         ),
                //                                       ),
                //                                   errorWidget:
                //                                       (context, url, error) => Icon(
                //                                       Icons
                //                                           .no_accounts_rounded),
                //                                 ),
                //                               ),
                //                             ),
                //                           ]),
                //                     )
                //                   ],
                //                 ),
                //               ),
                //           //     Padding(
                //           //   padding: const EdgeInsets.all(8.0),
                //           //   child: Card(
                //           //     //  margin: const EdgeInsets.all(5),
                //           //     shape: RoundedRectangleBorder(
                //           //         borderRadius: BorderRadius.circular(50)),
                //           //     clipBehavior: Clip.antiAliasWithSaveLayer,
                //           //     elevation: 2,
                //           //     child: Stack(
                //           //       alignment: Alignment.center,
                //           //       children: [
                //           //         ShaderMask(
                //           //           shaderCallback: (rect) {
                //           //             return const LinearGradient(
                //           //               begin: Alignment.topCenter,
                //           //               end: Alignment.bottomLeft,
                //           //               colors: [
                //           //                 Colors.transparent,
                //           //                 Colors.black
                //           //               ],
                //           //             ).createShader(Rect.fromLTRB(
                //           //                 0, 0, rect.width, rect.height));
                //           //           },
                //           //           blendMode: BlendMode.darken,
                //           //           child: Container(
                //           //             height: 100,
                //           //             width: 100,
                //           //             child: CachedNetworkImage(
                //           //               imageUrl:
                //           //                   'https://firebasestorage.googleapis.com/v0/b/wahrane-a42eb.appspot.com/o/pub%2Fpub(${i}).jpg?alt=media&token=7fef3fb5-7a06-4df9-9112-88aefa8cb1c1',
                //           //               fit: BoxFit.cover,
                //           //             ),
                //           //           ),
                //           //         ),
                //           //         // ClipRRect(
                //           //         //   // make sure we apply clip it properly
                //           //         //   child: BackdropFilter(
                //           //         //     filter: ImageFilter.blur(
                //           //         //         sigmaX: 3, sigmaY: 3),
                //           //         //     child: Container(
                //           //         //       padding: EdgeInsets.all(15),
                //           //         //       alignment: Alignment.center,
                //           //         //       color: Colors.grey.withOpacity(0.1),
                //           //         //     ),
                //           //         //   ),
                //           //         // ),
                //           //         Padding(
                //           //           padding: const EdgeInsets.only(top: 15.0),
                //           //           child: Column(
                //           //             mainAxisAlignment:
                //           //                 MainAxisAlignment.center,
                //           //             children: [
                //           //               UnsplashAvatar(
                //           //                   UnsplashUrl: users[index].avatar),
                //           //               // Container(
                //           //               //   width: 90,
                //           //               //   child: FittedBox(
                //           //               //     child: RatingBar.builder(
                //           //               //       initialRating: double.parse(
                //           //               //           snapshot
                //           //               //               .data!
                //           //               //               .docs[index]
                //           //               //                   ['userItemsNbr']
                //           //               //               .toString()),
                //           //               //       ignoreGestures: true,
                //           //               //       minRating: 1,
                //           //               //       direction: Axis.horizontal,
                //           //               //       allowHalfRating: true,
                //           //               //       itemCount: 5,
                //           //               //       itemPadding:
                //           //               //           EdgeInsets.symmetric(
                //           //               //               horizontal: 4.0),
                //           //               //       itemBuilder: (context, _) =>
                //           //               //           Icon(
                //           //               //         Icons.star,
                //           //               //         color: Colors.amber,
                //           //               //       ),
                //           //               //       onRatingUpdate: (rating) {
                //           //               //         print(rating);
                //           //               //       },
                //           //               //     ),
                //           //               //   ),
                //           //               // ),
                //           //               FittedBox(
                //           //                 child: Text(
                //           //                   users[index]
                //           //                       .name
                //           //                       .toString()
                //           //                       .toUpperCase(),
                //           //                   style: TextStyle(
                //           //                       color: Colors.white70,
                //           //                       fontSize: 20,
                //           //                       fontWeight: FontWeight.bold),
                //           //                 ),
                //           //               ),
                //           //
                //           //               users[index].role == 'admin'
                //           //                   ? ShaderMask(
                //           //                       blendMode: BlendMode.srcIn,
                //           //                       shaderCallback: (Rect bounds) =>
                //           //                           LinearGradient(
                //           //                             colors: <Color>[
                //           //                               Colors.red,
                //           //                               Colors.yellowAccent,
                //           //                               Color.fromRGBO(
                //           //                                   246, 132, 2, 1.0),
                //           //                             ],
                //           //                             begin: Alignment.topLeft,
                //           //                             end:
                //           //                                 Alignment.bottomRight,
                //           //                           ).createShader(bounds),
                //           //                       child: Text(
                //           //                         users[index]
                //           //                             .role
                //           //                             .toString()
                //           //                             .toUpperCase(),
                //           //                         style: TextStyle(
                //           //                             color: Colors.white,
                //           //                             fontSize: 16,
                //           //                             fontWeight:
                //           //                                 FontWeight.bold),
                //           //                       ))
                //           //                   : Text(
                //           //                       users[index]
                //           //                           .role
                //           //                           .toString()
                //           //                           .toUpperCase(),
                //           //                       style: TextStyle(
                //           //                           color: Colors.white,
                //           //                           fontSize: 16,
                //           //                           fontWeight:
                //           //                               FontWeight.bold),
                //           //                     ),
                //           //             ],
                //           //           ),
                //           //         ),
                //           //       ],
                //           //     ),
                //           //   ),
                //           // ),
                //         );
                //       } else if (snapshot.hasError) {
                //         return Text('Error: ${snapshot.error}');
                //       }
                //       return Center(child: CircularProgressIndicator());
                //     },
                //   ),
                // ),
                const Padding(
                  padding: EdgeInsets.fromLTRB(18, 18, 18, 0),
                  child: Row(
                    children: [
                      Text(
                        'Premium',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            fontStyle: FontStyle.italic,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue),
                      ),
                      Text(
                        'Seller',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            fontStyle: FontStyle.italic,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black54),
                      ),
                    ],
                  ),
                ),
                Container(
                    padding: const EdgeInsets.only(left: 6),
                    width: MediaQuery.of(context).size.width,
                    height: 200,
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: const BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      itemCount: premiumUsers.length,
                      itemBuilder: (BuildContext context, int index) => Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50)),
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        elevation: 2,
                        child: Stack(
                          alignment: Alignment.center,
                          fit: StackFit.passthrough,
                          children: [
                            ShaderMask(
                              shaderCallback: (rect) {
                                return const LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomLeft,
                                  colors: [Colors.transparent, Colors.black],
                                ).createShader(Rect.fromLTRB(
                                    0, 0, rect.width, rect.height));
                              },
                              blendMode: BlendMode.darken,
                              child: CachedNetworkImage(
                                width: 80,
                                height: 50,
                                fit: BoxFit.cover,
                                imageUrl: premiumUsers[index]['timeline'],
                                errorWidget: (context, url, error) =>
                                    const Icon(
                                  Icons.error,
                                  color: Colors.red,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 15.0),
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    ShaderMask(
                                        blendMode: BlendMode.srcIn,
                                        shaderCallback: (Rect bounds) =>
                                            const LinearGradient(
                                              colors: <Color>[
                                                Colors.red,
                                                Colors.yellowAccent,
                                                Color.fromRGBO(
                                                    246, 132, 2, 1.0),
                                              ],
                                              begin: Alignment.topLeft,
                                              end: Alignment.bottomRight,
                                            ).createShader(bounds),
                                        child: Text(
                                          premiumUsers[index]['levelUser']
                                              .toString()
                                              .toUpperCase(),
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold),
                                        )),
                                    SizedBox(
                                      width: 70,
                                      child: FittedBox(
                                        child: RatingBar.builder(
                                          initialRating: premiumUsers[index]
                                              ['stars'],
                                          // double.parse(snapshot
                                          //     .data!.docs[index]['stars']
                                          //     .toString()),
                                          ignoreGestures: true,
                                          minRating: 1,
                                          direction: Axis.horizontal,
                                          allowHalfRating: true,
                                          itemCount: 5,
                                          itemPadding: const EdgeInsets.symmetric(
                                              horizontal: 4.0),
                                          itemBuilder: (context, _) => const Icon(
                                            Icons.star,
                                            color: Colors.amber,
                                          ),
                                          onRatingUpdate: (rating) {
                                            print(rating);
                                          },
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 70,
                                      height: 25,
                                      child: FittedBox(
                                        child: Text(
                                          premiumUsers[index]['displayName']
                                              .toString()
                                              .toUpperCase(),
                                          style: const TextStyle(
                                              color: Colors.white70,
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.fromLTRB(0, 10, 0, 20),
                                      child: SizedBox(
                                        width: 50.0,
                                        height: 50.0,
                                        child: CachedNetworkImage(
                                          imageUrl: premiumUsers[index]
                                              ['avatar'],
                                          imageBuilder:
                                              (context, imageProvider) =>
                                                  Container(
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                  width: 2,
                                                  color: Colors.white),
                                              shape: BoxShape.circle,
                                              image: DecorationImage(
                                                  image: imageProvider,
                                                  fit: BoxFit.cover),
                                            ),
                                          ),
                                          errorWidget: (context, url, error) =>
                                              const Icon(Icons.no_accounts_rounded),
                                        ),
                                      ),
                                    ),
                                  ]),
                            )
                          ],
                        ),
                      ),
                      //     Padding(
                      //   padding: const EdgeInsets.all(8.0),
                      //   child: Card(
                      //     //  margin: const EdgeInsets.all(5),
                      //     shape: RoundedRectangleBorder(
                      //         borderRadius: BorderRadius.circular(50)),
                      //     clipBehavior: Clip.antiAliasWithSaveLayer,
                      //     elevation: 2,
                      //     child: Stack(
                      //       alignment: Alignment.center,
                      //       children: [
                      //         ShaderMask(
                      //           shaderCallback: (rect) {
                      //             return const LinearGradient(
                      //               begin: Alignment.topCenter,
                      //               end: Alignment.bottomLeft,
                      //               colors: [
                      //                 Colors.transparent,
                      //                 Colors.black
                      //               ],
                      //             ).createShader(Rect.fromLTRB(
                      //                 0, 0, rect.width, rect.height));
                      //           },
                      //           blendMode: BlendMode.darken,
                      //           child: Container(
                      //             height: 100,
                      //             width: 100,
                      //             child: CachedNetworkImage(
                      //               imageUrl:
                      //                   'https://firebasestorage.googleapis.com/v0/b/wahrane-a42eb.appspot.com/o/pub%2Fpub(${i}).jpg?alt=media&token=7fef3fb5-7a06-4df9-9112-88aefa8cb1c1',
                      //               fit: BoxFit.cover,
                      //             ),
                      //           ),
                      //         ),
                      //         // ClipRRect(
                      //         //   // make sure we apply clip it properly
                      //         //   child: BackdropFilter(
                      //         //     filter: ImageFilter.blur(
                      //         //         sigmaX: 3, sigmaY: 3),
                      //         //     child: Container(
                      //         //       padding: EdgeInsets.all(15),
                      //         //       alignment: Alignment.center,
                      //         //       color: Colors.grey.withOpacity(0.1),
                      //         //     ),
                      //         //   ),
                      //         // ),
                      //         Padding(
                      //           padding: const EdgeInsets.only(top: 15.0),
                      //           child: Column(
                      //             mainAxisAlignment:
                      //                 MainAxisAlignment.center,
                      //             children: [
                      //               UnsplashAvatar(
                      //                   UnsplashUrl: users[index].avatar),
                      //               // Container(
                      //               //   width: 90,
                      //               //   child: FittedBox(
                      //               //     child: RatingBar.builder(
                      //               //       initialRating: double.parse(
                      //               //           snapshot
                      //               //               .data!
                      //               //               .docs[index]
                      //               //                   ['userItemsNbr']
                      //               //               .toString()),
                      //               //       ignoreGestures: true,
                      //               //       minRating: 1,
                      //               //       direction: Axis.horizontal,
                      //               //       allowHalfRating: true,
                      //               //       itemCount: 5,
                      //               //       itemPadding:
                      //               //           EdgeInsets.symmetric(
                      //               //               horizontal: 4.0),
                      //               //       itemBuilder: (context, _) =>
                      //               //           Icon(
                      //               //         Icons.star,
                      //               //         color: Colors.amber,
                      //               //       ),
                      //               //       onRatingUpdate: (rating) {
                      //               //         print(rating);
                      //               //       },
                      //               //     ),
                      //               //   ),
                      //               // ),
                      //               FittedBox(
                      //                 child: Text(
                      //                   users[index]
                      //                       .name
                      //                       .toString()
                      //                       .toUpperCase(),
                      //                   style: TextStyle(
                      //                       color: Colors.white70,
                      //                       fontSize: 20,
                      //                       fontWeight: FontWeight.bold),
                      //                 ),
                      //               ),
                      //
                      //               users[index].role == 'admin'
                      //                   ? ShaderMask(
                      //                       blendMode: BlendMode.srcIn,
                      //                       shaderCallback: (Rect bounds) =>
                      //                           LinearGradient(
                      //                             colors: <Color>[
                      //                               Colors.red,
                      //                               Colors.yellowAccent,
                      //                               Color.fromRGBO(
                      //                                   246, 132, 2, 1.0),
                      //                             ],
                      //                             begin: Alignment.topLeft,
                      //                             end:
                      //                                 Alignment.bottomRight,
                      //                           ).createShader(bounds),
                      //                       child: Text(
                      //                         users[index]
                      //                             .role
                      //                             .toString()
                      //                             .toUpperCase(),
                      //                         style: TextStyle(
                      //                             color: Colors.white,
                      //                             fontSize: 16,
                      //                             fontWeight:
                      //                                 FontWeight.bold),
                      //                       ))
                      //                   : Text(
                      //                       users[index]
                      //                           .role
                      //                           .toString()
                      //                           .toUpperCase(),
                      //                       style: TextStyle(
                      //                           color: Colors.white,
                      //                           fontSize: 16,
                      //                           fontWeight:
                      //                               FontWeight.bold),
                      //                     ),
                      //             ],
                      //           ),
                      //         ),
                      //       ],
                      //     ),
                      //   ),
                      // ),
                    )), //Users Premium
                const Padding(
                  padding: EdgeInsets.fromLTRB(18, 18, 18, 0),
                  child: Row(
                    children: [
                      Text(
                        'Flash',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            fontStyle: FontStyle.italic,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.brown),
                      ),
                      Text(
                        'Sell',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            fontStyle: FontStyle.italic,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.green),
                      ),
                    ],
                  ),
                ), // FlashSell
                Container(
                  padding: const EdgeInsets.only(left: 6),
                  height: 220,
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    itemCount: itm
                        .length, //1, //(iitem.documents.length / 3).truncate(),
                    itemBuilder: (BuildContext context, int index) {
                      print('////////////////////////////////////');
                      print(itm[index]['levelItem']);
                      print(itm.length);
                      var data = itm[index].data() as Map;
                      return GestureDetector(
                        onTap: () =>
                            Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => SilverdetailItem(
                            data: data,
                            idDoc: itm[index].id,
                          ),
                        )),
                        child: Card(
                          //  margin: const EdgeInsets.all(5),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          elevation: 2,
                          child: Column(
                            children: [
                              Stack(
                                alignment: Alignment.bottomRight,
                                children: [
                                  ShaderMask(
                                    shaderCallback: (rect) {
                                      return const LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomLeft,
                                        colors: [
                                          Colors.transparent,
                                          Colors.black
                                        ],
                                      ).createShader(Rect.fromLTRB(
                                          0, 0, rect.width, rect.height));
                                    },
                                    blendMode: BlendMode.darken,
                                    child: CachedNetworkImage(
                                      alignment: Alignment.topCenter,
                                      fadeInDuration: const Duration(seconds: 2),
                                      fit: BoxFit.cover,
                                      width: 100,
                                      height: 130,
                                      imageUrl: itm[index]['themb'],
                                      //iitem.documents[index]['themb'],
                                      // 'https://firebasestorage.googleapis.com/v0/b/adventure-eb4ca.appspot.com/o/carre%2Fcarre%20(${index + 1}).jpg?alt=media&token=68e384f1-bb64-47cf-a245-9f7f12202443',
                                      errorWidget: (context, url, error) =>
                                          const Icon(
                                        Icons.error,
                                        color: Colors.red,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 4),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          NumberFormat.compact().format(
                                            itm[index]['likes'],
                                            // iitem.documents[index]['likes']
                                          ),
                                          textAlign: TextAlign.end,
                                          style: const TextStyle(
                                            color: Colors.white70,
                                            fontSize: 10,
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 3,
                                        ),
                                        const Icon(
                                          FontAwesomeIcons.eye,
                                          size: 9,
                                          color: Colors.white70,
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                width: 100,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 4.0),
                                  child: Text(
                                    itm[index]['item'],
                                    // iitem.documents[index]['item'],
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 100,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 4.0),
                                  child: itm[index]['price'] >= 1000

                                      //   iitem.documents[index]['price'] >= 1000
                                      ? Text(
                                          NumberFormat.compactCurrency(
                                                  symbol: 'DZD ',
                                                  decimalDigits: 2)
                                              .format(itm[index]['price']
                                                  //iitem.documents[index]['price']
                                                  ),
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(fontSize: 14),
                                        )
                                      : Text(
                                          NumberFormat.currency(
                                                  symbol: 'DZD ',
                                                  decimalDigits: 2)
                                              .format(itm[index]['price']
                                                  //iitem.documents[index]['price']
                                                  ),
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(fontSize: 14),
                                        ),
                                ),
                              ),
                              SizedBox(
                                width: 100,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 4.0),
                                  child: Text(
                                    '${itm[index]['category']}-${itm[index]['levelItem']}',
                                    //   '${iitem.documents[index]['category']}  ${iitem.documents[index]['levelItem']}',
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 100,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 4.0),
                                  child: Text(
                                    itm[index]['createdAt']
                                        //iitem.documents[index]['createdAt']
                                        .toDate()
                                        .toString(),
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(fontSize: 9),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    elevation: 5,
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: Stack(
                        children: [
                          ShaderMask(
                            shaderCallback: (rect) {
                              return const LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomRight,
                                colors: [Colors.transparent, Colors.black45],
                              ).createShader(
                                  Rect.fromLTRB(0, 0, rect.width, rect.height));
                            },
                            blendMode: BlendMode.darken,
                            child: Container(
                              height: MediaQuery.of(context).size.height * 0.38,
                              decoration: const BoxDecoration(
                                image: DecorationImage(
                                  image: CachedNetworkImageProvider(
                                    'https://firebasestorage.googleapis.com/v0/b/adventure-eb4ca.appspot.com/o/wall%2Fwall%20(2).jpg?alt=media&token=c5c01dca-4b32-4b9d-88fe-717e976ac2f5',
                                  ),
                                  fit: BoxFit.cover,
                                  alignment: Alignment.topCenter,
                                ),
                              ),
                            ),
                          ),
                          BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                            child: Container(
                              alignment: Alignment.center,
                              color: Colors.grey.withValues(alpha: 0.1),
                            ),
                          ),
                          Column(
                            children: [
                              // Padding(
                              //   padding: const EdgeInsets.symmetric(
                              //       horizontal: 20.0, vertical: 10),
                              //   child: Card(
                              //     // margin: const EdgeInsets.all(5),
                              //     shape: RoundedRectangleBorder(
                              //         borderRadius: BorderRadius.circular(15)),
                              //     clipBehavior: Clip.antiAliasWithSaveLayer,
                              //     elevation: 2,
                              //     child: Stack(
                              //       alignment: Alignment.center,
                              //       children: [
                              //         // ShaderMask(
                              //         //   shaderCallback: (rect) {
                              //         //     return const LinearGradient(
                              //         //       begin: Alignment.topCenter,
                              //         //       end: Alignment.bottomLeft,
                              //         //       colors: [
                              //         //         Colors.transparent,
                              //         //         Colors.black
                              //         //       ],
                              //         //     ).createShader(Rect.fromLTRB(
                              //         //         0, 0, rect.width, rect.height));
                              //         //   },
                              //         //   blendMode: BlendMode.darken,
                              //         //   // child: Container(
                              //         //   //   height: 50,
                              //         //   //   decoration: BoxDecoration(
                              //         //   //     image: DecorationImage(
                              //         //   //       image: CachedNetworkImageProvider(
                              //         //   //         'https://firebasestorage.googleapis.com/v0/b/adventure-eb4ca.appspot.com/o/wall%2Fwall%20(3).jpg?alt=media&token=c5c01dca-4b32-4b9d-88fe-717e976ac2f5',
                              //         //   //       ),
                              //         //   //       fit: BoxFit.cover,
                              //         //   //       alignment: Alignment.topCenter,
                              //         //   //     ),
                              //         //   //   ),
                              //         //   // ),
                              //         // ),
                              //         Center(
                              //           child: Row(
                              //             mainAxisAlignment:
                              //                 MainAxisAlignment.center,
                              //             crossAxisAlignment:
                              //                 CrossAxisAlignment.center,
                              //             children: [
                              //               Text(
                              //                 'Affaire',
                              //                 textAlign: TextAlign.start,
                              //                 style: TextStyle(
                              //                     fontStyle: FontStyle.italic,
                              //                     fontSize: 20,
                              //                     fontWeight: FontWeight.bold,
                              //                     color: Colors.white),
                              //               ),
                              //               Text(
                              //                 'Jahde',
                              //                 textAlign: TextAlign.center,
                              //                 style: TextStyle(
                              //                     fontStyle: FontStyle.italic,
                              //                     fontSize: 20,
                              //                     fontWeight: FontWeight.bold,
                              //                     color: Colors.black),
                              //               ),
                              //             ],
                              //           ),
                              //         ),
                              //       ],
                              //     ),
                              //   ),
                              // ),
                              const Padding(
                                padding: EdgeInsets.all(15.0),
                                child: Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Affaire',
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                            shadows: [
                                              Shadow(
                                                blurRadius: 10.0, // shadow blur
                                                color: Colors
                                                    .black54, // shadow color
                                                offset: Offset(2.0,
                                                    2.0), // how much shadow will be shown
                                              ),
                                            ],
                                            fontStyle: FontStyle.italic,
                                            fontSize: 25,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white),
                                      ),
                                      Text(
                                        'Jahde',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            shadows: [
                                              Shadow(
                                                blurRadius: 10.0, // shadow blur
                                                color: Colors
                                                    .black38, // shadow color
                                                offset: Offset(2.0,
                                                    2.0), // how much shadow will be shown
                                              ),
                                            ],
                                            fontStyle: FontStyle.italic,
                                            fontSize: 25,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.only(left: 6),
                                height: 200,
                                // child: ListView.builder(
                                //   shrinkWrap: true,
                                //   physics: BouncingScrollPhysics(),
                                //   scrollDirection: Axis.horizontal,
                                //   itemCount: 12,
                                //   itemBuilder:
                                //       (BuildContext context, int index) {
                                //     return Card(
                                //       //  margin: const EdgeInsets.all(5),
                                //       shape: RoundedRectangleBorder(
                                //           borderRadius:
                                //               BorderRadius.circular(10)),
                                //       clipBehavior: Clip.antiAliasWithSaveLayer,
                                //       elevation: 2,
                                //       child: ShaderMask(
                                //         shaderCallback: (rect) {
                                //           return const LinearGradient(
                                //             begin: Alignment.topCenter,
                                //             end: Alignment.bottomLeft,
                                //             colors: [
                                //               Colors.transparent,
                                //               Colors.black
                                //             ],
                                //           ).createShader(Rect.fromLTRB(
                                //               0, 0, rect.width, rect.height));
                                //         },
                                //         blendMode: BlendMode.darken,
                                //         child: CachedNetworkImage(
                                //           width: 90,
                                //           fit: BoxFit.cover,
                                //           imageUrl:
                                //               'https://firebasestorage.googleapis.com/v0/b/adventure-eb4ca.appspot.com/o/carre%2Fcarre%20(${index + 1}).jpg?alt=media&token=68e384f1-bb64-47cf-a245-9f7f12202443',
                                //           errorWidget: (context, url, error) =>
                                //               const Icon(
                                //             Icons.error,
                                //             color: Colors.red,
                                //           ),
                                //         ),
                                //       ),
                                //     );
                                //   },
                                // ),
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  physics: const BouncingScrollPhysics(),
                                  scrollDirection: Axis.horizontal,
                                  itemCount: itmm.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    print(
                                        '////////////////////////////////////');
                                    print(itmm[index]['levelItem']);
                                    print(itmm.length);
                                    var data = itmm[index].data() as Map;
                                    return GestureDetector(
                                      onTap: () => Navigator.of(context)
                                          .push(MaterialPageRoute(
                                        builder: (context) => SilverdetailItem(
                                          data: data,
                                          idDoc: itmm[index].id,
                                        ),
                                      )),
                                      child: Card(
                                        //  margin: const EdgeInsets.all(5),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        clipBehavior:
                                            Clip.antiAliasWithSaveLayer,
                                        elevation: 2,
                                        child: Column(
                                          children: [
                                            Stack(
                                              alignment: Alignment.bottomCenter,
                                              children: [
                                                ShaderMask(
                                                  shaderCallback: (rect) {
                                                    return const LinearGradient(
                                                      begin:
                                                          Alignment.topCenter,
                                                      end: Alignment.bottomLeft,
                                                      colors: [
                                                        Colors.transparent,
                                                        Colors.black
                                                      ],
                                                    ).createShader(
                                                        Rect.fromLTRB(
                                                            0,
                                                            0,
                                                            rect.width,
                                                            rect.height));
                                                  },
                                                  blendMode: BlendMode.darken,
                                                  child: CachedNetworkImage(
                                                    alignment:
                                                        Alignment.topCenter,
                                                    fadeInDuration:
                                                        const Duration(seconds: 2),
                                                    fit: BoxFit.cover,
                                                    width: 100,
                                                    height: 130,
                                                    imageUrl: itmm[index]
                                                        ['themb'],
                                                    //iitem.documents[index]['themb'],
                                                    // 'https://firebasestorage.googleapis.com/v0/b/adventure-eb4ca.appspot.com/o/carre%2Fcarre%20(${index + 1}).jpg?alt=media&token=68e384f1-bb64-47cf-a245-9f7f12202443',
                                                    errorWidget:
                                                        (context, url, error) =>
                                                            const Icon(
                                                      Icons.error,
                                                      color: Colors.red,
                                                    ),
                                                  ),
                                                ),
                                                // Padding(
                                                //   padding: const EdgeInsets
                                                //           .symmetric(
                                                //       horizontal: 8,
                                                //       vertical: 4),
                                                //   child: Row(
                                                //     mainAxisAlignment:
                                                //         MainAxisAlignment
                                                //             .center,
                                                //     crossAxisAlignment:
                                                //         CrossAxisAlignment
                                                //             .center,
                                                //     children: [
                                                //       Text(
                                                //         NumberFormat.compact()
                                                //             .format(
                                                //           itm[index]['likes'],
                                                //           // iitem.documents[index]['likes']
                                                //         ),
                                                //         textAlign:
                                                //             TextAlign.end,
                                                //         style: TextStyle(
                                                //           color: Colors.white70,
                                                //           fontSize: 10,
                                                //         ),
                                                //       ),
                                                //       SizedBox(
                                                //         width: 3,
                                                //       ),
                                                //       Icon(
                                                //         FontAwesomeIcons.eye,
                                                //         size: 9,
                                                //         color: Colors.white70,
                                                //       )
                                                //     ],
                                                //   ),
                                                // ),
                                                Padding(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 4.0),
                                                  child: itmm[index]['price'] >=
                                                          1000000

                                                      //   iitem.documents[index]['price'] >= 1000
                                                      ? Text(
                                                          NumberFormat.compactCurrency(
                                                                  symbol:
                                                                      'DZD ',
                                                                  decimalDigits:
                                                                      2)
                                                              .format(
                                                                  itmm[index]
                                                                      ['price']
                                                                  //iitem.documents[index]['price']
                                                                  ),
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style: const TextStyle(
                                                              fontSize: 14,
                                                              color: Colors
                                                                  .greenAccent),
                                                        )
                                                      : Text(
                                                          NumberFormat.currency(
                                                                  symbol:
                                                                      'DZD ',
                                                                  decimalDigits:
                                                                      2)
                                                              .format(
                                                                  itmm[index]
                                                                      ['price']
                                                                  //iitem.documents[index]['price']
                                                                  ),
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style: const TextStyle(
                                                              fontSize: 14,
                                                              color: Colors
                                                                  .greenAccent),
                                                        ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              width: 100,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 4.0),
                                                child: Text(
                                                  itmm[index]['item'],
                                                  // iitem.documents[index]['item'],
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style:
                                                      const TextStyle(fontSize: 12),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 100,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 4.0),
                                                child: Text(
                                                  '${itmm[index]['category']}-${itmm[index]['levelItem']}',
                                                  //   '${iitem.documents[index]['category']}  ${iitem.documents[index]['levelItem']}',
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style:
                                                      const TextStyle(fontSize: 12),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 100,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 4.0),
                                                child: Text(
                                                  itmm[index]['createdAt']
                                                      //iitem.documents[index]['createdAt']
                                                      .toDate()
                                                      .toString(),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: const TextStyle(fontSize: 9),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    '${iitem.documents.length} Articles Les Plus Recent Par Pertinance. ',
                    style: const TextStyle(fontStyle: FontStyle.italic),
                  ),
                ),
              ],
            ),
          ),
          // footer: SliverToBoxAdapter(
          //   child: Column(
          //     children: [
          //       Container(
          //         height: 200.0,
          //         child: ListView.builder(
          //           shrinkWrap: true,
          //           physics: BouncingScrollPhysics(),
          //           scrollDirection: Axis.horizontal,
          //           itemCount: 16,
          //           itemBuilder: (BuildContext context, int index) {
          //             return UnsplashSlider(
          //               UnsplashUrl:
          //                   'https://firebasestorage.googleapis.com/v0/b/adventure-eb4ca.appspot.com/o/mob%2Fmob%20(${index}).jpg?alt=media&token=e307d1db-a16f-42f9-a472-1f3a2f47ee79',
          //             );
          //           },
          //         ),
          //       ),
          //     ],
          //   ),
          // ),

          itemsPerPage: 10000,
          onEmpty: const EmptyDisplay(),
          separator: const EmptySeparator(),
          initialLoader: const InitialLoader(),
          bottomLoader: const BottomLoader(),
          shrinkWrap: true,
          isLive: true,
          itemBuilderType: PaginateBuilderType.gridView,
          query: FirebaseFirestore.instance
              .collection('Products')
              .orderBy('createdAt', descending: true),
          itemBuilder: (BuildContext, DocumentSnapshot, int) {
            var data = DocumentSnapshot[int].data() as Map?;
            String dataid = DocumentSnapshot[int].id;
            Random random = Random();
            var randomNumber = random.nextInt(27);
            String randomPhoto =
                'https://firebasestorage.googleapis.com/v0/b/wahrane-a42eb.appspot.com/o/pub%2Fpub($randomNumber).jpg?alt=media&token=5d9e0764-23f6-4b18-95f4-e085736659cc';
            if (int % 5 == 0 && int != 0) {
              return Card(
                //  margin: const EdgeInsets.all(5),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                clipBehavior: Clip.antiAliasWithSaveLayer,
                elevation: 5,
                child: Stack(
                  alignment: Alignment.center,
                  fit: StackFit.passthrough,
                  children: [
                    Container(
                      // decoration: BoxDecoration(
                      //   image: DecorationImage(
                      //     image: CachedNetworkImageProvider(
                      //       randomPhoto,
                      //     ),
                      //     fit: BoxFit.cover,
                      //     alignment: Alignment.topCenter,
                      //   ),
                      // ),
                      child: CachedNetworkImage(
                        fit: BoxFit.cover,
                        imageUrl: randomPhoto,
                      ),
                    ),
                    const Center(
                      child: Text(
                        'PubArea',
                        style: TextStyle(
                            shadows: [
                              Shadow(
                                blurRadius: 10.0, // shadow blur
                                color: Colors.black54, // shadow color
                                offset: Offset(
                                    2.0, 2.0), // how much shadow will be shown
                              ),
                            ],
                            fontSize: 40,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                ),
              );
            }

            return GestureDetector(
              onTap: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => SilverdetailItem(
                  data: data,
                  idDoc: dataid,
                ),
              )),
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                clipBehavior: Clip.antiAliasWithSaveLayer,
                elevation: 5,
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    ShaderMask(
                      shaderCallback: (rect) {
                        return const LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomLeft,
                          colors: [Colors.transparent, Colors.black],
                        ).createShader(
                            Rect.fromLTRB(0, 0, rect.width, rect.height));
                      },
                      blendMode: BlendMode.darken,
                      child: Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: CachedNetworkImageProvider(
                              data!['imageUrls'][0],
                            ),
                            fit: BoxFit.cover,
                            alignment: Alignment.topCenter,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                color: Colors.black54,
                                borderRadius: BorderRadius.circular(8)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                      color: Colors.black54,
                                      borderRadius: BorderRadius.circular(8)),
                                  padding: const EdgeInsets.all(5.0),
                                  child: Text(
                                    data['category'],
                                    overflow: TextOverflow.fade,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 11,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 8),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        NumberFormat.compact()
                                            .format(data['likes']),
                                        textAlign: TextAlign.end,
                                        style: const TextStyle(
                                          color: Colors.white70,
                                          fontSize: 12,
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 3,
                                      ),
                                      const Icon(
                                        FontAwesomeIcons.eye,
                                        size: 11,
                                        color: Colors.white70,
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Spacer(),
                          Column(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 5),
                                child: Text(
                                  data['item'].toString().toUpperCase(),
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      color: Colors.white70,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 0.0),
                                child: Center(
                                  child: Text(
                                    data['price'] >= 1000000.00
                                        ? NumberFormat.compactCurrency(
                                                symbol: 'DZD ',
                                                decimalDigits: 2)
                                            .format(data['price'])
                                        : NumberFormat.currency(
                                                symbol: 'DZD ',
                                                decimalDigits: 2)
                                            .format(data['price']),
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                        //backgroundColor: Colors.black45,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white,
                                        fontFamily: 'oswald'),
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 5, bottom: 5),
                                child: Text(
                                    timeago.format(data['createdAt'].toDate(),
                                        locale: 'fr'),
                                    textAlign: TextAlign.start,
                                    style: const TextStyle(
                                      color: Colors.white70,
                                      fontWeight: FontWeight.normal,
                                      fontSize: 12,
                                      fontFamily: 'Oswald',
                                    )),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    // GridTile(
                    //   header: Container(
                    //     decoration: BoxDecoration(
                    //         color: Colors.black54,
                    //         borderRadius: BorderRadius.circular(8)),
                    //     child: Row(
                    //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //       children: [
                    //         Container(
                    //           decoration: BoxDecoration(
                    //               color: Colors.black54,
                    //               borderRadius: BorderRadius.circular(8)),
                    //           padding: const EdgeInsets.all(5.0),
                    //           child: Text(
                    //             data['category'],
                    //             overflow: TextOverflow.fade,
                    //             textAlign: TextAlign.center,
                    //             style: TextStyle(
                    //                 color: Colors.white,
                    //                 fontSize: 11,
                    //                 fontWeight: FontWeight.w500),
                    //           ),
                    //         ),
                    //         Padding(
                    //           padding: const EdgeInsets.symmetric(horizontal: 8),
                    //           child: Row(
                    //             mainAxisAlignment: MainAxisAlignment.center,
                    //             crossAxisAlignment: CrossAxisAlignment.center,
                    //             children: [
                    //               Text(
                    //                 NumberFormat.compact().format(data['likes']),
                    //                 textAlign: TextAlign.end,
                    //                 style: TextStyle(
                    //                   color: Colors.white70,
                    //                   fontSize: 12,
                    //                 ),
                    //               ),
                    //               SizedBox(
                    //                 width: 3,
                    //               ),
                    //               Icon(
                    //                 FontAwesomeIcons.eye,
                    //                 size: 11,
                    //                 color: Colors.white70,
                    //               )
                    //             ],
                    //           ),
                    //         ),
                    //       ],
                    //     ),
                    //   ),
                    //   footer: Column(
                    //     children: [
                    //       Padding(
                    //         padding: const EdgeInsets.symmetric(horizontal: 5),
                    //         child: Text(
                    //           data['item'],
                    //           overflow: TextOverflow.ellipsis,
                    //           style: TextStyle(
                    //               color: Colors.white70,
                    //               fontSize: 12,
                    //               fontWeight: FontWeight.w500),
                    //         ),
                    //       ),
                    //       Padding(
                    //         padding: const EdgeInsets.only(bottom: 8.0),
                    //         child: Center(
                    //           child: Text(
                    //             data['price'] >= 1000000.00
                    //                 ? NumberFormat.compactCurrency(
                    //                         symbol: 'DZD ', decimalDigits: 2)
                    //                     .format(data['price'])
                    //                 : NumberFormat.currency(
                    //                         symbol: 'DZD ', decimalDigits: 2)
                    //                     .format(data['price']),
                    //             overflow: TextOverflow.ellipsis,
                    //             style: TextStyle(
                    //                 //backgroundColor: Colors.black45,
                    //                 fontSize: 16,
                    //                 fontWeight: FontWeight.w500,
                    //                 color: Colors.white,
                    //                 fontFamily: 'oswald'),
                    //           ),
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    //   child: Center(
                    //     child: Container(),
                    //   ),
                    // ),
                  ],
                ),
              ),
            );
          }),
    );
  }
}

class UnsplashAvatarProvider extends StatelessWidget {
  const UnsplashAvatarProvider({
    Key? key,
    required this.userID,
  }) : super(key: key);

  final String userID;

  @override
  Widget build(BuildContext context) {
    final docRef = FirebaseFirestore.instance.collection('Users').doc(userID);
    return FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        future: docRef.get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: Text('Loading..'),
            );
          }
          var data = snapshot.data?.data();
          return InkWell(
            onTap: () async {
              Map dataUser = data as Map;
              await Navigator.push(context,
                  MaterialPageRoute(builder: (BuildContext context) {
                return ProfileOthers(data: dataUser);
              }));
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 20.0,
                    height: 20.0,
                    child: CachedNetworkImage(
                      imageUrl: data!['avatar'],
                      imageBuilder: (context, imageProvider) => Container(
                        decoration: BoxDecoration(
                          border: Border.all(width: 2, color: Colors.white),
                          // borderRadius: BorderRadius.circular(100),
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              image: imageProvider, fit: BoxFit.cover),
                        ),
                      ),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.no_accounts_rounded),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: SizedBox(
                      child: Text(
                        data['displayName'],
                        style: const TextStyle(fontSize: 16, color: Colors.cyan),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}

Future<void> moveStock(String productID, data, int amount, PUA) async {
  final CollectionReference SourceCollection =
      FirebaseFirestore.instance.collection('Products');
  final CollectionReference DestinationCollection =
      FirebaseFirestore.instance.collection('Instalives');
  final DocumentReference sourceReference = SourceCollection.doc(productID);
  final DocumentReference destinationReference =
      DestinationCollection.doc(productID);
  User? user = FirebaseAuth.instance.currentUser;

  await FirebaseFirestore.instance
      .runTransaction((Transaction transaction) async {
    //start
    await transaction.get(sourceReference);
    await transaction.get(destinationReference);

    int sourceStock = data['stock'];
    //    int destinationStock = destinationSnapshot.data()['qty'];
    DocumentSnapshot<Map<String?, dynamic>> docDestination =
        await FirebaseFirestore.instance
            .collection('Instalives')
            .doc(productID)
            .get();

    if (sourceStock >= amount) {
      if (docDestination.exists) {
        transaction
            .update(sourceReference, {'stock': sourceStock - amount});
        transaction.update(destinationReference, {
          'createdAt': Timestamp.now().toDate(),
          'category': data['category'],
          'model': data['model'],
          'description': data['description'],
          'size': data['size'],
          'prixAchat': data['prixAchat'],
          'prixVente': data['prixVente'],
          'stock': data['stock'],
          'codebar': data['codebar'],
          'oldStock': data['oldStock'],
          'origine': data['origine'],
          'user': user!.uid, //data['user'],
          'qty': FieldValue.increment(amount),
          'state': true,
          //'earn': earn,
          'PUA': PUA,
        });
      } else {
        transaction
            .update(sourceReference, {'stock': sourceStock - amount});
        transaction.set(destinationReference, {
          'createdAt': Timestamp.now().toDate(),
          'category': data['category'],
          'model': data['model'],
          'description': data['description'],
          'size': data['size'],
          'prixAchat': data['prixAchat'],
          'prixVente': data['prixVente'],
          'stock': data['stock'],
          'codebar': data['codebar'],
          'oldStock': data['oldStock'],
          'origine': data['origine'],
          'user': user!.uid, //data['user'],
          'qty': FieldValue.increment(amount),
          'state': true,
          //'earn': earn,
          'PUA': PUA,
        });
      }
    } else {
      throw Exception('Not enough stock in source product');
    }
  });
}
