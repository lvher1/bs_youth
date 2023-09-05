import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import './auth.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String? errorMsg = '';
  bool isLogin = true;

  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPwd = TextEditingController();

  Future<void> signInWithEmailAndPassword() async {
    try {
      await Auth().signInWithEmailAndPassword(
          email: _controllerEmail.text, password: _controllerPwd.text);
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMsg = e.message;
      });
    }
  }

  Future<void> createUserWithEmailAndPassword() async {
    try {
      await Auth().createUserWithEmailAndPassword(
          email: _controllerEmail.text, password: _controllerPwd.text);
      final currentUser = FirebaseAuth.instance;
      final wordPair = WordPair.random();

      Map<String, dynamic> userMap = {
        "name": wordPair.asPascalCase,
        "age": Random().nextInt(100),
        "uid": currentUser.currentUser!.email.toString()
      };
      print(currentUser.currentUser!.email.toString());
      await FirebaseFirestore.instance
          .collection('User').doc(currentUser.currentUser!.email.toString()).set(userMap);

    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMsg = e.message;
      });
    }
  }

  Widget _title() {
    return const Text('구글 메일로 로그인');
  }

  Widget _entryField(
    String title,
    TextEditingController controller,
    bool obscure,
  ) {
    return SizedBox(
        width: 500,
        child: TextField(
          obscureText: obscure,
          controller: controller,
          decoration: InputDecoration(labelText: title),
          style: TextStyle(fontSize: 10, color: Colors.green),
          keyboardType: TextInputType.emailAddress,
        ));
  }

  Widget _errorMessage() {
    return Text(errorMsg == '' ? '' : 'Humm ? $errorMsg');
  }

  Widget _submitButton() {
    return ElevatedButton(
        onPressed: isLogin
            ? signInWithEmailAndPassword
            : createUserWithEmailAndPassword,
        child: Text(isLogin ? '로그인' : '회원가입'));
  }

  Widget _loginOrRegisterButton() {
    return TextButton(
      onPressed: () {
        setState(() {
          isLogin = !isLogin;
        });
      },
      child: Text(isLogin ? '회원가입' : '로그인'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _title(),
        backgroundColor: Colors.lightGreen,
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            //Image.asset('image/Songlist Icon.png', width: 150, height:150, fit: BoxFit.fill),
            _entryField('이메일', _controllerEmail, false),
            _entryField('비밀번호', _controllerPwd, true),
            _errorMessage(),
            _submitButton(),
            _loginOrRegisterButton(),
          ],
        ),
      ),
    );
  }
}
