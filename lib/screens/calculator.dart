// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quanlychitieu/constant.dart';

class Calcualtor extends StatefulWidget {
  const Calcualtor({super.key});

  @override
  State<Calcualtor> createState() => _CalcualtorState();
}

class _CalcualtorState extends State<Calcualtor> {
  late int first, second;
  String opp = '';
  late String result;
  String Text1 = "";
  void btnClicker(String btnText) {
    if (btnText == "C") {
      result = "";
      Text1 = "";
      first = 0;
      second = 0;
    } else if (btnText == "+" ||
        btnText == "-" ||
        btnText == "x" ||
        btnText == "/") {
      first = int.parse(Text1);
      result = "";
      opp = btnText;
    } else if (btnText == "=") {
      second = int.parse(Text1);
      if (opp == "+") {
        result = (first + second).toString();
      } else if (opp == "-") {
        result = (first - second).toString();
      } else if (opp == "X") {
        result = (first * second).toString();
      } else if (opp == "/") {
        result = (first ~/ second).toString();
      } else {
        result = Text1.toString();
      }
    } else {
      result = int.parse(Text1 + btnText).toString();
    }
    setState(() {
      Text1 = result;
    });
  }

  Widget customOutline(String value) {
    return Expanded(
      child: InkWell(
        onTap: () {
          btnClicker(value);
        },
        child: Container(
          height: 60,
          decoration: BoxDecoration(
              border: Border.all(width: 2, color: kdybackgroup),
              borderRadius: BorderRadius.circular(10),
              color: kdy1),
          child: Center(
            child: Text(
              value,
              style: const TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 20.0),
              child: Align(
                alignment: Alignment.topCenter,
                child: Text(
                  'Máy Tính Nina',
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 30,
                      color: Colors.indigo),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 70, 10, 10),
              child: Column(children: [
                Expanded(
                  flex: 6,
                  child: Container(
                    alignment: Alignment.bottomRight,
                    margin: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 107, 184, 255),
                        border: Border.all(
                            width: 3, color: Colors.black.withOpacity(0.55)),
                        borderRadius: BorderRadius.circular(10)),
                    child: Text(
                      Text1,
                      style: TextStyle(
                          fontSize: 50,
                          fontWeight: FontWeight.w700,
                          color: kdybackgroup.withOpacity(0.8)),
                    ),
                  ),
                ),
                Expanded(
                  child: Row(
                    children: [
                      customOutline("9"),
                      const SizedBox(
                        width: 10,
                      ),
                      customOutline("8"),
                      const SizedBox(
                        width: 10,
                      ),
                      customOutline("7"),
                      const SizedBox(
                        width: 10,
                      ),
                      customOutline("+"),
                    ],
                  ),
                ),
                Expanded(
                  child: Row(
                    children: [
                      customOutline("6"),
                      const SizedBox(
                        width: 10,
                      ),
                      customOutline("5"),
                      const SizedBox(
                        width: 10,
                      ),
                      customOutline("4"),
                      const SizedBox(
                        width: 10,
                      ),
                      customOutline("-"),
                    ],
                  ),
                ),
                Expanded(
                  child: Row(
                    children: [
                      customOutline("3"),
                      const SizedBox(
                        width: 10,
                      ),
                      customOutline("2"),
                      const SizedBox(
                        width: 10,
                      ),
                      customOutline("1"),
                      const SizedBox(
                        width: 10,
                      ),
                      customOutline("x"),
                    ],
                  ),
                ),
                Row(
                  children: [
                    customOutline("C"),
                    const SizedBox(
                      width: 10,
                    ),
                    customOutline("0"),
                    const SizedBox(
                      width: 10,
                    ),
                    customOutline("="),
                    const SizedBox(
                      width: 10,
                    ),
                    customOutline("/"),
                  ],
                ),
              ]),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15.0, left: 5),
              child: IconButton(
                  onPressed: () => Get.back(),
                  icon: const Icon(
                    Icons.arrow_back_ios,
                    color: Colors.indigo,
                    size: 30,
                  )),
            )
          ],
        ),
      ),
    );
  }
}
