import 'package:flutter/material.dart';
import 'package:scrollable_widgets/const/colors.dart';
import 'package:scrollable_widgets/layout/main_layout.dart';

class ListViewScreen extends StatelessWidget {
  final List<int> numbers = List.generate(100, (index) => index);
  ListViewScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      title: 'ListViewScreen',
      body: renderSeperated(),
    );
  }

  // 2
  // 화면에 보이는 것만 그림 / 중간 중간 위젯너을 수 있음

  Widget renderSeperated() {
    return ListView.separated(
      itemBuilder: (context, index) {
        return renderContainer(
            index: index, color: rainbowColors[index % rainbowColors.length]);
      },
      separatorBuilder: (context, index) {
        index += 1;
        // 5개의 아이템마다 배너 보여주기
        if (index % 5 == 0) {
          return renderContainer(
              color: Colors.black, index: index, height: 100);
        }
        return SizedBox(
          height: 10.0,
        );
      },
      itemCount: 100,
    );
  }

  // 2
  // 화면에 보이는 것만 그림
  Widget renderBuilder() {
    // 0 ~ 2 화면에 보이는 것 까지 그림, 위/아래를 다시 그리는 것으로 보아 화면에서 사라지면
    // 메모리에서 사라진다.
    return ListView.builder(
      itemCount: 100,
      itemBuilder: (context, index) {
        return renderContainer(
            index: index, color: rainbowColors[index % rainbowColors.length]);
      },
    );
  }

  // 1
  // 모두 한번에 그림
  Widget renderDefault() {
    // 0 ~ 99 까지 한꺼번에 그려짐
    return ListView(
      children: numbers
          .map((e) => renderContainer(
              index: e, color: rainbowColors[e % rainbowColors.length]))
          .toList(),
    );
  }

  Widget renderContainer(
      {required Color color, required int index, double? height}) {
    print(index);
    return Container(
      height: height ?? 300,
      color: color,
      child: Center(
        child: Text(
          index.toString(),
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 30.0,
          ),
        ),
      ),
    );
  }
}
