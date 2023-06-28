import 'package:flutter/material.dart';
import 'package:scrollable_widgets/const/colors.dart';
import 'package:scrollable_widgets/layout/main_layout.dart';

class ReorderableListViewScreen extends StatefulWidget {
  const ReorderableListViewScreen({Key? key}) : super(key: key);

  @override
  State<ReorderableListViewScreen> createState() =>
      _ReorderableListViewScreenState();
}

class _ReorderableListViewScreenState extends State<ReorderableListViewScreen> {
  List<int> numbers = List.generate(100, (index) => index);

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      title: 'ReorderableListView',
      body: ReorderableListView.builder(
        itemBuilder: (context, index) {
          return renderContainer(
            color: rainbowColors[numbers[index] % rainbowColors.length],
            index: numbers[index],
          );
        },
        itemCount: numbers.length,
        onReorder: (int oldIndex, int newIndex) {
          try {
            setState(() {
              // old / new 모두 이동이 되기 전에 산정된다
              // [red, orange, yellow]
              // red를 yellow 다음으로 옴긴다 => 새로운 인덱스는 -1
              // yellow를 red 전으으로 옴긴다 => 새로운 인덱스 그대로 사용
              if (oldIndex < newIndex) {
                newIndex -= 1;
              }
              final item = numbers.removeAt(oldIndex);
              numbers.insert(newIndex, item);
            });
          } catch (e, s) {
            print(s);
          }
        },
      ),
    );
  }

  // 1
  // 한번에 그린다.
  Widget renderDefault() {
    return ReorderableListView(
      // 화면에서 순서 변경된 것을 데이터에도 반영한다.
      onReorder: (int oldIndex, int newIndex) {
        try {
          setState(() {
            // old / new 모두 이동이 되기 전에 산정된다
            // [red, orange, yellow]
            // red를 yellow 다음으로 옴긴다 => 새로운 인덱스는 -1
            // yellow를 red 전으으로 옴긴다 => 새로운 인덱스 그대로 사용
            if (oldIndex < newIndex) {
              newIndex -= 1;
            }
            final item = numbers.removeAt(oldIndex);
            numbers.insert(newIndex, item);
          });
        } catch (e, s) {
          print(s);
        }
      },
      children: numbers
          .map(
            (e) => renderContainer(
              color: rainbowColors[e % rainbowColors.length],
              index: e,
            ),
          )
          .toList(),
    );
  }

  Widget renderContainer(
      {required Color color, required int index, double? height}) {
    print(index);
    return Container(
      key: Key(index.toString()),
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
