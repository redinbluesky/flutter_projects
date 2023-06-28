import 'package:flutter/material.dart';

import '../screen/route_one_screen.dart';

class MainLayout extends StatelessWidget {
  final String title;
  final List<Widget> childern;
  const MainLayout({required this.title, required this.childern, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 8.0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: childern,
        ),
      ),
    );
  }
}
