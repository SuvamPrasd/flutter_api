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

class _ApiFlutterState extends State<ApiFlutter> {
  Future<Album> futureAlbum;
  Future<Nasa> futureResult;

  @override
  void initState() {
    super.initState();
    futureAlbum = fetchAlbum();
    futureResult = fetchData();
    print(futureResult);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Flutte Api'),
        ),
        body: FutureBuilder<Nasa>(
          future: futureResult,
          builder: (ctx, snapshot) {
            if (snapshot.hasData) {
              return Text(snapshot.data.title);
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }

            // By default, show a loading spinner.
            return CircularProgressIndicator();
          },
        ));
  }
}

Future<Album> fetchAlbum() async {
  const BASE_URL =
      "https://api.nasa.gov/planetary/apod?api_key=gKLuukaxhBSWbNFPeeR7UcLC84ptiIPxWvScNJ2S";
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
      "https://api.nasa.gov/planetary/apod?api_key=gKLuukaxhBSWbNFPeeR7UcLC84ptiIPxWvScNJ2S";
  final response = await http.get(BASE_URL);
  if (response.statusCode == 200) {
    return nasa.fetchNasa(json.decode(response.body));
  } else {
    throw Exception('Failed to load');
  }
}
