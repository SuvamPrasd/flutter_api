import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import './models/album.dart';

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

  @override
  void initState() {
    futureAlbum = fetchAlbum();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutte Api'),
      ),
      body: Center(
        child: Text('Some data'),
      ),
    );
  }
}

Future<Album> fetchAlbum() async {
  final response =
      await http.get('https://jsonplaceholder.typicode.com/albums/1');

  if (response.statusCode == 200) {
    return Album.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to load album');
  }
}
