import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:wahrane/pages/addPost.dart';

import 'pages/Profile.dart';
import 'pages/publicLoggedPage.dart';

class NavigationExample extends StatefulWidget {
  NavigationExample({Key? key, required this.userDoc}) : super(key: key);
  final userDoc;

  @override
  State<NavigationExample> createState() => _NavigationExampleState();
}

class _NavigationExampleState extends State<NavigationExample> {
  int currentPageIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        foregroundColor: Colors.transparent,
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) {
            return stepper_widget();
          }));
        },
        child: const Icon(
          FontAwesomeIcons.add,
          color: Colors.black54,
        ),
      ),
      bottomNavigationBar: NavigationBar(
        height: 60,
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        selectedIndex: currentPageIndex,
        destinations: <Widget>[
          NavigationDestination(
            icon: Icon(FontAwesomeIcons.home),
            label: 'Home',
          ),
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
        publicLoggerPage(
          datta: widget.userDoc,
        ),
        Profile(),
      ][currentPageIndex],
    );
  }
}
