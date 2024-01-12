import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/src/widgets/framework.dart';
import 'package:location/location.dart';
import 'package:presensi/models/save_presensi_response.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_maps/maps.dart';
import 'package:http/http.dart' as http;

class SimpanPage extends StatefulWidget {
  const SimpanPage({super.key});

  @override
  State<SimpanPage> createState() => _SimpanPageState();
}

class _SimpanPageState extends State<SimpanPage> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  late Future<String> _token, _cookie;

  @override
  void initState() {
    super.initState();
    _token = _prefs.then((SharedPreferences prefs) {
      return prefs.getString("token") ?? "";
    });

    _cookie = _prefs.then((SharedPreferences prefs) {
      return prefs.getString("cookie") ?? "";
    });
  }

  Future<LocationData?> _currenctLocation() async {
    bool serviceEnable;
    PermissionStatus permissionGranted;

    Location location = Location();

    serviceEnable = await location.serviceEnabled();

    if (!serviceEnable) {
      serviceEnable = await location.requestService();
      if (!serviceEnable) {
        return null;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return null;
      }
    }

    return await location.getLocation();
  }

  Future savePresensi(latitude, longitude) async {
    SavePresensiResponseModel savePresensiResponseModel;

    List<List<String>> arrayData = [
      ['192.168.30.98	', '3.5845773', '	98.6668818', '3.716'],
      ['192.168.30.199', '3.5844896', '98.6670536', '5.999'],
      ['192.168.30.200', '3.5844907', '98.6670548', '6.775'],
      ['192.168.30.201', '3.5844953', '98.6670567', '7.292'],
      ['192.168.30.202', '3.5845246', '98.6670794', '19.086'],
      ['192.168.30.203', '3.584739', '98.6671032', '14.272'],
      ['192.168.30.204', '3.5846794', '98.6671112', '14.329'],
      ['192.168.30.205', '3.5847069', '98.6671123', '13.576'],
      ['192.168.30.206', '3.5846695', '98.6671135', '13.587'],
      ['192.168.30.207', '3.5847094', '98.6671217', '13.017'],
      ['192.168.30.208', '3.584639', '98.6671234', '13.419'],
      ['192.168.30.209', '3.5846664', '98.6671235', '12.675'],
      ['192.168.30.210', '3.5845997', '98.6671244', '14.643'],
      ['192.168.30.211', '3.5846851', '98.667125', '13.356'],
      ['192.168.30.212', '3.584609', '98.6671281', '23.487'],
      ['192.168.30.213', '3.5846015', '98.6671307', '12.892'],
      ['192.168.30.214', '3.5845929', '98.667132', '12.83'],
      ['192.168.30.215', '3.5845981', '98.6671349', '12.546'],
      ['192.168.30.216', '3.5846461', '98.667137', '12.602'],
      ['192.168.30.217', '3.5845745', '98.6671449', '14.795'],
      ['192.168.30.218', '3.5846861', '98.6671459', '19.315'],
      ['192.168.30.219', '3.5846971', '98.6671474', '18.374'],
      ['192.168.30.220', '3.5845601', '98.6671505', '13.608'],
      ['192.168.30.221', '3.5845393', '98.6671571', '12.329'],
      ['192.168.30.222', '3.5845353', '98.6671574', '23.554'],
      ['192.168.30.223', '3.5846673', '98.667175', '13.13'],
      ['192.168.30.224', '3.5845062', '98.6671788', '11.675'],
      ['192.168.30.225', '3.5846771', '98.6671794', '11.489'],
      ['192.168.30.226', '3.5846999', '98.6671809', '15.882'],
      ['192.168.30.227', '3.5845098', '98.667184', '11.481'],
      ['192.168.30.228', '3.5846017', '98.6671847', '35.514'],
      ['192.168.30.229', '3.5846775', '98.667185', '11.48'],
      ['192.168.30.230', '3.584511', '98.6671853', '13.897'],
      ['192.168.30.231', '3.5844954', '98.6671861', '13.024'],
      ['192.168.30.232', '3.5845105', '98.6671863', '12.892'],
      ['192.168.30.233', '3.5845025', '98.6671877', '11.476'],
      ['192.168.30.234', '3.5846677', '98.6671884', '11.505'],
      ['192.168.30.235', '3.5844977', '98.6671892', '23.134'],
      ['192.168.30.236', '3.5844931', '98.6671899', '11.476'],
      ['192.168.30.237', '3.5845084', '98.66719', '11.67'],
      ['192.168.30.238', '3.5844977', '98.6671901', '11.483'],
      ['192.168.30.239', '3.5844969', '98.6671909', '11.522'],
      ['192.168.30.240', '3.5845025', '98.6671911', '12.306'],
      ['192.168.30.241', '3.5845052', '98.6671911', '11.478'],
      ['192.168.30.242', '3.5845014', '98.6671914', '11.559'],
      ['192.168.30.243', '3.5846716', '98.6671916', '11.66'],
      ['192.168.30.244', '3.5846704', '98.6671917', '11.469'],
      ['192.168.30.245', '3.584504', '98.6671922', '11.487'],
      ['192.168.30.246', '3.584498', '98.6671922', '11.476'],
    ];

    List<String> getRandomRowData(List<List<String>> arrayData) {
      List<String> randomRowData = [];
      Random random = Random();
      // Mengambil satu baris secara acak
      int randomRowIndex = random.nextInt(arrayData.length);
      // Mengambil semua isi dari baris yang dipilih
      randomRowData.addAll(arrayData[randomRowIndex]);

      return randomRowData;
    }

    List<String> getData = getRandomRowData(arrayData);
    // Mendapatkan tanggal saat ini
    DateTime now = DateTime.now();
    // Format tanggal dengan format 'dd/MM/yyyy'
    String tgl = DateFormat('MM/dd/yyyy').format(now);
    String jam = DateFormat('h:mm a').format(now);
    Map<String, String> body = {
      'wfh': '0',
      'tgl': tgl,
      'jam': jam,
      'cGatewayIp': getData[0],
      'cPublicIp': '',
      'cLat': getData[1],
      'cLong': getData[2],
      'cAltitude': '26.5',
      'cAccuracy': getData[3],
    };
    // debugPrint('HASIL : ${body.toString()}');
    Map<String, String> headers = {
      "X-API-KEY": await _token,
      'cookie': await _cookie,
    };
    var response = await http.post(
        Uri.parse("http://103.169.21.106:8887/api/remoteClockIn"),
        body: body,
        headers: headers);

    savePresensiResponseModel =
        SavePresensiResponseModel.fromJson(json.decode(response.body));

    if (!savePresensiResponseModel.error) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Sukses simpan Presensi')));
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Gagal simpan Presensi')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Presensi"),
      ),
      body: FutureBuilder<LocationData?>(
          future: _currenctLocation(),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.hasData) {
              final LocationData currentLocation = snapshot.data;
              // debugPrint(
              //     'KODING : ${currentLocation.latitude.toString()} | ${currentLocation.longitude.toString()}');
              return SafeArea(
                  child: Column(
                children: [
                  SizedBox(
                    height: 300,
                    child: SfMaps(
                      layers: [
                        MapTileLayer(
                          initialFocalLatLng: MapLatLng(
                              currentLocation.latitude!,
                              currentLocation.longitude!),
                          initialZoomLevel: 15,
                          initialMarkersCount: 1,
                          urlTemplate:
                              "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                          markerBuilder: (BuildContext context, int index) {
                            return MapMarker(
                              latitude: currentLocation.latitude!,
                              longitude: currentLocation.longitude!,
                              child: const Icon(
                                Icons.location_on,
                                color: Colors.red,
                              ),
                            );
                          },
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        savePresensi(currentLocation.latitude,
                            currentLocation.longitude);
                      },
                      child: const Text("Simpan Presensi"))
                ],
              ));
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
    );
  }
}
