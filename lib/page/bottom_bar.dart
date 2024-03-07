// ignore_for_file: use_key_in_widget_constructors, camel_case_types, library_private_types_in_public_api, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:bloom/page/account.dart';
import 'package:bloom/page/book_bill.dart';
import 'package:bloom/page/home_screen.dart';
import 'package:bloom/page/roomscreen.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';

class bottombar extends StatefulWidget {
  @override
  _bottombarState createState() => _bottombarState();
}

class _bottombarState extends State<bottombar> {
  final PageController _pageController = PageController(initialPage: 0);

  final List<Widget> _pages = [
    HomeScreen(),
    Room(),
    BookingListPage(),
    AccountPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        physics: NeverScrollableScrollPhysics(), // Disable page swiping
        onPageChanged: (index) {
          setState(() {
          });
        },
        children: _pages,
      ),
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.transparent,
        color: Colors.purple,
        buttonBackgroundColor: const Color.fromARGB(255, 187, 33, 243),
        height: 57,
        animationDuration: Duration(milliseconds: 300),
        animationCurve: Curves.easeInOut,
        items: <Widget>[
          Icon(Icons.home, size: 35),
          Icon(Icons.book, size: 35),
          Icon(Icons.library_books, size: 35),
          Icon(Icons.account_circle, size: 35),
        ],
        onTap: (index) {
          setState(() {
            _pageController.animateToPage(
              index,
              duration: Duration(milliseconds: 220),
              curve: Curves.easeInOut,
            );
          });
        },
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
