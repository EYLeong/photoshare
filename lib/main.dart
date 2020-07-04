import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

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
    'email',
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
  }

  @override
  Widget build(BuildContext context) {
    if (_currentUser == null) {
      return RaisedButton(
        onPressed: _handleSignIn,
        child: Text("Sign in"),
      );
    } else {
      return RaisedButton(
        onPressed: _handleSignOut,
        child: Text("Sign Out"),
      );
    }
  }
}
