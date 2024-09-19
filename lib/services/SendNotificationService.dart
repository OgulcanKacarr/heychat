import 'dart:convert';
import 'package:heychat/constants/AppStrings.dart';
import 'package:http/http.dart' as http;

Future<void> sendNotificationService({
  required String target,
  required String message,
  required String title,
  required String targetPage,
  required String receiverId,
}) async {
  const url = 'https://onesignal.com/api/v1/notifications';

  final headers = {
    'Content-Type': 'application/json; charset=utf-8',
    'Authorization': 'Basic ${AppStrings.apiKey}',
  };

  final body = json.encode({
    'app_id': AppStrings.appId,
    'filters': [
      {'field': 'tag', 'key': 'userId', 'relation': '=', 'value': target}, // userId'ye göre hedefleme
    ],
    'headings': {'en': title},
    'contents': {'en': message},
    'data': {'targetPage': targetPage, 'receiverId': receiverId},
  });


  final response = await http.post(Uri.parse(url), headers: headers, body: body);

  if (response.statusCode == 200) {
    print('Bildirim gönderildi: ${response.body}');
  } else {
    print('Bildirim gönderilemedi: ${response.statusCode} ${response.body}');
  }
}
