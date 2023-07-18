import 'dart:convert';

import 'package:actual/common/const/colors.dart';
import 'package:actual/common/layout/default_layout.dart';
import 'package:actual/common/view/root_tab.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../common/component/custom_text_from_field.dart';
import '../../common/const/data.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String username = '';
  String password = '';

  final dio = Dio();

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      child: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: SafeArea(
          top: true,
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _Title(),
                SizedBox(height: 16.0),
                _SubTitle(),
                Image.asset(
                  'asset/img/misc/logo.png',
                  height: MediaQuery.of(context).size.height / 2,
                ),
                CustomTextFormField(
                  hintText: '이메일을 입력해주세요',
                  onChanged: (String value) {
                    username = value;
                  },
                ),
                SizedBox(height: 16.0),
                CustomTextFormField(
                  hintText: '비밀번호를 입력해주세요',
                  obscureText: true,
                  onChanged: (String value) {
                    password = value;
                  },
                ),
                SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () async {
                    // ID:비밀번호
                    final rawString = '$username:$password';

                    Codec<String, String> stringToBase64 = utf8.fuse(base64);

                    String token = stringToBase64.encode(rawString);

                    final resp = await dio.post(
                      'http://${ip}/auth/login',
                      options: Options(
                        headers: {'authorization': 'Basic $token'},
                      ),
                    );

                    final refreshToken = resp.data['refreshToken'];
                    final accessToken = resp.data['accessToken'];

                    await storage.write(
                        key: REFRESH_TOKEN_KEY, value: refreshToken);
                    await storage.write(
                        key: ACCESS_TOKEN_KEY, value: accessToken);

                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => RootTab(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(primary: PRIMARY_COLOR),
                  child: Text('로그인'),
                ),
                TextButton(
                  onPressed: () async {},
                  style: TextButton.styleFrom(primary: Colors.black),
                  child: Text('회원가입'),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Title extends StatelessWidget {
  const _Title({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      '환영합니다!',
      style: TextStyle(
        fontSize: 30,
        fontWeight: FontWeight.w500,
        color: Colors.black,
      ),
    );
  }
}

class _SubTitle extends StatelessWidget {
  const _SubTitle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      '이메일과 비밀번호를 입력해서 로그인해주세요!\n오늘도 성공적인 주문이 되길 :)',
      style: TextStyle(
        fontSize: 14,
        color: BODY_TEXT_COLOR,
      ),
    );
  }
}
