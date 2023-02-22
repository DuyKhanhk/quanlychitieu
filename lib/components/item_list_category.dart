// ignore_for_file: avoid_print

import 'dart:async';

import 'package:expandable/expandable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:quanlychitieu/components/update_widget.dart';
import 'package:quanlychitieu/constant.dart';

import '../models/model.dart';

final formatCurrency = NumberFormat("#,##0", "en_US");

class ItemCategory extends StatefulWidget {
  const ItemCategory(
      {super.key,
      required this.currentScreen,
      required this.expense,
      required this.snapshot});
  final DataSnapshot snapshot;
  final Expense expense;
  final int currentScreen;

  @override
  State<ItemCategory> createState() => _ItemCategoryState();
}

class _ItemCategoryState extends State<ItemCategory> {
  final db = FirebaseDatabase.instance.ref();
  final auth = FirebaseAuth.instance;
  late StreamSubscription getTotalMoney;
  TextEditingController txtTotalMoney = TextEditingController();

  @override
  void initState() {
    super.initState();
    _getTotalMoney();
  }

  void _getTotalMoney() {
    getTotalMoney = db
        .child('users/${auth.currentUser!.uid}/accountBanks')
        .onValue
        .listen((event) {
      final data = event.snapshot.value as dynamic;
      if (mounted) {
        setState(() {
          txtTotalMoney.text = data[2].toString();
        });
      }
    });
  }

  void _removeItemCategory() {
    if (widget.currentScreen == 0) {
      final index = int.parse(widget.expense.money) +
          int.parse(txtTotalMoney.text.toString());
      final update = <String, dynamic>{'1': 'Ví', '2': index};
      db
          .child('users/${auth.currentUser!.uid}/accountBanks')
          .update(update)
          .then((_) => print('newSpending has been written!'))
          .catchError((error) => print('You got an error $error'));

      db.child('spendings/${widget.snapshot.key}').remove();
    } else {
      final index = int.parse(txtTotalMoney.text.toString()) -
          int.parse(widget.expense.money);
      final update = <String, dynamic>{'1': 'Ví', '2': index};
      db
          .child('users/${auth.currentUser!.uid}/accountBanks')
          .update(update)
          .then((_) => print('newSpending has been written!'))
          .catchError((error) => print('You got an error $error'));

      db.child('spendings/${widget.snapshot.key}').remove();
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWith = MediaQuery.of(context).size.width;
    return ExpandableNotifier(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 13),
        child: Expanded(
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.grey[200],
                boxShadow: [
                  BoxShadow(
                      spreadRadius: -5,
                      blurRadius: 7,
                      offset: const Offset(0, 4),
                      color: kdybackgroup),
                ]),
            child: Column(
              children: [
                SizedBox(
                  height: screenWith / 7.5,
                  child: Slidable(
                    key: UniqueKey(),
                    // ignore: prefer_const_constructors
                    endActionPane: ActionPane(
                      motion: const ScrollMotion(),
                      dismissible: DismissiblePane(
                          onDismissed: () => _removeItemCategory()),
                      children: [
                        SlidableAction(
                          borderRadius: BorderRadius.circular(10),
                          onPressed: (context) => _removeItemCategory(),
                          backgroundColor:
                              const Color.fromARGB(255, 182, 73, 254),
                          foregroundColor: Colors.white,
                          icon: Icons.delete,
                          label: 'Xóa',
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        SizedBox(
                          width: screenWith / 40,
                        ),
                        Icon(
                          Icons.money,
                          color: Colors.indigo.withOpacity(.7),
                          size: 30,
                        ),
                        SizedBox(
                          width: screenWith / 1.4,
                          child: ListTile(
                            title: Text(
                              '${formatCurrency.format(
                                widget.snapshot.child('money').value,
                              )} VND',
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: kdybackgroup.withOpacity(0.9),
                                  fontSize: 25),
                            ),
                            subtitle: Text(
                              '${DateTime.parse(widget.expense.timeChosse).month}-${DateTime.parse(widget.expense.timeChosse).day}-${DateTime.parse(widget.expense.timeChosse).year}',
                              style: const TextStyle(fontSize: 15),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                ScrollOnExpand(
                    child: ExpandablePanel(
                  theme: const ExpandableThemeData(
                      tapBodyToExpand: true, tapBodyToCollapse: true),
                  header: Container(
                    padding: const EdgeInsets.only(top: 20, left: 10),
                    child: Text(
                      'Ngày tạo: ${widget.expense.timeInput}',
                      style: TextStyle(color: Colors.black.withOpacity(.7)),
                    ),
                  ),
                  collapsed: Align(
                    alignment: Alignment.bottomCenter,
                    child: widget.expense.note != ''
                        ? Container(
                            width: screenWith / 1.1,
                            padding: const EdgeInsets.fromLTRB(10, 7, 7, 7),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.indigo.withOpacity(0.95)),
                            child: SingleChildScrollView(
                              child: Text(
                                widget.expense.note,
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 15,
                                    color: Colors.grey[200]),
                              ),
                            ),
                          )
                        : Container(),
                  ),
                  expanded: UpdateWidget(
                    keyItemCategory: widget.snapshot.key.toString(),
                    expense: widget.expense,
                    currentScreen: widget.currentScreen,
                  ),
                  builder: (_, collapsed, expanded) {
                    return Expandable(
                      collapsed: collapsed,
                      expanded: expanded,
                      theme: const ExpandableThemeData(),
                    );
                  },
                ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
