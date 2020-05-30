import 'package:flutter/material.dart';

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
