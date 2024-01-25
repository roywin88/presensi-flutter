import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:presensi/core/components/buttons.dart';
import 'package:presensi/core/components/custom_text_field.dart';
import 'package:presensi/core/constants/colors.dart';
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
  bool checkbox1 = false;
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
      backgroundColor: AppColors.bgcolor,
      body: Stack(
        children: [
          Column(
            children: [
              Image.asset('assets/images/login_BG1.png'),
              const SizedBox(height: 197),
              Image.asset('assets/images/login_BG2.png'),
            ],
          ),
          SafeArea(
            child: ListView(
              children: [
                Column(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(height: 230),
                          Text(
                            'Welcome Back',
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: AppColors.white,
                            ),
                          ),
                          Text(
                            'Login to your account',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Color(0xffD4D4D4),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width,
                          // height: MediaQuery.of(context).size.height * 0.53,
                          margin: const EdgeInsets.only(
                            top: 50,
                            left: 24,
                            right: 24,
                          ),
                          padding: const EdgeInsets.only(
                            top: 50,
                            left: 20,
                            right: 20,
                            bottom: 40,
                          ),
                          decoration: const BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20),
                            ),
                          ),
                          child: Column(
                            children: [
                              CustomTextField(
                                controller: emailController,
                                label: "Email",
                              ),
                              const SizedBox(height: 15),
                              CustomTextField(
                                controller: passwordController,
                                label: 'Password',
                                obscureText: true,
                              ),
                              const SizedBox(height: 18),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Checkbox(
                                    value: checkbox1,
                                    onChanged: (value) {
                                      setState(
                                        () {
                                          checkbox1 = value!;
                                        },
                                      );
                                    },
                                  ),
                                  // const SizedBox(width: 10),
                                  const Text(
                                    'Remember me',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w300,
                                      color: Color(0xff5D5D5D),
                                    ),
                                  ),
                                  const SizedBox(width: 20),
                                  const Text(
                                    'Forgot Password',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xff5D5D5D),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 45.0),
                              Button.filled(
                                onPressed: () {
                                  login(emailController.text,
                                      passwordController.text);
                                },
                                label: 'Login',
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
