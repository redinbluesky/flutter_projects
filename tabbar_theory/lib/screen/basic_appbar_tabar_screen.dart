import 'package:flutter/material.dart';

import '../constants/tabs.dart';

class BasicAppbarTabbarScreen extends StatelessWidget {
  const BasicAppbarTabbarScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: TABS.length,
      child: Scaffold(
        appBar: AppBar(
          title: Text('BasicAppbarScreen'),
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(100),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TabBar(
                  indicatorColor: Colors.red,
                  indicatorWeight: 4.0,
                  indicatorSize: TabBarIndicatorSize.tab,
                  isScrollable: true,
                  labelColor: Colors.yellow,
                  unselectedLabelColor: Colors.black,
                  labelStyle: TextStyle(
                    fontWeight: FontWeight.w700,
                  ),
                  unselectedLabelStyle: TextStyle(
                    fontWeight: FontWeight.w100,
                  ),
                  tabs: TABS
                      .map((e) => Tab(
                            child: Text(e.label),
                            icon: Icon(e.icon),
                          ))
                      .toList(),
                ),
              ],
            ),
          ),
        ),
        body: TabBarView(
            physics: NeverScrollableScrollPhysics(),
            children: TABS
                .map(
                  (e) => Center(child: Icon(e.icon)),
                )
                .toList()),
      ),
    );
  }
}
