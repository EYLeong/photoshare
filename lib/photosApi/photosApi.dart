import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

import 'album.dart';

Future<List<Album>> listAlbums(Future<Map<String, String>> authHeaders) async {
  List<Album> albumList = [];

  const String url = 'https://photoslibrary.googleapis.com/v1/albums';

  Response res = await http.get(url, headers: await authHeaders);
  jsonDecode(res.body)["albums"].forEach((albumJson) {
    albumList.add(Album.fromJson(albumJson));
  });

  return albumList;
}
