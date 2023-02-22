// ignore_for_file: file_names, unnecessary_question_mark

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:widget_and_text_animator/widget_and_text_animator.dart';

final formatCurrency = NumberFormat("#,##0", "en_US");

class AppbarCustom extends StatelessWidget {
  AppbarCustom({
    super.key,
    required this.screensIndex,
    required this.urlLottie,
  });

  final Size screensIndex;
  final String urlLottie;
  final auth = FirebaseAuth.instance;

  final _db = FirebaseDatabase.instance.ref();

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 8,
      toolbarHeight: screensIndex.width / 3,
      leading: Container(
        height: screensIndex.width / 4,
        margin: EdgeInsets.fromLTRB(screensIndex.width / 8,
            screensIndex.width / 20, screensIndex.width / 5, 0),
        alignment: Alignment.topCenter,
        child: StreamBuilder(
            stream: _db.child('users/${auth.currentUser!.uid}').onValue,
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.data != null) {
                final data = (snapshot.data as DatabaseEvent)
                    .snapshot
                    .child('accountBanks')
                    .value as List<dynamic?>;
                final index = int.parse(data[2].toString());
                return Column(
                  children: [
                    Expanded(
                      child: Text(
                        formatCurrency.format(
                          index,
                        ),
                        maxLines: 2,
                        style: const TextStyle(
                            letterSpacing: 1.2,
                            fontSize: 30,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                    const Expanded(
                      child: Text(
                        ' VND',
                        style: TextStyle(
                            letterSpacing: 1.5,
                            fontSize: 30,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(top: screensIndex.width / 40),
                        child: Row(
                          // ignore: prefer_const_literals_to_create_immutables
                          children: [
                            // ignore: prefer_const_constructors
                            Text(
                              ' TK: ${data[1]}',
                              style: const TextStyle(fontSize: 15),
                            ),
                            IconButton(
                                onPressed: () {},
                                icon: const Icon(
                                  Icons.qr_code,
                                  size: 20,
                                ))
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              }
              return const CircularProgressIndicator();
            }),
      ),
      leadingWidth: screensIndex.width,
      toolbarOpacity: 0.7,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
            bottom: Radius.elliptical(
                screensIndex.width, screensIndex.height / 10)),
      ),
      shadowColor: const Color.fromARGB(255, 39, 0, 86),
      flexibleSpace: Container(
        padding: EdgeInsets.only(
            left: screensIndex.width / 2,
            top: screensIndex.width / 15,
            bottom: screensIndex.width / 17,
            right: screensIndex.width / 50),
        child: WidgetAnimator(
          incomingEffect: WidgetTransitionEffects.incomingSlideInFromBottom(),
          child: Lottie.asset(
            urlLottie,
            width: screensIndex.width / 2,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}

class AppbarCustomInput extends StatelessWidget {
  const AppbarCustomInput({
    super.key,
    required this.screensIndex,
  });

  final Size screensIndex;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: screensIndex.width / 2,
      child: AppBar(
        elevation: 8,
        toolbarHeight: screensIndex.width / 3,
        leadingWidth: screensIndex.width,
        leading: Container(
          height: screensIndex.width / 4,
          margin: EdgeInsets.fromLTRB(screensIndex.width / 15,
              screensIndex.width / 20, screensIndex.width / 3, 0),
          alignment: Alignment.topCenter,
          child: WidgetAnimator(
            incomingEffect: WidgetTransitionEffects.incomingSlideInFromTop(),
            child: const Text(
              'Quản lý tài chính\ncá nhân\nmỗi ngày',
              maxLines: 3,
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.w400),
            ),
          ),
        ),
        flexibleSpace: Container(
          padding: EdgeInsets.only(
              left: screensIndex.width / 2,
              top: screensIndex.width / 15,
              bottom: screensIndex.width / 10,
              right: screensIndex.width / 9),
          child: WidgetAnimator(
            incomingEffect: WidgetTransitionEffects.incomingSlideInFromRight(),
            child: Lottie.asset(
              'assets/images/manwriting.json',
              fit: BoxFit.cover,
            ),
          ),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
              bottom: Radius.elliptical(
                  screensIndex.width, screensIndex.height / 10)),
        ),
      ),
    );
  }
}
