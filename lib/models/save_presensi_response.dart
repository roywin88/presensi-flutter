// To parse this JSON data, do
//
//     final savePresensiResponseModel = savePresensiResponseModelFromJson(jsonString);

import 'dart:convert';

SavePresensiResponseModel savePresensiResponseModelFromJson(String str) =>
    SavePresensiResponseModel.fromJson(json.decode(str));

String savePresensiResponseModelToJson(SavePresensiResponseModel data) =>
    json.encode(data.toJson());

class SavePresensiResponseModel {
  final bool error;
  final String data;
  final String errMsg;
  final List<dynamic> errParam;

  SavePresensiResponseModel({
    required this.error,
    required this.data,
    required this.errMsg,
    required this.errParam,
  });

  factory SavePresensiResponseModel.fromJson(Map<String, dynamic> json) =>
      SavePresensiResponseModel(
        error: json["Error"],
        data: json["Data"],
        errMsg: json["ErrMsg"],
        errParam: List<dynamic>.from(json["ErrParam"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "Error": error,
        "Data": data,
        "ErrMsg": errMsg,
        "ErrParam": List<dynamic>.from(errParam.map((x) => x)),
      };
}

// class Data {
//   Data({
//     required this.id,
//     required this.userId,
//     required this.latitude,
//     required this.longitude,
//     required this.tanggal,
//     required this.masuk,
//     required this.pulang,
//     required this.createdAt,
//     required this.updatedAt,
//   });

//   int id;
//   String userId;
//   String latitude;
//   String longitude;
//   DateTime tanggal;
//   String masuk;
//   dynamic pulang;
//   DateTime createdAt;
//   DateTime updatedAt;

//   factory Data.fromJson(Map<String, dynamic> json) => Data(
//         id: json["id"],
//         userId: json["user_id"],
//         latitude: json["latitude"],
//         longitude: json["longitude"],
//         tanggal: DateTime.parse(json["tanggal"]),
//         masuk: json["masuk"],
//         pulang: json["pulang"],
//         createdAt: DateTime.parse(json["created_at"]),
//         updatedAt: DateTime.parse(json["updated_at"]),
//       );

//   Map<String, dynamic> toJson() => {
//         "id": id,
//         "user_id": userId,
//         "latitude": latitude,
//         "longitude": longitude,
//         "tanggal":
//             "${tanggal.year.toString().padLeft(4, '0')}-${tanggal.month.toString().padLeft(2, '0')}-${tanggal.day.toString().padLeft(2, '0')}",
//         "masuk": masuk,
//         "pulang": pulang,
//         "created_at": createdAt.toIso8601String(),
//         "updated_at": updatedAt.toIso8601String(),
//       };
// }
