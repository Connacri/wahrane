import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../services/FirebaseService.dart';
import 'PublicHomeLIst.dart';

class SilverdetailItem extends StatelessWidget {
  SilverdetailItem({
    Key? key,
    required this.data,
    required this.idDoc,
  }) : super(key: key);

//  final String UnsplashUrl;
  final Map data;
  final String idDoc;
  // final int intex;
  final CollectionReference docProducts =
      FirebaseFirestore.instance.collection("Products");
  final String userId = FirebaseAuth.instance.currentUser!.uid;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: CustomScrollView(
          slivers: <Widget>[
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
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 15),
                      child: Text(
                        data['code'],
                        style: TextStyle(
                            fontFamily: 'oswald',
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                    Text(
                      ' - ' + data['category'],
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'oswald'),
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
                    imageUrl: data['themb'],
                    errorWidget: (context, url, error) => const Icon(
                      Icons.error,
                      color: Colors.red,
                    ),
                  ),
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  Padding(
                    padding: new EdgeInsets.symmetric(horizontal: 20.0),
                    child: new Text(
                      'Category : ' + data['category'],
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'oswald'),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: new EdgeInsets.symmetric(horizontal: 20.0),
                      child: new Text(
                        'Price : ' +
                            NumberFormat.currency(
                                    symbol: 'DZ ', decimalDigits: 2)
                                .format(data['price']),
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            //backgroundColor: Colors.black45,
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Colors.green,
                            fontFamily: 'oswald'),
                      ),
                    ),
                  ),
                  Container(
                    height: 200.0,
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      itemCount: data['imageUrls'].length,
                      itemBuilder: (BuildContext context, int index) {
                        return UnsplashSlider(
                            UnsplashUrl: data['imageUrls'][index]);
                      },
                    ),
                  ),
                  Center(
                    child: Padding(
                      padding: new EdgeInsets.all(20.0),
                      child: Text(
                        'Size : ' + data['item'],
                        style: TextStyle(
                            color: Colors.red,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'oswald'),
                      ),
                    ),
                  ),
                  Padding(
                    padding: new EdgeInsets.symmetric(horizontal: 20.0),
                    child: Text(
                      'Description : ' + data['Description'],
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'oswald'),
                    ),
                  ),
                  Padding(
                    padding: new EdgeInsets.all(20.0),
                    child: Text(
                      'Made In ' + data['code'],
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, fontFamily: 'oswald'),
                    ),
                  ),
                  Padding(
                      padding: new EdgeInsets.symmetric(horizontal: 20.0),
                      child: new Text(
                          'Le Lorem Ipsum est simplement du faux texte employé dans la composition et la mise en page avant impression. Le Lorem Ipsum est le faux texte standard de l\'imprimerie depuis les années 1500, quand un imprimeur anonyme assembla ensemble des morceaux de texte pour réaliser un livre spécimen de polices de texte. Il n\'a pas fait que survivre cinq siècles, mais s\'est aussi adapté à la bureautique informatique, sans que son contenu n\'en soit modifié. Il a été popularisé dans les années 1960 grâce à la vente de feuilles Letraset contenant des passages du Lorem Ipsum, et, plus récemment, par son inclusion dans des applications de mise en page de texte, comme Aldus PageMaker.',
                          textAlign: TextAlign.justify,
                          style: new TextStyle(
                              fontSize: 18.0, fontFamily: 'oswald'))),
                  Padding(
                      padding: new EdgeInsets.all(20.0),
                      child: new Text('Item ${2.toString()}',
                          style: new TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                              fontSize: 25.0,
                              fontFamily: 'oswald'))),
                  Padding(
                      padding: new EdgeInsets.symmetric(horizontal: 20.0),
                      child: new Text(
                          "At vero eos et accusamus et iusto odio dignissimos ducimus qui blanditiis praesentium voluptatum deleniti atque corrupti quos dolores et quas molestias excepturi sint occaecati cupiditate non provident, similique sunt in culpa qui officia deserunt mollitia animi, id est laborum et dolorum fuga. Et harum quidem rerum facilis est et expedita distinctio. Nam libero tempore, cum soluta nobis est eligendi optio cumque nihil impedit quo minus id quod maxime placeat facere possimus, omnis voluptas assumenda est, omnis dolor repellendus. Temporibus autem quibusdam et aut officiis debitis aut rerum necessitatibus saepe eveniet ut et voluptates repudiandae sint et molestiae non recusandae. Itaque earum rerum hic tenetur a sapiente delectus, ut aut reiciendis voluptatibus maiores alias consequatur aut perferendis doloribus asperiores repellat.",
                          textAlign: TextAlign.justify,
                          style: new TextStyle(
                              fontSize: 18.0, fontFamily: 'oswald'))),
                ],
              ),
            ),
            data['userID'] == userId
                ? SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(58.0),
                      child: ElevatedButton(
                        onPressed: () async {
                          // Get the document from Firestore
                          docProducts
                              .doc(idDoc)
                              .get()
                              .then((documentSnapshot) async {
                            print(userId);
                            print(data['userID']);
                            if (documentSnapshot.exists) {
                              // Document exists, check if the field is equal to user ID
                              var data = documentSnapshot;
                              final String fieldValue = data['userID'];
                              if (fieldValue == userId) {
                                await docProducts
                                    .doc(idDoc)
                                    .delete()
                                    .whenComplete(
                                        () => Navigator.of(context).pop());
                              }
                            } else {
                              print(
                                  'tu n\'est pas le proprietaire du document');
                            }
                          }).catchError((error) {
                            // Handle the error
                          });
                        },
                        child: Text('Delete'),
                      ),
                    ),
                  )
                : SliverToBoxAdapter(
                    child: Container(),
                  ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 100,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
