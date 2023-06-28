import 'package:flutter/material.dart';
import 'package:navigation/layout/main_layout.dart';
import 'package:navigation/screen/route_one_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // true - pop 가능, false - pop 불가능
        // pop 버튼을 만든 경우 통과 가능
        if (Navigator.of(context).canPop()) {
          return true;
        } else {
          return false;
        }
      },
      child: MainLayout(title: 'Home Screen', childern: [
        ElevatedButton(
          onPressed: () async {
            final result = await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => RouteOneScreen(
                  number: 123,
                ),
              ),
            );
            print(result);
          },
          child: Text(
            'Push',
          ),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Pop'),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).maybePop(); // 스텍에 페이지가 있을 때 작동한다.
          },
          child: Text('Maybe Pop'),
        ),
        ElevatedButton(
          onPressed: () {
            print(Navigator.of(context).canPop());
          },
          child: Text('Can Pop'),
        )
      ]),
    );
  }
}
