import 'package:photoshare/PhotoClient.dart';
import 'package:photoshare/Utility.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.yellow,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),

      // Log into the application
      home: ChangeNotifierProvider(
        create: (_) => Utility(),
        child: LoginPage(),
      ),
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Create a button widget for Google sign in
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<Utility>(
        builder: (context, state, child) {
          // User is NOT logged in
          if (!state.isLoggedIn()) {
            return Center(
              child: RaisedButton(
                child: Text('Sign In with Google'),
                // On press: call the signIn function to authenticate the user
                onPressed: () {
                  state.signIn();
                },
              ),
            );
            // User is logged in
          } else {
            if (MediaQuery.of(context).orientation == Orientation.portrait) {
              return _albumGrid(state);
              // return _albumList(state);
            } else {
              return _albumGrid(state);
            }
          }
        },
      ),
    );
  }

  // Display the albums in a list format
  Widget _albumList(Utility state) {
    return SafeArea(
      child: ListView.builder(
        itemCount: state.albums.length,
        itemBuilder: (context, idx) {
          return ListTile(
            title: Text(state.albums[idx].title),
            // State the width and height of the photo
            leading: Image.network(
              "${state.albums[idx].coverPhotoBaseUrl}=w50-h50-c",
            ),
            // On tap: opens the album
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => ChangeNotifierProvider.value(
                  value: state,
                  child: PhotosPage(id: state.albums[idx].id),
                ),
              ));
            },
          );
        },
      ),
    );
  }

  // Display the albums in a gridview format
  Widget _albumGrid(Utility state) {
    return SafeArea(
        child: GridView.builder(
            itemCount: state.albums.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
            ),
            itemBuilder: (context, idx) {
              return InkWell(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => ChangeNotifierProvider.value(
                      value: state,
                      child: PhotosPage(id: state.albums[idx].id),
                    ),
                  ));
                },
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  color: Colors.lightBlueAccent,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        child: Image.network(
                          "${state.albums[idx].coverPhotoBaseUrl}=w200-h150-c",
                          fit: BoxFit.fitWidth,
                        ),
                      ),
                      Expanded(
                        child: Center(
                          child: Column(children: <Widget>[
                            SizedBox(height: 8.0),
                            Text(
                              state.albums[idx].title,
                              style: TextStyle(
                                  fontSize: 20.0, fontWeight: FontWeight.bold),
                            ),
                          ]),
                        ),
                      ),
                    ],
                  ),
                  elevation: 3.0,
                  margin: EdgeInsets.all(5.0),
                ),
              );
            }));
  }
}

class PhotosPage extends StatefulWidget {
  final String id;

  const PhotosPage({Key key, this.id}) : super(key: key);

  @override
  _PhotosPageState createState() => _PhotosPageState();
}

class _PhotosPageState extends State<PhotosPage> {
  PageController _pageController;
  int totalPages = 0;

  // @override
  // void initState() {
  //   _pageController = PageController(
  //     viewportFraction: 0.6,
  //   );
  // }

  // Load the photo within the album
  @override
  Widget build(BuildContext context) {
    var state = Provider.of<Utility>(context);
    print(state.user.displayName);
    return FutureBuilder(
        future: state.getPhotos(widget.id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return _buildPhotoFrame(snapshot.data);
          }

          return Center(
            child: CircularProgressIndicator(),
          );
        });
  }

  // How the photo is being displayed
  Widget _buildPhotoFrame(List<Photo> data) {
    totalPages = data.length;
    return PageView.builder(
        controller: _pageController,
        itemCount: data.length,
        itemBuilder: (context, idx) {
          return Image.network(data[idx].baseUrl);
          // return PhotoWidget(
          //   url: data[idx].baseUrl,
          // );
        });
  }
}
