import 'package:dio/dio.dart';
import 'package:dusty_dust/component/card_title.dart';
import 'package:dusty_dust/const/colors.dart';
import 'package:dusty_dust/const/status_level.dart';
import 'package:dusty_dust/model/stat_model.dart';
import 'package:dusty_dust/model/stat_status_model.dart';
import 'package:dusty_dust/utils/data_utils.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:sugar/sugar.dart';

import '../container/category_card.dart';
import '../component/main_app_bar.dart';
import '../component/main_card.dart';
import '../component/main_drawer.dart';
import '../component/main_stat.dart';
import '../const/data.dart';
import '../const/regions.dart';
import '../container/hourly_card.dart';
import '../repository/stat_repository.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isExpanded = true;
  String region = regions[0];
  ScrollController scrollController = ScrollController();

  @override
  initState() {
    super.initState();
    scrollController.addListener(scrollListener);
    fetchData();
  }

  @override
  dispose() {
    scrollController.removeListener(scrollListener);
    scrollController.dispose();
    super.dispose();
  }

  Future<void> fetchData() async {
    try {
      //final now = DateTime.now();
      final now = ZonedDateTime.now(Timezone('ROK'));
      final fetchTime = DateTime(
        now.year,
        now.month,
        now.day,
        now.hour,
      );
      final box = Hive.box<StatModel>(ItemCode.PM10.name);

      if (box.values.isNotEmpty &&
          (box.values.last as StatModel).dataTime.isAtSameMomentAs(fetchTime)) {
        print("이미최신 데이터가 있습니다.");
        return;
      }

      List<Future> futures = [];

      for (ItemCode itemCode in ItemCode.values) {
        futures.add(
          StatRepository.fetchData(itemCode: itemCode),
        );
      }
      // 한번에 날려서 다 기다린다.
      final results = await Future.wait(futures);
      for (int i = 0; i < results.length; i++) {
        // ItemCode
        final key = ItemCode.values[i];
        // List<StatModel>
        final value = results[i];
        final box = Hive.box<StatModel>(key.name);

        for (StatModel stat in value) {
          box.put(stat.dataTime.toString(), stat);
        }

        final allKeys = box.keys.toList();
        if (allKeys.length > 24) {
          final deleteKeys = allKeys.sublist(0, allKeys.length - 24);
          box.deleteAll(deleteKeys);
        }
      }
    } on DioError catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('인터텟 연결이 원활하지 않습니다./n${e.message}'),
        ),
      );
    }
  }

  scrollListener() {
    bool isExpanded = scrollController.offset < 410 - kToolbarHeight;
    if (isExpanded != this.isExpanded) {
      setState(() {
        this.isExpanded = isExpanded;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Box>(
      valueListenable: Hive.box<StatModel>(ItemCode.PM10.name).listenable(),
      builder: (context, box, widget) {
        if (box.values.isEmpty) {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        final recentStat = (box.values.toList().last as StatModel);
        final status = DataUtils.getStatusFromItemCodeAndValue(
            value: recentStat.getLevelFromRegion(region),
            itemCode: ItemCode.PM10);
        return Scaffold(
          drawer: MainDrawer(
              darkColor: status.darkColor,
              lightColor: status.lightColor,
              onRegionTap: (String region) {
                setState(() {
                  this.region = region;
                });
                Navigator.of(context).pop();
              },
              selectedRetion: region),
          body: Container(
            color: status.primaryColor,
            child: RefreshIndicator(
              onRefresh: () async {
                await fetchData();
              },
              child: CustomScrollView(
                controller: scrollController,
                slivers: [
                  MainAppBar(
                    isExpanded: isExpanded,
                    dateTime: recentStat.dataTime,
                    region: region,
                    stat: recentStat,
                    status: status,
                  ),
                  SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        CategoryCard(
                            region: region,
                            darkColor: status.darkColor,
                            lightColor: status.lightColor),
                        SizedBox(height: 16.0),
                        ...ItemCode.values.map((itemCode) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 16.0),
                            child: HourlyCard(
                              itemCode: itemCode,
                              darkColor: status.darkColor,
                              lightColor: status.lightColor,
                              region: region,
                            ),
                          );
                        }).toList(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
