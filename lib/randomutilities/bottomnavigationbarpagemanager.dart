import 'package:flutter/material.dart';
import 'package:nutricare/pages/daily_tips.dart';
import 'package:nutricare/pages/diet_planner.dart';
import 'package:nutricare/pages/home.dart';
import 'package:nutricare/pages/useraccount.dart';

import '../pages/chat.dart';


class PageManager extends StatefulWidget {
  final int initialPage;
  const PageManager({Key? key, required this.initialPage}) : super(key: key);

  @override
  _PageManagerState createState() => _PageManagerState();
}

class _PageManagerState extends State<PageManager> {
  late int _selectedIndex;

  final List<Widget> _pages = [
    DietPlanner(),
    UserAccount(),
    Home(),
    Chat(),
    DailyTips(),
  ];

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialPage;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar:Theme(
        data: Theme.of(context).copyWith(
          // This is where you set the background color of the BottomNavigationBar.
          // It overrides the default or theme's canvasColor for the BottomNavigationBar.
          //This is necessary to do for some reason as when you use backgroundColor it wont swap >)
          canvasColor: Color(0xFF2abca4),
        ),
      child: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.food_bank), label: 'Diet Planner'),
          BottomNavigationBarItem(icon: Icon(Icons.account_circle), label: 'User Account'),
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Chat'),
          BottomNavigationBarItem(icon: Icon(Icons.tips_and_updates), label: 'Daily Tips'),
        ],
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    ));
  }
}