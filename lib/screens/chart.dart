// ignore_for_file: unused_field, unused_import

import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quanlychitieu/constant.dart';
import 'package:quanlychitieu/models/categorys.dart';

class PieChart extends StatefulWidget {
  PieChart({super.key, required this.spending, required this.income});
  final MonthChart spending;
  final MonthChart income;
  final Color leftBarColor = listColorSp[3];
  final Color rightBarColor = listColorIc[0];
  final Color avgColor = listColorIc[3];
  @override
  State<PieChart> createState() => _PieChartState();
}

class _PieChartState extends State<PieChart> {
  final double width = 7;

  late List<BarChartGroupData> rawBarGroups;
  late List<BarChartGroupData> showingBarGroups;
  late StreamSubscription _totalCategory;
  int touchedGroupIndex = -1;

  @override
  void initState() {
    super.initState();
    setState(() {
      final barGroup1 = makeGroupData(0, widget.spending.t1, widget.income.t1);
      final barGroup2 = makeGroupData(1, widget.spending.t2, widget.income.t2);
      final barGroup3 = makeGroupData(2, widget.spending.t3, widget.income.t3);
      final barGroup4 = makeGroupData(3, widget.spending.t4, widget.income.t4);
      final barGroup5 = makeGroupData(4, widget.spending.t5, widget.income.t5);
      final barGroup6 = makeGroupData(5, widget.spending.t6, widget.income.t6);
      final barGroup7 = makeGroupData(6, widget.spending.t7, widget.income.t7);
      final barGroup8 = makeGroupData(7, widget.spending.t8, widget.income.t8);
      final barGroup9 = makeGroupData(8, widget.spending.t9, widget.income.t9);
      final barGroup10 =
          makeGroupData(9, widget.spending.t10, widget.income.t10);
      final barGroup11 =
          makeGroupData(10, widget.spending.t11, widget.income.t11);
      final barGroup12 =
          makeGroupData(11, widget.spending.t12, widget.income.t12);
      final barGroup13 =
          makeGroupData(12, widget.spending.t12, widget.income.t12);

      final items = [
        widget.spending.t1 == 0 && widget.income.t1 == 0
            ? barGroup13
            : barGroup1,
        widget.spending.t2 == 0 && widget.income.t2 == 0
            ? barGroup13
            : barGroup2,
        widget.spending.t3 == 0 && widget.income.t3 == 0
            ? barGroup13
            : barGroup3,
        widget.spending.t4 == 0 && widget.income.t4 == 0
            ? barGroup13
            : barGroup4,
        widget.spending.t5 == 0 && widget.income.t5 == 0
            ? barGroup13
            : barGroup5,
        widget.spending.t6 == 0 && widget.income.t6 == 0
            ? barGroup13
            : barGroup6,
        widget.spending.t7 == 0 && widget.income.t7 == 0
            ? barGroup13
            : barGroup7,
        widget.spending.t8 == 0 && widget.income.t8 == 0
            ? barGroup13
            : barGroup8,
        widget.spending.t9 == 0 && widget.income.t9 == 0
            ? barGroup13
            : barGroup9,
        widget.spending.t10 == 0 && widget.income.t10 == 0
            ? barGroup13
            : barGroup10,
        widget.spending.t11 == 0 && widget.income.t11 == 0
            ? barGroup13
            : barGroup11,
        widget.spending.t12 == 0 && widget.income.t12 == 0
            ? barGroup13
            : barGroup12,
      ];

      rawBarGroups = items;

      showingBarGroups = rawBarGroups;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        // makeTransactionsIcon(),
                        const SizedBox(
                          width: 38,
                        ),
                        const Text(
                          'Tổng thu chi năm',
                          style: TextStyle(color: Colors.black54, fontSize: 22),
                        ),
                        const SizedBox(
                          width: 4,
                        ),
                        Text(
                          DateTime.now().year.toString(),
                          style: const TextStyle(
                              color: Color(0xff77839a), fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                      onPressed: () => Get.back(),
                      icon: Icon(
                        Icons.arrow_back_ios,
                        color: kdy2,
                        size: 30,
                      ))
                ],
              ),
              const SizedBox(
                height: 38,
              ),
              Expanded(
                child: BarChart(
                  BarChartData(
                    maxY: 20,
                    barTouchData: BarTouchData(
                      touchTooltipData: BarTouchTooltipData(
                        tooltipBgColor: Colors.grey,
                        getTooltipItem: (a, b, c, d) => null,
                      ),
                      touchCallback: (FlTouchEvent event, response) {
                        if (response == null || response.spot == null) {
                          setState(() {
                            touchedGroupIndex = -1;
                            showingBarGroups = List.of(rawBarGroups);
                          });
                          return;
                        }

                        touchedGroupIndex = response.spot!.touchedBarGroupIndex;

                        setState(() {
                          if (!event.isInterestedForInteractions) {
                            touchedGroupIndex = -1;
                            showingBarGroups = List.of(rawBarGroups);
                            return;
                          }
                          showingBarGroups = List.of(rawBarGroups);
                          if (touchedGroupIndex != -1) {
                            var sum = 0.0;
                            for (final rod
                                in showingBarGroups[touchedGroupIndex]
                                    .barRods) {
                              sum += rod.toY;
                            }
                            final avg = sum /
                                showingBarGroups[touchedGroupIndex]
                                    .barRods
                                    .length;

                            showingBarGroups[touchedGroupIndex] =
                                showingBarGroups[touchedGroupIndex].copyWith(
                              barRods: showingBarGroups[touchedGroupIndex]
                                  .barRods
                                  .map((rod) {
                                return rod.copyWith(
                                    toY: avg, color: Colors.cyan);
                              }).toList(),
                            );
                          }
                        });
                      },
                    ),
                    titlesData: FlTitlesData(
                      show: true,
                      rightTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      topTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: bottomTitles,
                          reservedSize: 42,
                        ),
                      ),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 28,
                          interval: 1,
                          getTitlesWidget: leftTitles,
                        ),
                      ),
                    ),
                    borderData: FlBorderData(
                      show: false,
                    ),
                    barGroups: showingBarGroups,
                    gridData: FlGridData(show: false),
                  ),
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              Row(
                children: [
                  Expanded(
                    child: ListTile(
                      leading: Container(
                          width: 15,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: widget.leftBarColor)),
                      trailing: const Text('Tổng chi'),
                    ),
                  ),
                  const Spacer(),
                  Expanded(
                    child: ListTile(
                      leading: Container(
                          width: 15,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: widget.rightBarColor)),
                      trailing: const Text('Tổng thu'),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget leftTitles(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Color(0xff7589a2),
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    String text;
    if (value == 0) {
      text = '0Tr';
    } else if (value == 4) {
      text = '10\nTr';
    } else if (value == 10) {
      text = '25\nTr';
    } else if (value == 20) {
      text = '50\nTr';
    } else {
      return Container();
    }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 0,
      child: Text(text, style: style),
    );
  }

  Widget bottomTitles(double value, TitleMeta meta) {
    final titles = <String>[
      '1',
      '2',
      '3',
      '4',
      '5',
      '6',
      '7',
      '8',
      '9',
      '10',
      '11',
      '12',
      ''
    ];

    final Widget text = Text(
      titles[value.toInt()],
      style: const TextStyle(
        color: Color(0xff7589a2),
        fontWeight: FontWeight.bold,
        fontSize: 14,
      ),
    );

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 16, //margin top
      child: text,
    );
  }

  BarChartGroupData makeGroupData(int x, double y1, double y2) {
    return BarChartGroupData(
      barsSpace: 4,
      x: x,
      barRods: [
        BarChartRodData(
          toY: y1,
          color: widget.leftBarColor,
          width: width,
        ),
        BarChartRodData(
          toY: y2,
          color: widget.rightBarColor,
          width: width,
        ),
      ],
    );
  }
}
