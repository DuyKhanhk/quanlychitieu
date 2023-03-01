// ignore_for_file: avoid_print, use_build_context_synchronously, prefer_typing_uninitialized_variables, non_constant_identifier_names
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quanlychitieu/components/Appbar_cust.dart';
import 'package:quanlychitieu/components/notify_salary_plan.dart';
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
  String? _selectedItemSalaryP = '';
  String? _selectedItemIncome = '';
  TextEditingController txtSpending = TextEditingController();
  TextEditingController txtIncome = TextEditingController();
  TextEditingController txtSpedingNote = TextEditingController();
  TextEditingController txtIncomeNote = TextEditingController();
  TextEditingController txtTotalMoney = TextEditingController();
  TextEditingController txtSalary = TextEditingController();
  TextEditingController txtDaySalary = TextEditingController();
  TextEditingController txtJar1 = TextEditingController();
  TextEditingController txtJar2 = TextEditingController();
  TextEditingController txtJar3 = TextEditingController();
  TextEditingController txtJar4 = TextEditingController();
  TextEditingController txtJar5 = TextEditingController();
  TextEditingController txtJar6 = TextEditingController();

  int x = 0;

  late StreamSubscription getTotalMoney;

  //  late StreamSubscription _useLevel;
  // ignore:
  @override
  void initState() {
    super.initState();
    _selectedItemSpending = listSpending[0];
    _selectedItemIncome = listImcome[0];
    _selectedItemSalaryP = listSalaryPlan[0];
    _getTotalMoney();
  }

  void _getTotalMoney() async {
    getTotalMoney = _db
        .child('users/${auth.currentUser!.uid}/accountBanks')
        .onValue
        .listen((event) {
      final data = event.snapshot.value as dynamic;
      if (mounted) {
        setState(() {
          txtTotalMoney.text = data[2].toString();
          txtJar1.text = data[3].toString();
          txtJar2.text = data[4].toString();
          txtJar3.text = data[5].toString();
          txtJar4.text = data[6].toString();
          txtJar5.text = data[7].toString();
          txtJar6.text = data[8].toString();
          txtSalary.text = data[9].toString();
          txtDaySalary.text = data[10].toString();
        });
      }
    });
  }

  Future<int> _getSalary() async {
    getTotalMoney = _db
        .child('users/${auth.currentUser!.uid}/accountBanks')
        .onValue
        .listen((event) {
      final data = event.snapshot.value as dynamic;
      if (mounted) {
        setState(() {
          x = int.parse(data[9].toString());
        });
      }
    });
    return x;
  }

  void _insertItem() {
    final newSpending = <String, dynamic>{
      'uID': auth.currentUser!.uid,
      'money': int.parse(txtSpending.text.toString()),
      'type': _selectedItemSpending,
      'timeChosse': dateTime.toString(),
      'timeInput': DateTime.now().toString(),
      'note': txtSpedingNote.text,
      'status': 'Ví'
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
  }

  void _insertData() async {
    switch (widget.selected_index) {
      case 0:
        {
          if (txtSpending.text != '' &&
              !txtSpending.text.contains('.') &&
              !txtSpending.text.contains('-') &&
              !txtSpending.text.contains(' ')) {
            if (txtDaySalary.text == '') {
              _insertItem();
            } else {
              switch (_selectedItemSalaryP) {
                case 'Sinh hoạt':
                  {
                    final newSpending = <String, dynamic>{
                      'uID': auth.currentUser!.uid,
                      'money': int.parse(txtSpending.text.toString()),
                      'type': _selectedItemSpending,
                      'timeChosse': dateTime.toString(),
                      'timeInput': DateTime.now().toString(),
                      'note': txtSpedingNote.text,
                      'status': 'Sinh hoạt'
                    };
                    _db
                        .child('spendings/${GUIDGen.generate()}')
                        .set(newSpending)
                        .then((_) => print('newSpending has been written!'))
                        .catchError(
                            (error) => print('You got an error $error'));

                    final index = int.parse(txtJar1.text.toString()) -
                        int.parse(txtSpending.text.toString());
                    final update = <String, dynamic>{'1': 'Ví', '3': index};
                    _db
                        .child('users/${auth.currentUser!.uid}/accountBanks')
                        .update(update)
                        .then((_) => print('newSpending has been written!'))
                        .catchError(
                            (error) => print('You got an error $error'));

                    txtSpedingNote.clear();
                    txtSpending.clear();
                    Navigator.of(context).push(
                      PageRouteBuilder(
                        opaque: false,
                        pageBuilder: (BuildContext context, _, __) =>
                            const Successfull(
                          content: 'Tuyệt vời!',
                        ),
                      ),
                    );
                  }
                  break;
                case 'Học tập':
                  {
                    final newSpending = <String, dynamic>{
                      'uID': auth.currentUser!.uid,
                      'money': int.parse(txtSpending.text.toString()),
                      'type': _selectedItemSpending,
                      'timeChosse': dateTime.toString(),
                      'timeInput': DateTime.now().toString(),
                      'note': txtSpedingNote.text,
                      'status': 'Sinh hoạt'
                    };
                    _db
                        .child('spendings/${GUIDGen.generate()}')
                        .set(newSpending)
                        .then((_) => print('newSpending has been written!'))
                        .catchError(
                            (error) => print('You got an error $error'));

                    final index = int.parse(txtJar1.text.toString()) -
                        int.parse(txtSpending.text.toString());
                    final update = <String, dynamic>{'1': 'Ví', '3': index};
                    _db
                        .child('users/${auth.currentUser!.uid}/accountBanks')
                        .update(update)
                        .then((_) => print('newSpending has been written!'))
                        .catchError(
                            (error) => print('You got an error $error'));

                    txtSpedingNote.clear();
                    txtSpending.clear();
                    Navigator.of(context).push(
                      PageRouteBuilder(
                        opaque: false,
                        pageBuilder: (BuildContext context, _, __) =>
                            const Successfull(
                          content: 'Tuyệt vời!',
                        ),
                      ),
                    );
                  }
                  break;
                case 'Tiết kiệm':
                  {
                    final newSpending = <String, dynamic>{
                      'uID': auth.currentUser!.uid,
                      'money': int.parse(txtSpending.text.toString()),
                      'type': _selectedItemSpending,
                      'timeChosse': dateTime.toString(),
                      'timeInput': DateTime.now().toString(),
                      'note': txtSpedingNote.text,
                      'status': 'Tiết kiệm'
                    };
                    _db
                        .child('spendings/${GUIDGen.generate()}')
                        .set(newSpending)
                        .then((_) => print('newSpending has been written!'))
                        .catchError(
                            (error) => print('You got an error $error'));

                    final index = int.parse(txtJar2.text.toString()) -
                        int.parse(txtSpending.text.toString());
                    final update = <String, dynamic>{'1': 'Ví', '5': index};
                    _db
                        .child('users/${auth.currentUser!.uid}/accountBanks')
                        .update(update)
                        .then((_) => print('newSpending has been written!'))
                        .catchError(
                            (error) => print('You got an error $error'));

                    txtSpedingNote.clear();
                    txtSpending.clear();
                    Navigator.of(context).push(
                      PageRouteBuilder(
                        opaque: false,
                        pageBuilder: (BuildContext context, _, __) =>
                            const Successfull(
                          content: 'Tuyệt vời!',
                        ),
                      ),
                    );
                  }
                  break;
                case 'Đầu tư':
                  {
                    final newSpending = <String, dynamic>{
                      'uID': auth.currentUser!.uid,
                      'money': int.parse(txtSpending.text.toString()),
                      'type': _selectedItemSpending,
                      'timeChosse': dateTime.toString(),
                      'timeInput': DateTime.now().toString(),
                      'note': txtSpedingNote.text,
                      'status': 'Đầu tư'
                    };
                    _db
                        .child('spendings/${GUIDGen.generate()}')
                        .set(newSpending)
                        .then((_) => print('newSpending has been written!'))
                        .catchError(
                            (error) => print('You got an error $error'));

                    final index = int.parse(txtJar3.text.toString()) -
                        int.parse(txtSpending.text.toString());
                    final update = <String, dynamic>{'1': 'Ví', '6': index};
                    _db
                        .child('users/${auth.currentUser!.uid}/accountBanks')
                        .update(update)
                        .then((_) => print('newSpending has been written!'))
                        .catchError(
                            (error) => print('You got an error $error'));

                    txtSpedingNote.clear();
                    txtSpending.clear();
                    Navigator.of(context).push(
                      PageRouteBuilder(
                        opaque: false,
                        pageBuilder: (BuildContext context, _, __) =>
                            const Successfull(
                          content: 'Tuyệt vời!',
                        ),
                      ),
                    );
                  }
                  break;
                case 'Hưởng thụ':
                  {
                    final newSpending = <String, dynamic>{
                      'uID': auth.currentUser!.uid,
                      'money': int.parse(txtSpending.text.toString()),
                      'type': _selectedItemSpending,
                      'timeChosse': dateTime.toString(),
                      'timeInput': DateTime.now().toString(),
                      'note': txtSpedingNote.text,
                      'status': 'Hưởng thụ'
                    };
                    _db
                        .child('spendings/${GUIDGen.generate()}')
                        .set(newSpending)
                        .then((_) => print('newSpending has been written!'))
                        .catchError(
                            (error) => print('You got an error $error'));

                    final index = int.parse(txtJar4.text.toString()) -
                        int.parse(txtSpending.text.toString());
                    final update = <String, dynamic>{'1': 'Ví', '7': index};
                    _db
                        .child('users/${auth.currentUser!.uid}/accountBanks')
                        .update(update)
                        .then((_) => print('newSpending has been written!'))
                        .catchError(
                            (error) => print('You got an error $error'));

                    txtSpedingNote.clear();
                    txtSpending.clear();
                    Navigator.of(context).push(
                      PageRouteBuilder(
                        opaque: false,
                        pageBuilder: (BuildContext context, _, __) =>
                            const Successfull(
                          content: 'Tuyệt vời!',
                        ),
                      ),
                    );
                  }
                  break;
                case 'Từ thiện':
                  {
                    final newSpending = <String, dynamic>{
                      'uID': auth.currentUser!.uid,
                      'money': int.parse(txtSpending.text.toString()),
                      'type': _selectedItemSpending,
                      'timeChosse': dateTime.toString(),
                      'timeInput': DateTime.now().toString(),
                      'note': txtSpedingNote.text,
                      'status': 'Từ thiện'
                    };
                    _db
                        .child('spendings/${GUIDGen.generate()}')
                        .set(newSpending)
                        .then((_) => print('newSpending has been written!'))
                        .catchError(
                            (error) => print('You got an error $error'));

                    final index = int.parse(txtJar5.text.toString()) -
                        int.parse(txtSpending.text.toString());
                    final update = <String, dynamic>{'1': 'Ví', '8': index};
                    _db
                        .child('users/${auth.currentUser!.uid}/accountBanks')
                        .update(update)
                        .then((_) => print('newSpending has been written!'))
                        .catchError(
                            (error) => print('You got an error $error'));

                    txtSpedingNote.clear();
                    txtSpending.clear();
                    Navigator.of(context).push(
                      PageRouteBuilder(
                        opaque: false,
                        pageBuilder: (BuildContext context, _, __) =>
                            const Successfull(
                          content: 'Tuyệt vời!',
                        ),
                      ),
                    );
                  }
                  break;

                case 'Ví':
                  {
                    _insertItem();
                  }
                  break;
              }
            }
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
          if (txtIncome.text != '' &&
              !txtIncome.text.contains('.') &&
              !txtIncome.text.contains('-') &&
              !txtIncome.text.contains(' ')) {
            if (_selectedItemIncome == listImcome[0]) {
              var isOK = int.parse(txtSalary.text.toString()) == 0
                  ? await Navigator.of(context).push(
                      PageRouteBuilder(
                          opaque: false,
                          pageBuilder: (BuildContext context, _, __) =>
                              const NotifySalaryPlan(
                                content:
                                    'Bạn có muốn sử dụng lương theo kế hoạch?',
                              )),
                    )
                  : 'OK';
              if (isOK == 'OK') {
                final newIncome = <String, dynamic>{
                  'uID': auth.currentUser!.uid,
                  'money': int.parse(txtIncome.text.toString()),
                  'type': _selectedItemIncome,
                  'timeChosse': dateTime.toString(),
                  'timeInput': DateTime.now().toString(),
                  'note': txtIncomeNote.text,
                  'status': true
                };
                _db
                    .child('incomes/${GUIDGen.generate()}')
                    .set(newIncome)
                    .then((_) => print('newSpending has been written!'))
                    .catchError((error) => print('You got an error $error'));
                final index = int.parse(txtSalary.text.toString()) +
                    int.parse(txtIncome.text.toString());
                final update = <String, dynamic>{
                  '3': (index * 0.55).round(),
                  '4': (index * 0.1).round(),
                  '5': (index * 0.1).round(),
                  '6': (index * 0.1).round(),
                  '7': (index * 0.1).round(),
                  '8': (index * 0.05).round(),
                  '9': index,
                  '10': txtDaySalary.text.toString().isEmpty
                      ? dateTime.toString()
                      : txtDaySalary.text
                };
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
                    pageBuilder: (BuildContext context, _, __) =>
                        const Successfull(
                      content: 'Tuyệt vời!',
                    ),
                  ),
                );
              } else {
                final newIncome = <String, dynamic>{
                  'uID': auth.currentUser!.uid,
                  'money': int.parse(txtIncome.text.toString()),
                  'type': _selectedItemIncome,
                  'timeChosse': dateTime.toString(),
                  'timeInput': DateTime.now().toString(),
                  'note': txtIncomeNote.text,
                  'status': false
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
                    pageBuilder: (BuildContext context, _, __) =>
                        const Successfull(
                      content: 'Tuyệt vời!',
                    ),
                  ),
                );
              }
            } else {
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
                  pageBuilder: (BuildContext context, _, __) =>
                      const Successfull(
                    content: 'Tuyệt vời!',
                  ),
                ),
              );
            }
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
                            Row(
                              children: [
                                FutureBuilder(
                                    future: _getSalary(),
                                    builder: (BuildContext context,
                                        AsyncSnapshot<int> snapshot) {
                                      if (!snapshot.hasData) {
                                        return const CircularProgressIndicator();
                                      } else {
                                        return x != 0
                                            ? Expanded(
                                                flex: 2,
                                                child: SizedBox(
                                                  width:
                                                      screensIndex.width / 3.5,
                                                  child:
                                                      DropdownButtonFormField(
                                                    value: _selectedItemSalaryP,
                                                    items:
                                                        listSalaryPlan.map((e) {
                                                      return DropdownMenuItem(
                                                        // ignore: sort_child_properties_last
                                                        child: Text(e),
                                                        value: e,
                                                      );
                                                    }).toList(),
                                                    onChanged: ((value) {
                                                      setState(() {
                                                        _selectedItemSalaryP =
                                                            value as String;
                                                      });
                                                    }),
                                                    icon: Expanded(
                                                      child: Icon(
                                                        Icons
                                                            .arrow_drop_down_circle,
                                                        color:
                                                            Colors.indigo[400],
                                                      ),
                                                    ),
                                                    dropdownColor:
                                                        Colors.indigo[300],
                                                    decoration: InputDecoration(
                                                        labelText: 'Nguồn',
                                                        border: OutlineInputBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        20))),
                                                  ),
                                                ),
                                              )
                                            : Container();
                                      }
                                    }),
                                SizedBox(
                                  width: x == 0 ? 0 : 10,
                                ),
                                Expanded(
                                  flex: 3,
                                  child: SizedBox(
                                    width: screensIndex.width / 3.5,
                                    child: DropdownButtonFormField(
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
                                          _selectedItemSpending =
                                              value as String;
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
                                              borderRadius:
                                                  BorderRadius.circular(20))),
                                    ),
                                  ),
                                ),
                              ],
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
