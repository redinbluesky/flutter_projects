import 'dart:math';

import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final textStyle = TextStyle(fontSize: 16.0);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<int>(
        // Stream를 자동으로 닫아준다.
        // setState시 캐싱을 통해 이전 값을 가지고 있다. stream 실행 후 변경 된다.
        stream: streamNumbers(),
        builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'StreamBuilder',
                style: textStyle.copyWith(
                  fontWeight: FontWeight.w700,
                  fontSize: 20.0,
                ),
              ),
              Text(
                'ConState: ${snapshot.connectionState}',
                style: textStyle,
              ),
              Text(
                'Data: ${snapshot.data}',
                style: textStyle,
              ),
              Text(
                'Error: ${snapshot.error}',
                style: textStyle,
              ),
              ElevatedButton(
                  onPressed: () {
                    setState(() {});
                  },
                  child: Text('setState'))
            ],
          );
        },
      ),
    );
  }

  Stream<int> streamNumbers() async* {
    for (int i = 0; i < 10; i++) {
      if (i == 5) throw Exception('i = 5');
      await Future.delayed(
        Duration(seconds: 1),
      );
      yield i;
    }
  }
}
