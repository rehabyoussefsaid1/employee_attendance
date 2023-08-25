import 'package:shared_preferences/shared_preferences.dart';


//get token 
Future<String> getToken() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  return pref.getString('token') ?? '';
}

// get user id
Future<int> getUserId() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  return pref.getInt('userId') ?? 0;
}

// get user name
Future<String> getUserName() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  return pref.getString('fullName') ?? "";
}

// get user email
Future<String> getUserEmail() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  return pref.getString('email') ?? "";
}

// logout
Future<bool> logout() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  return await pref.remove('token');
}

// get devicemodel
Future<String> deviceModel() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  return pref.getString('devicemodel') ?? "";
}

// get devicename
Future<String> deviceName() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  return pref.getString('devicename') ?? "";
}

// get version.release
Future<String> versionRelease() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  return pref.getString('versionrelease') ?? "";
}

// get platform
Future<String> platform() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  return pref.getString('platform') ?? "";
}

// get idiom
Future<String> idiom() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  return pref.getString('idiom') ?? "";
}

// get deviceid
Future<String> deviceid() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  return pref.getString('deviceid') ?? "";
}