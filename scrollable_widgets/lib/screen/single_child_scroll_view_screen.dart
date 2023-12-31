import 'package:flutter/material.dart';
import 'package:scrollable_widgets/const/colors.dart';
import 'package:scrollable_widgets/layout/main_layout.dart';

class SingleChildScrollViewScreen extends StatelessWidget {
  final List<int> numbers = List.generate(
    100,
    (index) => index,
  );
  SingleChildScrollViewScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      title: 'SingleChildScrollView',
      body: renderPerfomance(),
    );
  }

  //1
  // 기본 랜더링법
  Widget renderSimple() {
    return Container(
      // 화면이 넘어가야 스코롤 기능 부여
      child: SingleChildScrollView(
        child: Column(
          children:
              rainbowColors.map((e) => renderContainer(color: e)).toList(),
        ),
      ),
    );
  }

  //2
  // 화면을 넘어가지 않아도 스크롤 가능
  Widget renderAlwaysScroll() {
    return SingleChildScrollView(
      physics: AlwaysScrollableScrollPhysics(),
      child: Column(
        children: [renderContainer(color: Colors.black)],
      ),
    );
  }

  //3
  // 화면 위젯이 잘리지 않게 하기
  Widget renderClip() {
    return SingleChildScrollView(
      // 잘렸을때 작동방식
      clipBehavior: Clip.none,
      physics: AlwaysScrollableScrollPhysics(),
      child: Column(
        children: [
          renderContainer(color: Colors.black),
        ],
      ),
    );
  }

  //4
  // 여러가지 physics 정리
  Widget renderPhysics() {
    return SingleChildScrollView(
      // AlwaysScrollableScrollPhysics - 스크롤 됨
      // NeverScrollableScrollPhysics - 스크롤 안됨
      // BouncingScrollPhysics - IOS 스타일
      // ClampingScrollPhysics - 안드로이드 스타일
      physics: ClampingScrollPhysics(),
      child: Column(
        children: rainbowColors.map((e) => renderContainer(color: e)).toList(),
      ),
    );
  }

  //5
  // SingleChildScrollView 퍼포먼스
  Widget renderPerfomance() {
    return SingleChildScrollView(
      child: Column(
        // 한번에 다 랜더링한다.
        children: numbers
            .map(
              (e) => renderContainer(
                  color: rainbowColors[e % rainbowColors.length], index: e),
            )
            .toList(),
      ),
    );
  }

  Widget renderContainer({required Color color, int? index}) {
    if (index != null) print(index);
    return Container(
      height: 300,
      color: color,
    );
  }
}
