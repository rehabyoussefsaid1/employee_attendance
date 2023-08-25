import 'dart:convert';
import 'dart:io';

import 'package:employee_attendance/constants/constants.dart';
import 'package:employee_attendance/models/User.dart';
import 'package:employee_attendance/models/api-response.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/SharedPreferences.dart';



Future<ApiResponse> login(String username, String password) async {
  // Get the current date and time
  DateTime now = DateTime.now();
String formattedDateTime = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);

  final SharedPreferences prefs = await SharedPreferences.getInstance();
  ApiResponse apiResponse = ApiResponse();
  try {
    final response = await http.post(
      Uri.parse(loginURL),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "Username": "2498266291", // Use the provided username argument
        "Password": "Bb123456", // Use the provided password argument
        "UserId": "", // Use the UserId from SharedPreferences
        "AttandanceTypeId": 0,
        "Y": 0.0,
        "X": 0.0,
        "AtandDate": "0001-01-01T00:00:00", //formattedDateTime
        "Image": null,
        "MonitoringFingerprintID": null,
        "EmployeeID": null,
        "DeviceInfo": {
          "deviceModel": "ANY-NX1",
          "manufacturer": "HONOR",
          "deviceName": "ANY-NX1",
          "version": "11",
          "platform": "Android",
          "idiom":  "Phone",
          "DeviceID": "9f8a73ee5d1aa4f4",
          "FirebaseToken": "dCYiOQXwRs-Gk1Pm7sgsUd:APA91bHPI6Y_JzQ5RfotQE9B5YTD5-9JJO71Ka0i5GwULka_X4JjwS9VBQjZHic204T56F6c2QErFSBff4LSpVDF4SH5J8pd6DqxuEqXPu7rYfgXW5pi2K1RNylYVppjEQ_9vrio_sxN"
        },
      }),
    );
    print(jsonEncode({
        "Username": "2498266291", // Use the provided username argument
        "Password": "Bb123456", // Use the provided password argument
        "UserId": prefs.getString('UserId'), // Use the UserId from SharedPreferences
        "AttandanceTypeId": 0,
        "Y": 0.0,
        "X": 0.0,
        "AtandDate": "0001-01-01T00:00:00",
        "Image": null,
        "MonitoringFingerprintID": null,
        "EmployeeID": null,
        "DeviceInfo": {
          "deviceModel": prefs.getString('devicemodel'),
          "manufacturer": prefs.getString('manufacturer'),
          "deviceName": prefs.getString('devicename'),
          "version": prefs.getString('versionrelease'),
          "platform": prefs.getString('platform'),
          "idiom":  prefs.getString('idiom'),
          "DeviceID": prefs.getString('deviceid'),
          "FirebaseToken": "dCYiOQXwRs-Gk1Pm7sgsUd:APA91bHPI6Y_JzQ5RfotQE9B5YTD5-9JJO71Ka0i5GwULka_X4JjwS9VBQjZHic204T56F6c2QErFSBff4LSpVDF4SH5J8pd6DqxuEqXPu7rYfgXW5pi2K1RNylYVppjEQ_9vrio_sxN"
        },
      }),);
    switch (response.statusCode) {
      case 200:
        print("Login 200");
        apiResponse.data = User.fromJson(jsonDecode(response.body));
        print(response.body);
        break;
      case 422:
        print("Login 422");
        final errors = jsonDecode(response.body)['errors'];
        apiResponse.error = errors[errors.keys.elementAt(0)][0];
        break;
      case 403:
        print("Login 403");
        apiResponse.error = jsonDecode(response.body)['errors'];
        break;
      default:
        apiResponse.error = somethingWentWrong;
        break;
    }
  } catch (e) {
    apiResponse.error = serverError;
    print(e);
  }
  return apiResponse;
}

    




// Register
Future<ApiResponse> register(
    String first_name,
    String last_name,
    String cin,
    String avatar,
    String phone_number,
    DateTime birthday,
    String email,
    String password) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    final response = await http.post(Uri.parse(registerURL), headers: {
      'Accept': 'application/json'
    }, body: {
      'first_nam': first_name,
      'last_name': last_name,
      'cin': cin,
      'avatar': avatar,
      'phone_number': phone_number,
      'birthday': birthday.toString(),
      'email': email,
      'password': password,
      'password_confirmation': password
    });

    switch (response.statusCode) {
      case 200:
        apiResponse.data = User.fromJson(jsonDecode(response.body));
        break;
      case 422:
        final errors = jsonDecode(response.body)['errors'];
        apiResponse.error = errors[errors.keys.elementAt(0)][0];
        break;
      default:
        apiResponse.error = somethingWentWrong;
        break;
    }
  } catch (e) {
    apiResponse.error = serverError;
  }
  return apiResponse;
}

// User
Future<ApiResponse> getUserDetail() async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    final response = await http.get(Uri.parse(userURL), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    });

    switch (response.statusCode) {
      case 200:
        apiResponse.data = User.fromJson(jsonDecode(response.body));
        break;
      case 401:
        apiResponse.error = unauthorized;
        break;
      default:
        apiResponse.error = somethingWentWrong;
        break;
    }
  } catch (e) {
    apiResponse.error = serverError;
  }
  return apiResponse;
}

// Update user
Future<ApiResponse> updateUser(
  String first_name,
  String last_name,
  String email,
  String phone_number,
  String birthday,
  String adress,
  String image,
) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    Map<String, dynamic> requestBody;
    requestBody = {
      'first_name': first_name,
      'last_name': last_name,
      'email': email,
      'phone_number': phone_number,
      'birthday': birthday,
      'adress': adress,
      'avatar': image,
    };
    final response = await http.put(
      Uri.parse(userURL),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: requestBody,
    );

    switch (response.statusCode) {
      case 200:
        apiResponse.data = jsonDecode(response.body)['message'];
        break;
      case 401:
        apiResponse.error = unauthorized;
        break;
      default:
        print(response.body);
        apiResponse.error = somethingWentWrong;
        break;
    }
  } catch (e) {
    apiResponse.error = serverError;
  }
  return apiResponse;
}

// Update password
Future<ApiResponse> changePassword(
    String old_password, String new_password) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    Map<String, dynamic> requestBody;
    requestBody = {
      'old_password': old_password,
      'new_password': new_password,
    };
    final response = await http.post(
      Uri.parse(passwordURL),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: requestBody,
    );

    switch (response.statusCode) {
      case 200:
        apiResponse.data = jsonDecode(response.body)['message'];
        break;
      case 401:
        apiResponse.error = jsonDecode(response.body)['message'];
        break;
      case 422:
        apiResponse.error = jsonDecode(response.body)['message'];
        break;
      default:
        print(response.body);
        apiResponse.error = somethingWentWrong;
        break;
    }
  } catch (e) {
    apiResponse.error = serverError;
  }
  return apiResponse;
}

//send OTP
Future<ApiResponse> sendOtp(String email) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    final response = await http.post(
      Uri.parse(sendOtpURL),
      headers: {
        'Accept': 'application/json',
      },
      body: {'email': email},
    );

    switch (response.statusCode) {
      case 200:
        apiResponse.data = jsonDecode(response.body)['message'];
        break;
      case 401:
        apiResponse.error = jsonDecode(response.body)['message'];
        break;
      case 422:
        apiResponse.error = jsonDecode(response.body)['message'];
        break;
      default:
        print(response.body);
        apiResponse.error = somethingWentWrong;
        break;
    }
  } catch (e) {
    // Network or server error
    apiResponse.error = 'Server error';
  }

  return apiResponse;
}

//Verify OTP code
Future<ApiResponse> verifyOtp(String email, String otp) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    final response = await http.post(
      Uri.parse(verifyOtpURL),
      headers: {
        'Accept': 'application/json',
      },
      body: {'email': email, 'otp_code': otp},
    );

    switch (response.statusCode) {
      case 200:
        apiResponse.data = jsonDecode(response.body)['message'];
        break;
      case 401:
        apiResponse.error = jsonDecode(response.body)['message'];
        break;
      case 422:
        apiResponse.error = jsonDecode(response.body)['message'];
        break;
      default:
        print(response.body);
        apiResponse.error = somethingWentWrong;
        break;
    }
  } catch (e) {
    // Network or server error
    apiResponse.error = 'Server error';
  }

  return apiResponse;
}



// Get base64 encoded image
String? getStringImage(File? file) {
  if (file == null) return null;
  return base64Encode(file.readAsBytesSync());
}

//change password 2
Future<ApiResponse> changePass(String email, String password) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    final response = await http.post(
      Uri.parse(passwordURL2),
      headers: {
        'Accept': 'application/json',
      },
      body: {'email': email, 'new_password': password},
    );

    switch (response.statusCode) {
      case 200:
        apiResponse.data = jsonDecode(response.body)['message'];
        break;
      case 401:
        apiResponse.error = jsonDecode(response.body)['message'];
        break;
      case 422:
        apiResponse.error = jsonDecode(response.body)['message'];
        break;
      default:
        print(response.body);
        apiResponse.error = somethingWentWrong;
        break;
    }
  } catch (e) {
    // Network or server error
    apiResponse.error = 'Server error';
  }

  return apiResponse;
}
