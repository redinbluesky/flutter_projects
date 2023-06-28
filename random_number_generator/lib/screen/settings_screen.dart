import 'package:flutter/material.dart';
import 'package:random_number_generator/compoment/number_row.dart';
import 'package:random_number_generator/constants/color.dart';

class SettingsScreen extends StatefulWidget {
  final int maxNumber;
  const SettingsScreen({required this.maxNumber, Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  double maxNumber = 1000;

  @override
  void initState() {
    super.initState();
    this.maxNumber = widget.maxNumber.toDouble();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PRIMARY_COLOR,
      body: Center(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _Body(
                  maxNumber: maxNumber,
                ),
                _Footer(
                  onSlideChanged: onSlideChanged,
                  maxNumber: maxNumber,
                  onButtonPressed: onButtonPressed,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void onSlideChanged(double val) {
    setState(() {
      maxNumber = val;
    });
  }

  void onButtonPressed() {
    Navigator.of(context).pop(maxNumber.toInt());
  }
}

class _Body extends StatelessWidget {
  final double maxNumber;
  const _Body({required this.maxNumber, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: NumberRow(
        number: maxNumber.toInt(),
      ),
    );
  }
}

class _Footer extends StatelessWidget {
  final double maxNumber;
  final ValueChanged<double>? onSlideChanged;
  final VoidCallback onButtonPressed;

  const _Footer(
      {required this.onSlideChanged,
      required this.maxNumber,
      required this.onButtonPressed,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Slider(
          value: maxNumber,
          min: 1000,
          max: 100000,
          onChanged: onSlideChanged,
        ),
        ElevatedButton(
          onPressed: onButtonPressed,
          style: ElevatedButton.styleFrom(
            primary: RED_COLOR,
          ),
          child: Text(
            '저장!',
          ),
        )
      ],
    );
  }
}
