// ignore_for_file: avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';
import 'package:quanlychitieu/components/notify_showdialog.dart';
import 'package:quanlychitieu/screens/phone_number.dart';

import '../constant.dart';

class OtpPhone extends StatefulWidget {
  const OtpPhone({super.key});
  static String verify = '';

  @override
  State<OtpPhone> createState() => _OtpPhoneState();
}

class _OtpPhoneState extends State<OtpPhone> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final _db = FirebaseDatabase.instance.ref();

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: TextStyle(
          fontSize: 20, color: kdybackgroup, fontWeight: FontWeight.w600),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey, width: 2),
        borderRadius: BorderRadius.circular(9),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: kdybackgroup),
      borderRadius: BorderRadius.circular(8),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration?.copyWith(
          // color: Colors.grey,
          ),
    );
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
            onPressed: () => Get.back(),
            icon: Icon(
              Icons.arrow_back_ios_rounded,
              color: kdybackgroup,
            )),
      ),
      body: SafeArea(
        child: Container(
          margin:
              EdgeInsets.only(left: screenWidth / 20, right: screenWidth / 20),
          alignment: Alignment.center,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Xác minh số điện thoại',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                      color: Colors.black45),
                ),
                const Text(
                  'Hãy nhập số điện thoại của bạn ngay',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                      color: Colors.black45),
                ),
                SizedBox(
                  height: screenWidth / 20,
                ),
                Pinput(
                  // androidSmsAutofillMethod:  AndroidSmsAutofillMethod.smsUserConsentApi,
                  length: 6,
                  defaultPinTheme: defaultPinTheme,
                  focusedPinTheme: focusedPinTheme,
                  submittedPinTheme: submittedPinTheme,
                  // errorPinTheme: errorPinTheme,
                  showCursor: true,
                  onCompleted: (pin) async {
                    try {
                      PhoneAuthCredential credential =
                          PhoneAuthProvider.credential(
                              verificationId: PhoneNumber.verify, smsCode: pin);
                      await auth.signInWithCredential(credential);
                      final snapshot = await _db
                          .child('users/${auth.currentUser!.uid}/userName')
                          .get();
                      // final newUserName = await _db.child('users').get();
                      if (!snapshot.exists) {
                        final nextMember = <String, dynamic>{
                          'userID': auth.currentUser!.uid,
                          'phone': auth.currentUser!.phoneNumber,
                          'image': 1,
                          'userName': "Người dùng mới",
                          'totalMoney': 0,
                          'time': DateTime(2023, 1, 1, 20).toString(),
                          'accountBanks': {
                            '1': 'Ví',
                            '2': 0.0,
                            '3': 0.0,
                            '4': 0.0,
                            '5': 0.0,
                            '6': 0.0,
                            '7': 0.0,
                            '8': 0.0,
                            '9': 0,
                            '10': ''
                          }
                        };
                        _db
                            .child('users/${auth.currentUser!.uid}')
                            .set(nextMember)
                            .then((_) => print('User has been written!'))
                            .catchError(
                                (error) => print('You got an error $error'));
                      }
                      // ignore: use_build_context_synchronously
                      Navigator.pushNamedAndRemoveUntil(
                          context, 'home', (route) => false);
                    } catch (e) {
                      Navigator.of(context).push(
                        PageRouteBuilder(
                          opaque: false,
                          pageBuilder: (BuildContext context, _, __) =>
                              const NotifyShowdialog(
                            content: 'Nhập sai mã OTP rồi!!',
                          ),
                        ),
                      );
                    }
                  },
                ),
                SizedBox(
                  height: screenWidth / 20,
                ),
                Text(
                  'Không nhận được mã OTP',
                  style: TextStyle(
                    color: kdybackgroup,
                    fontSize: screenWidth / 25,
                    letterSpacing: 1.2,
                  ),
                ),
                InkWell(
                  onTap: () {
                    Get.back();
                  },
                  child: Text(
                    'Gửi lại',
                    style: TextStyle(
                      color: kdybackgroup,
                      fontSize: screenWidth / 25,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.1,
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
