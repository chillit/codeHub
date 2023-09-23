import 'package:duolingo/src/home/appbar_home_screen.dart';
import 'package:duolingo/src/home/main_screen/home_screen.dart';
import 'package:duolingo/src/home/main_screen/profile.dart';
import 'package:duolingo/src/home/main_screen/ranking.dart';

import 'package:duolingo/src/utils/images.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;
  final List<Widget> screens = [
    HomeScreen(),
    Profile(),
    Ranking(),

  ];
  final PageStorageBucket _bucket = PageStorageBucket();
  Widget currentScreen = HomeScreen();

  @override
  Widget build(BuildContext context) {
    const double _iconSize = 41;
    const double _iconSizeSelected = 53;
    final AppBarHomeScreen appBar = AppBarHomeScreen();

    return Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(45),
          child: appBar,
        ),
        body: Column(
          children: [
            Expanded(
              child: PageStorage(
                bucket: _bucket,
                child: currentScreen,
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: 1.5, // Adjust the height of the line as needed
              decoration: BoxDecoration(
                color: Colors.grey[350], // You can change the color of the line
              ),
            ),
         SizedBox(
          height: 100,
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            currentIndex: _currentIndex,
            backgroundColor: Colors.white,
            iconSize: _iconSize,
            onTap: (int index) {
              setState(() {
                _currentIndex = index;
              });
            },
            items: [
              BottomNavigationBarItem(
                label: '',
                icon: IconButton(
                  icon: _currentIndex == 0
                      ? Images.selectedLessons
                      : Images.tabLessons,
                  onPressed: () {
                    setState(() {
                      _currentIndex = 0;
                      currentScreen = HomeScreen();
                    });
                  },
                  iconSize: _currentIndex == 0 ? _iconSizeSelected : _iconSize,
                ),
              ),
              BottomNavigationBarItem(
                label: '',
                icon: IconButton(
                  icon: _currentIndex == 1
                      ? Images.selectedRanking
                      : Images.tabRanking,
                  onPressed: () {
                    setState(() {
                      _currentIndex = 1;
                      currentScreen = Ranking();
                    });
                  },
                  iconSize: _currentIndex == 1 ? _iconSizeSelected : _iconSize,
                ),
              ),

              BottomNavigationBarItem(
                label: '',
                icon: IconButton(
                  icon: _currentIndex == 2
                      ? Images.selectedProfile
                      : Images.tabProfile,
                  onPressed: () {
                    setState(() {
                      _currentIndex = 2;
                      currentScreen = Profile();
                    });
                  },
                  iconSize: _currentIndex == 2 ? _iconSizeSelected : _iconSize,
                ),
              ),

            ],
          ),
        )
          ],
        )
    );
  }
}
