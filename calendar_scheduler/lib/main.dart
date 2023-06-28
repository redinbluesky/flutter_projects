import 'package:calendar_scheduler/const/colors.dart';
import 'package:calendar_scheduler/database/drift_database.dart';
import 'package:calendar_scheduler/screen/home_screen.dart';
import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  // 플롯터 실행될 때 까지 대기
  WidgetsFlutterBinding.ensureInitialized();

  await initializeDateFormatting();

  final database = LocalDatabase();

  GetIt.I.registerSingleton<LocalDatabase>(database);

  final colors = await database.getCategoryColors();
  if (colors.isEmpty) {
    for (String hexCode in DEFAULT_COLORS) {
      await database
          .createCategorColor(CategoryColorsCompanion(hexCode: Value(hexCode)));
    }
  }

  runApp(
    MaterialApp(
      theme: ThemeData(
        fontFamily: 'NotoSans',
      ),
      home: HomeScreen(),
    ),
  );
}
