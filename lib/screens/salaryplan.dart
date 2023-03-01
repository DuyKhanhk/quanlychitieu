// ignore_for_file: avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:quanlychitieu/constant.dart';

final formatCurrency = NumberFormat("#,##0", "en_US");

class SalaryPlan extends StatefulWidget {
  const SalaryPlan({super.key});

  @override
  State<SalaryPlan> createState() => _SalaryPlanState();
}

class _SalaryPlanState extends State<SalaryPlan> {
  final auth = FirebaseAuth.instance;
  final _db = FirebaseDatabase.instance.ref();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: StreamBuilder(
              stream: _db.child('users/${auth.currentUser!.uid}').onValue,
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.data != null) {
                  final data = (snapshot.data as DatabaseEvent)
                      .snapshot
                      .child('accountBanks')
                      .value as List<dynamic>;
                  final index = int.parse(data[9].toString());
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          Align(
                            alignment: Alignment.topLeft,
                            child: IconButton(
                                onPressed: () => Get.back(),
                                icon: Icon(
                                  Icons.arrow_back_ios,
                                  color: kdy2,
                                  size: 30,
                                )),
                          ),
                          Text(
                            'Kế hoạch sử dụng lương',
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 24,
                                color: Colors.black.withOpacity(0.6)),
                          ),
                        ],
                      ),
                      Container(
                        margin: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                  spreadRadius: -5,
                                  blurRadius: 15,
                                  offset: const Offset(5, 5),
                                  color: kdybackgroup),
                            ]),
                        child: Row(
                          children: [
                            ItemSalary(
                              num: '55',
                              title:
                                  '${!int.parse(data[3].toString()).isNaN ? 0 : (int.parse(data[3].toString()) / index * 100).toStringAsFixed(2)}% \nSinh hoạt',
                              money: formatCurrency
                                  .format(int.parse(data[3].toString())),
                            ),
                            ItemSalary(
                              num: '10',
                              title:
                                  '${!int.parse(data[4].toString()).isNaN ? 0 : (int.parse(data[4].toString()) / index * 100).toStringAsFixed(2)}% \nHọc tập',
                              money: formatCurrency
                                  .format(int.parse(data[4].toString())),
                            ),
                            ItemSalary(
                              num: '10',
                              money: formatCurrency
                                  .format(int.parse(data[5].toString())),
                              title:
                                  '${!int.parse(data[5].toString()).isNaN ? 0 : (int.parse(data[5].toString()) / index * 100).toStringAsFixed(2)}% \nTiết kiệm',
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                  spreadRadius: -5,
                                  blurRadius: 15,
                                  offset: const Offset(5, 5),
                                  color: kdybackgroup),
                            ]),
                        child: Row(
                          children: [
                            ItemSalary(
                              num: '10',
                              money: formatCurrency
                                  .format(int.parse(data[6].toString())),
                              title:
                                  '${!int.parse(data[6].toString()).isNaN ? 0 : (int.parse(data[6].toString()) / index * 100).toStringAsFixed(2)}% \nĐầu tư',
                            ),
                            ItemSalary(
                              num: '10',
                              money: formatCurrency
                                  .format(int.parse(data[7].toString())),
                              title:
                                  '${!int.parse(data[7].toString()).isNaN ? 0 : (int.parse(data[7].toString()) / index * 100).toStringAsFixed(2)}% \nHưởng thụ',
                            ),
                            ItemSalary(
                              num: '5',
                              money: formatCurrency
                                  .format(int.parse(data[8].toString())),
                              title:
                                  '${!int.parse(data[8].toString()).isNaN ? 0 : (int.parse(data[8].toString()) / index * 100).toStringAsFixed(2)}% \nTừ thiện',
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              data[10].toString() != ''
                                  ? Container(
                                      decoration: BoxDecoration(
                                          color: Colors.grey[100],
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          boxShadow: [
                                            BoxShadow(
                                                spreadRadius: -5,
                                                blurRadius: 15,
                                                offset: const Offset(5, 5),
                                                color: kdybackgroup
                                                    .withOpacity(0.8)),
                                          ]),
                                      child: TextButton(
                                          onPressed: () {
                                            final index = int.parse(
                                                    data[2].toString()) +
                                                int.parse(data[3].toString()) +
                                                int.parse(data[4].toString()) +
                                                int.parse(data[5].toString()) +
                                                int.parse(data[6].toString()) +
                                                int.parse(data[7].toString()) +
                                                int.parse(data[8].toString());

                                            final update = <String, dynamic>{
                                              '2': index,
                                              '3': 0,
                                              '4': 0,
                                              '5': 0,
                                              '6': 0,
                                              '7': 0,
                                              '8': 0,
                                              '9': 0,
                                              '10': ''
                                            };
                                            _db
                                                .child(
                                                    'users/${auth.currentUser!.uid}/accountBanks')
                                                .update(update)
                                                .then((_) => print(
                                                    'newIncome has been written!'))
                                                .catchError((error) => print(
                                                    'You got an error $error'));
                                          },
                                          child: const Text(
                                            'Hủy kế hoạch',
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w700),
                                          )),
                                    )
                                  : Container()
                            ],
                          ),
                        ),
                      )
                    ],
                  );
                } else {
                  return const CircularProgressIndicator();
                }
              })),
    );
  }
}

class ItemSalary extends StatelessWidget {
  const ItemSalary({
    super.key,
    required this.num,
    required this.title,
    required this.money,
  });
  final String num, title, money;
  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Stack(
      alignment: Alignment.center,
      children: [
        Lottie.asset('assets/images/jarCoins.json'),
        Padding(
          padding: const EdgeInsets.only(top: 113.0, left: 4),
          child: Container(
            width: 75,
            padding: const EdgeInsets.all(5),
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(15)),
            child: Text(
              '$num%',
              style: TextStyle(
                  fontWeight: FontWeight.w900,
                  color: Colors.black.withOpacity(.75),
                  fontSize: 30,
                  backgroundColor: Colors.white,
                  letterSpacing: 1.1),
            ),
          ),
        ),
        Padding(
            padding: const EdgeInsets.only(bottom: 70),
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                  color: Colors.black.withOpacity(0.65)),
            )),
        Padding(
            padding: const EdgeInsets.only(top: 270, bottom: 10),
            child: Text(
              "$money VND",
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                  color: Colors.black.withOpacity(0.65)),
            ))
      ],
    ));
  }
}
