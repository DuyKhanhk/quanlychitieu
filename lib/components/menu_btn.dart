import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class MenuButton extends StatelessWidget {
  const MenuButton({
    super.key,
    required this.press,
    required this.riveOnInit,
  });

  final VoidCallback press;
  final ValueChanged<Artboard> riveOnInit;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: press,
            child: Container(
              width: 40,
              margin: const EdgeInsets.only(left: 15, top: 10),
              height: 40,
              decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.rectangle,
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black38, 
                        offset: Offset(0, 4),
                        blurRadius: 5)
                  ]),
              child: RiveAnimation.asset(
                'assets/icons/menu_icon.riv',
                onInit: riveOnInit,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
