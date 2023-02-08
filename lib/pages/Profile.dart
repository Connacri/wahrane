import 'package:avatar_glow/avatar_glow.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import '../Oauth/Ogoogle/googleSignInProvider.dart';
import '../services/upload_random.dart';

class Profile extends StatelessWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userGoo = FirebaseAuth.instance.currentUser;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Stack(
            alignment: Alignment.bottomCenter,
            children: [
              // Lottie.asset(
              //   'assets/lotties/132349-business-woman.json',
              //   repeat: true,
              //   // reverse: true,
              //   animate: true,
              // ),
              Column(
                children: [
                  Stack(
                    children: [
                      AvatarGlow(
                        glowColor: Colors.black54,
                        endRadius: 60.0,
                        child: Material(
                          // Replace this child with your own
                          elevation: 8.0,
                          shape: CircleBorder(),
                          child: CircleAvatar(
                            backgroundImage:
                                NetworkImage(userGoo!.photoURL.toString()),
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
                  Text(userGoo.displayName.toString().toUpperCase()),
                  //Text(authInfo.user.email),
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
            ],
          ),
          // Text(prov.userAvatar),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child:
                Text(userGoo.emailVerified != true ? 'Email Not Verified' : ''),
          ),
          Text(userGoo.phoneNumber != null
              ? userGoo.phoneNumber.toString()
              : ' '.toUpperCase()),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 38),
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
                final provider =
                    Provider.of<googleSignInProvider>(context, listen: false);
                await provider.logouta();
                // Navigator.of(context).pop();
                Navigator.pop(context, true);
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 50, vertical: 50),
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                  primary: Colors.blueGrey,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  elevation: 4.0,
                  minimumSize: const Size.fromHeight(50)),
              icon: Icon(
                Icons.cancel,
                color: Colors.red,
              ),
              label: const Text(
                'upload_random',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
              onPressed: () async {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => upload_random()));
              },
            ),
          ),
          // Google
          // IconButton(
          //   icon: const Icon(Icons.logout),
          //   tooltip: 'Déconnexion',
          //   onPressed: () {
          //     FirebaseAuth.instance.signOut();
          //     final provider =
          //         Provider.of<googleSignInProvider>(context, listen: false);
          //     provider.logout();
          //     Navigator.of(context).pop();
          //   },
          // ),
        ],
      ),
    );
  }
}
