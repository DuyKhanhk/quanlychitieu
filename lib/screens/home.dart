import 'package:flutter/material.dart';
import 'package:quanlychitieu/constant.dart';
import 'package:quanlychitieu/screens/side_menu.dart';
import 'package:quanlychitieu/screens/tabs_namagement.dart';
import 'package:quanlychitieu/utils/rive_utils.dart';
import 'package:quanlychitieu/components/menu_btn.dart';
import 'package:rive/rive.dart';

class Home extends StatefulWidget {
  const Home({super.key});
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late SMIBool isSideBarClose;
  bool isSideMenuClose = true;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        
        resizeToAvoidBottomInset: false,
        extendBody: true,
        backgroundColor: kdybackgroup,
        body: Stack(
          children: [
            AnimatedPositioned(
              duration: const Duration(milliseconds: 250),
              curve: Curves.fastOutSlowIn,
              left: isSideMenuClose ? -screenWidth * 3 / 4 : 0,
              width: screenWidth * 3 / 4,
              height: screenHeight,
              child: const SideMenu(),
            ),
            Transform.translate(
              offset: Offset(isSideMenuClose ? 0 : screenWidth * 3 / 4, 0),
              child: Transform.scale(
                  scale: isSideMenuClose ? 1 : 0.8,
                  child: ClipRRect(
                      borderRadius: BorderRadius.all(isSideMenuClose
                          ? const Radius.circular(0)
                          : const Radius.circular(24)),
                      child: const TabsScreen())),
            ),
            AnimatedPositioned(
              duration: const Duration(milliseconds: 200),
              curve: Curves.fastOutSlowIn,
              top: 5,
              left: isSideMenuClose
                  ? 0
                  : MediaQuery.of(context).size.width * 3.55 / 5,
              child: MenuButton(
                riveOnInit: (artboard) {
                  StateMachineController controller =
                      RiveUtils.getRiveController(artboard,
                          stateMachineName: 'State Machine 1');
                  isSideBarClose = controller.findSMI('isOpen') as SMIBool;
                  isSideBarClose.value = false;
                },
                press: () {
                  isSideBarClose.value = !isSideBarClose.value;
                  setState(() {
                    isSideMenuClose = isSideBarClose.value;
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
