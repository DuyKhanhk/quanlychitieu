// ignore_for_file: unused_field

import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:quanlychitieu/constant.dart';
import 'package:quanlychitieu/models/rive_assets.dart';
import 'package:quanlychitieu/screens/chart.dart';
import 'package:quanlychitieu/screens/home.dart';
import 'package:quanlychitieu/screens/profile_user.dart';
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
                      int.parse(itemC.child('money').value.toString()) /
                          2500000;
                }
                break;

              case 2:
                {
                  spending.t2 +=
                      int.parse(itemC.child('money').value.toString()) /
                          2500000;
                }
                break;

              case 3:
                {
                  spending.t3 +=
                      int.parse(itemC.child('money').value.toString()) /
                          2500000;
                }
                break;

              case 4:
                {
                  spending.t4 +=
                      int.parse(itemC.child('money').value.toString()) /
                          2500000;
                }
                break;

              case 5:
                {
                  spending.t5 +=
                      int.parse(itemC.child('money').value.toString()) /
                          2500000;
                }
                break;

              case 6:
                {
                  spending.t6 +=
                      int.parse(itemC.child('money').value.toString()) /
                          2500000;
                }
                break;

              case 7:
                {
                  spending.t7 +=
                      int.parse(itemC.child('money').value.toString()) /
                          2500000;
                }
                break;

              case 8:
                {
                  spending.t8 +=
                      int.parse(itemC.child('money').value.toString()) /
                          2500000;
                }
                break;

              case 9:
                {
                  spending.t9 +=
                      int.parse(itemC.child('money').value.toString()) /
                          2500000;
                }
                break;

              case 10:
                {
                  spending.t10 +=
                      int.parse(itemC.child('money').value.toString()) /
                          2500000;
                }
                break;
              case 11:
                {
                  spending.t11 +=
                      int.parse(itemC.child('money').value.toString()) /
                          2500000;
                }
                break;
              case 12:
                {
                  spending.t12 +=
                      int.parse(itemC.child('money').value.toString()) /
                          2500000;
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
                  income.t1 +=
                      int.parse(itemC.child('money').value.toString()) /
                          2500000;
                }
                break;

              case 2:
                {
                  income.t2 +=
                      int.parse(itemC.child('money').value.toString()) /
                          2500000;
                }
                break;

              case 3:
                {
                  income.t3 +=
                      int.parse(itemC.child('money').value.toString()) /
                          2500000;
                }
                break;

              case 4:
                {
                  income.t4 +=
                      int.parse(itemC.child('money').value.toString()) /
                          2500000;
                }
                break;

              case 5:
                {
                  income.t5 +=
                      int.parse(itemC.child('money').value.toString()) /
                          2500000;
                }
                break;

              case 6:
                {
                  income.t6 +=
                      int.parse(itemC.child('money').value.toString()) /
                          2500000;
                }
                break;

              case 7:
                {
                  income.t7 +=
                      int.parse(itemC.child('money').value.toString()) /
                          2500000;
                }
                break;

              case 8:
                {
                  income.t8 +=
                      int.parse(itemC.child('money').value.toString()) /
                          2500000;
                }
                break;

              case 9:
                {
                  income.t9 +=
                      int.parse(itemC.child('money').value.toString()) /
                          2500000;
                }
                break;

              case 10:
                {
                  income.t10 +=
                      int.parse(itemC.child('money').value.toString()) /
                          2500000;
                }
                break;
              case 11:
                {
                  income.t11 +=
                      int.parse(itemC.child('money').value.toString()) /
                          2500000;
                }
                break;
              case 12:
                {
                  income.t12 +=
                      int.parse(itemC.child('money').value.toString()) /
                          2500000;
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
                    press: () {
                      menu.input!.change(true);
                      Future.delayed(const Duration(seconds: 1), () {
                        menu.input!.change(false);
                      });
                      setState(() {
                        selectMenu = menu;
                      });
                      if (selectMenu == sideMenus[0]) {
                        // Navigator.popUntil();
                        Get.to(() => const Home(),
                            transition: Transition.rightToLeftWithFade,
                            duration: const Duration(milliseconds: 500));
                      } else if (selectMenu == sideMenus[1]) {
                        // Navigator.of(context).push(MaterialPageRoute(
                        //   builder: (context) => const PieChart(),
                        // ));
                        Get.to(
                            () => PieChart(
                                  spending: spending,
                                  income: income,
                                ),
                            transition: Transition.rightToLeftWithFade,
                            duration: const Duration(milliseconds: 500));
                      } else if (selectMenu == sideMenus[5]) {
                        FirebaseAuth.instance.signOut();
                        Navigator.pushNamedAndRemoveUntil(
                            context, 'phone', (route) => false);
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
