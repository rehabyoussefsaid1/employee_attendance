// To parse this JSON data, do
//
//     final user = userFromJson(jsonString);

import 'dart:convert';

User userFromJson(String str) => User.fromJson(json.decode(str));

String userToJson(User data) => json.encode(data.toJson());

class User {
    int statusCode;
    Data data;
    dynamic msg;

    User({
        required this.statusCode,
        required this.data,
        this.msg,
    });

    factory User.fromJson(Map<String, dynamic> json) => User(
        statusCode: json["statusCode"],
        data: Data.fromJson(json["data"]),
        msg: json["msg"],
    );

    Map<String, dynamic> toJson() => {
        "statusCode": statusCode,
        "data": data.toJson(),
        "msg": msg ,
    };
}

class Data {
    String userId;
    String fullName;
    String email;
    String phoneNumber;
    String lastLoginDate;
    String employeeId;
    String token;
    dynamic monitoring;
    bool attEnablePicture;

    Data({
        required this.userId,
        required this.fullName,
        required this.email,
        required this.phoneNumber,
        required this.lastLoginDate,
        required this.employeeId,
        required this.token,
        this.monitoring,
        required this.attEnablePicture,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        userId: json["userID"],
        fullName: json["fullName"],
        email: json["email"],
        phoneNumber: json["phoneNumber"],
        lastLoginDate: json["lastLoginDate"],
        employeeId: json["employeeID"],
        token: json["token"],
        monitoring: json["monitoring"] ,
        attEnablePicture: json["attEnablePicture"] ,
    );

    Map<String, dynamic> toJson() => {
        "userID": userId,
        "fullName": fullName,
        "email": email,
        "phoneNumber": phoneNumber,
        "lastLoginDate": lastLoginDate,
        "employeeID": employeeId,
        "token": token,
        "monitoring": monitoring,
        "attEnablePicture": attEnablePicture,
    };
}
