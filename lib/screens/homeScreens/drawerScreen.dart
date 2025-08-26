import 'package:coachandstudent/auth/firebaseAuth.dart';
import 'package:coachandstudent/auth/sessionController.dart';
import 'package:coachandstudent/auth/userNameAuth.dart';
import 'package:coachandstudent/auth/userPPAuth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class DrawerSlide extends StatefulWidget {
  const DrawerSlide({
    super.key,
  });

  @override
  State<DrawerSlide> createState() => _DrawerSlideState();
}

class _DrawerSlideState extends State<DrawerSlide> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Widget listTile(
      {required IconData iconData,
        required String title,
        required Function() click}) {
    return ListTile(
      onTap: click,
      leading: Icon(
        iconData,
        color: Colors.black,
        size: 23,
      ),
      title: Text(
        title,
        style: TextStyle(color: Colors.black, fontSize: 15),
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SizedBox(
        width: 100,
        child: ListView(
          children: [
            StreamBuilder(
                stream: users
                    .doc(SessionController().userId =
                    _auth.currentUser?.uid.toString())
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData && snapshot.data!.exists) {
                    return DrawerHeader(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          UserProfilePictureAuthenticate(
                            userId: SessionController().userId =
                                _auth.currentUser?.uid.toString(),
                          ),
                          const SizedBox(
                            width: 10.25,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              UserNameAuthenticate(
                                  userId: _auth.currentUser?.uid ?? "",
                                  color: Colors.black),
                              TextButton(
                                onPressed: () => logOut(context),
                                child: Text(
                                  'Log Out'.toUpperCase(),
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  }
                  return Center(child: Text('Loading...'));
                }),
            listTile(
              iconData: Icons.account_circle,
              title: 'View Profile',
              click: () {
                // Navigator.of(context).pop();
                // nextScreen(
                //   context,
                //   UserProfile(
                //     userId: SessionController().userId =
                //         _auth.currentUser?.uid.toString(),
                //   ),
                // );
              },
            ),
            listTile(
              iconData: Icons.article_outlined,
              title: 'About',
              click: () {
                // Navigator.of(context).pop();
                // nextScreen(context, AboutPage());
              },
            ),
            listTile(
              iconData: Icons.share,
              title: 'Refer A Friends',
              click: () {
                // Navigator.of(context).pop();
                // Share.share(
                //     'Download App on Play Store and manage your non-profit organization accounts'
                //         ' https://play.google.com/store/apps/details?id=com.shm.account');
              },
            ),
            listTile(
              iconData: Icons.star,
              title: 'Rating & Review',
              click: () {
                // Navigator.of(context).pop();
                // launchUrl(Uri.parse('https://play.google.com/store/apps/details?id=com.shm.account'));
              },
            ),
            listTile(
              iconData: Icons.policy_rounded,
              title: 'Terms & Conditions',
              click: () {
                // Navigator.of(context).pop();
                // launchUrl(Uri.parse(
                //     'https://doc-hosting.flycricket.io/ngo-account-manager-terms-of-use/bc900c89-e9c4-40d9-9916-4d317d8c5335/terms'));
              },
            ),
            const Divider(),
            const SizedBox(
              height: 200,
              child: Padding(
                padding: EdgeInsets.only(left: 17, top: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Contact Support',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          Text(
                            'Email us:',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            'abcd@gmail.com',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              height: 20,
              child: Column(
                children: [
                  Text(
                    'Version: 0.0.1',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            )
          ],
        ),
      ),
    );
  }
}

Future<void> logOut(BuildContext context) async {
  FirebaseAuth _auth = FirebaseAuth.instance;

  try {
    await _auth.signOut().then((value) {
      Navigator.of(context).pop();
      // Navigator.pushReplacement(
      //     context, MaterialPageRoute(builder: (_) => SignInPage()));
    });
  } catch (e) {
    print("error");
  }
}