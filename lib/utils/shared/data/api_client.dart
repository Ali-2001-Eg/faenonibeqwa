import 'dart:convert';
import 'package:faenonibeqwa/utils/base/constants.dart';
import 'package:http/http.dart' as http;

class ApiClient {
  //Auth token we will use to generate a meeting and connect to it
  static const String token = AppConstants.videosdkToken;

// API call to create meeting
  static Future<String> createMeeting() async {
    final http.Response httpResponse = await http.post(
      Uri.parse(AppConstants.videosdkBaseUrl),
      headers: {'Authorization': token},
    );
    if (httpResponse.statusCode != 200) {
      throw Exception(json.decode(httpResponse.body)["error"]);
    } else {
      return json.decode(httpResponse.body)['roomId'];
    }
  }
}
