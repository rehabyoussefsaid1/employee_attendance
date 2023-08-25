import 'dart:convert';

import 'package:employee_attendance/models/CheckLocationModel.dart';
import 'package:employee_attendance/services/user-services.dart';

import '../constants/SharedPreferences.dart';
import '../constants/constants.dart';
import '../models/Assignment.dart';
import '../models/api-response.dart';
import 'package:http/http.dart' as http;

//get Assignment
Future<ApiResponse> getAssignments(int id_employee) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    Map<String, dynamic> requestBody;
    requestBody = {
      'id_employee': id_employee.toString(),
    };
    final response = await http.post(
      Uri.parse(assignmentURL),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: requestBody,
    );

    switch (response.statusCode) {
      case 200:
        List<dynamic> data = jsonDecode(response.body)['assignments'];
        List<Assignment> assignments =
            data.map((e) => Assignment.fromJson(e)).toList();
        apiResponse.data = assignments;
        break;
      case 401:
        apiResponse.error = unauthorized;
        break;
      default:
        apiResponse.error = somethingWentWrong;
        break;
    }
  } catch (e) {
    print(e);

    apiResponse.error = serverError;
  }
  return apiResponse;
}

//get Assignment
Future<ApiResponse> checkLocation() async {
   String token = await getToken();
  ApiResponse apiResponse = ApiResponse();
  try {
    final response = await http.post(Uri.parse(checkLocationURL),
         headers: {'Content-Type': 'application/json',  'Authorization': 'Bearer $token',},
        body: '''{"Username":null,"Password":null,"UserId":"44a7ce18-fa21-4bff-a8dc-faf772a1a05b","AttandanceTypeId":0,"Y":42.7288974,"X":18.3025469,"AtandDate":"2023-07-08T08:06:35.29246+02:00","Image":null,"MonitoringFingerprintID":null,"EmployeeID":null,"DeviceInfo":null}''');
    
    switch (response.statusCode) {
      case 200:
        print("LOgin 200");
        apiResponse.data = CheckLocationModel.fromJson(jsonDecode(response.body));
        print(response.body);

        break;
      case 422:
        print(" Login 422");
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