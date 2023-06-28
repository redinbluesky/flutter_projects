import 'package:flutter/material.dart';
import 'package:scrollable_widgets/const/colors.dart';
import 'package:scrollable_widgets/layout/main_layout.dart';

class GrideViewScreen extends StatelessWidget {
  List<int> numbers = List.generate(100, (index) => index);
  GrideViewScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      title: 'GrideViewScreen',
      body: renderMaxExtent(),
    );
  }

  // 1
  // 한번에 다 그림
  Widget renderCount() {
    return GridView.count(
        mainAxisSpacing: 12.0,
        crossAxisSpacing: 12.0,
        crossAxisCount: 2, // 가로 배치 개수
        children: numbers
            .map(
              (index) => renderContainer(
                color: rainbowColors[index % rainbowColors.length],
                index: index,
              ),
            )
            .toList());
  }

  // 2
  // 보이는 것만 그림
  Widget renderBuilder() {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12.0,
        crossAxisSpacing: 12.0,
      ),
      itemBuilder: (context, index) {
        return renderContainer(
          color: rainbowColors[index % rainbowColors.length],
          index: index,
        );
      },
    );
  }

  // 3
  // 최대사이즈
  Widget renderMaxExtent() {
    return GridView.builder(
      gridDelegate:
          SliverGridDelegateWithMaxCrossAxisExtent(maxCrossAxisExtent: 200),
      itemBuilder: (context, index) {
        return renderContainer(
          color: rainbowColors[index % rainbowColors.length],
          index: index,
        );
      },
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
