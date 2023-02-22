import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lottie/lottie.dart';

class Avatar extends StatefulWidget {
  const Avatar({super.key});

  @override
  State<Avatar> createState() => _AvatarState();
}

List<String> urlAvatar = [
  'assets/images/avatar/Avartar1.json',
  'assets/images/avatar/Avartar2.json',
  'assets/images/avatar/Avartar3.json',
  'assets/images/avatar/Avartar4.json',
  'assets/images/avatar/Avartar5.json',
  'assets/images/avatar/Avartar6.json',
  'assets/images/avatar/Avartar7.json',
  'assets/images/avatar/Avartar8.json',
];

class _AvatarState extends State<Avatar> {
  final _db = FirebaseDatabase.instance.ref();
  final auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    double screensWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0),
      body: InkWell(
        onTap: () => Navigator.pop(context),
        child: Container(
          width: double.infinity,
          height: double.infinity,
          alignment: Alignment.topCenter,
          child: Column(
            children: [
              SizedBox(
                height: screensWidth / 2,
              ),
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.95),
                ),
                height: screensWidth / 3,
                width: screensWidth / 3,
                child: ListView.builder(
                  itemCount: urlAvatar.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        _db
                            .child('users/${auth.currentUser!.uid}/image')
                            .set(index + 1);
                      },
                      child: Lottie.asset(urlAvatar[index], fit: BoxFit.cover),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
