// ignore_for_file: avoid_print

import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:quanlychitieu/constant.dart';
import 'package:quanlychitieu/models/model.dart';

import '../screens/calculator.dart';
import 'notify_showdialog.dart';

class UpdateWidget extends StatefulWidget {
  const UpdateWidget(
      {super.key,
      required this.currentScreen,
      required this.expense,
      required this.keyItemCategory});
  final int currentScreen;
  final Expense expense;
  final String keyItemCategory;
  @override
  State<UpdateWidget> createState() => _UpdateWidgetState();
}

class _UpdateWidgetState extends State<UpdateWidget> {
  FirebaseAuth auth = FirebaseAuth.instance;
  final _db = FirebaseDatabase.instance.ref();

  TextEditingController txtSpending = TextEditingController();
  TextEditingController txtIncome = TextEditingController();
  TextEditingController txtSpedingNote = TextEditingController();
  TextEditingController txtIncomeNote = TextEditingController();
  TextEditingController txtTotalMoney = TextEditingController();
  late StreamSubscription getTotalMoney;
  String? _selectedItemSpending = '';
  String? _selectedItemIncome = '';
  late DateTime dateTime;

  @override
  void initState() {
    super.initState();
    _selectedItemSpending = widget.expense.type;
    _selectedItemIncome = widget.expense.type;
    txtSpending.text = txtIncome.text = widget.expense.money;
    txtSpedingNote.text = txtIncomeNote.text = widget.expense.note;
    dateTime = DateTime.parse(widget.expense.timeChosse);
    _getTotalMoney();
  }

  void _getTotalMoney() {
    getTotalMoney = _db
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

  void _insertData() async {
    switch (widget.currentScreen) {
      case 0:
        {
          if (txtSpending.text != '') {
            final newSpending = <String, dynamic>{
              'uID': auth.currentUser!.uid,
              'money': int.parse(txtSpending.text.toString()),
              'type': _selectedItemSpending,
              'timeChosse': dateTime.toString(),
              'timeInput': widget.expense.timeInput,
              'note': txtSpedingNote.text,
            };
            _db
                .child('spendings/${widget.keyItemCategory}')
                .set(newSpending)
                .then((_) => print('newSpending has been written!'))
                .catchError((error) => print('You got an error $error'));

            final index = int.parse(txtTotalMoney.text.toString()) -
                int.parse(txtSpending.text.toString()) +
                int.parse(widget.expense.money);
            final update = <String, dynamic>{'1': 'Ví', '2': index};
            _db
                .child('users/${auth.currentUser!.uid}/accountBanks')
                .update(update)
                .then((_) => print('newSpending has been written!'))
                .catchError((error) => print('You got an error $error'));

            Navigator.of(context).push(
              PageRouteBuilder(
                opaque: false,
                pageBuilder: (BuildContext context, _, __) => const Successfull(
                  content: 'Tuyệt vời!',
                ),
              ),
            );
          } else {
            Navigator.of(context).push(
              PageRouteBuilder(
                  opaque: false,
                  pageBuilder: (BuildContext context, _, __) =>
                      const NotifyShowdialog(
                          content: 'Vui lòng nhập số tiền đã chi')),
            );
          }
        }
        break;
      case 1:
        {
          if (txtIncome.text != '') {
            final newIncome = <String, dynamic>{
              'uID': auth.currentUser!.uid,
              'money': int.parse(txtIncome.text.toString()),
              'type': _selectedItemIncome,
              'timeChosse': dateTime.toString(),
              'timeInput': widget.expense.timeInput,
              'note': txtSpedingNote.text,
            };
            _db
                .child('incomes/${widget.keyItemCategory}')
                .set(newIncome)
                .then((_) => print('newSpending has been written!'))
                .catchError((error) => print('You got an error $error'));

            final index = int.parse(txtTotalMoney.text.toString()) +
                int.parse(txtIncome.text.toString()) -
                int.parse(widget.expense.money);
            final update = <String, dynamic>{'1': 'Ví', '2': index};
            _db
                .child('users/${auth.currentUser!.uid}/accountBanks')
                .update(update)
                .then((_) => print('newIncome has been written!'))
                .catchError((error) => print('You got an error $error'));

            Navigator.of(context).push(
              PageRouteBuilder(
                opaque: false,
                pageBuilder: (BuildContext context, _, __) => const Successfull(
                  content: 'Tuyệt vời!',
                ),
              ),
            );
          } else {
            Navigator.of(context).push(
              PageRouteBuilder(
                  opaque: false,
                  pageBuilder: (BuildContext context, _, __) =>
                      const NotifyShowdialog(
                          content: 'Vui lòng nhập số tiền đã nhận')),
            );
          }
        }
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    Size screensIndex = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.all(screensIndex.width / 20),
      child: Container(
        width: screensIndex.width * 7 / 8,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.grey[300],
            boxShadow: [
              BoxShadow(
                  spreadRadius: -5,
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                  color: kdybackgroup),
            ]),
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            screensIndex.width / 20,
            screensIndex.width / 20,
            screensIndex.width / 20,
            screensIndex.width / 15,
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: TextField(
                          textInputAction: TextInputAction.next,
                          controller: widget.currentScreen == 0
                              ? txtSpending
                              : txtIncome,
                          cursorColor: Colors.indigo,
                          cursorWidth: 2,
                          textAlign: TextAlign.center,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              hintText: 'Sửa đi nào...'),
                          onSubmitted: (value) {
                            txtIncome.text = txtSpending.text = value;
                          }),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.calculate_outlined,
                        size: 35,
                      ),
                      onPressed: () => Get.to(const Calcualtor(),
                          transition: Transition.zoom),
                    ),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(5),
                        alignment: Alignment.center,
                        height: screensIndex.width / 10,
                        decoration: BoxDecoration(
                            border: Border.all(width: 2),
                            borderRadius: BorderRadius.circular(7)),
                        child: const Text(
                          'VND',
                          style: TextStyle(
                              letterSpacing: 1.2,
                              fontSize: 21,
                              fontWeight: FontWeight.w600,
                              color: Colors.black54),
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: screensIndex.width / 15,
                ),
                DropdownButtonFormField(
                  value: widget.currentScreen == 0
                      ? _selectedItemSpending
                      : _selectedItemIncome,
                  items: widget.currentScreen == 0
                      ? listSpending.map((e) {
                          return DropdownMenuItem(
                            // ignore: sort_child_properties_last
                            child: Text(e),
                            value: e,
                          );
                        }).toList()
                      : listImcome.map((e) {
                          return DropdownMenuItem(
                            // ignore: sort_child_properties_last
                            child: Text(e),
                            value: e,
                          );
                        }).toList(),
                  onChanged: ((value) {
                    setState(() {
                      widget.currentScreen == 0
                          ? _selectedItemSpending = value as String
                          : _selectedItemIncome = value as String;
                    });
                  }),
                  icon: Icon(
                    Icons.arrow_drop_down_circle,
                    color: Colors.indigo[400],
                  ),
                  dropdownColor: Colors.indigo[300],
                  decoration: InputDecoration(
                      labelText: widget.currentScreen == 0
                          ? 'Chi tiêu cho...'
                          : 'Thu nhập nhờ',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20))),
                ),
                SizedBox(
                  height: screensIndex.width / 15,
                ),
                Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(width: 1, color: Colors.grey)),
                  child: CupertinoPageScaffold(
                    backgroundColor: Colors.grey[300],
                    child: CupertinoButton(
                      child: Text(
                        '${dateTime.month}-${dateTime.day}-${dateTime.year}',
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
                                    backgroundColor: Colors.indigo[400],
                                    initialDateTime: dateTime,
                                    onDateTimeChanged: (DateTime newTime) {
                                      setState(() {
                                        dateTime = newTime;
                                      });
                                    },
                                    use24hFormat: true,
                                    mode: CupertinoDatePickerMode.date,
                                  ),
                                ));
                      },
                    ),
                  ),
                ),
                SizedBox(
                  height: screensIndex.width / 15,
                ),
                Container(
                  width: double.infinity,
                  height: screensIndex.width / 2.2,
                  decoration: BoxDecoration(
                      color: Colors.white54,
                      border: Border.all(width: 3, color: Colors.grey),
                      borderRadius: BorderRadius.circular(20)),
                  child: TextField(
                      controller: txtSpedingNote,
                      maxLines: null,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: const InputDecoration(
                          hintText: ' Ghi chú...', border: InputBorder.none),
                      onSubmitted: (value) {
                        txtSpedingNote.text = value;
                      }),
                ),
                Center(
                  child: InkWell(
                    onTap: () => _insertData(),
                    child: Container(
                      width: screensIndex.width / 3.5,
                      margin: const EdgeInsets.only(top: 15),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            const BoxShadow(
                                spreadRadius: -5,
                                blurRadius: 10,
                                offset: Offset(-5, -5),
                                color: Colors.white),
                            BoxShadow(
                                spreadRadius: -5,
                                blurRadius: 15,
                                offset: const Offset(5, 5),
                                color: kdybackgroup),
                          ]),
                      child: Lottie.asset('assets/images/savebtn.json',
                          width: screensIndex.width / 3.5, fit: BoxFit.fill),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
