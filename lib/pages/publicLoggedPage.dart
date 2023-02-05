import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Oauth/Ogoogle/googleSignInProvider.dart';

class publicLoggerPage extends StatelessWidget {
  const publicLoggerPage({
    Key? key,
    required this.datta,
  }) : super(key: key);

  final DocumentSnapshot<Object?>? datta;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            datta!.exists
                ? Text(
                    'PUBLIC LOGGED \n ${datta!['role']}',
                    style: TextStyle(fontSize: 40, color: Colors.green),
                  )
                : Text(
                    'PUBLIC LOGGED \n no data',
                    style: TextStyle(fontSize: 40, color: Colors.green),
                  ),
            Padding(
              padding: const EdgeInsets.all(28.0),
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
                onPressed: () async {
                  FirebaseAuth.instance.signOut();
                  final provider =
                      Provider.of<googleSignInProvider>(context, listen: false);
                  await provider.logouta();
                  // Navigator.of(context).pop();
                  // Navigator.pop(context, true);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
