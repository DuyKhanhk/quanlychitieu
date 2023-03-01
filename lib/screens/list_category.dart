// ignore_for_file: avoid_print
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:quanlychitieu/components/item_list_category.dart';
import 'package:quanlychitieu/models/model.dart';

import '../constant.dart';

final formatCurrency = NumberFormat("#,##0", "en_US");

class ShowListCategory extends StatelessWidget {
  ShowListCategory(
      {super.key,
      required this.type,
      required this.currentScreens,
      required this.timeChosse});
  final int currentScreens;
  final String type;
  final String timeChosse;
  final db = FirebaseDatabase.instance.ref();
  final auth = FirebaseAuth.instance;

  bool _getChosseTime(DateTime timeFirebase, String itemlistCt) {
    var dateTimenow = DateTime.now();
    switch (itemlistCt) {
      case 'Ngày':
        {
          if (timeFirebase.toString().split(' ')[0] ==
              dateTimenow.toString().split(' ')[0]) {
            return true;
          }
        }
        break;
      case 'Tuần':
        {
          int weeksFB = _weekNumber(timeFirebase);
          int weeksystem = _weekNumber(DateTime.now());
          if (weeksFB == weeksystem &&
              timeFirebase.year == DateTime.now().year) {
            return true;
          }
        }
        break;
      case 'Tháng':
        {
          if (timeFirebase.month == DateTime.now().month &&
              timeFirebase.year == DateTime.now().year) return true;
        }
        break;
      case 'Năm':
        {
          if (timeFirebase.year == DateTime.now().year) return true;
        }
        break;
    }
    return false;
  }

  int _weekNumber(DateTime date) {
    int dayOfYear = int.parse(DateFormat("D").format(date));
    return ((dayOfYear - date.weekday + 10) / 7).floor();
  }

  @override
  Widget build(BuildContext context) {
    double screenWith = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
          child: Stack(
        children: [
          Padding(
            padding: EdgeInsets.only(top: screenWith / 2.455),
            child: Expanded(
              child: FirebaseAnimatedList(
                query: currentScreens == 0
                    ? db
                        .child('spendings')
                        .orderByChild('uID')
                        .equalTo(auth.currentUser!.uid)
                    : db
                        .child('incomes')
                        .orderByChild('uID')
                        .equalTo(auth.currentUser!.uid),
                itemBuilder: (context, snapshot, animation, index) {
                  // ignore: unrelated_type_equality_checks
                  return snapshot.child('type').value.toString() == type &&
                          _getChosseTime(
                              DateTime.parse(snapshot
                                  .child('timeChosse')
                                  .value
                                  .toString()),
                              timeChosse)
                      ? type == listImcome[0]
                          ? ItemCategory(
                              expense: Expense(
                                  snapshot.child('money').value.toString(),
                                  snapshot.child('note').value.toString(),
                                  snapshot.child('timeChosse').value.toString(),
                                  snapshot.child('timeInput').value.toString(),
                                  snapshot.child('type').value.toString(),
                                  snapshot.child('uID').value.toString()),
                              currentScreen: currentScreens,
                              status:
                                  snapshot.child('status').value.toString() ==
                                      'true',
                              snapshot: snapshot,
                            )
                          : ItemCategory(
                              expense: Expense(
                                  snapshot.child('money').value.toString(),
                                  snapshot.child('note').value.toString(),
                                  snapshot.child('timeChosse').value.toString(),
                                  snapshot.child('timeInput').value.toString(),
                                  snapshot.child('type').value.toString(),
                                  snapshot.child('uID').value.toString()),
                              currentScreen: currentScreens,
                              status:
                                  snapshot.child('status').value.toString() ==
                                      'Ví',
                              snapshot: snapshot,
                            )
                      : Container();
                },
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: screenWith / 4),
            child: Align(
              alignment: Alignment.topCenter,
              child: Container(
                width: screenWith / 5.5,
                height: screenWith / 5.5,
                decoration: BoxDecoration(
                  // color: kdy2,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                        spreadRadius: -2,
                        blurRadius: 10,
                        offset: const Offset(-5, 5),
                        color: kdybackgroup),
                  ],
                ),
              ),
            ),
          ),
          Container(
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: screenWith / 8),
            height: screenWith / 2.3,
            width: double.infinity,
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10)),
                image: DecorationImage(
                    image: AssetImage('assets/images/appbarCategory.gif'),
                    fit: BoxFit.cover)),
            child: Padding(
              padding: EdgeInsets.only(bottom: screenWith / 7.8),
              child: Container(
                width: screenWith / 1.3,
                alignment: Alignment.center,
                margin: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.yellow[600],
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                        spreadRadius: -2,
                        blurRadius: 15,
                        offset: const Offset(5, 5),
                        color: kdybackgroup),
                  ],
                ),
                child: Text(
                  type,
                  style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 25,
                      color: Colors.black.withOpacity(.65)),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 15.0, left: 5),
            child: IconButton(
                onPressed: () => Get.back(result: {'a': '123'}),
                icon: const Icon(
                  Icons.arrow_back_ios,
                  color: Colors.white,
                  size: 30,
                )),
          ),
        ],
      )),
    );
  }
}
