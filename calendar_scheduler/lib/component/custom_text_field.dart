import 'package:calendar_scheduler/const/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final String intialValue;
  // true: 시간, false: 내용
  final bool isTime;
  final FormFieldSetter<String>? onSaved;
  const CustomTextField(
      {Key? key,
      required this.label,
      required this.isTime,
      this.onSaved,
      required this.intialValue})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: PRIMARY_COLOR,
            fontWeight: FontWeight.w600,
          ),
        ),
        if (isTime) renderTextField(),
        if (!isTime)
          Expanded(
            child: renderTextField(),
          ),
      ],
    );
  }

  Widget renderTextField() {
    return TextFormField(
      onSaved: onSaved,
      // null 리턴 시 에러가 없다
      // 에러가 있으면 스트링 값으로 리턴
      validator: (String? value) {
        if (value == null || value.isEmpty) {
          return '값을 입력해주세요';
        }

        if (isTime) {
          int time = int.parse(value!);
          if (time < 0) {
            return '0 이상의 숫자를 입력해주세요.';
          }
          if (time > 24) {
            return '24 이하의 숫자를 입력해주세요';
          }
        } else {}
        return null;
      },
      expands: !isTime,
      maxLines: isTime ? 1 : null,
      initialValue: intialValue,
      //maxLength: 500,
      cursorColor: Colors.grey,
      keyboardType: isTime ? TextInputType.number : TextInputType.multiline,
      inputFormatters: isTime
          ? [
              FilteringTextInputFormatter.digitsOnly,
            ]
          : [],
      decoration: InputDecoration(
        border: InputBorder.none,
        filled: true,
        fillColor: Colors.grey[300],
        suffixText: isTime ? '시' : null,
      ),
    );
  }
}
