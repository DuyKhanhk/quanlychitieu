// ignore_for_file: avoid_function_literals_in_foreach_calls, must_be_immutable, unused_field
import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quanlychitieu/components/Appbar_cust.dart';
import 'package:quanlychitieu/components/pie_chart.dart';
import 'package:quanlychitieu/constant.dart';
import 'package:intl/intl.dart';
import 'package:quanlychitieu/models/categorys.dart';
import 'package:quanlychitieu/screens/list_category.dart';

import '../models/Item_piechart.dart';

final formatCurrency = NumberFormat("#,##0", "en_US");

class Spending extends StatefulWidget {
  Spending({super.key, required this.currentScreen});
  int currentScreen;
  @override
  State<Spending> createState() => _SpendingState();
}

class _SpendingState extends State<Spending> {
  final db = FirebaseDatabase.instance.ref();
  final auth = FirebaseAuth.instance;
  late StreamSubscription _totalCategory;
  final List<DataItem> dataset = [
    DataItem(0, '', Colors.grey.withOpacity(0.8))
  ];
  CategorySpending categorySpending =
      CategorySpending(0, 0, 0, 0, 0, 0, 0, 0, 0);
  List<String> listCategory = [];
  double totalAll = 0.0;
  dynamic total = 0;
  int indexColor = -1;

  @override
  void initState() {
    super.initState();
    _getTotalCategory();
  }

  void _getTotalCategory() {
    _totalCategory = db
        .child('spendings')
        .orderByChild('uID')
        .equalTo(auth.currentUser!.uid)
        .onValue
        .listen((event) {
      final data = event.snapshot.children;
      if (mounted) {
        setState(() {
          listCategory.clear();
          dataset.clear();
          categorySpending = CategorySpending(0, 0, 0, 0, 0, 0, 0, 0, 0);
          totalAll = 0;
          for (var itemC in data) {
            if (itemC.child('type').value.toString() == listSpending[0]) {
              categorySpending.thueNha +=
                  int.parse(itemC.child('money').value.toString());
            } else if (itemC.child('type').value.toString() ==
                listSpending[1]) {
              categorySpending.hocTap +=
                  int.parse(itemC.child('money').value.toString());
            } else if (itemC.child('type').value.toString() ==
                listSpending[2]) {
              categorySpending.diLai +=
                  int.parse(itemC.child('money').value.toString());
            } else if (itemC.child('type').value.toString() ==
                listSpending[3]) {
              categorySpending.anUong +=
                  int.parse(itemC.child('money').value.toString());
            } else if (itemC.child('type').value.toString() ==
                listSpending[4]) {
              categorySpending.giaiTri +=
                  int.parse(itemC.child('money').value.toString());
            } else if (itemC.child('type').value.toString() ==
                listSpending[5]) {
              categorySpending.dienNuoc +=
                  int.parse(itemC.child('money').value.toString());
            } else if (itemC.child('type').value.toString() ==
                listSpending[6]) {
              categorySpending.mangWifi +=
                  int.parse(itemC.child('money').value.toString());
            } else if (itemC.child('type').value.toString() ==
                listSpending[7]) {
              categorySpending.muaSam +=
                  int.parse(itemC.child('money').value.toString());
            } else if (itemC.child('type').value.toString() ==
                listSpending[8]) {
              categorySpending.khac +=
                  int.parse(itemC.child('money').value.toString());
            }
          }
          totalAll += categorySpending.thueNha +
              categorySpending.hocTap +
              categorySpending.diLai +
              categorySpending.anUong +
              categorySpending.giaiTri +
              categorySpending.dienNuoc +
              categorySpending.mangWifi +
              categorySpending.muaSam +
              categorySpending.khac;

          double x1 =
              double.parse(categorySpending.thueNha.toString()) / totalAll;
          double x2 =
              double.parse(categorySpending.hocTap.toString()) / totalAll;
          double x3 =
              double.parse(categorySpending.diLai.toString()) / totalAll;
          double x4 =
              double.parse(categorySpending.anUong.toString()) / totalAll;
          double x5 =
              double.parse(categorySpending.giaiTri.toString()) / totalAll;
          double x6 =
              double.parse(categorySpending.dienNuoc.toString()) / totalAll;
          double x7 =
              double.parse(categorySpending.mangWifi.toString()) / totalAll;
          double x8 =
              double.parse(categorySpending.muaSam.toString()) / totalAll;
          double x9 = double.parse(categorySpending.khac.toString()) / totalAll;

          double x10 = 1 -
              double.parse(x1.toStringAsFixed(2)) -
              double.parse(x2.toStringAsFixed(2)) -
              double.parse(x3.toStringAsFixed(2)) -
              double.parse(x4.toStringAsFixed(2)) -
              double.parse(x5.toStringAsFixed(2)) -
              double.parse(x6.toStringAsFixed(2)) -
              double.parse(x7.toStringAsFixed(2)) -
              double.parse(x8.toStringAsFixed(2));

          !x1.isNaN
              ? dataset.add(DataItem(
                  x1,
                  x1 == 0 ? '' : '${(x1 * 100).toStringAsFixed(2)}%',
                  listColorSp[0]))
              : null;
          !x2.isNaN
              ? dataset.add(DataItem(
                  x2,
                  x2 == 0 ? '' : '${(x2 * 100).toStringAsFixed(2)}%',
                  listColorSp[1]))
              : null;
          !x3.isNaN
              ? dataset.add(DataItem(
                  x3,
                  x3 == 0 ? '' : '${(x3 * 100).toStringAsFixed(2)}%',
                  listColorSp[2]))
              : null;
          !x4.isNaN
              ? dataset.add(DataItem(
                  x4,
                  x4 == 0 ? '' : '${(x4 * 100).toStringAsFixed(2)}%',
                  listColorSp[3]))
              : null;
          !x5.isNaN
              ? dataset.add(DataItem(
                  x5,
                  x5 == 0 ? '' : '${(x5 * 100).toStringAsFixed(2)}%',
                  listColorSp[4]))
              : null;
          !x6.isNaN
              ? dataset.add(DataItem(
                  x6,
                  x6 == 0 ? '' : '${(x6 * 100).toStringAsFixed(2)}%',
                  listColorSp[5]))
              : null;
          !x7.isNaN
              ? dataset.add(DataItem(
                  x7,
                  x7 == 0 ? '' : '${(x7 * 100).toStringAsFixed(2)}%',
                  listColorSp[6]))
              : null;
          !x8.isNaN
              ? dataset.add(DataItem(
                  x8,
                  x8 == 0 ? '' : '${(x8 * 100).toStringAsFixed(2)}%',
                  listColorSp[7]))
              : null;
          !x9.isNaN
              ? dataset.add(DataItem(
                  x9,
                  x9 == 0 ? '' : '${(x10 * 100).toStringAsFixed(2)}%',
                  listColorSp[8]))
              : null;
        });
      }
    });
  }

  List<DataItem> kdy = [DataItem(0.0, '', kdy1)];

  @override
  Widget build(BuildContext context) {
    Size screensIndex = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(alignment: Alignment.topCenter, children: [
        SizedBox(
            height: screensIndex.height / 3.5,
            child: AppbarCustom(
              screensIndex: screensIndex,
              urlLottie: 'assets/images/blueCard.json',
            )),
        PieChartCustom(
          listCategory: listCategory,
          totalAll: totalAll,
          currentScreens: widget.currentScreen,
          dataset: dataset.isEmpty ? kdy : dataset,
        ),
        Padding(
          padding: EdgeInsets.only(
              top: screensIndex.width / 2.5 + screensIndex.width / 1.7),
          child: SizedBox(
              width: screensIndex.width * 7 / 8,
              child: FirebaseAnimatedList(
                  query: db
                      .child('spendings')
                      .orderByChild('uID')
                      .equalTo(auth.currentUser!.uid),
                  itemBuilder: (context, snapshot, animation, index) {
                    int count = 0;
                    listCategory.forEach((element) {
                      if (listCategory
                          .contains(snapshot.child('type').value.toString())) {
                        count++;
                      } else {
                        count = 0;
                      }
                    });

                    listCategory.add(snapshot.child('type').value.toString());
                    return count == 0
                        ? InkWell(
                            onTap: () {
                              setState(() {
                                // listCategory.clear();
                                count = 0;
                                _getTotalCategory();
                              });
                              Get.to(
                                  ShowListCategory(
                                      currentScreens: widget.currentScreen,
                                      type: snapshot
                                          .child('type')
                                          .value
                                          .toString()),
                                  transition: Transition.zoom);
                            },
                            child: Container(
                                margin: EdgeInsets.only(
                                    bottom: screensIndex.width / 35),
                                height: screensIndex.width / 7,
                                decoration: BoxDecoration(
                                    color: isRightColors(snapshot, 0)
                                        ? listColorSp[0]
                                        : isRightColors(snapshot, 1)
                                            ? listColorSp[1]
                                            : isRightColors(snapshot, 2)
                                                ? listColorSp[2]
                                                : isRightColors(snapshot, 3)
                                                    ? listColorSp[3]
                                                    : isRightColors(snapshot, 4)
                                                        ? listColorSp[4]
                                                        : isRightColors(
                                                                snapshot, 5)
                                                            ? listColorSp[5]
                                                            : isRightColors(
                                                                    snapshot, 6)
                                                                ? listColorSp[6]
                                                                : isRightColors(
                                                                        snapshot,
                                                                        7)
                                                                    ? listColorSp[
                                                                        7]
                                                                    : listColorSp[
                                                                        8],
                                    shape: BoxShape.rectangle,
                                    boxShadow: const [
                                      BoxShadow(
                                          color: Colors.black38,
                                          offset: Offset(2, 4),
                                          blurRadius: 5)
                                    ],
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(
                                            screensIndex.width / 25))),
                                alignment: Alignment.center,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Text(
                                      snapshot.child('type').value.toString(),
                                      style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          color: Colors.black.withOpacity(.65)),
                                    ),
                                    SizedBox(
                                      width: screensIndex.width / 10,
                                    ),
                                    Text(
                                      isInList(snapshot, 0)
                                          ? '${formatCurrency.format(categorySpending.thueNha)} VND'
                                          : isInList(snapshot, 1)
                                              ? '${formatCurrency.format(categorySpending.hocTap)} VND'
                                              : isInList(snapshot, 2)
                                                  ? '${formatCurrency.format(categorySpending.diLai)} VND'
                                                  : isInList(snapshot, 3)
                                                      ? '${formatCurrency.format(categorySpending.anUong)} VND'
                                                      : isInList(snapshot, 4)
                                                          ? '${formatCurrency.format(categorySpending.giaiTri)} VND'
                                                          : isInList(
                                                                  snapshot, 5)
                                                              ? '${formatCurrency.format(categorySpending.dienNuoc)} VND'
                                                              : isInList(
                                                                      snapshot,
                                                                      6)
                                                                  ? '${formatCurrency.format(categorySpending.mangWifi)} VND'
                                                                  : isInList(
                                                                          snapshot,
                                                                          7)
                                                                      ? '${formatCurrency.format(categorySpending.muaSam)} VND'
                                                                      : '${formatCurrency.format(categorySpending.khac)} VND',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black.withOpacity(.7)),
                                    ),
                                  ],
                                )),
                          )
                        : Container();
                  })),
        )
      ]),
    );
  }

  bool isRightColors(DataSnapshot snapshot, int x) =>
      snapshot.child('type').value.toString() == listSpending[x];

  bool isInList(DataSnapshot snapshot, int x) =>
      snapshot.child('type').value.toString() == listSpending[x];
}
