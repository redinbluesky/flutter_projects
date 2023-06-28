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
      body: FutureBuilder<int>(
        // setState시 캐싱을 통해 이전 값을 가지고 있다. future 실행 후 변경 된다.
        future: getNumber(),
        builder: (context, snapshot) {
          /* // setState시 계속 로딩 않좋음
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );

          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          */
          if (snapshot.hasData) {
            // 데이터가 있을 때 위젯 랜더링
          }
          if (snapshot.hasError) {
            // 에러가 났을 때 위젯 랜더링
          }
          // 로딩중일 때 위젯 렌더링
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'FutureBuilder',
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

  Future<int> getNumber() async {
    await Future.delayed(Duration(seconds: 3));
    final random = Random();

    //throw Exception('에러가 발생했습니다.');
    return random.nextInt(100);
  }
}
