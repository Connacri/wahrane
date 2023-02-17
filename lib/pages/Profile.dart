import 'package:avatar_glow/avatar_glow.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterflow_paginate_firestore/paginate_firestore.dart';
import 'package:flutterflow_paginate_firestore/widgets/bottom_loader.dart';
import 'package:flutterflow_paginate_firestore/widgets/empty_display.dart';
import 'package:flutterflow_paginate_firestore/widgets/empty_separator.dart';
import 'package:flutterflow_paginate_firestore/widgets/initial_loader.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import '../Oauth/Ogoogle/googleSignInProvider.dart';
import '../services/upload_random.dart';
import 'itemDetails.dart';

class Profile extends StatelessWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userGoo = FirebaseAuth.instance.currentUser;
    return Scaffold(
      backgroundColor: Colors.white,
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection('Users')
            .doc(userGoo!.uid)
            .get(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return Icon(Icons.error);
          }

          if (snapshot.hasData && !snapshot.data!.exists) {
            return Icon(Icons.account_box);
          }

          if (snapshot.connectionState == ConnectionState.done) {
            Map<String, dynamic> data =
                snapshot.data!.data() as Map<String, dynamic>;
            return CustomScrollView(slivers: <Widget>[
              SliverAppBar(
                expandedHeight: 220.0,
                floating: true,
                pinned: true,
                snap: true,
                elevation: 50,
                backgroundColor: Colors.black38,
                flexibleSpace: FlexibleSpaceBar(
                  centerTitle: true,
                  title: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 15),
                        child: Text(
                          data['displayName'] ?? 'null',
                          overflow: TextOverflow.fade,
                          style: TextStyle(
                              fontFamily: 'oswald',
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                      Spacer(),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 2),
                        child: Text(
                          data['email'],
                          style: TextStyle(fontSize: 8),
                        ),
                      ),
                    ],
                  ),
                  background: ShaderMask(
                    shaderCallback: (rect) {
                      return const LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomLeft,
                        colors: [Colors.transparent, Colors.black],
                      ).createShader(
                          Rect.fromLTRB(0, 0, rect.width, rect.height));
                    },
                    blendMode: BlendMode.darken,
                    child: CachedNetworkImage(
                      fit: BoxFit.cover,
                      imageUrl: data['timeline'] ??
                          'https://source.unsplash.com/random?sig=20*3+1',
                      errorWidget: (context, url, error) => const Icon(
                        Icons.error,
                        color: Colors.red,
                      ),
                    ),
                  ),
                ),
              ),
              SliverList(
                  delegate: SliverChildListDelegate([
                Column(
                  children: [
                    Stack(
                      children: [
                        AvatarGlow(
                          glowColor: Colors.black54,
                          endRadius: 60.0,
                          child: Material(
                            elevation: 8.0,
                            shape: CircleBorder(),
                            child: CircleAvatar(
                              backgroundImage: NetworkImage(data['avatar']),
                              radius: 30.0,
                            ),
                          ),
                        ),
                        Positioned(
                          right: 27,
                          bottom: 27,
                          child: Icon(
                            Icons.check_circle,
                            color: Colors.blue,
                          ),
                        )
                      ],
                    ),
                    Text(data['displayName'].toUpperCase()),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        userGoo.emailVerified == true
                            ? Icon(
                                Icons.check_circle,
                                color: Colors.blue,
                              )
                            : Icon(
                                Icons.not_interested_outlined,
                                color: Colors.red,
                              ),
                        Text(userGoo.email.toString().toUpperCase()),
                      ],
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(userGoo.emailVerified != true
                      ? 'Email Not Verified'
                      : ''),
                ),
                Text(userGoo.phoneNumber != null
                    ? userGoo.phoneNumber.toString()
                    : ' '.toUpperCase()),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 38),
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                        primary: Colors.black54,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                        elevation: 4.0,
                        minimumSize: const Size.fromHeight(50)),
                    icon: Icon(
                      Icons.cancel,
                      color: Colors.red,
                    ),
                    label: const Text(
                      'Deconnexion',
                      style: TextStyle(fontSize: 24, color: Colors.white),
                    ),
// onPressed: () async {
//   final provider =
//       Provider.of<googleSignInProvider>(context, listen: false);
//   await provider.logout().whenComplete(() =>
//       Navigator.of(context).pushAndRemoveUntil(
//           MaterialPageRoute(builder: (context) {
//         return NavigationExample();
//       }), ModalRoute.withName('/')));
//   // (route) => true
// },
// onPressed: () {
//   FirebaseAuth.instance.signOut();
//   final provider =
//       Provider.of<googleSignInProvider>(context, listen: false);
//   provider.logout();
//   // Navigator.of(context).pop();
//
//   // Navigator.of(context).push(MaterialPageRoute(
//   //   builder: (context) => verifi_auth(),
//   // ));
// },
                    onPressed: () async {
                      FirebaseAuth.instance.signOut();
                      final provider = Provider.of<googleSignInProvider>(
                          context,
                          listen: false);
                      await provider.logouta();
// Navigator.of(context).pop();
                      Navigator.pop(context, true);
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 50),
                  child: IconButton(
                    icon: Icon(
                      Icons.add_box_rounded,
                      color: Colors.blue,
                    ),
                    onPressed: () async {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => upload_random()));
                    },
                  ),
                ),
              ])),
              SliverList(
                delegate: SliverChildListDelegate([
                  PaginateFirestore(
                    physics: NeverScrollableScrollPhysics(),
                    itemsPerPage: 10000,
                    onEmpty: const EmptyDisplay(),
                    separator: const EmptySeparator(),
                    initialLoader: const InitialLoader(),
                    bottomLoader: const BottomLoader(),
                    shrinkWrap: true,
                    itemBuilderType: PaginateBuilderType.listView,
                    query: FirebaseFirestore.instance
                        .collection("Products")
                        .where("userID", isEqualTo: userGoo.uid),
                    //.orderBy('createdAt', descending: true)
                    //.limit(5)
                    // .orderBy('createdAt', descending: true),
                    itemBuilder: (BuildContext context,
                        List<DocumentSnapshot<Object?>> list, int index) {
                      var document = list[index];
                      return ListTile(
                        trailing: IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () async {
                            await showConfirmationDialog(
                                context, list[index].id);
                          },
                        ),
                        leading: GestureDetector(
                          onDoubleTap: () =>
                              Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => SilverdetailItem(
                              data: data!,
                              idDoc: list[index].id,
                            ),
                          )),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(5),
                            child: Container(
                              height: 50,
                              width: 50,
                              child: CachedNetworkImage(
                                imageUrl: document['themb'],
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        title: new Text(
                          document["item"],
                          overflow: TextOverflow.ellipsis,
                        ),
                      );
                    },
                  ),
                  // StreamBuilder<QuerySnapshot>(
                  //   stream: FirebaseFirestore.instance
                  //       .collection("Products")
                  //       .where("userID", isEqualTo: userGoo.uid)
                  //       //.orderBy('createdAt', descending: true)
                  //       .limit(5)
                  //       .snapshots(),
                  //   builder: (BuildContext context,
                  //       AsyncSnapshot<QuerySnapshot> snapshot) {
                  //     if (snapshot.hasError)
                  //       return new Text('Error: ${snapshot.error}');
                  //     switch (snapshot.connectionState) {
                  //       case ConnectionState.waiting:
                  //         return new Text('Loading...');
                  //       default:
                  //         return new ListView(
                  //           physics: NeverScrollableScrollPhysics(),
                  //           shrinkWrap: true,
                  //           children: snapshot.data!.docs
                  //               .map((DocumentSnapshot document) {
                  //             var data = document.data() as Map?;
                  //
                  //             return new ListTile(
                  //               trailing: IconButton(
                  //                 icon: Icon(Icons.delete),
                  //                 onPressed: () async {
                  //                   await showConfirmationDialog(
                  //                       context, document.id);
                  //                 },
                  //               ),
                  //               leading: GestureDetector(
                  //                 onDoubleTap: () => Navigator.of(context)
                  //                     .push(MaterialPageRoute(
                  //                   builder: (context) => SilverdetailItem(
                  //                     data: data!,
                  //                     idDoc: document.id,
                  //                   ),
                  //                 )),
                  //                 child: ClipRRect(
                  //                   borderRadius: BorderRadius.circular(5),
                  //                   child: Container(
                  //                     height: 50,
                  //                     width: 50,
                  //                     child: CachedNetworkImage(
                  //                       imageUrl: document['themb'],
                  //                       fit: BoxFit.cover,
                  //                     ),
                  //                   ),
                  //                 ),
                  //               ),
                  //               title: new Text(
                  //                 document["item"],
                  //                 overflow: TextOverflow.ellipsis,
                  //               ),
                  //             );
                  //           }).toList(),
                  //         );
                  //     }
                  //   },
                  // )
                ]),
              )
            ]);
          }

          return Text("loading");
        },
      ),
    );
  }
}

Future<bool?> showConfirmationDialog(BuildContext context, String documentID) {
  return showDialog<bool>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Confirmation'),
        content: Text('Etes Vous Sur De Proceder à La Supression?'),
        actions: <Widget>[
          ElevatedButton(
            child: Text('No'),
            onPressed: () => Navigator.of(context).pop(false),
          ),
          ElevatedButton(
            child: Text('Yes'),
            onPressed: () async {
              await FirebaseFirestore.instance
                  .collection('Products')
                  .doc(documentID)
                  .delete()
                  .whenComplete(
                    () => Navigator.of(context).pop(),
                  );
            },
          ),
        ],
      );
    },
  );
}
