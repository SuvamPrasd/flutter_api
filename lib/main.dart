import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import './models/album.dart';
import './models/nasa.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter_api',
      home: ApiFlutter(),
    );
  }
}

class ApiFlutter extends StatefulWidget {
  @override
  _ApiFlutterState createState() => _ApiFlutterState();
}

class _ApiFlutterState extends State<ApiFlutter> with TickerProviderStateMixin {
  Future<Album> futureAlbum;
  Future<Nasa> futureResult;
  AnimationController _controller;
  Animatable<Color> background = TweenSequence<Color>(
    [
      TweenSequenceItem(
        weight: 1.0,
        tween: ColorTween(
          begin: Colors.red,
          end: Colors.green,
        ),
      ),
      TweenSequenceItem(
        weight: 1.0,
        tween: ColorTween(
          begin: Colors.green,
          end: Colors.blue,
        ),
      ),
      TweenSequenceItem(
        weight: 1.0,
        tween: ColorTween(
          begin: Colors.blue,
          end: Colors.pink,
        ),
      ),
    ],
  );

  @override
  void initState() {
    super.initState();
    futureAlbum = fetchAlbum();
    futureResult = fetchData();
    _controller = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    )..repeat();
    print(futureResult);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: _controller,
        builder: (ctx, builder) {
          return Scaffold(
              backgroundColor: Colors.black,
              appBar: AppBar(
                title: Text(
                  'Flutte API',
                  style: TextStyle(
                    fontWeight: FontWeight.w300,
                    letterSpacing: 1,
                  ),
                ),
                centerTitle: true,
                backgroundColor: Colors.black,
              ),
              body: FutureBuilder<Nasa>(
                future: futureResult,
                builder: (ctx, snapshot) {
                  if (snapshot.hasData) {
                    return SingleChildScrollView(
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 10,
                        ),
                        color: Colors.black,
                        child: Card(
                          color: background.evaluate(
                              AlwaysStoppedAnimation(_controller.value)),
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              children: <Widget>[
                                Text(
                                  snapshot.data.title,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 30,
                                  ),
                                ),
                                SizedBox(
                                  height: 12,
                                ),
                                Image.network(
                                  snapshot.data.imageUrl,
                                  fit: BoxFit.cover,
                                  loadingBuilder: (ctx, child, loadingProgrss) {
                                    if (loadingProgrss == null) {
                                      return child;
                                    }
                                    return LinearProgressIndicator(
                                      backgroundColor: Colors.white,
                                      valueColor:
                                          AlwaysStoppedAnimation(Colors.black),
                                      value: loadingProgrss
                                                  .expectedTotalBytes !=
                                              null
                                          ? loadingProgrss
                                                  .cumulativeBytesLoaded /
                                              loadingProgrss.expectedTotalBytes
                                          : null,
                                    );
                                  },
                                ),
                                SizedBox(
                                  height: 12,
                                ),
                                Text(
                                  snapshot.data.content,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w300,
                                    letterSpacing: 0.4,
                                    height: 1.5,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(
                                  height: 12,
                                ),
                                OutlineButton.icon(
                                    onPressed: () {
                                      if (_controller.isAnimating) {
                                        _controller.stop();
                                      } else {
                                        _controller.repeat();
                                      }
                                    },
                                    icon: Icon(Icons.stop),
                                    label: Text('Stop Animation')),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Text("${snapshot.error}");
                  }

                  // By default, show a loading spinner.
                  return Center(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      CircularProgressIndicator(
                        backgroundColor: Colors.white,
                        valueColor: AlwaysStoppedAnimation(Colors.black),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Loading...',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ));
                },
              ));
        });
  }
}

Future<Album> fetchAlbum() async {
  const BASE_URL =
      "https://api.nasa.gov/planetary/apod?api_key=API-KEY";
  final response =
      await http.get('https://jsonplaceholder.typicode.com/albums/1');

  if (response.statusCode == 200) {
    return Album.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to load album');
  }
}

Future<Nasa> fetchData() async {
  final nasa = Nasa();
  const BASE_URL =
      "https://api.nasa.gov/planetary/apod?api_key=API-KEY";
  final response = await http.get(BASE_URL);
  if (response.statusCode == 200) {
    return nasa.fetchNasa(json.decode(response.body));
  } else {
    throw Exception('Failed to load');
  }
}
