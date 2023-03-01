// ignore_for_file: unused_field, avoid_print

import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:quanlychitieu/constant.dart';
import 'package:quanlychitieu/models/rive_assets.dart';
import 'package:quanlychitieu/screens/chart.dart';
import 'package:quanlychitieu/screens/notifilocation.dart';
import 'package:quanlychitieu/screens/profile_user.dart';
import 'package:quanlychitieu/screens/salaryplan.dart';
import 'package:rive/rive.dart';
import '../models/categorys.dart';
import '../utils/rive_utils.dart';
import '../components/info_card.dart';
import '../components/side_menu_title.dart';
import 'package:get/get.dart';

class SideMenu extends StatefulWidget {
  const SideMenu({super.key});

  @override
  State<SideMenu> createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  final db = FirebaseDatabase.instance.ref();
  final auth = FirebaseAuth.instance;
  RiveAsset selectMenu = sideMenus.first;
  bool isSideMenuClose = true;
  int year = DateTime.now().year;
  int maxNum = 0;
  late StreamSubscription _totalCategory;
  late MonthChart spending;
  late MonthChart income;

  @override
  void initState() {
    super.initState();
    _getInComesItem();
    _getSpendingItem();
  }

  void _getSpendingItem() {
    _totalCategory = db
        .child('spendings')
        .orderByChild('uID')
        .equalTo(auth.currentUser!.uid)
        .onValue
        .listen((event) {
      final data = event.snapshot.children;
      if (mounted) {
        setState(() {
          spending = MonthChart(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
          for (var itemC in data) {
            switch (DateTime.parse(itemC.child('timeChosse').value.toString())
                .month) {
              case 1:
                {
                  spending.t1 +=
                      int.parse(itemC.child('money').value.toString());
                  spending.t1 > maxNum
                      ? maxNum = int.parse(spending.t1.toString().split('.')[0])
                      : maxNum;
                }
                break;

              case 2:
                {
                  spending.t2 +=
                      int.parse(itemC.child('money').value.toString());
                  spending.t2 > maxNum
                      ? maxNum = int.parse(spending.t2.toString().split('.')[0])
                      : maxNum;
                }
                break;

              case 3:
                {
                  spending.t3 +=
                      int.parse(itemC.child('money').value.toString());
                  spending.t3 > maxNum
                      ? maxNum = int.parse(spending.t3.toString().split('.')[0])
                      : maxNum;
                }
                break;

              case 4:
                {
                  spending.t4 +=
                      int.parse(itemC.child('money').value.toString());
                  spending.t4 > maxNum
                      ? maxNum = int.parse(spending.t4.toString().split('.')[0])
                      : maxNum;
                }
                break;

              case 5:
                {
                  spending.t5 +=
                      int.parse(itemC.child('money').value.toString());
                  spending.t5 > maxNum
                      ? maxNum = int.parse(spending.t5.toString().split('.')[0])
                      : maxNum;
                }
                break;

              case 6:
                {
                  spending.t6 +=
                      int.parse(itemC.child('money').value.toString());
                  spending.t6 > maxNum
                      ? maxNum = int.parse(spending.t6.toString().split('.')[0])
                      : maxNum;
                }
                break;

              case 7:
                {
                  spending.t7 +=
                      int.parse(itemC.child('money').value.toString());
                  spending.t7 > maxNum
                      ? maxNum = int.parse(spending.t7.toString().split('.')[0])
                      : maxNum;
                }
                break;

              case 8:
                {
                  spending.t8 +=
                      int.parse(itemC.child('money').value.toString());
                  spending.t8 > maxNum
                      ? maxNum = int.parse(spending.t8.toString().split('.')[0])
                      : maxNum;
                }
                break;

              case 9:
                {
                  spending.t9 +=
                      int.parse(itemC.child('money').value.toString());
                  spending.t9 > maxNum
                      ? maxNum = int.parse(spending.t9.toString().split('.')[0])
                      : maxNum;
                }
                break;

              case 10:
                {
                  spending.t10 +=
                      int.parse(itemC.child('money').value.toString());
                  spending.t10 > maxNum
                      ? maxNum =
                          int.parse(spending.t10.toString().split('.')[0])
                      : maxNum;
                }
                break;
              case 11:
                {
                  spending.t11 +=
                      int.parse(itemC.child('money').value.toString());
                  spending.t11 > maxNum
                      ? maxNum =
                          int.parse(spending.t11.toString().split('.')[0])
                      : maxNum;
                }
                break;
              case 12:
                {
                  spending.t12 +=
                      int.parse(itemC.child('money').value.toString());
                  spending.t12 > maxNum
                      ? maxNum =
                          int.parse(spending.t12.toString().split('.')[0])
                      : maxNum;
                }
                break;
            }
          }
        });
      }
    });
  }

  void _getInComesItem() {
    _totalCategory = db
        .child('incomes')
        .orderByChild('uID')
        .equalTo(auth.currentUser!.uid)
        .onValue
        .listen((event) {
      final data = event.snapshot.children;
      if (mounted) {
        setState(() {
          income = MonthChart(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
          for (var itemC in data) {
            switch (DateTime.parse(itemC.child('timeChosse').value.toString())
                .month) {
              case 1:
                {
                  income.t1 += int.parse(itemC.child('money').value.toString());
                  income.t1 > maxNum
                      ? maxNum = int.parse(income.t1.toString().split('.')[0])
                      : maxNum;
                }
                break;

              case 2:
                {
                  income.t2 += int.parse(itemC.child('money').value.toString());
                  income.t2 > maxNum
                      ? maxNum = int.parse(income.t2.toString().split('.')[0])
                      : maxNum;
                }
                break;

              case 3:
                {
                  income.t3 += int.parse(itemC.child('money').value.toString());
                  income.t3 > maxNum
                      ? maxNum = int.parse(income.t3.toString().split('.')[0])
                      : maxNum;
                }
                break;

              case 4:
                {
                  income.t4 += int.parse(itemC.child('money').value.toString());
                  income.t4 > maxNum
                      ? maxNum = int.parse(income.t4.toString().split('.')[0])
                      : maxNum;
                }
                break;

              case 5:
                {
                  income.t5 += int.parse(itemC.child('money').value.toString());
                  income.t5 > maxNum
                      ? maxNum = int.parse(income.t5.toString().split('.')[0])
                      : maxNum;
                }
                break;

              case 6:
                {
                  income.t6 += int.parse(itemC.child('money').value.toString());
                  income.t6 > maxNum
                      ? maxNum = int.parse(income.t6.toString().split('.')[0])
                      : maxNum;
                }
                break;

              case 7:
                {
                  income.t7 += int.parse(itemC.child('money').value.toString());
                  income.t7 > maxNum
                      ? maxNum = int.parse(income.t7.toString().split('.')[0])
                      : maxNum;
                }
                break;

              case 8:
                {
                  income.t8 += int.parse(itemC.child('money').value.toString());
                  income.t8 > maxNum
                      ? maxNum = int.parse(income.t8.toString().split('.')[0])
                      : maxNum;
                }
                break;

              case 9:
                {
                  income.t9 += int.parse(itemC.child('money').value.toString());
                  income.t9 > maxNum
                      ? maxNum = int.parse(income.t9.toString().split('.')[0])
                      : maxNum;
                }
                break;

              case 10:
                {
                  income.t10 +=
                      int.parse(itemC.child('money').value.toString());
                  income.t10 > maxNum
                      ? maxNum = int.parse(income.t10.toString().split('.')[0])
                      : maxNum;
                }
                break;
              case 11:
                {
                  income.t11 +=
                      int.parse(itemC.child('money').value.toString());
                  income.t11 > maxNum
                      ? maxNum = int.parse(income.t11.toString().split('.')[0])
                      : maxNum;
                }
                break;
              case 12:
                {
                  income.t12 +=
                      int.parse(itemC.child('money').value.toString());
                  income.t12 > maxNum
                      ? maxNum = int.parse(income.t12.toString().split('.')[0])
                      : maxNum;
                }
                break;
            }
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width * 3 / 4,
        height: double.infinity,
        color: kdybackgroup,
        child: SafeArea(
          child: Column(
            // ignore: prefer_const_literals_to_create_immutables
            children: [
              InkWell(
                onTap: () {
                  Navigator.of(context).push(
                    PageRouteBuilder(
                        opaque: false,
                        pageBuilder: (BuildContext context, _, __) =>
                            const ProfileUser()),
                  );
                },
                child: InfoCard(),
              ),
              ...sideMenus.map((menu) => SideMenuTitle(
                    menu: menu,
                    riveonInit: (artboard) {
                      StateMachineController controller =
                          RiveUtils.getRiveController(artboard,
                              stateMachineName: menu.stateMachineName);
                      menu.input = controller.findSMI('active') as SMIBool;
                    },
                    press: () async {
                      menu.input!.change(true);
                      Future.delayed(const Duration(seconds: 1), () {
                        menu.input!.change(false);
                      });
                      setState(() {
                        selectMenu = menu;
                      });
                      if (selectMenu == sideMenus[0]) {
                        // Navigator.popUntil();
                        // Get.to(() => const SalaryPlan(),
                        //     transition: Transition.rightToLeftWithFade,
                        //     duration: const Duration(milliseconds: 500));
                      } else if (selectMenu == sideMenus[1]) {
                        print(maxNum);
                        final demo = await Get.to(
                            () => PieChart(
                                  maxNum: maxNum,
                                  spending: spending,
                                  income: income,
                                ),
                            transition: Transition.rightToLeftWithFade,
                            duration: const Duration(milliseconds: 500));
                        print(demo);
                      } else if (selectMenu == sideMenus[2]) {
                        Get.to(() => const NotifiCationskdy(),
                            transition: Transition.rightToLeftWithFade,
                            duration: const Duration(milliseconds: 500));
                      } else if (selectMenu == sideMenus[3]) {
                        Get.to(() => const SalaryPlan(),
                            transition: Transition.rightToLeftWithFade,
                            duration: const Duration(milliseconds: 500));
                      } else if (selectMenu == sideMenus[4]) {
                        Navigator.pushNamedAndRemoveUntil(
                            context, 'phone', (route) => false);
                        FirebaseAuth.instance.signOut();
                      }
                    },
                    isActive: selectMenu == menu,
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
