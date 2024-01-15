import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:presensi/core/constants/variables.dart';
import 'package:presensi/models/home_response.dart';
import 'package:presensi/simpan_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  late Future<String> _userName, _token, _cookie;
  HomeResponseModel? homeResponseModel;
  Datum? hariIni;
  List<Datum> riwayat = [];

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
  }

  Future getData() async {
    const String apiUrl = Variables.baseUrlGet;
    DateTime now = DateTime.now();
    int bulan = now.month;
    int tahun = now.year;
    String urlWithParams = "$apiUrl?bulan=$bulan&tahun=$tahun";
    final Map<String, String> headers = {
      "Content-Type": "application/json",
      "X-API-KEY": await _token,
      'cookie': await _cookie,
    };
    var response = await http.get(Uri.parse(urlWithParams), headers: headers);
    homeResponseModel = HomeResponseModel.fromJson(json.decode(response.body));
    riwayat.clear();
    for (var element in homeResponseModel!.data) {
      if (element.attDate == DateFormat('dd-MM-yyyy').format(now)) {
        hariIni = element;
      } else {
        riwayat.add(element);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: getData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else {
              return SafeArea(
                  child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FutureBuilder(
                        future: _userName,
                        builder: (BuildContext context,
                            AsyncSnapshot<String> snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const CircularProgressIndicator();
                          } else {
                            if (snapshot.hasData) {
                              // debugPrint(snapshot.data);
                              return Text(snapshot.data!,
                                  style: const TextStyle(fontSize: 22));
                            } else {
                              return const Text("-",
                                  style: TextStyle(fontSize: 22));
                            }
                          }
                        }),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      width: 400,
                      decoration: BoxDecoration(
                        color: Colors.blue[800],
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Text(hariIni?.attDate ?? '-',
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 32)),
                            const SizedBox(
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Column(
                                  children: [
                                    Text(hariIni?.clockTime ?? '-',
                                        style: const TextStyle(
                                            color: Colors.white, fontSize: 24)),
                                    const Text(
                                      "Masuk",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    Text(hariIni?.clockTimeOut ?? '-',
                                        style: const TextStyle(
                                            color: Colors.white, fontSize: 24)),
                                    const Text(
                                      "Pulang",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "Riwayat Presensi",
                      style: TextStyle(fontSize: 20),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: riwayat.length,
                        itemBuilder: (context, index) => Card(
                          child: ListTile(
                            leading: Text(
                              riwayat[index].attDate,
                              style: const TextStyle(fontSize: 18),
                            ),
                            title: Row(children: [
                              Column(
                                children: [
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  Text(riwayat[index].clockTime,
                                      style: const TextStyle(fontSize: 18)),
                                  const Text("Masuk",
                                      style: TextStyle(fontSize: 16))
                                ],
                              ),
                              const SizedBox(width: 40),
                              Column(
                                children: [
                                  Text(riwayat[index].clockTimeOut,
                                      style: const TextStyle(fontSize: 18)),
                                  const Text("Pulang",
                                      style: TextStyle(fontSize: 16))
                                ],
                              ),
                            ]),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ));
            }
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => const SimpanPage()))
              .then((value) {
            setState(() {});
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
