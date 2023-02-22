import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class InfoCard extends StatelessWidget {
  InfoCard({
    super.key,
  });

  final auth = FirebaseAuth.instance;
  final _db = FirebaseDatabase.instance.ref();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: _db.child('users/${auth.currentUser!.uid}').onValue,
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            final data = Map<String, dynamic>.from(
              Map<String, dynamic>.from((snapshot.data as DatabaseEvent)
                  .snapshot
                  .value as Map<dynamic, dynamic>),
            );
            return ListTile(
              leading: CircleAvatar(
                  backgroundColor: Colors.white24,
                  child: Lottie.asset(
                      'assets/images/avatar/Avartar${data['image'].toString()}.json')),
              title: Text(
                '${data['userName']}',
                style: const TextStyle(color: Colors.white),
              ),
              subtitle: Text(
                '${data['phone']}',
                style: const TextStyle(color: Colors.white),
              ),
            );
          }
          return const CircularProgressIndicator();
        });
  }
}
