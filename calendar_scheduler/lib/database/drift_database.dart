// private 값들은 부러올 수 없다.
import 'dart:io';

import 'package:calendar_scheduler/model/category_color.dart';
import 'package:calendar_scheduler/model/schedule.dart';
import 'package:calendar_scheduler/model/shcedule_with_color.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

// import보다 넓은 기능.
// private 값들 까지 가져온다.
// .g : 자동으로 생성된 파일
// flutter pub run build_runner build
part 'drift_database.g.dart';

@DriftDatabase(
  tables: [Schedules, CategoryColors],
)
// drift_database.g.dart 가 자동 생성되면서 _$LocalDatabase가 들어가 있다
class LocalDatabase extends _$LocalDatabase {
  LocalDatabase() : super(_openConnection());

  Future<int> createSchedule(SchedulesCompanion data) =>
      into(schedules).insert(data);

  Future<int> createCategorColor(CategoryColorsCompanion data) =>
      into(categoryColors).insert(data);

  Future<List<CategoryColor>> getCategoryColors() =>
      select(categoryColors).get();

  Future<int> removeSchedule(int id) =>
      (delete(schedules)..where((tbl) => tbl.id.equals(id))).go();

  Future<int> updateScheduleById(int id, SchedulesCompanion data) =>
      (update(schedules)..where((tbl) => tbl.id.equals(id))).write(data);

  Future<Schedule> getScheduleById(int id) =>
      (select(schedules)..where((tbl) => tbl.id.equals(id))).getSingle();

  Stream<List<ScheduleWithColor>> watchSchdules(DateTime date) {
    final query = select(schedules).join([
      innerJoin(categoryColors, categoryColors.id.equalsExp(schedules.colorId))
    ]);
    query.where(schedules.date.equals(date));
    query.orderBy([
      OrderingTerm.asc(schedules.startTime),
    ]);
    return query.watch().map(
          (rows) => rows
              .map(
                (row) => ScheduleWithColor(
                  schedule: row.readTable(schedules),
                  categoryColor: row.readTable(categoryColors),
                ),
              )
              .toList(),
        );
    // .. 함수 실행 후 실행 된 대상이 리턴된다.
    //return (select(schedules)..where((tbl) => tbl.date.equals(date))).watch();
  }

  // 테이블 상태 버전. 테이블이 변경이 될 때 마다 변경한다.
  @override
  int get schemaVersion => 1;
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    // 애플리케이션이 사용할 수 있는 폴더를 시스템에서 가져온다.
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    return NativeDatabase(file);
  });
}
