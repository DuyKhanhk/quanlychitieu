import 'package:flutter/material.dart';
import 'package:quanlychitieu/constant.dart';

class ItemCatergory extends StatelessWidget {
  const ItemCatergory({
    super.key,
    required this.category,
    required this.index,
    required this.currentScreen,
  });
  final String category;
  final int index;
  final int currentScreen;

  @override
  Widget build(BuildContext context) {
    Size screensIndex = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Container(
            width: screensIndex.width / 50,
            height: screensIndex.width / 50,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: currentScreen == 0
                    ? isSpendingCl(0)
                        ? listColorSp[0]
                        : isSpendingCl(1)
                            ? listColorSp[1]
                            : isSpendingCl(2)
                                ? listColorSp[2]
                                : isSpendingCl(3)
                                    ? listColorSp[3]
                                    : isSpendingCl(4)
                                        ? listColorSp[4]
                                        : isSpendingCl(5)
                                            ? listColorSp[5]
                                            : isSpendingCl(6)
                                                ? listColorSp[6]
                                                : isSpendingCl(7)
                                                    ? listColorSp[7]
                                                    : listColorSp[8]
                    : isIncomeCl(0)
                        ? listColorIc[0]
                        : isIncomeCl(1)
                            ? listColorIc[1]
                            : isIncomeCl(2)
                                ? listColorIc[2]
                                : isIncomeCl(3)
                                    ? listColorIc[3]
                                    : isIncomeCl(4)
                                        ? listColorIc[4]
                                        : isIncomeCl(5)
                                            ? listColorIc[5]
                                            : isIncomeCl(6)
                                                ? listColorIc[6]
                                                : listColorIc[7]),
          ),
          SizedBox(
            width: screensIndex.width / 50,
          ),
          Expanded(
              child: Text(category,
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.black.withOpacity(.6))))
        ],
      ),
    );
  }

  bool isSpendingCl(int x) => category == listSpending[x];
  bool isIncomeCl(int x) => category == listImcome[x];
}
