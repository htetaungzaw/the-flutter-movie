import 'package:flutter/material.dart';
import 'package:flutter_movie/screens/home.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'The Flutter Movie App',
      home: HomeScreen(),
    );
  }
}
