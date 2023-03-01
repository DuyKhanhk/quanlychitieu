import 'dart:async';
import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'package:quanlychitieu/components/item_category.dart';
import 'package:quanlychitieu/constant.dart';
import 'package:quanlychitieu/models/Item_piechart.dart';

final formatCurrency = intl.NumberFormat("#,##0", "en_US");

class PieChartCustom extends StatefulWidget {
  const PieChartCustom({
    super.key,
    required this.listCategory,
    required this.totalAll,
    required this.currentScreens,
    required this.dataset,
  });
  final double totalAll;
  final int currentScreens;
  final Set<String> listCategory;
  final List<DataItem> dataset;

  static const pal = [
    0xFFF2387C,
    0xFF05C7F2,
    0xFF04D9C4,
    0xFFF2B705,
    0xFFF26241
  ];

  @override
  State<PieChartCustom> createState() => _PieChartCustomState();
}

class _PieChartCustomState extends State<PieChartCustom> {
  final db = FirebaseDatabase.instance.ref();
  final auth = FirebaseAuth.instance;
  late Timer timer;
  double fullAngle = 0.0;
  double seconsToComplete = 5.0;

  @override
  void initState() {
    super.initState();
    // addItem();
    timer = Timer.periodic(const Duration(milliseconds: 1000 ~/ 60), (timer) {
      setState(() {
        fullAngle += 360.0 / (seconsToComplete * 1000 ~/ 60);
        if (fullAngle >= 360.0) {
          fullAngle = 360;
          timer.cancel();
        }
      });
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size screensIndex = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.only(top: screensIndex.width / 2.5),
      child: Container(
        width: screensIndex.width * 7 / 8,
        height: screensIndex.width / 1.8,
        decoration: BoxDecoration(
            color: Colors.grey[200],
            shape: BoxShape.rectangle,
            boxShadow: const [
              BoxShadow(
                  color: Colors.black38, offset: Offset(0, 4), blurRadius: 5)
            ],
            borderRadius:
                BorderRadius.all(Radius.circular(screensIndex.width / 20))),
        child: Stack(
          alignment: Alignment.centerLeft,
          children: [
            Padding(
              padding: EdgeInsets.all(screensIndex.width / 50),
              child: Container(
                width: screensIndex.width / 2,
                decoration: BoxDecoration(
                    color: Colors.grey[200],
                    shape: BoxShape.circle,
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
              ),
            ),
            CustomPaint(
              painter: DoutChartPainter(widget.dataset, fullAngle),
              child: Row(
                children: [
                  const Spacer(
                    flex: 3,
                  ),
                  Expanded(
                      flex: 2,
                      child: Container(
                        margin: EdgeInsets.fromLTRB(
                            screensIndex.width / 40,
                            screensIndex.width / 20,
                            screensIndex.width / 30,
                            screensIndex.width / 20),
                        height: double.infinity,
                        child: Stack(
                          children: [
                            Align(
                                alignment: Alignment.topCenter,
                                child: Text(
                                  "Danh mục",
                                  style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black.withOpacity(.7)),
                                )),
                            SizedBox(
                              height: screensIndex.width / 40,
                            ),
                            Padding(
                                padding: EdgeInsets.only(
                                    top: screensIndex.width / 20),
                                child: ListView.builder(
                                    itemCount: widget.listCategory.length,
                                    itemBuilder: (context, index) {
                                      return ItemCatergory(
                                        category: widget.listCategory
                                            .elementAt(index),
                                        index: index,
                                        currentScreen: widget.currentScreens,
                                      );
                                    })),
                          ],
                        ),
                      )),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(
                  screensIndex.width / 6.85,
                  screensIndex.width / 50,
                  screensIndex.width / 50,
                  screensIndex.width / 50),
              child: Container(
                width: screensIndex.width / 4,
                height: screensIndex.width / 4,
                decoration: BoxDecoration(
                    color: Colors.grey[200],
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                          spreadRadius: -5,
                          blurRadius: 5,
                          offset: const Offset(-5, -5),
                          color: Colors.white.withOpacity(0.7)),
                      BoxShadow(
                          spreadRadius: -5,
                          blurRadius: 15,
                          offset: const Offset(5, 5),
                          color: kdybackgroup),
                    ]),
                child: Center(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  // ignore: prefer_const_literals_to_create_immutables
                  children: [
                    Flexible(
                        child: Text(
                      formatCurrency.format(widget.totalAll),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.black.withOpacity(0.6)),
                    )),
                    const Text(
                      'VND',
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.black54,
                          letterSpacing: 1.1),
                    )
                  ],
                )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DoutChartPainter extends CustomPainter {
  final List<DataItem> dataset;
  final double fullAngle;
  DoutChartPainter(this.dataset, this.fullAngle);

  final linePaint = Paint()
    ..color = Colors.white
    ..strokeWidth = 0.5
    ..style = PaintingStyle.stroke;

  final midPaint = Paint()
    ..color = Colors.white
    ..style = PaintingStyle.fill;

  TextStyle textFieldTextBigStyle = const TextStyle(
      color: Colors.black38, fontWeight: FontWeight.w600, fontSize: 18);

  TextStyle labelStyle = const TextStyle(
      color: Colors.black, fontSize: 10, fontWeight: FontWeight.w400);

  @override
  void paint(Canvas canvas, Size size) {
    final c = Offset(size.width / 3.225, size.height / 2);
    final radius = size.width * 0.525;
    final rect = Rect.fromCenter(center: c, width: radius, height: radius);

    var startAngle = 0.0;
    canvas.drawArc(rect, startAngle, fullAngle * pi, false, linePaint);
    // ignore: avoid_function_literals_in_foreach_calls
    dataset.forEach((element) {
      double sweepAngle = element.value * fullAngle * pi / 180.0;
      drawSector(element, canvas, rect, startAngle, sweepAngle);
      //draw lines
      drawLines(radius, startAngle, c, canvas);
      startAngle += sweepAngle;
    });

    startAngle = 0.0;
    // ignore: avoid_function_literals_in_foreach_calls
    dataset.forEach((element) {
      double sweepAngle = element.value * fullAngle * pi / 180.0;
      //draw lines
      drawLines(radius, startAngle, c, canvas);
      startAngle += sweepAngle;
    });

    startAngle = 0.0;
    // ignore: avoid_function_literals_in_foreach_calls
    dataset.forEach((element) {
      double sweepAngle = element.value * fullAngle * pi / 180.0;
      //draw Labels
      drawLabels(radius, startAngle, sweepAngle, c, canvas, element.label);
      startAngle += sweepAngle;
    });
    // draw th middle
    canvas.drawCircle(c, radius * 0.25, midPaint);
    //draw title
    drawTextCentered(
        canvas, c, '', textFieldTextBigStyle, radius * 0.6, (Size sz) {});
  }

  void drawLabels(double radius, double startAngle, double sweepAngle, Offset c,
      Canvas canvas, String label) {
    final r = radius * 0.375;
    final dx = r * cos(startAngle + sweepAngle / 2.0);
    final dy = r * sin(startAngle + sweepAngle / 2.0);
    final position = c + Offset(dx, dy);
    drawTextCentered(canvas, position, label, labelStyle, 50.0, (Size sz) {
      final rect =
          Rect.fromCenter(center: position, width: sz.width, height: sz.height);
      final rrect = RRect.fromRectAndRadius(rect, const Radius.circular(10));
      canvas.drawRRect(rrect, midPaint);
    });
  }

  TextPainter measureText(
      String s, TextStyle style, double maxWidth, TextAlign align) {
    final span = TextSpan(text: s, style: style);
    final tp = TextPainter(
        text: span, textAlign: align, textDirection: TextDirection.ltr);
    tp.layout(minWidth: 0, maxWidth: maxWidth);
    return tp;
  }

  Size drawTextCentered(Canvas canvas, Offset position, String text,
      TextStyle style, double maxWith, Function(Size sz) bgCb) {
    final tp = measureText(text, style, maxWith, TextAlign.center);
    final pos = position + Offset(-tp.width / 2.0, -tp.height / 2.0);
    bgCb(tp.size);
    tp.paint(canvas, pos);
    return tp.size;
  }

  void drawLines(double radius, double startAngle, Offset c, Canvas canvas) {
    final dx = radius / 2.0 * cos(startAngle);
    final dy = radius / 2.0 * sin(startAngle);
    final p2 = c + Offset(dx, dy);
    canvas.drawLine(c, p2, linePaint);
  }

  double drawSector(DataItem element, Canvas canvas, Rect rect,
      double startAngle, double sweepAngle) {
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..color = element.color;
    canvas.drawArc(rect, startAngle, sweepAngle, true, paint);
    return sweepAngle;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
