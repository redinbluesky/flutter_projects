import 'package:actual/common/view/splash_screen.dart';
import 'package:actual/user/view/login_screen.dart';
import 'package:flutter/material.dart';

import 'common/component/custom_text_from_field.dart';

void main() {
  runApp(_App());
}

class _App extends StatelessWidget {
  const _App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(fontFamily: 'Notosans'),
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}
