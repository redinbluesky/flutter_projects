import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';

import '../main.dart';

class TestScreen2 extends StatefulWidget {
  const TestScreen2({Key? key}) : super(key: key);

  @override
  State<TestScreen2> createState() => _TestScreen2State();
}

class _TestScreen2State extends State<TestScreen2> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('TestScreen2'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ValueListenableBuilder<Box>(
            valueListenable: Hive.box(testBox).listenable(),
            builder: (context, box, widget) {
              print(box.values.toList());
              return Column(
                children: box.values.map((e) => Text(e.toString())).toList(),
              );
            },
          )
        ],
      ),
    );
  }
}
