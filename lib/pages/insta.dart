import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterflow_paginate_firestore/paginate_firestore.dart';
import 'package:flutterflow_paginate_firestore/widgets/bottom_loader.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'ProfileOthers.dart';
import 'item_details-statefull.dart';
import 'package:intl/intl.dart' as intl;

class insta extends StatefulWidget {
  const insta({Key? key}) : super(key: key);

  @override
  State<insta> createState() => _instaState();
}

class _instaState extends State<insta> {
  final PageStorageBucket _bucket = PageStorageBucket();
  @override
  Widget build(BuildContext context) {
    // Add french messages
    timeago.setLocaleMessages('fr', timeago.FrMessages());
    final userm = FirebaseAuth.instance.currentUser;
    final bool _enabled = true;
    return Scaffold(
      body: PageStorage(
        bucket: _bucket,
        child: PaginateFirestore(
          // header: SliverToBoxAdapter(
          //   child: ListView(
          //     padding: EdgeInsets.zero,
          //     physics: const NeverScrollableScrollPhysics(),
          //     shrinkWrap: true,
          //     children: [
          //       SliderH(TopHotelFuture: _TopHotelFuture, enabled: _enabled),
          //       Padding(
          //         padding: const EdgeInsets.all(18.0),
          //         child: Card(
          //           child: meteoList.isEmpty
          //               ? null //const Center(child: LinearProgressIndicator())
          //               : Padding(
          //                   padding: const EdgeInsets.only(left: 30),
          //                   child: Row(
          //                     mainAxisAlignment: MainAxisAlignment.start,
          //                     children: [
          //                       Padding(
          //                         padding: const EdgeInsets.all(15.0),
          //                         child: Column(
          //                           children: [
          //                             CircleAvatar(
          //                               backgroundColor: Colors.grey,
          //                               backgroundImage: NetworkImage(
          //                                 //'http://openweathermap.org/img/wn/10d@2x.png',
          //                                 'http://openweathermap.org/img/wn/${meteoList.first['weather'][0]['icon']}@2x.png',
          //                               ),
          //                             ),
          //                             Text(
          //                               '${meteoList.first['main']['temp']}°C',
          //                               style: const TextStyle(
          //                                   fontFamily: 'Oswald'),
          //                             ),
          //                           ],
          //                         ),
          //                       ),
          //                       Column(
          //                         mainAxisAlignment: MainAxisAlignment.start,
          //                         children: [
          //                           Row(
          //                             children: [
          //                               const Icon(
          //                                 Icons.location_on,
          //                                 size: 13,
          //                               ),
          //                               Text(
          //                                 // 'toress ',
          //                                 //$_street,
          //                                 '$_locality  ',
          //                                 style: const TextStyle(
          //                                     fontFamily: 'oswald', fontSize: 13
          //                                     //fontSize: 13,
          //                                     ),
          //                                 textAlign: TextAlign.center,
          //                               ),
          //                               Text(
          //                                 // ${meteoList[indexM]['main']['temp']}°C '
          //                                 '${meteoList.first['weather'][0]['description']}',
          //                                 style: const TextStyle(
          //                                     fontFamily: 'Oswald'),
          //                               ),
          //                             ],
          //                           ),
          //                           Text(
          //                             'Vitesse du Vent : ${double.parse((meteoList.first['wind']['speed']).toStringAsFixed(2))} Nœud ',
          //                             // * 3.6).toStringAsFixed(2))} Km/h ',
          //                             style:
          //                                 const TextStyle(fontFamily: 'Oswald'),
          //                           ),
          //                           direction == null
          //                               ? Text(
          //                                   'Direction : ${meteoList.first['wind']['deg']}°',
          //                                   style: const TextStyle(
          //                                       fontFamily: 'Oswald'),
          //                                 )
          //                               : Row(
          //                                   children: [
          //                                     Text(
          //                                       'Direction : ${meteoList.first['wind']['deg']}° ',
          //                                       style: const TextStyle(
          //                                           fontFamily: 'Oswald'),
          //                                     ),
          //                                     Text(
          //                                       directionVent(direction)
          //                                           .toString(),
          //                                       style: const TextStyle(
          //                                           fontFamily: 'Oswald'),
          //                                     ),
          //                                   ],
          //                                 ),
          //                         ],
          //                       ),
          //                     ],
          //                   ),
          //                 ),
          //         ),
          //       ),
          //       // Meteo
          //
          //       SizedBox(
          //           height: 20,
          //           child: Marquee(
          //             text: textPub.toUpperCase(),
          //             style: TextStyle(fontFamily: 'oswald'),
          //             blankSpace: 10,
          //             fadingEdgeStartFraction: 0.5,
          //             fadingEdgeEndFraction: 0.5,
          //             velocity: 100,
          //           )),
          //       Container(
          //         color: Colors.blueGrey,
          //         child: SizedBox(
          //             height: 20,
          //             child: Marquee(
          //               text: textPub.toUpperCase(),
          //               style: TextStyle(
          //                   fontFamily: 'oswald', color: Colors.white),
          //               blankSpace: 10,
          //               fadingEdgeStartFraction: 0.5,
          //               fadingEdgeEndFraction: 0.5,
          //               velocity: 50,
          //             )),
          //       ),
          //       WidgetMarqueeArab(textPubArab: textPubArab),
          //
          //       Top_Hotel(TopHotelFuture: _TopHotelFuture),
          //       Padding(
          //         padding: const EdgeInsets.all(8.0),
          //         child: Column(
          //           children: [
          //             const Top_Title(
          //                 toptitle: 'Top Résidence',
          //                 toptitle2: 'Flash',
          //                 CustomColorSpan: Colors.green,
          //                 toptitle3: 'Vente',
          //                 CustomColorSpan2: Colors.black,
          //                 CustomIcon: Icons.arrow_forward_ios_sharp),
          //             TopWidget(TopFuture: _TopResidenceFuture),
          //           ],
          //         ),
          //       ), // ListView Horizontal Filtered Top Résidence
          //       Padding(
          //         padding: const EdgeInsets.all(8.0),
          //         child: Column(
          //           children: [
          //             const Top_Title(
          //                 toptitle: 'Top Agence',
          //                 toptitle2: 'Best',
          //                 CustomColorSpan: Colors.deepPurple,
          //                 toptitle3: 'Choice',
          //                 CustomColorSpan2: Colors.red,
          //                 CustomIcon: Icons.arrow_forward_ios_sharp),
          //             TopWidget(TopFuture: _TopAgenceFuture),
          //           ],
          //         ),
          //       ),
          //       // Padding(
          //       //   padding: const EdgeInsets.all(8.0),
          //       //   child: Column(
          //       //     children: [
          //       //       FutureBuilder<QuerySnapshot>(
          //       //         future: _TopSponsorFuture,
          //       //         builder: (BuildContext context,
          //       //             AsyncSnapshot<QuerySnapshot> snapshot) {
          //       //           if (snapshot.hasError) {
          //       //             return const Text('Something went wrong');
          //       //           }
          //       //
          //       //           if (snapshot.connectionState ==
          //       //               ConnectionState.waiting) {
          //       //             return Shimmer.fromColors(
          //       //                 baseColor: Colors.grey.shade300,
          //       //                 highlightColor: Colors.grey.shade100,
          //       //                 enabled: _enabled,
          //       //                 child: Container()); //Text("Loading");
          //       //           }
          //       //
          //       //           return ListView(
          //       //             shrinkWrap: true,
          //       //             scrollDirection: Axis.vertical,
          //       //             physics: const NeverScrollableScrollPhysics(),
          //       //             children: snapshot.data!.docs
          //       //                 .map((DocumentSnapshot document) {
          //       //               Map<String, dynamic> data =
          //       //                   document.data()! as Map<String, dynamic>;
          //       //               return Card(
          //       //                 clipBehavior: Clip.antiAlias,
          //       //                 elevation: 5,
          //       //                 child: Column(
          //       //                   children: [
          //       //                     ListTile(
          //       //                       leading: CircleAvatar(
          //       //                         backgroundImage:
          //       //                             NetworkImage(data['themb']),
          //       //                       ),
          //       //                       /*Icon(Icons.add_a_photo_rounded),*/
          //       //                       title: Text(
          //       //                         data['item'].toUpperCase(),
          //       //                         overflow: TextOverflow.ellipsis,
          //       //                         style: const TextStyle(
          //       //                           color: Colors.blue,
          //       //                           fontWeight: FontWeight.normal,
          //       //                           fontSize: 15,
          //       //                           fontFamily: 'Oswald',
          //       //                         ),
          //       //                       ),
          //       //                       subtitle: Text(
          //       //                         '${data['price']}.00 DZD',
          //       //                         overflow: TextOverflow.ellipsis,
          //       //                         style: const TextStyle(
          //       //                           color: Colors.redAccent,
          //       //                           fontWeight: FontWeight.bold,
          //       //                           fontSize: 15,
          //       //                           fontFamily: 'Oswald',
          //       //                         ),
          //       //                       ),
          //       //                     ),
          //       //                     ShaderMask(
          //       //                       shaderCallback: (rect) {
          //       //                         return const LinearGradient(
          //       //                           begin: Alignment.topCenter,
          //       //                           end: Alignment.bottomCenter,
          //       //                           colors: [
          //       //                             Colors.transparent,
          //       //                             Colors.black
          //       //                           ],
          //       //                         ).createShader(Rect.fromLTRB(
          //       //                             0, 0, rect.width, rect.height));
          //       //                       },
          //       //                       blendMode: BlendMode.darken,
          //       //                       child: CachedNetworkImage(
          //       //                         fit: BoxFit.cover,
          //       //                         imageUrl: data['themb'],
          //       //                         /*placeholder: (context, url) => Center(
          //       //                       child: CircularProgressIndicator(),
          //       //                     ),*/
          //       //                         errorWidget: (context, url, error) =>
          //       //                             const Icon(Icons.error),
          //       //                       ),
          //       //                     ),
          //       //                     Padding(
          //       //                       padding: const EdgeInsets.all(16.0),
          //       //                       child: Text(
          //       //                         'Greyhound divisively hello coldly wonderfully marginally far upon excluding.'
          //       //                             .toUpperCase(),
          //       //                         //overflow: TextOverflow.ellipsis,
          //       //                         style: TextStyle(
          //       //                           color: Colors.black.withOpacity(0.6),
          //       //                           fontWeight: FontWeight.normal,
          //       //                           fontSize: 15,
          //       //                           fontFamily: 'Oswald',
          //       //                         ),
          //       //                       ),
          //       //                     ),
          //       //                     ButtonBar(
          //       //                       alignment: MainAxisAlignment.start,
          //       //                       children: [
          //       //                         MaterialButton(
          //       //                           textColor: const Color(0xFF005DFF),
          //       //                           onPressed: () {
          //       //                             // Perform some action
          //       //                           },
          //       //                           child: Text(
          //       //                             'ACTION 1'.toUpperCase(),
          //       //                             //overflow: TextOverflow.ellipsis,
          //       //                             style: const TextStyle(
          //       //                               //color: Colors.black.withOpacity(0.6),
          //       //                               fontWeight: FontWeight.bold,
          //       //                               fontSize: 15,
          //       //                               fontFamily: 'Oswald',
          //       //                             ),
          //       //                           ),
          //       //                         ),
          //       //                         MaterialButton(
          //       //                           textColor: const Color(0xFFFF0000),
          //       //                           onPressed: () {
          //       //                             // Perform some action
          //       //                           },
          //       //                           child: Text(
          //       //                             'ACTION 2'.toUpperCase(),
          //       //                             //overflow: TextOverflow.ellipsis,
          //       //                             style: const TextStyle(
          //       //                               //color: Colors.black.withOpacity(0.6),
          //       //                               fontWeight: FontWeight.normal,
          //       //                               fontSize: 15,
          //       //                               fontFamily: 'Oswald',
          //       //                             ),
          //       //                           ),
          //       //                         ),
          //       //                       ],
          //       //                     ),
          //       //                     /* Image.network('https://images.unsplash.com/photo-1481349518771-20055b2a7b24?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=939&q=80'),*/
          //       //                   ],
          //       //                 ),
          //       //               );
          //       //             }).toList(),
          //       //           );
          //       //         },
          //       //       ),
          //       //     ],
          //       //   ),
          //       // ), // ListView Horizontal Filtered Top Product
          //     ],
          //   ),
          // ),
          footer: const SliverToBoxAdapter(child: Center(child: Text('Fin.'))),
          itemsPerPage: 10000,
          isLive: true,
          //scrollController: _scrollController,
          itemBuilderType: PaginateBuilderType.listView,
          query: FirebaseFirestore.instance
              .collection('Products')
              .orderBy('createdAt', descending: true),
          bottomLoader: const BottomLoader(),
          itemBuilder: (BuildContext, documentSnapshots, index) {
            var data = documentSnapshots[index].data() as Map?;
            String /*var*/ dataid = documentSnapshots[index].id;

            final docidd = data!['userID']; //dataid.toString();
            print(docidd);

            // final DocumentReference _userRef_Document =
            //     FirebaseFirestore.instance.collection('Users').doc(docidd.trim());

            print(data['price']);
            print(
                '/////////////////////////////////////********/////////////////////////////////////////////');
            return data == null
                ? const Text(
                    'Error in data',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Oswald'),
                  )
                : InkWell(
                    child: like_instagram(
                      data: data,
                      user: userm,
                      isLiked:
                          data['usersLike'].toString().contains(userm!.uid),
                      docid: dataid,
                      docidd: docidd.toString(),
                    ),
                    onTap: () async {
                      // await Navigator.push(context,
                      //     MaterialPageRoute(builder: (BuildContext) {
                      //   return Hero(
                      //     tag: 'Hero_Items',
                      //     child: item_details_statefull(
                      //       data: data,
                      //       user: userm,
                      //       isLiked: data['usersLike']
                      //           .toString()
                      //           .contains(userm.uid),
                      //       docid: dataid,
                      //       docidd: docidd.toString(),
                      //     ),
                      //   );
                      // }));
                    },
                  );
          },
        ),
      ),
    );
  }

  directionVent(direction) {
    if (direction >= 0 && direction < 22.5) {
      return 'Nord N';
    }
    if (direction >= 22.5 && direction < 45) {
      return 'Nord NNE';
    }
    if (direction >= 45 && direction < 67.5) {
      return 'Nord NE';
    }
    if (direction >= 67.5 && direction < 90) {
      return 'Est ENE';
    }
    if (direction >= 90 && direction < 112.5) {
      return 'Est E';
    }
    if (direction >= 112.5 && direction < 135) {
      return 'Est ESE';
    }
    if (direction >= 135 && direction < 157.5) {
      return 'Sud SE';
    }
    if (direction >= 157.5 && direction < 180) {
      return 'Sud SSE';
    }
    if (direction >= 180 && direction < 202.5) {
      return 'Sud S';
    }
    if (direction >= 202.5 && direction < 225) {
      return 'Sud SSW';
    }
    if (direction >= 225 && direction < 247.5) {
      return 'Sud SW';
    }
    if (direction >= 247.5 && direction < 270) {
      return 'Ouest WSW';
    }
    if (direction >= 270 && direction < 292.5) {
      return 'Ouest W';
    }
    if (direction >= 292.5 && direction < 315) {
      return 'Ouest WNW';
    }
    if (direction >= 315 && direction < 337.5) {
      return 'Nord NW';
    }
    if (direction >= 337.5 && direction <= 360) {
      return 'Nord NNW';
    }
    print(
        'METEOMETEOMETEOMETEOMETEOMETEOMETEOMETEOMETEOMETEOMETEOMETEOMETEOMETEOMETEOMETEOMETEO');
    //print(directionVent(direction).toString());
  }
}

class like_instagram extends StatefulWidget {
  like_instagram({
    Key? key,
    required Map? data,
    required this.docid,
    required this.user,
    required this.isLiked,
    required this.docidd,
  })  : datam = data,
        //**************
        super(key: key);

  final Map? datam;
  final User? user;
  String docid;
  bool isLiked;
  String docidd;

  @override
  State<like_instagram> createState() => _like_instagramState();
}

class _like_instagramState extends State<like_instagram> {
  bool isHeartAnimating = false;

  //bool isLiked = false;

  final user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          children: [
            buildImage(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      //color: Colors.green,
                      child: HeartAnimationWidget(
                        alwaysAnimate: true,
                        isAnimating: widget.isLiked,
                        dataid: '',
                        user: '',
                        child: IconButton(
                          icon: widget.isLiked
                              ? const Icon(
                                  Icons.favorite,
                                  color: Colors.red,
                                )
                              : const Icon(Icons.favorite_border_outlined,
                                  color: Colors.blueGrey),
                          onPressed: widget.isLiked
                              ? () async {
                                  await FirebaseFirestore.instance
                                      .collection('Products')
                                      .doc(widget.docid)
                                      .update({
                                    'likes': FieldValue.increment(-1),
                                    'usersLike':
                                        FieldValue.arrayRemove([user!.uid]),
                                  });
                                  //setState(() => widget.isLiked = !widget.isLiked);
                                }
                              : () async {
                                  await FirebaseFirestore.instance
                                      .collection('Products')
                                      .doc(widget.docid)
                                      .update({
                                    'likes': FieldValue.increment(1),
                                    'usersLike':
                                        FieldValue.arrayUnion([user!.uid]),
                                  });
                                  //setState(() => widget.isLiked = !widget.isLiked);
                                },
                        ),
                      ),
                    ),
                    Container(
                      //color: Colors.blue,
                      child: Text(
                        intl.NumberFormat.compact(locale: 'fr_IN')
                            .format(widget.datam!['likes']),
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.black54,
                          fontWeight: FontWeight.normal,
                          fontSize: 14,
                          fontFamily: 'Oswald',
                        ),
                      ),
                    ), // Likes Number
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    '${widget.datam!['price']}.00 DZD',
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.black54,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      fontFamily: 'Oswald',
                    ),
                  ),
                ), // Price
              ],
            ), // Likes Number // Price
            ExpansionTile(
              title: const Text(
                'Detail',
                style: TextStyle(
                  color: Colors.black54,
                  fontWeight: FontWeight.normal,
                  fontSize: 15,
                  fontFamily: 'Oswald',
                ),
              ),
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Text(
                      widget.datam!['item'].toUpperCase(),
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.black54,
                        fontWeight: FontWeight.normal,
                        fontSize: 15,
                        fontFamily: 'Oswald',
                      ),
                    ),
                  ),
                ), // Items
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Align(
                      alignment: Alignment.centerLeft,
                      //alignment: Alignment.topLeft,
                      child: widget.datam!['category'] == 'Hotel'
                          ? Text(
                              '${' ' + widget.datam!['category'].toUpperCase()} ',
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                backgroundColor: Colors.white,
                                //Colors.blue,
                                color: Colors.blue,
                                fontWeight: FontWeight.normal,
                                fontSize: 12,
                                fontFamily: 'Oswald',
                              ),
                            )
                          : widget.datam!['category'] == 'Agence'
                              ? Text(
                                  '${' ' + widget.datam!['category'].toUpperCase()} ',
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    backgroundColor: Colors.white,
                                    //Colors.blue,
                                    color: Colors.blue,
                                    fontWeight: FontWeight.normal,
                                    fontSize: 12,
                                    fontFamily: 'Oswald',
                                  ),
                                )
                              : widget.datam!['category'] == 'Residence'
                                  ? Text(
                                      '${' ' + widget.datam!['category'].toUpperCase()} ',
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        backgroundColor: Colors.white,
                                        //Colors.blue,
                                        color: Colors.blue,
                                        fontWeight: FontWeight.normal,
                                        fontSize: 12,
                                        fontFamily: 'Oswald',
                                      ),
                                    )
                                  : widget.datam!['category'] == 'Autres'
                                      ? Text(
                                          '${' ' + widget.datam!['category'].toUpperCase()} ',
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            backgroundColor: Colors.white,
                                            //Colors.blue,
                                            color: Colors.blue,
                                            fontWeight: FontWeight.normal,
                                            fontSize: 12,
                                            fontFamily: 'Oswald',
                                          ),
                                        )
                                      : Text(
                                          '${' ' + widget.datam!['category'].toUpperCase()} ',
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            backgroundColor: Colors.white,
                                            //Colors.blue,
                                            color: Colors.blue,
                                            fontWeight: FontWeight.normal,
                                            fontSize: 12,
                                            fontFamily: 'Oswald',
                                          ),
                                        )),
                ),
              ],
            ), // category
          ],
        ),
      );

  Widget buildImage() => GestureDetector(
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Stack(
              alignment: Alignment.center,
              fit: StackFit.loose,
              clipBehavior: Clip.hardEdge,
              children: [
                AspectRatio(
                  aspectRatio: 1,
                  child: ShaderMask(
                    shaderCallback: (rect) {
                      return const RadialGradient(
                        colors: [Colors.transparent, Colors.black87],
                        tileMode: TileMode.clamp,
                        focalRadius: 1,
                        radius: 1,
                        stops: [0.1, 1],
                        center: Alignment.center,
                      ).createShader(
                          Rect.fromLTRB(0, 0, rect.width, rect.height));
                    },
                    blendMode: BlendMode.darken,
                    child: CachedNetworkImage(
                      fit: BoxFit.cover,
                      imageUrl: widget.datam!['themb'],
                    ),
                  ),
                ),
                Positioned(
                  top: 10,
                  left: 10,
                  // height: 40,
                  // width: 300,
                  child: FutureBuilder(
                    future: FirebaseFirestore.instance
                        .collection('Users')
                        .doc(widget.docidd.trim())
                        .get(),
                    //.where('userID', isEqualTo: userIDD).get(),
                    builder: (BuildContext context,
                        AsyncSnapshot<dynamic> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Text('...');
                      } else if (snapshot.connectionState ==
                          ConnectionState.done) {
                        if (snapshot.hasError) {
                          return const Text('error user');
                        } else if (snapshot.hasData) {
                          if (snapshot.data.data() != null) {
                            return Row(
                              children: [
                                Container(
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            width: 2, color: Colors.white),
                                        borderRadius:
                                            BorderRadius.circular(100)),
                                    child: InkWell(
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          child: CachedNetworkImage(
                                            imageUrl: snapshot.data
                                                .data()['userAvatar'],
                                            height: 30,
                                            width: 30,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        onTap: () async {
                                          await Navigator.push(context,
                                              MaterialPageRoute(builder:
                                                  (BuildContext context) {
                                            return ProfileOthers(
                                                data: snapshot.data.data());

                                            Container(
                                              child: Center(
                                                child: Text(
                                                  snapshot.data.data()[
                                                      'userDisplayName'],
                                                  style: const TextStyle(
                                                      color: Colors.redAccent),
                                                ),
                                              ),
                                            );
                                          }));
                                        })),
                                Padding(
                                  padding: const EdgeInsets.all(6.0),
                                  child: Text(
                                    snapshot.data['userDisplayName'],
                                    style: const TextStyle(
                                        fontSize: 15,
                                        fontFamily: 'Oswald',
                                        fontWeight: FontWeight.normal,
                                        color: Colors.white),
                                  ),
                                ),
                              ],
                            );
                          } else {
                            return Row(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          width: 2, color: Colors.white),
                                      borderRadius: BorderRadius.circular(100)),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: CachedNetworkImage(
                                      imageUrl:
                                          'https://source.unsplash.com/random/?city,night',
                                      height: 30,
                                      width: 30,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                const Padding(
                                  padding: EdgeInsets.all(6.0),
                                  child: Text(
                                    'NADA',
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontFamily: 'Oswald',
                                        fontWeight: FontWeight.normal,
                                        color: Colors.white),
                                  ),
                                ),
                              ],
                            );
                          }
                        } else {
                          return const Text('Empty Data');
                        }
                      } else {
                        return Text('State : ${snapshot.connectionState}');
                      }
                    },
                  ),
                ),
                Positioned(
                  top: 140,
                  left: 140,
                  child: Opacity(
                    opacity: isHeartAnimating ? 1 : 0,
                    child: HeartAnimationWidget(
                      isAnimating: isHeartAnimating,
                      duration: const Duration(milliseconds: 700),
                      onEnd: () => setState(
                        () => isHeartAnimating = false,
                      ),
                      user: widget.user!.uid,
                      dataid: widget.docid,
                      child: const Icon(
                        Icons.favorite,
                        color: Colors.redAccent,
                        size: 80,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 10,
                  right: 15,
                  child: Text(
                      timeago.format(widget.datam!['createdAt'].toDate(),
                          locale: 'fr'),
                      textAlign: TextAlign.end,
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
        onDoubleTap: () {
          widget.isLiked
              ? setState(() {
                  isHeartAnimating = false;
                  //widget.isLiked = false;
                })
              : setState(() {
                  isHeartAnimating = true;
                  widget.isLiked = true;
                  FirebaseFirestore.instance
                      .collection('Products')
                      .doc(widget.docid)
                      .update({
                    'likes': FieldValue.increment(1),
                    'usersLike': FieldValue.arrayUnion([user!.uid]),
                  });
                });
        },
      );

// Widget buildAction(dataid) {
//   final icon =
//       widget.isLiked ? Icons.favorite : Icons.favorite_border_outlined;
//   final color = widget.isLiked ? Colors.red : Colors.grey;
//
//   return HeartAnimationWidget(
//     alwaysAnimate: true,
//     isAnimating: widget.isLiked,
//     dataid: '',
//     user: '',
//     child: IconButton(
//       icon: Icon(icon, color: color, size: 20),
//       onPressed: widget.isLiked ? likeVerification(dataid) : likeVerification(dataid),
//     ),
//   );
// }

// likeVerification(dataid) async {
//   await FirebaseFirestore.instance
//       .collection('Products')
//       .doc(dataid)
//       .update({
//     'likes':
//     FieldValue.increment(-1),
//     'usersLike':
//     FieldValue.arrayRemove(
//         [user!.uid]),
//   })
//   setState(() => widget.isLiked = !widget.isLiked);
// }
}

class HeartAnimationWidget extends StatefulWidget {
  final Widget child;
  final bool isAnimating;
  final bool alwaysAnimate;
  final Duration duration;
  final VoidCallback? onEnd;

  final String user;
  final String dataid;

  const HeartAnimationWidget({
    Key? key,
    required this.child,
    required this.isAnimating,
    this.alwaysAnimate = false,
    this.duration = const Duration(milliseconds: 150),
    this.onEnd,
    required this.user,
    required this.dataid,
  }) : super(key: key);

  @override
  State<HeartAnimationWidget> createState() => _HeartAnimationWidgetState();
}

class _HeartAnimationWidgetState extends State<HeartAnimationWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> scale;

  @override
  void initState() {
    super.initState();
    final halfDuration = widget.duration.inMilliseconds ~/ 2;
    controller = AnimationController(
        vsync: this, duration: Duration(milliseconds: halfDuration));
    scale = Tween<double>(begin: 1, end: 1.2).animate(controller);
  }

  @override
  void didUpdateWidget(HeartAnimationWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isAnimating != oldWidget.isAnimating) {
      doAnimation();
    }
  }

  Future doAnimation() async {
    if (widget.isAnimating || widget.alwaysAnimate) {
      await controller.forward();
      await controller.reverse();
      await Future.delayed(const Duration(milliseconds: 400));
      if (widget.onEnd != null) {
        widget.onEnd!();
      }
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ScaleTransition(
      scale: scale,
      child: SizedBox(height: 40, width: 33, child: widget.child));
}
