import 'package:drift/drift.dart';

class Schedules extends Table {
  // Primiry Key
  // autoIncrement : 자동으로 증가하는 값이 입력된다.
  IntColumn get id => integer().autoIncrement()();

  // 내용
  TextColumn get content => text()();

  // 일정 날짜
  DateTimeColumn get date => dateTime()();

  // 시작 시간
  IntColumn get startTime => integer()();

  // 끝 시간
  IntColumn get endTime => integer()();

  // Cagegory Color Table ID
  IntColumn get colorId => integer()();

  // 생성날짜
  // clientDefault: 실행된 함수의 리턴값을 기본 값으로 사용한다.
  // ==> 입력된 값이 있는 경우 입련된 값이 사용된다.
  DateTimeColumn get createdAt =>
      dateTime().clientDefault(() => DateTime.now())();
}
