// ignore_for_file: avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quanlychitieu/sevices/schedule_notifications.dart';

import '../constant.dart';

class NotifiCationskdy extends StatefulWidget {
  const NotifiCationskdy({super.key});

  @override
  State<NotifiCationskdy> createState() => _NotifiCationskdyState();
}

class _NotifiCationskdyState extends State<NotifiCationskdy> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final _db = FirebaseDatabase.instance.ref();
  NotificationsServices notificationsServices = NotificationsServices();
  TextEditingController textEditingController = TextEditingController();
  DateTime dateTime = DateTime(2023, 1, 1, 00);
  @override
  void initState() {
    super.initState();
    notificationsServices.initialiseNotifications();
    getDate();
  }

  void getDate() {
    _db.child('users/${auth.currentUser!.uid}').onValue.listen((event) {
      final data = event.snapshot.value as dynamic;
      if (mounted) {
        setState(() {
          textEditingController.text = data['time'];
          dateTime = DateTime.parse(textEditingController.text.toString());
          print(textEditingController.text);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Size screensIndex = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Stack(
                children: [
                  IconButton(
                      onPressed: () => Get.back(),
                      icon: Icon(
                        Icons.arrow_back_ios,
                        color: kdy2,
                        size: 30,
                      )),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 13.0),
                      child: Text(
                        'Hãy cùng đặt thời gian',
                        style: TextStyle(
                            color: kdy2,
                            fontSize: 22,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: screensIndex.height / 3,
            ),
            Container(
              padding: const EdgeInsets.only(left: 20, right: 20),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.grey[300]),
              child: CupertinoPageScaffold(
                backgroundColor: Colors.grey[300],
                child: Column(
                  children: [
                    CupertinoButton(
                      borderRadius: BorderRadius.circular(10),
                      child: Text(
                        '${dateTime.hour < 10 ? '0${dateTime.hour}' : dateTime.hour}:${dateTime.minute < 10 ? '0${dateTime.minute}' : dateTime.minute}',
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.indigo[400]),
                      ),
                      onPressed: () {
                        showCupertinoModalPopup(
                            context: context,
                            builder: (BuildContext context) => SizedBox(
                                  height: screensIndex.width * 0.8,
                                  child: CupertinoDatePicker(
                                    backgroundColor: Colors.white,
                                    initialDateTime: dateTime,
                                    onDateTimeChanged: (DateTime newTime) {
                                      setState(() {
                                        dateTime = newTime;
                                      });
                                    },
                                    maximumYear: DateTime.now().year,
                                    use24hFormat: true,
                                    mode: CupertinoDatePickerMode.time,
                                  ),
                                ));
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  child: const Text('Bật nhắc nhở'),
                  onPressed: () {
                    notificationsServices.secheduleNotification(
                        'Nhắc nhở nho nhỏ',
                        'Thời gian đã đến bạn mau mau nhập thu chi của mình ngay nào!',
                        dateTime.hour,
                        dateTime.minute);
                    final timeData = <String, dynamic>{
                      'time': dateTime.toString()
                    };

                    _db
                        .child('users/${auth.currentUser!.uid}')
                        .update(timeData)
                        .then((_) => print('update successful'))
                        .catchError(
                            (error) => print('You got an error $error'));
                  },
                ),
                TextButton(
                  child: const Text('Tắt nhắc nhở'),
                  onPressed: () {
                    notificationsServices.stopNotifications();
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
