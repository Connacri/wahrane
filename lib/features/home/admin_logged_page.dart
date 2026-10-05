import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wahrane/features/auth/google_sign_in_provider.dart';

class AdminLoggedPage extends StatefulWidget {
  const AdminLoggedPage({Key? key}) : super(key: key);

  @override
  State<AdminLoggedPage> createState() => _adminLoggedPageState();
}

class _adminLoggedPageState extends State<AdminLoggedPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'ADMIN',
              style: TextStyle(fontSize: 40),
            ),
            Padding(
              padding: const EdgeInsets.all(28.0),
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black54,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    elevation: 4.0,
                    minimumSize: const Size.fromHeight(50)),
                icon: const Icon(
                  Icons.cancel,
                  color: Colors.red,
                ),
                label: const Text(
                  'Deconnexion',
                  style: TextStyle(fontSize: 24, color: Colors.white),
                ),
                // onPressed: () async {
                //   final provider =
                //       Provider.of<GoogleSignInProvider>(context, listen: false);
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
                //       Provider.of<GoogleSignInProvider>(context, listen: false);
                //   provider.logout();
                //   // Navigator.of(context).pop();
                //
                //   // Navigator.of(context).push(MaterialPageRoute(
                //   //   builder: (context) => AuthGate(),
                //   // ));
                // },
                onPressed: () async {
                  FirebaseAuth.instance.signOut();
                  final provider =
                      Provider.of<GoogleSignInProvider>(context, listen: false);
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
