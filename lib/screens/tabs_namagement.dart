import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quanlychitieu/screens/income.dart';
import 'package:quanlychitieu/screens/input_screens.dart';
import 'package:quanlychitieu/screens/spending.dart';
import 'package:widget_and_text_animator/widget_and_text_animator.dart';
import '../constant.dart';

class TabsScreen extends StatefulWidget {
  const TabsScreen({super.key});

  @override
  State<TabsScreen> createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  PageController pageController = PageController(initialPage: 0);
  int index = 0;
  void onItemTap(selectItems) {
    pageController.jumpToPage(selectItems);
    setState(() {
      index = selectItems;
    });
  }

  BottomNavigationBarItem _createBottomNavigationBarItem(
      IconData icons, String label) {
    return BottomNavigationBarItem(
      icon: Icon(
        icons,
        color: Colors.white70,
        size: 30,
      ),
      label: label,
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: pageController,
        children: [
          Spending(
            currentScreen: index,
          ),
          InCome(
            currentScreen: index,
          )
        ],
        // onPageChanged: onPageChanged,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      drawerScrimColor: Colors.black38,
      floatingActionButton: Container(
        margin: EdgeInsets.only(top: screenWidth / 250),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(100),
          child: Container(
            padding: EdgeInsets.all(screenWidth / 30),
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.indigo,
                boxShadow: [
                  BoxShadow(
                      spreadRadius: 1,
                      blurRadius: 10,
                      offset: const Offset(-2, -2),
                      color: kdybackgroup.withOpacity(0.8)),
                ]),
            child: FloatingActionButton(
                elevation: 10,
                highlightElevation: 8,
                backgroundColor: Colors.white,
                focusColor: Colors.white,
                child: WidgetAnimator(
                    atRestEffect: WidgetRestingEffects.swing(),
                    child: const Icon(
                      Icons.add,
                      color: Colors.black54,
                    )),
                onPressed: () {
                  Get.to(
                      Input(
                        selected_index: index,
                      ),
                      transition: Transition.zoom);
                }),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(
              spreadRadius: 1,
              blurRadius: 15,
              offset: const Offset(0, -2),
              color: Colors.black.withOpacity(0.7)),
        ]),
        child: BottomNavigationBar(
          elevation: 10,
          currentIndex: index,
          onTap: onItemTap,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.indigo,
          selectedFontSize: 12,
          unselectedFontSize: 5,
          showSelectedLabels: true,
          showUnselectedLabels: false,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
          selectedItemColor: Colors.white,
          items: [
            _createBottomNavigationBarItem(
              Icons.confirmation_num,
              'Chi tiêu',
            ),
            _createBottomNavigationBarItem(
              Icons.upcoming,
              'Thu nhập',
            ),
          ],
        ),
      ),
    );
  }
}
