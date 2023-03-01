import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:widget_and_text_animator/widget_and_text_animator.dart';

class NotifySalaryPlan extends StatefulWidget {
  const NotifySalaryPlan({super.key, required this.content});
  final String content;
  @override
  State<NotifySalaryPlan> createState() => _NotifySalaryPlanState();
}

class _NotifySalaryPlanState extends State<NotifySalaryPlan> {
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
                Expanded(
                    child: Text(
                  widget.content,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                      color: Colors.amberAccent[900]),
                )),
                Expanded(
                    child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                      onPressed: () {
                        // Get.back();
                        Navigator.pop(context, 'OK');
                      },
                      child: const Text('Có'),
                    ),
                    TextButton(
                      onPressed: () {
                        Get.back();
                      },
                      child: const Text('Không'),
                    )
                  ],
                )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
