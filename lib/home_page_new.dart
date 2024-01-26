import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:presensi/core/constants/colors.dart';
import 'package:presensi/core/constants/variables.dart';
import 'package:presensi/models/home_response.dart';
import 'package:presensi/simpan_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

class HomePageNew extends StatefulWidget {
  const HomePageNew({super.key});

  @override
  State<HomePageNew> createState() => _HomePageNewState();
}

class _HomePageNewState extends State<HomePageNew> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  late Future<String> _userName, _token, _cookie, _job, _dept, _fotoProfile;

  late StreamController<DateTime> _streamController;
  late DateTime _currentTime;

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

    _fotoProfile = _prefs.then((SharedPreferences prefs) {
      return prefs.getString("fotoProfile") ?? "";
    });

    _job = _prefs.then((SharedPreferences prefs) {
      return prefs.getString("job") ?? "";
    });

    _dept = _prefs.then((SharedPreferences prefs) {
      return prefs.getString("dept") ?? "";
    });

    // Atur timer untuk memperbarui jam setiap menit
    _currentTime = DateTime.now();
    _streamController = StreamController<DateTime>.broadcast();
    _startClock();
  }

  void _startClock() {
    Timer.periodic(const Duration(seconds: 1), (timer) {
      DateTime now = DateTime.now();
      if (_currentTime.minute != now.minute) {
        // Jika jam berubah, tambahkan waktu ke stream
        _currentTime = now;
        _streamController.add(now);
      }
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
    return StreamBuilder<DateTime>(
      stream: _streamController.stream,
      initialData: _currentTime,
      builder: (context, snapshot) {
        // Format waktu sesuai kebutuhan (misalnya, "HH:mm")
        String formattedTime = DateFormat.Hm().format(snapshot.data!);
        return Scaffold(
          body: FutureBuilder(
            future: getData(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else {
                return Stack(
                  children: [
                    Image.asset('assets/images/Home_BG1.png'),
                    SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                FutureBuilder(
                                  future: _fotoProfile,
                                  builder: (BuildContext context,
                                      AsyncSnapshot<String> snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return const CircularProgressIndicator();
                                    } else {
                                      if (snapshot.hasData) {
                                        return CircleAvatar(
                                          radius: 40,
                                          backgroundImage: NetworkImage(
                                            snapshot.data!,
                                          ),
                                        );
                                      } else {
                                        return const CircleAvatar(
                                          radius: 40,
                                          backgroundImage: AssetImage(
                                            'assets/images/Profile.png',
                                          ),
                                        );
                                      }
                                    }
                                  },
                                ),
                                const SizedBox(width: 12),
                                Column(
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
                                            return Text(
                                              snapshot.data!,
                                              style: const TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                                color: AppColors.white,
                                              ),
                                            );
                                          } else {
                                            return const Text(
                                              "-",
                                              style: TextStyle(
                                                fontSize: 22,
                                                fontWeight: FontWeight.bold,
                                                color: AppColors.white,
                                              ),
                                            );
                                          }
                                        }
                                      },
                                    ),
                                    Row(
                                      children: [
                                        FutureBuilder(
                                          future: _dept,
                                          builder: (BuildContext context,
                                              AsyncSnapshot<String> snapshot) {
                                            if (snapshot.connectionState ==
                                                ConnectionState.waiting) {
                                              return const CircularProgressIndicator();
                                            } else {
                                              if (snapshot.hasData) {
                                                return Text(
                                                  snapshot.data!,
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w400,
                                                    color: AppColors.white,
                                                  ),
                                                );
                                              } else {
                                                return const Text(
                                                  "-",
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                    color: AppColors.white,
                                                  ),
                                                );
                                              }
                                            }
                                          },
                                        ),
                                        const Text(
                                          " - ",
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w400,
                                            color: AppColors.white,
                                          ),
                                        ),
                                        FutureBuilder(
                                          future: _job,
                                          builder: (BuildContext context,
                                              AsyncSnapshot<String> snapshot) {
                                            if (snapshot.connectionState ==
                                                ConnectionState.waiting) {
                                              return const CircularProgressIndicator();
                                            } else {
                                              if (snapshot.hasData) {
                                                return Text(
                                                  snapshot.data!,
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w400,
                                                    color: AppColors.white,
                                                  ),
                                                );
                                              } else {
                                                return const Text(
                                                  "-",
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                    color: AppColors.white,
                                                  ),
                                                );
                                              }
                                            }
                                          },
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 15),
                            Container(
                              width: 400,
                              decoration: const BoxDecoration(
                                color: AppColors.white,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20),
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  top: 10,
                                  left: 24,
                                  right: 24,
                                ),
                                child: Column(
                                  children: [
                                    const Text(
                                      'Live Attendance',
                                      style: TextStyle(
                                        color: AppColors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      formattedTime,
                                      style: const TextStyle(
                                          color: Color(0xff4266B9),
                                          fontSize: 32,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      hariIni?.attDate ?? '-',
                                      style: const TextStyle(
                                        color: Color(0xff5D5D5D),
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Image.asset('assets/images/Line.png'),
                                    const SizedBox(height: 10),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Column(
                                          children: [
                                            Text(
                                              hariIni?.clockTime ?? '-',
                                              style: const TextStyle(
                                                  color: AppColors.black,
                                                  fontSize: 26,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            const Text(
                                              "Masuk",
                                              style: TextStyle(
                                                color: AppColors.black,
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Column(
                                          children: [
                                            Text(
                                              hariIni?.clockTimeOut ?? '-',
                                              style: const TextStyle(
                                                color: AppColors.black,
                                                fontSize: 26,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const Text(
                                              "Pulang",
                                              style: TextStyle(
                                                color: AppColors.black,
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 20),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width,
                                      height: 47,
                                      child: TextButton(
                                        style: TextButton.styleFrom(
                                          backgroundColor:
                                              const Color(0xff537FE7),
                                        ),
                                        onPressed: () {
                                          Navigator.of(context)
                                              .push(MaterialPageRoute(
                                                  builder: (context) =>
                                                      const SimpanPage()))
                                              .then(
                                                (value) {},
                                              );
                                        },
                                        child: const Text(
                                          'ABSENSI IN/OUT',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 35),
                                  ],
                                ),
                              ),
                            ),
                            const Text(
                              "Attendance History",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Expanded(
                              child: ListView.builder(
                                itemCount: riwayat.length,
                                itemBuilder: (context, index) => Card(
                                  child: ListTile(
                                    leading: Text(
                                      riwayat[index].attDate,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    title: Row(
                                      children: [
                                        Column(
                                          children: [
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                              riwayat[index].clockTime,
                                              style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            const Text(
                                              "Masuk",
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(width: 20),
                                        Column(
                                          children: [
                                            Text(
                                              riwayat[index].clockTimeOut,
                                              style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            const Text(
                                              "Pulang",
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              }
            },
          ),
          // floatingActionButton: FloatingActionButton(
          //   onPressed: () {
          //     Navigator.of(context)
          //         .push(MaterialPageRoute(
          //             builder: (context) => const SimpanPage()))
          //         .then(
          //       (value) {
          //         setState(() {});
          //       },
          //     );
          //   },
          //   child: const Icon(Icons.add),
          // ),
        );
      },
    );
  }
}
