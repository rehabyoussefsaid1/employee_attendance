// To parse this JSON data, do
//
//     final checkLocationModel = checkLocationModelFromJson(jsonString);

import 'dart:convert';

CheckLocationModel checkLocationModelFromJson(String str) => CheckLocationModel.fromJson(json.decode(str));

String checkLocationModelToJson(CheckLocationModel data) => json.encode(data.toJson());

class CheckLocationModel {
    int statusCode;
    bool data;
    String msg;

    CheckLocationModel({
        required this.statusCode,
        required this.data,
        required this.msg,
    });

    factory CheckLocationModel.fromJson(Map<String, dynamic> json) => CheckLocationModel(
        statusCode: json["statusCode"],
        data: json["data"],
        msg: json["msg"],
    );

    Map<String, dynamic> toJson() => {
        "statusCode": statusCode,
        "data": data,
        "msg": msg,
    };
}
