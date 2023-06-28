import 'package:flutter/material.dart';
import 'package:scrollable_widgets/const/colors.dart';

class _SliverFixedHeaderDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;
  final double maxHeight;
  final double minHeight;

  _SliverFixedHeaderDelegate(
      {required this.child, required this.maxHeight, required this.minHeight});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox.expand(
      child: child,
    );
  }

  @override
  // 최대 높이
  double get maxExtent => maxHeight;

  @override
  //최소 높이
  double get minExtent => minHeight;

  @override
  //covariant - 상속된 클래스도 사용가능
  //oldDelegate - build가 실행되었을 때 이전 Dlegate
  //this - 새로운 Dlegate
  //shouldRebuild - 새로 빌드를 해야할지 말지 결정
  bool shouldRebuild(_SliverFixedHeaderDelegate oldDelegate) {
    return oldDelegate.minHeight != minHeight ||
        oldDelegate.maxExtent != maxExtent ||
        oldDelegate.child != child;
  }
}

class CustomScrollViewScreen extends StatelessWidget {
  final List<int> numbers = List.generate(100, (index) => index);
  CustomScrollViewScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          renderSliverAppBar(),
          renderHeader(),
          renderBuilderSliverList(),
          renderHeader(),
          renderSliverGrideBuilder(),
          renderHeader(),
          renderBuilderSliverList(),
        ],
      ),
    );
  }

  SliverPersistentHeader renderHeader() {
    return SliverPersistentHeader(
      pinned: true,
      delegate: _SliverFixedHeaderDelegate(
        child: Container(
          color: Colors.black,
          child: Center(
            child: Text(
              '신기하지',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ),
        maxHeight: 200,
        minHeight: 50,
      ),
    );
  }

  SliverAppBar renderSliverAppBar() {
    return SliverAppBar(
      floating: true, // 스크롤했을때 리스트 중간에도 위로 스크롤하면 보인다.
      pinned: false, // 완전고정
      snap:
          true, // 자석효과, floating true일때 사용 조금만 움직여도 앱바가 내려온다. false: 내려오는 것이 중간에 멈출 수 있다
      stretch: true,
      expandedHeight: 200,
      collapsedHeight: 150,
      flexibleSpace: FlexibleSpaceBar(
        background: Image.asset(
          'asset/img/image_1.jpeg',
          fit: BoxFit.cover,
        ),
        title: Text('FlexibleSpace'),
      ),
      title: Text('CustomScrollViewScreen'),
    );
  }

  // Grideview.builder 와 유사
  SliverGrid renderSliverGrideBuilder() {
    return SliverGrid(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          return renderContainer(
            color: rainbowColors[index % rainbowColors.length],
            index: index,
          );
        },
        childCount: 10,
      ),
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 150,
      ),
    );
  }

  // GrideView.count와 유사
  SliverGrid renderChildSliverGirde() {
    return SliverGrid(
      delegate: SliverChildListDelegate(
        numbers
            .map(
              (e) => renderContainer(
                  color: rainbowColors[e % rainbowColors.length], index: e),
            )
            .toList(),
      ),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
      ),
    );
  }

  // ListView.builder 생성자와 유사함
  SliverList renderBuilderSliverList() {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          return renderContainer(
            color: rainbowColors[index % rainbowColors.length],
            index: index,
          );
        },
        childCount: 5,
      ),
    );
  }

  SliverList renderChildSliverList() {
    return SliverList(
      delegate: SliverChildListDelegate(
        numbers
            .map(
              (e) => renderContainer(
                  color: rainbowColors[e % rainbowColors.length], index: e),
            )
            .toList(),
      ),
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
