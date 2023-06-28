import 'package:drift/drift.dart';

class CategoryColors extends Table {
  // Primary 키
  // autoIncrement : 자동으로 증가하는 값이 입력된다.
  IntColumn get id => integer().autoIncrement()();

  // 생상코드
  TextColumn get hexCode => text()();
}
