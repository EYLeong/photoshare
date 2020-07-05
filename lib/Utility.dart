import 'package:photoshare/PhotoClient.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Utility extends ChangeNotifier {
  GoogleSignInAccount _user;

  final GoogleSignIn _signIn = GoogleSignIn(scopes: [
    'profile',
    'https://www.googleapis.com/auth/photoslibrary.readonly'
  ]);

  GoogleSignInAccount get user => _user;
  List<Album> get albums => _albums;

  PhotoClient _client;
  List<Album> _albums;

  Utility() {
    _signIn.onCurrentUserChanged.listen((GoogleSignInAccount account) {
      _user = account;
      if (_user != null) {
        _updateAlbums();
      }
    });
  }

  // Check if the user is logged in
  bool isLoggedIn() {
    return _user != null;
  }

  // Authenticate the sign in using Google sign in function
  void signIn() async {
    _user = await _signIn.signIn();

    if (_user != null) {
      // authHeaders, containing the current `authentication.accessToken`
      _client = PhotoClient(_user.authHeaders);
      await _updateAlbums();
    } else {
      notifyListeners();
    }
  }

  // Retrieve the album from Google Photos
  _updateAlbums() async {
    _albums = await _client.getAlbums();
    notifyListeners();
  }

  // Retrieve the photos from the album
  Future<List<Photo>> getPhotos(String albumID) async {
    return _client.getPhotos(albumID);
  }
}
