import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileOthers extends StatelessWidget {
  const ProfileOthers({
    Key? key,
    required Map? data,
  })  : datauser = data,
        //**************
        super(key: key);

  final Map? datauser;

  final double coverHeight = 200;
  final double profileHeight = 90;
  final bool _enabled = true;

  @override
  Widget build(BuildContext context) {
    final topPic = coverHeight - profileHeight - 35;
    return Scaffold(
      body: ListView(
        // mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              BuildCoverImage(),
              // Positioned(top: topPic, child: Container(child: BuildProfileImage())),
              Positioned(
                top: topPic,
                child: Material(
                  elevation: 8.0,
                  shape: const CircleBorder(),
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(width: 4, color: Colors.white),
                        borderRadius: BorderRadius.circular(100)),
                    child: Stack(
                      //alignment : Alignment.center,
                      fit: StackFit.passthrough,
                      children: [
                        CircleAvatar(
                            radius: profileHeight / 2,
                            backgroundImage: datauser!['userAvatar'] != null
                                ? NetworkImage(datauser!['userAvatar'])
                                : const NetworkImage(
                                    'https://source.unsplash.com/random/900×700/?fruit',
                                  )
                            //'https://source.unsplash.com/random?sig=8'),
                            ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Center(
            child: Text(
              datauser!['displayName'].toUpperCase(),
              style: const TextStyle(
                  color: Colors.black54,
                  overflow: TextOverflow.ellipsis,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Oswald',
                  fontSize: 20),
            ),
          ),
          Center(
            child: Text(
              datauser!['email'].toUpperCase(),
              style: const TextStyle(
                color: Colors.black45,
                fontWeight: FontWeight.normal,
                fontFamily: 'Oswald',
                fontSize: 10,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 10),
            child: ElevatedButton.icon(
              onPressed: () {},
              icon: datauser!['plan'] == 'premium'
                  ? const Icon(
                      Icons.workspace_premium,
                      color: Colors.amber,
                      size: 40,
                    )
                  : const Icon(
                      Icons.workspace_premium,
                      color: Colors.blueGrey,
                      size: 40,
                    ),
              label: Text(
                datauser!['plan'].toUpperCase(),
                style: const TextStyle(
                  fontWeight: FontWeight.normal,
                  fontFamily: 'Oswald',
                  fontSize: 14,
                  overflow: TextOverflow.ellipsis,
                ),
              ), // <-- Text
            ),
          ),
          FutureBuilder<QuerySnapshot>(
            future: FirebaseFirestore.instance
                .collection('Products')
                .where('userID', isEqualTo: datauser!['userID'])
                //.limit(3)
                //.orderBy('createdAt', descending: true)
                .get(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return const Text('Something went wrong');
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return
                    // Shimmer.fromColors(
                    //   baseColor: Colors.grey.shade300,
                    //   highlightColor: Colors.grey.shade100,
                    //   enabled: _enabled,
                    //   child:
                    Container();
                //   ); //Text("Loading");
              }

              return Padding(
                padding: const EdgeInsets.all(18.0),
                child: ListView(
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  physics: const NeverScrollableScrollPhysics(),
                  children:
                      snapshot.data!.docs.map((DocumentSnapshot document) {
                    Map<String, dynamic> data =
                        document.data()! as Map<String, dynamic>;
                    if (data.length >= 6) {
                      print('vous devez acheter premium');
                    }
                    final userm = FirebaseAuth.instance.currentUser;
                    return Card(
                      clipBehavior: Clip.antiAlias,
                      elevation: 1,
                      child: ListTile(
                        minLeadingWidth: 0,
                        visualDensity: VisualDensity.compact,
                        //contentPadding: EdgeInsets.zero,
                        leading: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(5),
                            child: CachedNetworkImage(
                              imageUrl: data['themb'],
                              height: 40,
                              width: 40,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        title: Text(
                          data['item'], //.toUpperCase(),
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.black45,
                            fontWeight: FontWeight.normal,
                            fontSize: 15,
                            fontFamily: 'Oswald',
                          ),
                        ),
                        subtitle: Text(
                          '${data['price']}.00 DZD',
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            fontFamily: 'Oswald',
                          ),
                        ),
                        isThreeLine: true,
                        dense: true,
                        trailing: userm!.uid != datauser!['userID']
                            ? Text('')
                            : IconButton(
                                icon: Icon(Icons.delete),
                                // onPressed: () {
                                //   FirebaseFirestore.instance
                                //       .collection('Products')
                                //       .doc(document.id)
                                //       .delete();
                                // },
                                onPressed: () {
                                  FirebaseFirestore.instance
                                      .collection('Users')
                                      .doc(datauser!['userID'])
                                      .update({
                                    'userItemsNbr': FieldValue.increment(-1)
                                  }).whenComplete(() => FirebaseFirestore
                                          .instance
                                          .collection(
                                              'Products') //.collection('cart')
                                          .doc(document.id)
                                          .delete());

                                  Navigator.pop(context, true);
                                },
                              ),
                        onTap: () async {
                          // await Navigator.push(context,
                          //     MaterialPageRoute(builder: (BuildContext) {
                          //   return Hero(
                          //     tag: 'Hero_Items',
                          //     child: item_details(
                          //       data: data,
                          //       user: userm,
                          //       isLiked: data['usersLike']
                          //           .toString()
                          //           .contains(userm.uid),
                          //       docid: document.id,
                          //       docidd: datauser!['userID'],
                          //     ),
                          //   );
                          // }));
                        },
                      ),
                    );
                  }).toList(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget BuildCoverImage() => Container(
        color: Colors.grey,
        child: CachedNetworkImage(
          imageUrl: 'https://source.unsplash.com/random/?city,night',
          //'https://source.unsplash.com/random',
          //'https://source.unsplash.com/random?sig=15',
          width: double.infinity,
          height: coverHeight,
          fit: BoxFit.cover,
        ),
      );

  Widget BuildProfileImage() => Stack(
        //alignment : Alignment.center,
        fit: StackFit.passthrough,
        children: [
          CircleAvatar(
              radius: profileHeight / 2,
              backgroundImage: datauser != null
                  ? NetworkImage(datauser!['userAvatar'])
                  : const NetworkImage(
                      'https://source.unsplash.com/random/900×700/?fruit',
                    )
              //'https://source.unsplash.com/random?sig=8'),
              ),
        ],
      );
}
