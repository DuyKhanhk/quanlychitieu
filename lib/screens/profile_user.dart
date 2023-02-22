// ignore_for_file: depend_on_referenced_packages

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:quanlychitieu/components/item_avatar.dart';
import 'package:quanlychitieu/components/notify_showdialog.dart';
import 'package:intl/intl.dart';

final formatCurrency = NumberFormat("#,##0", "en_US");

class ProfileUser extends StatefulWidget {
  const ProfileUser({super.key});

  @override
  State<ProfileUser> createState() => _ProfileUserState();
}

class _ProfileUserState extends State<ProfileUser> {
  final auth = FirebaseAuth.instance;

  final _db = FirebaseDatabase.instance.ref();

  bool _isvisible = false;

  TextEditingController txtname = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size screensIndex = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 1, 17, 37).withOpacity(.7),
      body: InkWell(
          onTap: () => navigator?.pop(context),
          child: StreamBuilder(
            stream: _db.child('users/${auth.currentUser!.uid}').onValue,
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.data != null) {
                final data = Map<String, dynamic>.from(
                  Map<String, dynamic>.from((snapshot.data as DatabaseEvent)
                      .snapshot
                      .value as Map<dynamic, dynamic>),
                );
                return Center(
                  child: SizedBox(
                    width: screensIndex.width,
                    height: screensIndex.height,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: screensIndex.width * 7 / 8,
                          height: screensIndex.width / 1.8,
                          decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                begin: Alignment.topRight,
                                end: Alignment.bottomLeft,
                                stops: [
                                  0.1,
                                  0.4,
                                  0.6,
                                  0.9,
                                ],
                                colors: [
                                  Color.fromARGB(255, 121, 73, 255),
                                  Color.fromARGB(255, 76, 219, 255),
                                  Color.fromARGB(255, 125, 177, 255),
                                  Color.fromARGB(255, 119, 70, 255),
                                ],
                              ),
                              shape: BoxShape.rectangle,
                              boxShadow: const [
                                BoxShadow(
                                    color: Colors.black38,
                                    offset: Offset(0, 4),
                                    blurRadius: 5)
                              ],
                              borderRadius: BorderRadius.all(
                                  Radius.circular(screensIndex.width / 20))),
                          child: Column(
                            children: [
                              SizedBox(
                                height: screensIndex.width / 8,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        TextField(
                                            textAlign: TextAlign.center,
                                            controller: txtname,
                                            readOnly: _isvisible == false
                                                ? true
                                                : false,
                                            style: const TextStyle(
                                                color: Colors.white),
                                            decoration: InputDecoration(
                                              border: InputBorder.none,
                                              label: _isvisible == false
                                                  ? Align(
                                                      alignment:
                                                          Alignment.center,
                                                      child: Text(
                                                        data['userName'],
                                                        style: TextStyle(
                                                          fontSize: screensIndex
                                                                  .width /
                                                              15,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                    )
                                                  : const Text(''),
                                            ),
                                            onSubmitted: (value) {
                                              setState(() {
                                                txtname.text = value;
                                              });
                                            }),
                                        Align(
                                          alignment: Alignment.centerRight,
                                          child: IconButton(
                                            onPressed: () async {
                                              setState(() {
                                                _isvisible == false
                                                    ? _isvisible = true
                                                    : _isvisible = false;
                                              });
                                              if (_isvisible == false) {
                                                final x = await _db
                                                    .child('users')
                                                    .get();
                                                bool isEmpty = true;
                                                for (int i = 0;
                                                    i < x.children.length;
                                                    i++) {
                                                  if (x.children
                                                          .elementAt(i)
                                                          .child('userName')
                                                          .value
                                                          .toString() ==
                                                      txtname.text) {
                                                    isEmpty = false;
                                                  }
                                                }

                                                if (isEmpty) {
                                                  _db
                                                      .child(
                                                          'users/${auth.currentUser!.uid}/userName')
                                                      .set(txtname.text);
                                                  txtname.clear();
                                                } else {
                                                  txtname.clear();
                                                  // ignore: use_build_context_synchronously
                                                  Navigator.of(context).push(
                                                    PageRouteBuilder(
                                                      opaque: false,
                                                      pageBuilder: (BuildContext
                                                                  context,
                                                              _,
                                                              __) =>
                                                          const NotifyShowdialog(
                                                              content:
                                                                  'Tên người dùng đã tồn tại!'),
                                                    ),
                                                  );
                                                }
                                              }
                                            },
                                            icon: Icon(
                                              _isvisible == false
                                                  ? Icons.edit
                                                  : Icons.check,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: screensIndex.width / 50,
                              ),
                              Text(
                                '${data['phone']}',
                                style: TextStyle(
                                    letterSpacing: 1.2,
                                    fontSize: screensIndex.width / 20,
                                    color: Colors.white.withOpacity(0.9),
                                    fontWeight: FontWeight.w500),
                              ),
                              SizedBox(
                                height: screensIndex.width / 10,
                              ),
                              Container(
                                padding: EdgeInsets.only(
                                  left: screensIndex.width / 25,
                                ),
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  children: [
                                    Text(
                                      'Tổng tài sản: ',
                                      style: TextStyle(
                                          fontSize: screensIndex.width / 25,
                                          color: Colors.white.withOpacity(0.9),
                                          fontWeight: FontWeight.w500),
                                    ),
                                    Text(
                                      formatCurrency.format(data['totalMoney']),
                                      style: TextStyle(
                                          fontSize: screensIndex.width / 20,
                                          color: Colors.white.withOpacity(0.9),
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding:
                              EdgeInsets.only(bottom: screensIndex.width / 1.7),
                          child: Container(
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black38,
                                    offset: Offset(0, 4),
                                    blurRadius: 5)
                              ],
                            ),
                            child: InkWell(
                              onTap: () => Navigator.of(context).push(
                                PageRouteBuilder(
                                  opaque: false,
                                  pageBuilder: (BuildContext context, _, __) =>
                                      const Avatar(),
                                ),
                              ),
                              child: CircleAvatar(
                                  radius: screensIndex.width / 8,
                                  backgroundColor: Colors.grey[200],
                                  child: Lottie.asset(
                                      'assets/images/avatar/Avartar${data['image'].toString()}.json',
                                      fit: BoxFit.fill)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }
              return const CircularProgressIndicator();
            },
          )),
    );
  }
}
