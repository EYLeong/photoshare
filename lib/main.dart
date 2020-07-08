import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:photoshare/photosApi/photosApi.dart' as api;

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
    'https://www.googleapis.com/auth/photoslibrary',
    'https://www.googleapis.com/auth/photoslibrary.sharing',
  ],
);

class GoogleSignInWidget extends StatefulWidget {
  @override
  _GoogleSignInWidgetState createState() => _GoogleSignInWidgetState();
}

class _GoogleSignInWidgetState extends State<GoogleSignInWidget> {
  GoogleSignInAccount _currentUser;

  Future<void> _handleSignIn() async {
    try {
      await _googleSignIn.signIn();
    } catch (error) {
      print(error);
    }
  }

  Future<void> _handleSignOut() => _googleSignIn.disconnect();

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
            onPressed: () => api.listAlbums(_currentUser.authHeaders),
          ),
          RaisedButton(
            onPressed: _handleSignOut,
            child: Text("Sign Out"),
          )
        ],
      );
    }
  }
}
