import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:widget_and_text_animator/widget_and_text_animator.dart';

class NotifyShowdialog extends StatefulWidget {
  const NotifyShowdialog({super.key, required this.content});
  final String content;
  @override
  State<NotifyShowdialog> createState() => _NotifyShowdialogState();
}

class _NotifyShowdialogState extends State<NotifyShowdialog> {
  late Timer time;

  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    super.initState();
    time = Timer(const Duration(seconds: 2), () {
      Get.back();
    });
  }

  @override
  Widget build(BuildContext context) {
    double screensWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: const Color.fromARGB(0, 240, 240, 240).withOpacity(0),
      body: WidgetAnimator(
        incomingEffect: WidgetTransitionEffects.incomingScaleUp(),
        child: Center(
          child: Container(
            width: screensWidth * 2 / 3,
            height: screensWidth / 3,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                boxShadow: const [
                  BoxShadow(
                      color: Colors.black38,
                      offset: Offset(0, 4),
                      blurRadius: 5)
                ],
                color: Colors.grey[200],
                borderRadius:
                    BorderRadius.all(Radius.circular(screensWidth / 20))),
            child: Column(
              children: [
                Expanded(
                  flex: 2,
                  child: Lottie.asset(
                    'assets/images/errorLittie.json',
                    fit: BoxFit.cover,
                  ),
                ),
                Expanded(child: Text(widget.content)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Successfull extends StatefulWidget {
  const Successfull({super.key, required this.content});
  final String content;
  @override
  State<Successfull> createState() => _SuccessfullState();
}

class _SuccessfullState extends State<Successfull> {
  late Timer time;

  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    super.initState();
    time = Timer(const Duration(milliseconds: 1500), () {
      Get.back();
    });
  }

  @override
  Widget build(BuildContext context) {
    double screensWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: const Color.fromARGB(0, 240, 240, 240).withOpacity(0),
      body: WidgetAnimator(
        incomingEffect: WidgetTransitionEffects.incomingScaleUp(),
        child: Center(
          child: Container(
            width: screensWidth * 2 / 3,
            height: screensWidth / 3,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0),
                borderRadius:
                    BorderRadius.all(Radius.circular(screensWidth / 20))),
            child: Column(
              children: [
                Expanded(
                  flex: 2,
                  child: Lottie.asset(
                    'assets/images/successfull.json',
                    fit: BoxFit.cover,
                  ),
                ),
                // Expanded(child: Text(widget.content)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
