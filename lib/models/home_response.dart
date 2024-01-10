import 'dart:convert';

HomeResponseModel homeResponseModelFromJson(String str) => HomeResponseModel.fromJson(json.decode(str));

String homeResponseModelToJson(HomeResponseModel data) => json.encode(data.toJson());

class HomeResponseModel {
    final bool error;
    final List<Datum> data;
    final String errMsg;
    final List<dynamic> errParam;

    HomeResponseModel({
        required this.error,
        required this.data,
        required this.errMsg,
        required this.errParam,
    });

    factory HomeResponseModel.fromJson(Map<String, dynamic> json) => HomeResponseModel(
        error: json["Error"],
        data: List<Datum>.from(json["Data"].map((x) => Datum.fromJson(x))),
        errMsg: json["ErrMsg"],
        errParam: List<dynamic>.from(json["ErrParam"].map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "Error": error,
        "Data": List<dynamic>.from(data.map((x) => x.toJson())),
        "ErrMsg": errMsg,
        "ErrParam": List<dynamic>.from(errParam.map((x) => x)),
    };
}

class Datum {
    final String attDate;
    final String clockTime;
    final String clockTimeOut;
    final String status;
    final String suhu;
    final String satuan;
    final String useMask;
    final String workTime;

    Datum({
        required this.attDate,
        required this.clockTime,
        required this.clockTimeOut,
        required this.status,
        required this.suhu,
        required this.satuan,
        required this.useMask,
        required this.workTime,
    });

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        attDate: json["AttDate"],
        clockTime: json["ClockTime"],
        clockTimeOut: json["ClockTimeOut"],
        status: json["Status"],
        suhu: json["Suhu"],
        satuan: json["Satuan"],
        useMask: json["UseMask"],
        workTime: json["WorkTime"],
    );

    Map<String, dynamic> toJson() => {
        "AttDate": attDate,
        "ClockTime": clockTime,
        "ClockTimeOut": clockTimeOut,
        "Status": status,
        "Suhu": suhu,
        "Satuan": satuan,
        "UseMask": useMask,
        "WorkTime": workTime,
    };
}