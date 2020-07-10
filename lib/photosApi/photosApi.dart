import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

import 'album.dart';

///Returns a list of Albums from the Google Photos API.
Future<List<Album>> listAlbums(Future<Map<String, String>> authHeaders,
    {int pageSize = 20, String pageToken = ''}) async {
  final List<Album> albumList = [];
  final String url =
      'https://photoslibrary.googleapis.com/v1/albums?pageSize=$pageSize&pageToken=$pageToken&excludeNonAppCreatedData=false';

  final Response res = await http.get(url, headers: await authHeaders);
  final Map<String, dynamic> resJson = jsonDecode(res.body);

  if (resJson["error"] != null) {
    if (resJson["error"]["status"] == "INVALID_ARGUMENT")
      throw FormatException(resJson["error"]["message"]);
    throw Exception(resJson["error"]["message"]);
  }

  if (resJson["albums"] != null) {
    resJson["albums"].forEach((albumJson) {
      albumList.add(Album.fromJson(albumJson));
    });
  }
  return albumList;
}
