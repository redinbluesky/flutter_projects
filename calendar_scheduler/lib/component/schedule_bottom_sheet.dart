import 'package:calendar_scheduler/const/colors.dart';
import 'package:calendar_scheduler/database/drift_database.dart';
import 'package:calendar_scheduler/model/category_color.dart';
import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'custom_text_field.dart';

class ScheduleBottomSheet extends StatefulWidget {
  final int? scheduleId;
  final DateTime selectedDate;
  const ScheduleBottomSheet(
      {Key? key, required this.selectedDate, this.scheduleId})
      : super(key: key);

  @override
  State<ScheduleBottomSheet> createState() => _ScheduleBottomSheetState();
}

class _ScheduleBottomSheetState extends State<ScheduleBottomSheet> {
  final GlobalKey<FormState> formkey = GlobalKey();
  int? startTime;
  int? endTime;
  String? content;
  int? selectedColorId;

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: FutureBuilder<Schedule>(
          future: widget.scheduleId == null
              ? null
              : GetIt.I<LocalDatabase>().getScheduleById(widget.scheduleId!),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text('스케출을 불러올 수 없습니다.'),
              );
            }
            // FutureBuilder 처음 실행했고 로딩중일때
            if (snapshot.connectionState != ConnectionState.none &&
                !snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            // Future 실행되고 값이 있는데 StartTime이 설정되지 않음
            if (snapshot.hasData && startTime == null) {
              startTime = snapshot.data!.startTime;
              endTime = snapshot.data!.endTime;
              content = snapshot.data!.content;
              selectedColorId = snapshot.data!.colorId;
            }
            return SafeArea(
              child: Container(
                color: Colors.white,
                height: MediaQuery.of(context).size.height / 2 + bottomInset,
                child: Padding(
                  padding: EdgeInsets.only(
                    bottom: bottomInset,
                  ),
                  child: Padding(
                    padding:
                        const EdgeInsets.only(left: 8.0, right: 8.0, top: 16.0),
                    child: Form(
                      key: formkey,
                      //autovalidateMode: AutovalidateMode.always,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _Time(
                            startInitialValue: startTime?.toString() ?? '',
                            endInitialValue: endTime?.toString() ?? '',
                            onEndSaved: (String? value) {
                              endTime = int.parse(value!);
                            },
                            onStartSaved: (String? value) {
                              startTime = int.parse(value!);
                            },
                          ),
                          SizedBox(height: 16.0),
                          _content(
                            initialValue: content ?? '',
                            onContentSaved: (String? value) {
                              content = value!;
                            },
                          ),
                          SizedBox(height: 16.0),
                          FutureBuilder<List<CategoryColor>>(
                            future:
                                GetIt.I<LocalDatabase>().getCategoryColors(),
                            builder: (context, snapshot) {
                              if (snapshot.hasData &&
                                  selectedColorId == null &&
                                  snapshot.data!.isNotEmpty) {
                                selectedColorId = snapshot.data![0].id;
                              }

                              return _ColorPicker(
                                  colorIdSetter: (int id) {
                                    setState(() {
                                      selectedColorId = id;
                                    });
                                  },
                                  selectdColorid: selectedColorId,
                                  colors:
                                      snapshot.hasData ? snapshot.data! : []);
                            },
                          ),
                          SizedBox(height: 8.0),
                          _SaveButton(
                            onPressed: onSavePressed,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          }),
    );
  }

  void onSavePressed() async {
    // formKey 생성을 했는데 Form 위젯과 결함을 안했을때
    if (formkey.currentState == null) {
      return;
    }

    if (formkey.currentState!.validate()) {
      formkey.currentState!.save();

      if (widget.scheduleId == null) {
        final key = await GetIt.I<LocalDatabase>().createSchedule(
          SchedulesCompanion(
            date: Value(widget.selectedDate),
            startTime: Value(startTime!),
            endTime: Value(endTime!),
            content: Value(content!),
            colorId: Value(selectedColorId!),
          ),
        );
      } else {
        await GetIt.I<LocalDatabase>().updateScheduleById(
          widget.scheduleId!,
          SchedulesCompanion(
            date: Value(widget.selectedDate),
            startTime: Value(startTime!),
            endTime: Value(endTime!),
            content: Value(content!),
            colorId: Value(selectedColorId!),
          ),
        );
      }
      Navigator.of(context).pop();
    } else {
      print('에러가 있습니다.');
    }
  }
}

class _SaveButton extends StatelessWidget {
  final VoidCallback onPressed;
  const _SaveButton({Key? key, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: PRIMARY_COLOR,
            ),
            child: Text('저장'),
          ),
        ),
      ],
    );
  }
}

typedef ColorIdSetter = void Function(int id);

class _ColorPicker extends StatelessWidget {
  final ColorIdSetter colorIdSetter;
  final int? selectdColorid;
  final List<CategoryColor> colors;
  const _ColorPicker(
      {Key? key,
      required this.colors,
      required this.selectdColorid,
      required this.colorIdSetter})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8.0,
      runSpacing: 10.0,
      children: colors
          .map(
            (e) => GestureDetector(
              onTap: () {
                colorIdSetter(e.id);
              },
              child: rendorColor(
                e,
                selectdColorid == e.id,
              ),
            ),
          )
          .toList(),
    );
  }

  Widget rendorColor(CategoryColor color, bool isSelected) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Color(
          int.parse(
            'FF${color.hexCode}',
            radix: 16,
          ),
        ),
        border: isSelected
            ? Border.all(
                color: Colors.black,
                width: 4.0,
              )
            : null,
      ),
      width: 32.0,
      height: 32.0,
    );
  }
}

class _content extends StatelessWidget {
  final String initialValue;
  final FormFieldSetter<String> onContentSaved;
  const _content(
      {Key? key, required this.onContentSaved, required this.initialValue})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: CustomTextField(
        intialValue: initialValue,
        label: '내용',
        isTime: false,
        onSaved: onContentSaved,
      ),
    );
  }
}

class _Time extends StatelessWidget {
  final FormFieldSetter<String> onStartSaved;
  final FormFieldSetter<String> onEndSaved;
  final String startInitialValue;
  final String endInitialValue;

  const _Time(
      {Key? key,
      required this.onStartSaved,
      required this.onEndSaved,
      required this.startInitialValue,
      required this.endInitialValue})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: CustomTextField(
            intialValue: startInitialValue,
            label: '시작시간',
            isTime: true,
            onSaved: onStartSaved,
          ),
        ),
        SizedBox(
          width: 16.0,
        ),
        Expanded(
          child: CustomTextField(
            intialValue: endInitialValue,
            label: '마감시간',
            isTime: true,
            onSaved: onEndSaved,
          ),
        ),
      ],
    );
  }
}
