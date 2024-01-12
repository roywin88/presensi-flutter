import 'dart:convert';

import 'package:flutter/material.dart';
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
  late Future<String> _userName, _token;
  String sessionCookie = "";

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
    checkToken(_token, _userName);
  }

  checkToken(token, userName) async {
    String tokenStr = await token;
    String nameStr = await userName;
    if (tokenStr != "" && nameStr != "") {
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
    LoginResponseModel? loginResponseModel;
    Map<String, String> body = {"userEmail": email, "password": password};
    var response = await http.post(
        Uri.parse('http://103.169.21.106:8887/api/auth/loginEss'),
        body: body);
    if (response.statusCode == 401) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Email atau password salah")));
    } else {
      loginResponseModel =
          LoginResponseModel.fromJson(json.decode(response.body));
      // debugPrint('HASIL ${response.body}');
      final cookies = response.headers['set-cookie']!;
      if (cookies.isNotEmpty) {
        sessionCookie = cookies;
        // debugPrint("Session Cookie: $sessionCookie");
      } else {
        debugPrint("Tidak ada cookie dalam respons.");
      }
      saveUser(loginResponseModel.data.token, loginResponseModel.data.userName,
          sessionCookie);
    }
  }

  Future saveUser(token, userName, sessionCookie) async {
    try {
      // debugPrint('LEWAT SINI $token | $userName');
      final SharedPreferences pref = await _prefs;
      pref.setString("userName", userName);
      pref.setString("token", token);
      pref.setString("sessionCookie", sessionCookie);
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => const HomePage()))
          .then((value) {
        setState(() {});
      });
    } catch (err) {
      debugPrint('ERROR :${err.toString()}');
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(err.toString())));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Center(child: Text("LOGIN")),
              const SizedBox(height: 20),
              const Text("Email"),
              TextField(
                controller: emailController,
              ),
              const SizedBox(height: 20),
              const Text("Password"),
              TextField(
                controller: passwordController,
                obscureText: true,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                  onPressed: () {
                    login(emailController.text, passwordController.text);
                  },
                  child: const Text("Masuk"))
            ],
          ),
        ),
      )),
    );
  }
}
