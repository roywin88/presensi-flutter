import 'dart:convert';

LoginResponseModel loginResponseModelFromJson(String str) =>
    LoginResponseModel.fromJson(json.decode(str));

String loginResponseModelToJson(LoginResponseModel data) =>
    json.encode(data.toJson());

class LoginResponseModel {
  final bool error;
  final Data data;
  final String errMsg;
  final List<dynamic> errParam;

  LoginResponseModel({
    required this.error,
    required this.data,
    required this.errMsg,
    required this.errParam
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) =>
      LoginResponseModel(
        error: json["Error"],
        data: Data.fromJson(json["Data"]),
        errMsg: json["ErrMsg"],
        errParam: List<dynamic>.from(json["ErrParam"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "Error": error,
        "Data": data.toJson(),
        "ErrMsg": errMsg,
        "ErrParam": List<dynamic>.from(errParam.map((x) => x)),
      };
}

class Data {
  final String userID;
    final String userEmail;
    final String userName;
    final String userPassword;
    final String userFingerID;
    final String token;
    final String noKtp;
    final String location;
    final String gender;
    final String job;
    final String dept;
    final String fungsi;
    final String fotoProfile;

  Data({
    required this.userID,
    required this.userEmail,
    required this.userName,
    required this.userPassword,
    required this.userFingerID,
    required this.token,
    required this.noKtp,
    required this.location,
    required this.gender,
    required this.job,
    required this.dept,
    required this.fungsi,
    required this.fotoProfile,
  });

  

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        userID: json["UserID"],
        userEmail: json["UserEmail"],
        userName: json["UserName"],
        userPassword: json["UserPassword"],
        userFingerID: json["UserFingerID"],
        token: json["Token"],
        noKtp: json["NoKtp"],
        location: json["Location"],
        gender: json["Gender"],
        job: json["Job"],
        dept: json["Dept"],
        fungsi: json["Fungsi"],
        fotoProfile: json["FotoProfile"],
      );

  Map<String, dynamic> toJson() => {
        "UserID": userID,
        "UserEmail": userEmail,
        "UserName": userName,
        "UserPassword": userPassword,
        "UserFingerID": userFingerID,
        "Token": token,
        "NoKtp": noKtp,
        "Location": location,
        "Gender": gender,
        "Job": job,
        "Dept": dept,
        "Fungsi": fungsi,
        "FotoProfile": fotoProfile,
      };
}
