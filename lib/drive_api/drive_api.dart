import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

///Uploads a file to Google Drive.
Future<void> uploadFile(
    File fileToUpload, Future<Map<String, String>> authHeaders) async {
  final url =
      "https://www.googleapis.com/upload/drive/v3/files?uploadType=media";
  http.post(url,
      headers: await authHeaders, body: fileToUpload.readAsBytesSync());
}

Future<void> listFiles(Future<Map<String, String>> authHeaders) async {
  final url =
      'https://www.googleapis.com/drive/v3/files?fields=files(id,webViewLink,thumbnailLink)';
  final response = await http.get(url, headers: await authHeaders);
  print(response.body);
}

Future<void> createFolder(String name, String description,
    Future<Map<String, String>> authHeaders) async {
  final url = 'https://www.googleapis.com/drive/v3/files';
  final reqBody = {
    'name': name,
    'mimeType': 'application/vnd.google-apps.folder',
    'description': description
  };
  final reqBodyJson = jsonEncode(reqBody);
  var headers = await authHeaders;
  headers['Content-Type'] = 'application/json';
  http.post(url, headers: headers, body: reqBodyJson);
}
