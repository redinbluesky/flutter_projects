import 'package:flutter/material.dart';
import 'package:tabbar_theory/constants/tabs.dart';
import 'package:tabbar_theory/screen/appbar_using_cotroller.dart';
import 'package:tabbar_theory/screen/basic_appbar_tabar_screen.dart';
import 'package:tabbar_theory/screen/bottom_naviation_bar.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Sdreen'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => BasicAppbarTabbarScreen(),
                  ),
                );
              },
              child: Text('Basic AppBar TabBar Screen'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => AppbarUsingController(),
                  ),
                );
              },
              child: Text('Appbar Using Controller Screen'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => BottomNavigationBarScreen(),
                  ),
                );
              },
              child: Text('Bottom Navigation Bar Screen'),
            )
          ],
        ),
      ),
    );
  }
}
