import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:presensi/core/components/buttons.dart';
import 'package:presensi/core/components/custom_text_field.dart';
import 'package:presensi/core/constants/variables.dart';
import 'package:presensi/home_page.dart';
import 'package:http/http.dart' as http;
import 'package:presensi/models/login_response.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  late Future<String> _userName, _token, _cookie;
  List<String> allowedEmails = [
    'roni.hutabarat@sta.co.id',
    'dennis@sta.co.id',
    'amir@sta.co.id',
    'yohanes.gultom@sta.co.id',
  ];

  @override
  void initState() {
    // todo: implement initState
    super.initState();
    _token = _prefs.then((SharedPreferences prefs) {
      return prefs.getString("token") ?? "";
    });

    _userName = _prefs.then((SharedPreferences prefs) {
      return prefs.getString("userName") ?? "";
    });

    _cookie = _prefs.then((SharedPreferences prefs) {
      return prefs.getString("cookie") ?? "";
    });
    checkToken(_token, _userName, _cookie);
  }

  checkToken(token, userName, cookie) async {
    String tokenStr = await token;
    String nameStr = await userName;
    String cookieStr = await cookie;
    if (tokenStr != "" && nameStr != "" && cookieStr != "") {
      Future.delayed(const Duration(seconds: 1), () async {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => const HomePage()))
            .then((value) {
          setState(() {});
        });
      });
    }
  }

  Future login(email, password) async {
    if (allowedEmails.contains(email)) {
      LoginResponseModel? loginResponseModel;
      Map<String, String> body = {"userEmail": email, "password": password};
      var response =
          await http.post(Uri.parse(Variables.baseUrlLogin), body: body);
      if (response.statusCode == 401) {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Email atau password salah")));
      } else {
        loginResponseModel =
            LoginResponseModel.fromJson(json.decode(response.body));
        final cookie = response.headers['set-cookie']!;
        saveUser(loginResponseModel.data.token,
            loginResponseModel.data.userName, cookie);
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Alamat Email Anda Tidak Diizinkan")));
    }
  }

  Future saveUser(token, userName, cookie) async {
    try {
      final SharedPreferences pref = await _prefs;
      pref.setString("userName", userName);
      pref.setString("token", token);
      pref.setString("cookie", cookie);
      // ignore: use_build_context_synchronously
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => const HomePage()))
          .then((value) {
        setState(() {});
      });
    } catch (err) {
      debugPrint('ERROR :${err.toString()}');
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(err.toString())));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          const SizedBox(height: 80.0),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 130.0),
              child: Image.asset(
                'assets/images/logo.png',
                width: 100,
                height: 100,
              )),
          const SizedBox(height: 24.0),
          const Center(
            child: Text(
              "Galaxy Armed By Alexroywin",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
            ),
          ),
          const SizedBox(height: 8.0),
          const Center(
            child: Text(
              "Masuk untuk explorer",
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: Colors.grey,
              ),
            ),
          ),
          const SizedBox(height: 40.0),
          CustomTextField(
            controller: emailController,
            label: "Email",
          ),
          const SizedBox(height: 12.0),
          CustomTextField(
            controller: passwordController,
            label: 'Password',
            obscureText: true,
          ),
          const SizedBox(height: 24.0),
          Button.filled(
            onPressed: () {
              login(emailController.text, passwordController.text);
            },
            label: 'Masuk',
          ),
        ],
      ),
    );
  }
}
