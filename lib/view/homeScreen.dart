import 'package:assignment/view/panchangScreen.dart';
import 'package:flutter/material.dart';

import 'astrologyScreen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Size size;
  int _currentIndex=0;
  final tabs=[
   const PanchangScreen(),
    const AstrologyScreen(),
    Container(),
    Container(),
    Container()
  ];
  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(floatingActionButton: _currentIndex!=0? Container() : FloatingActionButton(backgroundColor: Colors.orange,child: const Icon(Icons.menu),onPressed: (){

      },),body: tabs[_currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          
          selectedItemColor: Colors.orange,
          currentIndex: _currentIndex,
          type: BottomNavigationBarType.fixed,
          items: const [
           BottomNavigationBarItem(icon:  ImageIcon(AssetImage("assets/images/home.png")),label: "Home"),
           BottomNavigationBarItem(icon:  ImageIcon( AssetImage("assets/images/talk.png")),label: "    Talk to\n Astrologer" ),
           BottomNavigationBarItem(icon:  ImageIcon(AssetImage("assets/images/ask.png")),label: "   Ask \nQuestion" ),
           BottomNavigationBarItem(icon:  ImageIcon( AssetImage("assets/images/reports.png")),label: "Reports" ),
            BottomNavigationBarItem(icon: ImageIcon( AssetImage("assets/images/reports.png")),label: "Chat with \nAstrologer",),
          ],
          onTap: (index){
            setState(() {
              _currentIndex=index;
            });
          },
        ),
      ),
    );
  }
}
