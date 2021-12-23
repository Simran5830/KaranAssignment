import 'package:flutter/material.dart';

class Header extends StatelessWidget {

 late Size size;
  @override
  Widget build(BuildContext context) {
     size = MediaQuery.of(context).size;
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Image.asset("assets/images/hamburger.png", width: size.width * 0.1),
          Image.asset("assets/images/logo.png", width: size.width * 0.18),
          Image.asset("assets/images/profile.png", width: size.width * 0.07)
        ],
      );
  }
}