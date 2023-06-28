import 'package:dusty_dust/model/stat_model.dart';
import 'package:dusty_dust/model/status_model.dart';
import 'package:flutter/material.dart';

class StatAndStausModel {
  final ItemCode itemCode;
  final StatusModel status;
  final StatModel stat;

  StatAndStausModel({
    required this.itemCode,
    required this.status,
    required this.stat,
  });
}
