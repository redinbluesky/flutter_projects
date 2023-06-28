import 'package:flutter/material.dart';
import 'package:scrollable_widgets/screen/custom_scroll_view_screen.dart';
import 'package:scrollable_widgets/screen/gride_view_screen.dart';
import 'package:scrollable_widgets/screen/list_view_screen.dart';
import 'package:scrollable_widgets/screen/refresh_indicator.dart';
import 'package:scrollable_widgets/screen/reorderable_list_view.dart';
import 'package:scrollable_widgets/screen/scrollbar_screen.dart';
import 'package:scrollable_widgets/screen/single_child_scroll_view_screen.dart';

import '../layout/main_layout.dart';

class ScreenModel {
  final WidgetBuilder builder;
  final String name;

  ScreenModel({required this.builder, required this.name});
}

class HomeScreen extends StatelessWidget {
  final screens = [
    ScreenModel(
        builder: (context) => SingleChildScrollViewScreen(),
        name: 'SigleChildScrollViewScreen'),
    ScreenModel(
      builder: (context) => ListViewScreen(),
      name: 'ListViewScreen',
    ),
    ScreenModel(
      builder: (context) => GrideViewScreen(),
      name: 'GrideViewScreen',
    ),
    ScreenModel(
      builder: (context) => ReorderableListViewScreen(),
      name: 'ReorderableScreen',
    ),
    ScreenModel(
      builder: (context) => CustomScrollViewScreen(),
      name: 'CustomScrollViewScreen',
    ),
    ScreenModel(
      builder: (context) => ScrollBarScreen(),
      name: 'ScrollBarScreen',
    ),
    ScreenModel(
      builder: (context) => RefreshIndicatorScreen(),
      name: 'RefreshIndicatorScreen',
    ),
  ];
  HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      title: 'Home',
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: screens
                .map((screen) => ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: screen.builder),
                      );
                    },
                    child: Text(screen.name)))
                .toList(),
          ),
        ),
      ),
    );
  }
}
