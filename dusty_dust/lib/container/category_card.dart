import 'package:dusty_dust/model/stat_model.dart';
import 'package:dusty_dust/utils/data_utils.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';

import '../const/colors.dart';
import '../model/stat_status_model.dart';
import '../component/card_title.dart';
import '../component/main_card.dart';
import '../component/main_stat.dart';

class CategoryCard extends StatelessWidget {
  final String region;
  final Color darkColor;
  final Color lightColor;
  const CategoryCard(
      {Key? key,
      required this.region,
      required this.darkColor,
      required this.lightColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 160,
      child: MainCard(
        backgroundColor: lightColor,
        child: LayoutBuilder(builder: (context, constraint) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CardTitle(
                title: '종류별 통계',
                backgroundColor: darkColor,
              ),
              Expanded(
                child: ListView(
                  physics: PageScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  children: ItemCode.values
                      .map(
                        (ItemCode itemCode) => ValueListenableBuilder<Box>(
                          valueListenable:
                              Hive.box<StatModel>(itemCode.name).listenable(),
                          builder: (context, box, widget) {
                            final stat = (box.values.last as StatModel);
                            final status =
                                DataUtils.getStatusFromItemCodeAndValue(
                                    value: stat.getLevelFromRegion(region),
                                    itemCode: itemCode);
                            return MainStat(
                              width: constraint.maxWidth / 3,
                              category: DataUtils.getItemCodeKrString(
                                itemCode: itemCode,
                              ),
                              imgPath: status.imagePath,
                              level: status.label,
                              stat:
                                  '${stat.getLevelFromRegion(region)}${DataUtils.getUnitFromItemCode(itemCode: itemCode)}',
                            );
                          },
                        ),
                      )
                      .toList(),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
