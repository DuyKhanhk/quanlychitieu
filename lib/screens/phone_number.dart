// ignore_for_file: avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quanlychitieu/constant.dart';
import 'package:quanlychitieu/screens/otp.dart';

class PhoneNumber extends StatefulWidget {
  const PhoneNumber({super.key});
  static String verify = "";

  @override
  State<PhoneNumber> createState() => _PhoneNumberState();
}

class _PhoneNumberState extends State<PhoneNumber> {
  @override
  void initState() {
    coutryCodeController.text = "+84";
    super.initState();
  }

  TextEditingController coutryCodeController = TextEditingController();
  var phoneNumber = '';

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Container(
          margin:
              EdgeInsets.only(left: screenWidth / 20, right: screenWidth / 20),
          alignment: Alignment.center,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Xác minh số điện thoại'),
                const Text('Hãy nhập số điện thoại của bạn ngay'),
                SizedBox(
                  height: screenWidth / 20,
                ),
                Container(
                  height: screenWidth / 7,
                  decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.all(Radius.circular(screenWidth / 30)),
                      border: Border.all(width: 1.5, color: kdybackgroup)),
                  child: Row(
                    children: [
                      SizedBox(
                        width: screenWidth / 40,
                      ),
                      Expanded(
                          child: TextField(
                        readOnly: true,
                        controller: coutryCodeController,
                        keyboardType: TextInputType.number,
                        decoration:
                            const InputDecoration(border: InputBorder.none),
                      )),
                      Text(
                        '|',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: screenWidth / 10,
                            color: const Color.fromARGB(139, 16, 22, 60)),
                      ),
                      SizedBox(
                        width: screenWidth / 40,
                      ),
                      Expanded(
                          flex: 6,
                          child: TextField(
                            // maxLength: 8,
                            onChanged: (value) {
                              phoneNumber = value;
                            },
                            autofocus: true,
                            keyboardType: TextInputType.phone,
                            // ignore: prefer_const_constructors
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Số điện thoại'),
                          ))
                    ],
                  ),
                ),
                SizedBox(
                  height: screenWidth / 20,
                ),
                SizedBox(
                  height: screenWidth / 10,
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      try {
                        await FirebaseAuth.instance.verifyPhoneNumber(
                          phoneNumber: coutryCodeController.text + phoneNumber,
                          verificationCompleted:
                              (PhoneAuthCredential credential) {},
                          verificationFailed: (FirebaseAuthException e) {
                            if (e.code == 'invalid-phone-number') {
                              print('The provided phone number is not valid.');
                            }
                          },
                          codeSent: (String verificationId, int? resendToken) {
                            PhoneNumber.verify = verificationId;

                            Get.to(() => const OtpPhone(),
                                transition: Transition.rightToLeftWithFade,
                                duration: const Duration(seconds: 1));
                          },
                          codeAutoRetrievalTimeout: (String verificationId) {},
                        );
                      } catch (e) {
                        print('feild');
                      }
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: kdybackgroup,
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(screenWidth / 35))),
                    child: const Text('Gửi mã OTP'),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
