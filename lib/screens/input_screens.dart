// ignore_for_file: avoid_print, use_build_context_synchronously, prefer_typing_uninitialized_variables, non_constant_identifier_names

import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quanlychitieu/components/Appbar_cust.dart';
import 'package:quanlychitieu/components/notify_showdialog.dart';
import 'package:quanlychitieu/screens/calculator.dart';
import 'package:quanlychitieu/sevices/id_generate.dart';
import 'package:widget_and_text_animator/widget_and_text_animator.dart';
import '../constant.dart';

// ignore: must_be_immutable
class Input extends StatefulWidget {
  // ignore:
  Input({super.key, this.selected_index});
  var selected_index;
  @override
  State<Input> createState() => _InputState();
}

class _InputState extends State<Input> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final _db = FirebaseDatabase.instance.ref();

  DateTime dateTime = DateTime.now();
  String? _selectedItemSpending = '';
  String? _selectedItemIncome = '';
  TextEditingController txtSpending = TextEditingController();
  TextEditingController txtIncome = TextEditingController();
  TextEditingController txtSpedingNote = TextEditingController();
  TextEditingController txtIncomeNote = TextEditingController();
  TextEditingController txtTotalMoney = TextEditingController();
  late StreamSubscription getTotalMoney;

  //  late StreamSubscription _useLevel;
  // ignore:
  @override
  void initState() {
    super.initState();
    _selectedItemSpending = listSpending[0];
    _selectedItemIncome = listImcome[0];
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
    switch (widget.selected_index) {
      case 0:
        {
          if (txtSpending.text != '') {
            final newSpending = <String, dynamic>{
              'uID': auth.currentUser!.uid,
              'money': int.parse(txtSpending.text.toString()),
              'type': _selectedItemSpending,
              'timeChosse': dateTime.toString(),
              'timeInput': DateTime.now().toString(),
              'note': txtSpedingNote.text,
            };
            _db
                .child('spendings/${GUIDGen.generate()}')
                .set(newSpending)
                .then((_) => print('newSpending has been written!'))
                .catchError((error) => print('You got an error $error'));

            final index = int.parse(txtTotalMoney.text.toString()) -
                int.parse(txtSpending.text.toString());
            final update = <String, dynamic>{'1': 'Ví', '2': index};
            _db
                .child('users/${auth.currentUser!.uid}/accountBanks')
                .update(update)
                .then((_) => print('newSpending has been written!'))
                .catchError((error) => print('You got an error $error'));

            txtSpedingNote.clear();
            txtSpending.clear();
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
              'timeInput': DateTime.now().toString(),
              'note': txtIncomeNote.text,
            };
            _db
                .child('incomes/${GUIDGen.generate()}')
                .set(newIncome)
                .then((_) => print('newSpending has been written!'))
                .catchError((error) => print('You got an error $error'));

            final index = int.parse(txtTotalMoney.text.toString()) +
                int.parse(txtIncome.text.toString());
            final update = <String, dynamic>{'1': 'Ví', '2': index};
            _db
                .child('users/${auth.currentUser!.uid}/accountBanks')
                .update(update)
                .then((_) => print('newIncome has been written!'))
                .catchError((error) => print('You got an error $error'));
            txtIncome.clear();
            txtIncomeNote.clear();
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
    return DefaultTabController(
        initialIndex: widget.selected_index,
        length: 2,
        child: Scaffold(
            body: Stack(
          alignment: AlignmentDirectional.topCenter,
          children: [
            AppbarCustomInput(screensIndex: screensIndex),
            Padding(
              padding: EdgeInsets.only(top: screensIndex.width / 2.5),
              child: Container(
                  width: screensIndex.width * 7 / 8,
                  height: screensIndex.width / 7,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: const Color.fromARGB(249, 255, 101, 96),
                      boxShadow: [
                        BoxShadow(
                            spreadRadius: -5,
                            blurRadius: 15,
                            offset: const Offset(0, 5),
                            color: kdybackgroup),
                      ]),
                  // ignore: prefer_const_constructors
                  child: WidgetAnimator(
                    incomingEffect:
                        WidgetTransitionEffects.incomingSlideInFromRight(),
                    child: TabBar(
                      onTap: (index) {
                        setState(() {
                          widget.selected_index = index;
                        });
                      },
                      indicatorColor: Colors.white,
                      indicatorWeight: 4,
                      indicatorPadding:
                          const EdgeInsets.only(left: 15, right: 15),
                      tabs: const [
                        Tab(
                          icon: Icon(Icons.outbond),
                          text: 'Chi tiêu',
                        ),
                        Tab(
                          icon: Icon(Icons.incomplete_circle),
                          text: 'Thu nhập',
                        ),
                      ],
                    ),
                  )),
            ),
            Padding(
              padding: EdgeInsets.only(
                  top: screensIndex.width / 2,
                  bottom: screensIndex.width / 6.5),
              child: TabBarView(children: [
                Padding(
                  padding: EdgeInsets.all(screensIndex.width / 15),
                  child: Container(
                    width: screensIndex.width * 7 / 8,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
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
                                      controller: txtSpending,
                                      cursorColor: Colors.indigo,
                                      cursorWidth: 2,
                                      textAlign: TextAlign.center,
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20)),
                                          hintText: 'Nhập chi tiêu ngay nào..'),
                                      onSubmitted: (value) {
                                        print(value);
                                        txtSpending.text = value;
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
                                          fontSize: 24,
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
                              value: _selectedItemSpending,
                              items: listSpending.map((e) {
                                return DropdownMenuItem(
                                  // ignore: sort_child_properties_last
                                  child: Text(e),
                                  value: e,
                                );
                              }).toList(),
                              onChanged: ((value) {
                                setState(() {
                                  _selectedItemSpending = value as String;
                                });
                              }),
                              icon: Icon(
                                Icons.arrow_drop_down_circle,
                                color: Colors.indigo[400],
                              ),
                              dropdownColor: Colors.indigo[300],
                              decoration: InputDecoration(
                                  labelText: 'Chi tiêu cho...',
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
                                  border:
                                      Border.all(width: 1, color: Colors.grey)),
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
                                        builder: (BuildContext context) =>
                                            SizedBox(
                                              height: screensIndex.width * 0.8,
                                              child: CupertinoDatePicker(
                                                backgroundColor:
                                                    Colors.indigo[400],
                                                initialDateTime: dateTime,
                                                onDateTimeChanged:
                                                    (DateTime newTime) {
                                                  setState(() {
                                                    dateTime = newTime;
                                                  });
                                                },
                                                use24hFormat: true,
                                                mode: CupertinoDatePickerMode
                                                    .date,
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
                                  border:
                                      Border.all(width: 3, color: Colors.grey),
                                  borderRadius: BorderRadius.circular(20)),
                              child: TextField(
                                  controller: txtSpedingNote,
                                  maxLines: null,
                                  textCapitalization:
                                      TextCapitalization.sentences,
                                  decoration: const InputDecoration(
                                      hintText: ' Ghi chú...',
                                      border: InputBorder.none),
                                  onSubmitted: (value) {
                                    txtSpedingNote.text = value;
                                  }),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(screensIndex.width / 15),
                  child: Container(
                    width: screensIndex.width * 7 / 8,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
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
                                    controller: txtIncome,
                                    textInputAction: TextInputAction.next,
                                    cursorColor: Colors.indigo,
                                    cursorWidth: 2,
                                    textAlign: TextAlign.center,
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(20)),
                                        hintText: 'Thêm thu nhập ngay nào..'),
                                    onSubmitted: (value) {
                                      txtIncome.text = value;
                                    },
                                  ),
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
                                          fontSize: 25,
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
                              value: _selectedItemIncome,
                              items: listImcome.map((e) {
                                return DropdownMenuItem(
                                  // ignore: sort_child_properties_last
                                  child: Text(e),
                                  value: e,
                                );
                              }).toList(),
                              onChanged: ((value) {
                                setState(() {
                                  _selectedItemIncome = value as String;
                                });
                              }),
                              icon: Icon(
                                Icons.arrow_drop_down_circle,
                                color: Colors.indigo[400],
                              ),
                              dropdownColor: Colors.indigo[300],
                              decoration: InputDecoration(
                                  labelText: 'Thu nhập nhờ...',
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
                                  border:
                                      Border.all(width: 1, color: Colors.grey)),
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
                                        builder: (BuildContext context) =>
                                            SizedBox(
                                              height: screensIndex.width * 0.8,
                                              child: CupertinoDatePicker(
                                                backgroundColor:
                                                    Colors.indigo[400],
                                                initialDateTime: dateTime,
                                                onDateTimeChanged:
                                                    (DateTime newTime) {
                                                  setState(() {
                                                    dateTime = newTime;
                                                  });
                                                },
                                                use24hFormat: true,
                                                mode: CupertinoDatePickerMode
                                                    .date,
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
                                  border:
                                      Border.all(width: 3, color: Colors.grey),
                                  borderRadius: BorderRadius.circular(20)),
                              child: TextField(
                                controller: txtIncomeNote,
                                maxLines: null,
                                textInputAction: TextInputAction.done,
                                textCapitalization:
                                    TextCapitalization.sentences,
                                decoration: const InputDecoration(
                                    hintText: ' Ghi chú...',
                                    border: InputBorder.none),
                                onSubmitted: (value) {
                                  txtIncomeNote.text = value;
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ]),
            ),
            Padding(
                padding: EdgeInsets.fromLTRB(screensIndex.width / 15,
                    screensIndex.width * 1.81, screensIndex.width / 15, 10),
                child: Row(
                  children: [
                    Expanded(
                      flex: 8,
                      child: Container(
                        width: screensIndex.width * 7 / 8,
                        height: screensIndex.width / 7,
                        decoration: BoxDecoration(
                            borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(20),
                                bottomLeft: Radius.circular(20)),
                            color: const Color.fromARGB(249, 255, 101, 96),
                            boxShadow: [
                              BoxShadow(
                                  spreadRadius: -5,
                                  blurRadius: 20,
                                  offset: const Offset(0, 5),
                                  color: kdybackgroup),
                            ]),
                        child: IconButton(
                          icon: const Icon(
                            Icons.close,
                            size: 30,
                            color: Colors.white70,
                          ),
                          onPressed: () {
                            Get.back(closeOverlays: true);
                            // Get.to(
                            //     Spending(currentScreen: widget.selected_index));
                          },
                        ),
                      ),
                    ),
                    const Spacer(),
                    Expanded(
                      flex: 25,
                      child: InkWell(
                        onTap: () => _insertData(),
                        child: Container(
                          width: screensIndex.width * 7 / 8,
                          height: screensIndex.width / 7,
                          decoration: BoxDecoration(
                              borderRadius: const BorderRadius.only(
                                  topRight: Radius.circular(20),
                                  bottomRight: Radius.circular(20)),
                              color: Colors.indigo[500],
                              boxShadow: [
                                BoxShadow(
                                    spreadRadius: -5,
                                    blurRadius: 15,
                                    offset: const Offset(0, 5),
                                    color: kdybackgroup),
                              ]),
                          child: const Center(
                              child: Text(
                            'Tạo mới',
                            style: TextStyle(
                                fontSize: 20,
                                color: Colors.white70,
                                fontWeight: FontWeight.w700),
                          )),
                        ),
                      ),
                    )
                  ],
                )),
          ],
        )));
  }

  @override
  void dispose() {
    super.dispose();
  }
}
