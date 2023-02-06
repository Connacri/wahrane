import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:provider/provider.dart';
import 'package:wahrane/pages/PublicHomeLIst.dart';
import 'package:wahrane/pages/adminLoggedPage.dart';
import 'package:wahrane/pages/publicLoggedPage.dart';
import 'package:wahrane/pages/unloggerPublicPage.dart';

import 'Oauth/Ogoogle/googleSignInProvider.dart';
import 'exemple/screens/sign_in_screen.dart';
import 'exemple/widgets/google_sign_in_button.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      //options: DefaultFirebaseOptions.currentPlatform,
      );

  FlutterNativeSplash.removeAfter(initialization);
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky,
      overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom]);
  runApp(Materialclass());
}

Future initialization(BuildContext? context) async {
  Future.delayed(Duration(seconds: 5));
}

final navigatorKey = GlobalKey<NavigatorState>();

/// This is the main application widget.
class Materialclass extends StatelessWidget {
  Materialclass({Key? key}) : super(key: key);

  static const String _title = 'Oran ';
  final GoogleUser2 = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => googleSignInProvider(),
      lazy: true,
      child: MaterialApp(
        locale: const Locale('fr', ''),
        //scaffoldMessengerKey: Utils.messengerKey,
        navigatorKey: navigatorKey,
        debugShowCheckedModeBanner: false,
        title: _title,
        themeMode: ThemeMode.dark,
        theme: ThemeData(
          useMaterial3: true,
          fontFamily: "Oswald",
        ),
        home: //SignInScreen(),
            verifi_auth(),
      ),
    );
  }
}

class verifi_auth extends StatefulWidget {
  const verifi_auth({Key? key}) : super(key: key);

  @override
  State<verifi_auth> createState() => _verifi_authState();
}

class _verifi_authState extends State<verifi_auth> {
  @override
  Widget build(BuildContext context) => StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return const Center(child: Text('Probleme de Connexion'));
          }
          if (snapshot.hasData) {
            final userD = snapshot.data!.uid;
            return CheckRole(userD); //MultiProviderWidget();
          } else {
            return unloggedPublicPage(); //publicHomeList(); //
          }
        },
      );
}

class CheckRole extends StatelessWidget {
  final String documentId;

  CheckRole(this.documentId);

  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('Users');

    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection("Users")
          .doc(documentId)
          .snapshots(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          // Handle error
          return Center(child: Text("Error: ${snapshot.error}"));
        }

        // Document exists, retrieve data
        var data = snapshot.data;
        if (data!.exists) {
          var userRole = data['role'];
          // Check user role
          if (userRole == "admin") {
            return adminLoggedPage();
          } else {
            return
                //   Scaffold(
                //   appBar: AppBar(),
                //   body: Center(
                //     child: Text('publicLoggerPage'),
                //   ),
                // );
                publicLoggerPage(
              datta: data,
            );
          }
        } else
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('Marhba Bik'),
                  ElevatedButton(
                      onPressed: () => Navigator.pushNamedAndRemoveUntil(
                          context, '/', (_) => false),
                      child: Text('aya nebdou')),
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
                        final provider = Provider.of<googleSignInProvider>(
                            context,
                            listen: false);
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
      },
    );

    // FutureBuilder<DocumentSnapshot>(
    //   future: users.doc(documentId).get(),
    //   builder:
    //       (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
    //     if (snapshot.hasError) {
    //       return Text("Something went wrong");
    //     }
    //
    //     if (snapshot.hasData && !snapshot.data!.exists) {
    //       return Scaffold(
    //         backgroundColor: Colors.white,
    //         appBar: AppBar(
    //           title: FittedBox(
    //             child: Text('Bienvenue'),
    //           ),
    //           centerTitle: true,
    //         ),
    //         body: Center(
    //           child: Padding(
    //             padding:
    //                 const EdgeInsets.symmetric(vertical: 8, horizontal: 38),
    //             child: Column(
    //               mainAxisAlignment: MainAxisAlignment.center,
    //               crossAxisAlignment: CrossAxisAlignment.center,
    //               children: [
    //                 Padding(
    //                   padding: const EdgeInsets.all(58.0),
    //                   child: ElevatedButton(
    //                     child: Text('Log Out'),
    //                     onPressed: () {
    //                       googleSignInProvider().logouta();
    //                     },
    //                   ),
    //                 ),
    //                 Padding(
    //                   padding: const EdgeInsets.all(58.0),
    //                   child: ElevatedButton(
    //                     child: Text('Start'),
    //                     onPressed: () {
    //                       Navigator.of(context).pushNamedAndRemoveUntil(
    //                           '/', (Route<dynamic> route) => false);
    //                     },
    //                   ),
    //                 ),
    //               ],
    //             ),
    //           ),
    //         ),
    //       );
    //     }
    //
    //     if (snapshot.connectionState == ConnectionState.done) {
    //       Map<String, dynamic> userRole =
    //           snapshot.data!.data() as Map<String, dynamic>;
    //       if (userRole['Role'] == 'admin') {
    //         return adminLoggedPage();
    //       } else {
    //         return publicLoggerPage();
    //       }
    //     }
    //
    //     return Center(child: CircularProgressIndicator());
    //   },
    // );
  }
}
