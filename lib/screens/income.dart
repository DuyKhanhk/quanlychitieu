// ignore_for_file: must_be_immutable, unused_field, avoid_function_literals_in_foreach_calls

import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:quanlychitieu/components/Appbar_cust.dart';
import 'package:quanlychitieu/components/pie_chart.dart';
import 'package:quanlychitieu/constant.dart';
import 'package:quanlychitieu/models/Item_piechart.dart';
import 'package:quanlychitieu/models/categorys.dart';
import 'package:quanlychitieu/screens/list_category.dart';

final formatCurrency = NumberFormat("#,##0", "en_US");

class InCome extends StatefulWidget {
  InCome({super.key, required this.currentScreen});
  int currentScreen;
  @override
  State<InCome> createState() => _InComeState();
}

class _InComeState extends State<InCome> {
  final db = FirebaseDatabase.instance.ref();
  final auth = FirebaseAuth.instance;
  late StreamSubscription _totalCategory;
  List<String> listCategory = [];
  List<DataItem> dataset = [DataItem(0, '', Colors.grey.withOpacity(0.8))];
  CategoryIncome categoryIncome = CategoryIncome(0, 0, 0, 0, 0, 0, 0, 0);
  double totalAll = 0.8;
  dynamic total = 0;
  int indexColor = -1;

  @override
  void initState() {
    super.initState();
    _getTotalCategory();
  }

  void _getTotalCategory() {
    _totalCategory = db
        .child('incomes')
        .orderByChild('uID')
        .equalTo(auth.currentUser!.uid)
        .onValue
        .listen((event) {
      final data = event.snapshot.children;

      if (mounted) {
        setState(() {
          categoryIncome = CategoryIncome(0, 0, 0, 0, 0, 0, 0, 0);
          // listCategory.clear();
          dataset.clear();
          totalAll = 0;
          for (var itemC in data) {
            if (itemC.child('type').value.toString() == listImcome[0]) {
              categoryIncome.luong +=
                  int.parse(itemC.child('money').value.toString());
            } else if (itemC.child('type').value.toString() == listImcome[1]) {
              categoryIncome.thuongLuong +=
                  int.parse(itemC.child('money').value.toString());
            } else if (itemC.child('type').value.toString() == listImcome[2]) {
              categoryIncome.kinhDoanh +=
                  int.parse(itemC.child('money').value.toString());
            } else if (itemC.child('type').value.toString() == listImcome[3]) {
              categoryIncome.dauTu +=
                  int.parse(itemC.child('money').value.toString());
            } else if (itemC.child('type').value.toString() == listImcome[4]) {
              categoryIncome.choThue +=
                  int.parse(itemC.child('money').value.toString());
            } else if (itemC.child('type').value.toString() == listImcome[5]) {
              categoryIncome.donate +=
                  int.parse(itemC.child('money').value.toString());
            } else if (itemC.child('type').value.toString() == listImcome[6]) {
              categoryIncome.thuNhapThuDong +=
                  int.parse(itemC.child('money').value.toString());
            } else if (itemC.child('type').value.toString() == listImcome[7]) {
              categoryIncome.khac +=
                  int.parse(itemC.child('money').value.toString());
            }
          }
          totalAll += categoryIncome.luong +
              categoryIncome.thuongLuong +
              categoryIncome.kinhDoanh +
              categoryIncome.dauTu +
              categoryIncome.choThue +
              categoryIncome.donate +
              categoryIncome.thuNhapThuDong +
              categoryIncome.khac;

          double x1 = double.parse(categoryIncome.luong.toString()) / totalAll;
          double x2 =
              double.parse(categoryIncome.thuongLuong.toString()) / totalAll;
          double x3 =
              double.parse(categoryIncome.kinhDoanh.toString()) / totalAll;
          double x4 = double.parse(categoryIncome.dauTu.toString()) / totalAll;
          double x5 =
              double.parse(categoryIncome.choThue.toString()) / totalAll;
          double x6 = double.parse(categoryIncome.donate.toString()) / totalAll;
          double x7 =
              double.parse(categoryIncome.thuNhapThuDong.toString()) / totalAll;
          double x8 = double.parse(categoryIncome.khac.toString()) / totalAll;

          double x9 = 1 -
              double.parse(x1.toStringAsFixed(2)) -
              double.parse(x2.toStringAsFixed(2)) -
              double.parse(x3.toStringAsFixed(2)) -
              double.parse(x4.toStringAsFixed(2)) -
              double.parse(x5.toStringAsFixed(2)) -
              double.parse(x6.toStringAsFixed(2)) -
              double.parse(x7.toStringAsFixed(2));

          !x1.isNaN
              ? dataset.add(DataItem(
                  x1,
                  x1 == 0 ? '' : '${(x1 * 100).toStringAsFixed(2)}%',
                  listColorIc[0]))
              : null;
          !x2.isNaN
              ? dataset.add(DataItem(
                  x2,
                  x2 == 0 ? '' : '${(x2 * 100).toStringAsFixed(2)}%',
                  listColorIc[1]))
              : null;
          !x3.isNaN
              ? dataset.add(DataItem(
                  x3,
                  x3 == 0 ? '' : '${(x3 * 100).toStringAsFixed(2)}%',
                  listColorIc[2]))
              : null;
          !x4.isNaN
              ? dataset.add(DataItem(
                  x4,
                  x4 == 0 ? '' : '${(x4 * 100).toStringAsFixed(2)}%',
                  listColorIc[3]))
              : null;
          !x5.isNaN
              ? dataset.add(DataItem(
                  x5,
                  x5 == 0 ? '' : '${(x5 * 100).toStringAsFixed(2)}%',
                  listColorIc[4]))
              : null;
          !x6.isNaN
              ? dataset.add(DataItem(
                  x6,
                  x6 == 0 ? '' : '${(x6 * 100).toStringAsFixed(2)}%',
                  listColorIc[5]))
              : null;
          !x7.isNaN
              ? dataset.add(DataItem(
                  x7,
                  x7 == 0 ? '' : '${(x7 * 100).toStringAsFixed(2)}%',
                  listColorIc[6]))
              : null;
          !x8.isNaN
              ? dataset.add(DataItem(
                  x8,
                  x8 == 0 ? '' : '${(x9 * 100).toStringAsFixed(2)}%',
                  listColorIc[7]))
              : null;
        });
      }
    });
  }

  List<DataItem> kdy = [DataItem(1.0, '', kdy1)];

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
              urlLottie: 'assets/images/coinMoney.json',
            )),
        PieChartCustom(
          listCategory: listCategory,
          totalAll: totalAll,
          currentScreens: widget.currentScreen,
          dataset: dataset,
        ),
        Padding(
          padding: EdgeInsets.only(top: screensIndex.height / 2.2),
          child: SizedBox(
              width: screensIndex.width * 7 / 8,
              child: FirebaseAnimatedList(
                  query: db
                      .child('incomes')
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
                                count = 0;
                                _getTotalCategory();
                              });
                              Get.to(ShowListCategory(
                                  currentScreens: widget.currentScreen,
                                  type:
                                      snapshot.child('type').value.toString()));
                            },
                            child: Container(
                                margin: EdgeInsets.only(
                                    bottom: screensIndex.width / 35),
                                height: screensIndex.width / 7,
                                decoration: BoxDecoration(
                                    color: isRightColors(snapshot, 0)
                                        ? listColorIc[0]
                                        : isRightColors(snapshot, 1)
                                            ? listColorIc[1]
                                            : isRightColors(snapshot, 2)
                                                ? listColorIc[2]
                                                : isRightColors(snapshot, 3)
                                                    ? listColorIc[3]
                                                    : isRightColors(snapshot, 4)
                                                        ? listColorIc[4]
                                                        : isRightColors(
                                                                snapshot, 5)
                                                            ? listColorIc[5]
                                                            : isRightColors(
                                                                    snapshot, 6)
                                                                ? listColorIc[6]
                                                                : listColorIc[
                                                                    7],
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
                                          ? '${formatCurrency.format(categoryIncome.luong)} VND'
                                          : isInList(snapshot, 1)
                                              ? '${formatCurrency.format(categoryIncome.thuongLuong)} VND'
                                              : isInList(snapshot, 2)
                                                  ? '${formatCurrency.format(categoryIncome.kinhDoanh)} VND'
                                                  : isInList(snapshot, 3)
                                                      ? '${formatCurrency.format(categoryIncome.dauTu)} VND'
                                                      : isInList(snapshot, 4)
                                                          ? '${formatCurrency.format(categoryIncome.choThue)} VND'
                                                          : isInList(
                                                                  snapshot, 5)
                                                              ? '${formatCurrency.format(categoryIncome.donate)} VND'
                                                              : isInList(
                                                                      snapshot,
                                                                      6)
                                                                  ? '${formatCurrency.format(categoryIncome.thuNhapThuDong)} VND'
                                                                  : '${formatCurrency.format(categoryIncome.khac)} VND',
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
      snapshot.child('type').value.toString() == listImcome[x];

  bool isInList(DataSnapshot snapshot, int x) =>
      snapshot.child('type').value.toString() == listImcome[x];
}
