import 'package:flutter/material.dart';
// import 'package:presensi/home-page.dart';
import 'package:presensi/login_page.dart';
// import 'package:presensi/simpan-page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: LoginPage(),
    );
  }
}
