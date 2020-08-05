import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photoshare/drive_api/drive_api.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreenWidget(),
    );
  }
}

class HomeScreenWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Hello World!"),
        centerTitle: true,
      ),
      body: GoogleSignInWidget(),
    );
  }
}

GoogleSignIn _googleSignIn = GoogleSignIn(
  scopes: <String>[
    'https://www.googleapis.com/auth/drive.appdata',
    'https://www.googleapis.com/auth/drive.file',
    'https://www.googleapis.com/auth/drive.install'
  ],
);

class GoogleSignInWidget extends StatefulWidget {
  @override
  _GoogleSignInWidgetState createState() => _GoogleSignInWidgetState();
}

class _GoogleSignInWidgetState extends State<GoogleSignInWidget> {
  GoogleSignInAccount _currentUser;
  File _image;
  final picker = ImagePicker();

  Future<void> _handleSignIn() async {
    try {
      await _googleSignIn.signIn();
    } catch (error) {
      print(error);
    }
  }

  Future<void> _handleSignOut() => _googleSignIn.disconnect();

  Future<void> _getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      _image = File(pickedFile.path);
    });
    uploadFile(_image, _currentUser.authHeaders);
  }

  @override
  void initState() {
    super.initState();
    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount account) {
      setState(() {
        _currentUser = account;
      });
    });
    _googleSignIn.signInSilently();
  }

  @override
  Widget build(BuildContext context) {
    if (_currentUser == null) {
      return RaisedButton(
        onPressed: _handleSignIn,
        child: Text("Sign in"),
      );
    } else {
      return Column(
        children: <Widget>[
          Text("Signed in as ${_currentUser.displayName}"),
          RaisedButton(
            child: Text("Pick Image"),
            onPressed: _getImage,
          ),
          RaisedButton(
            onPressed: _handleSignOut,
            child: Text("Sign Out"),
          ),
          _image == null ? Text("No Image Selected") : Image.file(_image),
          RaisedButton(
            onPressed: () => listFiles(_currentUser.authHeaders),
            child: Text("List Files"),
          ),
          RaisedButton(
            onPressed: () =>
                createFolder("testName", "testDesc", _currentUser.authHeaders),
            child: Text("Create Folder"),
          ),
        ],
      );
    }
  }
}
