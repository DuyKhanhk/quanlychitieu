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
  String _listChosseTime = listChosseTime[1];
  List<String> listCategory = [];
  Set<String> listCategorypiechart = {};
  List<DataItem> dataset = [DataItem(0, '', Colors.grey.withOpacity(0.8))];
  CategoryIncome categoryIncome = CategoryIncome(0, 0, 0, 0, 0, 0, 0, 0);
  double totalAll = 0.0;
  dynamic total = 0;
  int indexColor = -1;
  int count = 0;

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
          dataset.clear();
          totalAll = 0;
          for (var itemC in data) {
            if (_getChosseTime(
                DateTime.parse(itemC.child('timeChosse').value.toString()),
                _listChosseTime)) {
              if (itemC.child('type').value.toString() == listImcome[0]) {
                categoryIncome.luong +=
                    int.parse(itemC.child('money').value.toString());
              } else if (itemC.child('type').value.toString() ==
                  listImcome[1]) {
                categoryIncome.thuongLuong +=
                    int.parse(itemC.child('money').value.toString());
              } else if (itemC.child('type').value.toString() ==
                  listImcome[2]) {
                categoryIncome.kinhDoanh +=
                    int.parse(itemC.child('money').value.toString());
              } else if (itemC.child('type').value.toString() ==
                  listImcome[3]) {
                categoryIncome.dauTu +=
                    int.parse(itemC.child('money').value.toString());
              } else if (itemC.child('type').value.toString() ==
                  listImcome[4]) {
                categoryIncome.choThue +=
                    int.parse(itemC.child('money').value.toString());
              } else if (itemC.child('type').value.toString() ==
                  listImcome[5]) {
                categoryIncome.donate +=
                    int.parse(itemC.child('money').value.toString());
              } else if (itemC.child('type').value.toString() ==
                  listImcome[6]) {
                categoryIncome.thuNhapThuDong +=
                    int.parse(itemC.child('money').value.toString());
              } else if (itemC.child('type').value.toString() ==
                  listImcome[7]) {
                categoryIncome.khac +=
                    int.parse(itemC.child('money').value.toString());
              }
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
          if (weeksFB == weeksystem&&timeFirebase.year == DateTime.now().year) return true;
        }
        break;
      case 'Tháng':
        {
          if (timeFirebase.month == DateTime.now().month&&timeFirebase.year == DateTime.now().year) return true;
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
          listCategory: listCategorypiechart,
          totalAll: totalAll,
          currentScreens: widget.currentScreen,
          dataset: dataset,
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(
              screensIndex.width / 3,
              screensIndex.width / 2.5 + screensIndex.width / 1.7,
              screensIndex.width / 3,
              screensIndex.width / 1.37),
          child: DropdownButtonFormField(
            value: _listChosseTime,
            items: listChosseTime.map((e) {
              return DropdownMenuItem(
                // ignore: sort_child_properties_last
                child: Text(
                  e,
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 15,
                      color: Colors.black.withOpacity(0.6)),
                ),
                value: e,
              );
            }).toList(),
            onChanged: ((value) {
              setState(() {
                _listChosseTime = value as String;
                _getTotalCategory();
              });
            }),
            icon: Icon(
              Icons.arrow_drop_down_circle,
              color: Colors.indigo[400],
            ),
            decoration: InputDecoration(
                labelText: 'Chọn thời gian',
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15))),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(
              top: screensIndex.width / 2.5 + screensIndex.width / 1.35),
          child: SizedBox(
              width: screensIndex.width * 7 / 8,
              child: FirebaseAnimatedList(
                  query: db
                      .child('incomes')
                      .orderByChild('uID')
                      .equalTo(auth.currentUser!.uid),
                  sort: (a, b) => b
                      .child('type')
                      .value
                      .toString()
                      .compareTo(a.child('type').value.toString()),
                  itemBuilder: (context, snapshot, animation, index) {
                    listCategory.forEach((element) {
                      if (listCategory
                          .contains(snapshot.child('type').value.toString())) {
                        count++;
                      } else {
                        count = 0;
                      }
                    });

                    count == 0 ? listCategory.clear() : null;
                    _getChosseTime(
                            DateTime.parse(
                                snapshot.child('timeChosse').value.toString()),
                            _listChosseTime)
                        ? {
                            listCategory
                                .add(snapshot.child('type').value.toString()),
                            listCategorypiechart
                                .add(snapshot.child('type').value.toString())
                          }
                        : listCategorypiechart.contains(
                                snapshot.child('type').value.toString())
                            ? listCategorypiechart
                                .remove(snapshot.child('type').value.toString())
                            : null;

                    return count == 0 &&
                            _getChosseTime(
                                DateTime.parse(snapshot
                                    .child('timeChosse')
                                    .value
                                    .toString()),
                                _listChosseTime)
                        ? InkWell(
                            onTap: () {
                              Get.to(ShowListCategory(
                                  timeChosse: _listChosseTime,
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
