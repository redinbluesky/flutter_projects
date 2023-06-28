import 'package:flutter/material.dart';
import 'package:navigation/layout/main_layout.dart';
import 'package:navigation/screen/route_three_screen.dart';

class RouteTwoScreen extends StatelessWidget {
  const RouteTwoScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context)!.settings.arguments;
    return MainLayout(
      title: 'Route Two',
      childern: [
        Text('argement: ${arguments}'),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Pop'),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pushNamed(
              '/three',
              arguments: 999,
            );
          },
          child: Text('Push Named'),
        ),
        ElevatedButton(
          onPressed: () {
            //Navigator.of(context).pushReplacement(
            // RouteTwo 제거
            //   MaterialPageRoute(builder: (context) => RouteThreeScreen()));
            Navigator.of(context).pushReplacementNamed("/three");
          },
          child: Text('Push Replacement'),
        ),
        ElevatedButton(
          onPressed: () {
            //Navigator.of(context).pushAndRemoveUntil(
            //   MaterialPageRoute(
            //     builder: (context) => RouteThreeScreen(),
            //    ),
            //    (route) => route.settings.name == '/', // 홈스크린 제외하고 다른 페이지 제거
            //  );
            Navigator.of(context).pushNamedAndRemoveUntil(
              "/three",
              (route) => route.settings.name == '/',
            );
          },
          child: Text('Push And Remove Util'),
        )
      ],
    );
  }
}
