import 'package:PhotoES/PhotoClient.dart';
import 'package:PhotoES/Utility.dart';
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
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,), 
        itemBuilder: (context, idx) {
          return InkWell (
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => ChangeNotifierProvider.value(
                  value: state,
                  child: PhotosPage(id: state.albums[idx].id),
                ),
              ));
            },
            child: Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
              clipBehavior: Clip.antiAliasWithSaveLayer,
              color: Colors.lightBlueAccent,
              child: Column( 
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[

                  Container(
                    child: Image.network(
                      "${state.albums[idx].coverPhotoBaseUrl}=w200-h150-c", 
                      fit: BoxFit.fitWidth,),
                  ),

                  Expanded(
                    child: Center(
                      child: Column(
                        children: <Widget> [
                          SizedBox(height: 8.0),
                          Text(
                            state.albums[idx].title,
                            style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold
                            ),),
                        ]
                      ),
                    ),
                  ),

                ],
              ),
              elevation: 3.0,
              margin: EdgeInsets.all(5.0),
            ),
          );
        }
      )
    );
  }
  
}



class PhotosPage extends StatefulWidget {
  final String id;

  const PhotosPage( {Key key, this.id}) : super(key: key);

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
      }
    );
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
      }
    );
  }
}

// class PhotoWidget extends StatelessWidget {
//   final String url;

//   const PhotoWidget({Key key, this.url}): super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: 250,
//       decoration: BoxDecoration(
//         image: DecorationImage(
//         image: NetworkImage(url),
//         fit: BoxFit.cover
//         ),
//       )
//     );
//   }
// }

// class MyHomePage extends StatefulWidget {
//   MyHomePage({Key key, this.title}) : super(key: key);

//   // This widget is the home page of your application. It is stateful, meaning
//   // that it has a State object (defined below) that contains fields that affect
//   // how it looks.

//   // This class is the configuration for the state. It holds the values (in this
//   // case the title) provided by the parent (in this case the App widget) and
//   // used by the build method of the State. Fields in a Widget subclass are
//   // always marked "final".

//   final String title;

//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   int _counter = 0;

//   void _incrementCounter() {
//     setState(() {
//       // This call to setState tells the Flutter framework that something has
//       // changed in this State, which causes it to rerun the build method below
//       // so that the display can reflect the updated values. If we changed
//       // _counter without calling setState(), then the build method would not be
//       // called again, and so nothing would appear to happen.
//       _counter++;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     // This method is rerun every time setState is called, for instance as done
//     // by the _incrementCounter method above.
//     //
//     // The Flutter framework has been optimized to make rerunning build methods
//     // fast, so that you can just rebuild anything that needs updating rather
//     // than having to individually change instances of widgets.
//     return Scaffold(
//       appBar: AppBar(
//         // Here we take the value from the MyHomePage object that was created by
//         // the App.build method, and use it to set our appbar title.
//         title: Text(widget.title),
//       ),
//       body: Center(
//         // Center is a layout widget. It takes a single child and positions it
//         // in the middle of the parent.
//         child: Column(
//           // Column is also a layout widget. It takes a list of children and
//           // arranges them vertically. By default, it sizes itself to fit its
//           // children horizontally, and tries to be as tall as its parent.
//           //
//           // Invoke "debug painting" (press "p" in the console, choose the
//           // "Toggle Debug Paint" action from the Flutter Inspector in Android
//           // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
//           // to see the wireframe for each widget.
//           //
//           // Column has various properties to control how it sizes itself and
//           // how it positions its children. Here we use mainAxisAlignment to
//           // center the children vertically; the main axis here is the vertical
//           // axis because Columns are vertical (the cross axis would be
//           // horizontal).
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             Text(
//               'You have pushed the button this many times:',
//             ),
//             Text(
//               '$_counter',
//               style: Theme.of(context).textTheme.headline4,
//             ),
//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: _incrementCounter,
//         tooltip: 'Increment',
//         child: Icon(Icons.add),
//       ), // This trailing comma makes auto-formatting nicer for build methods.
//     );
//   }
// }
