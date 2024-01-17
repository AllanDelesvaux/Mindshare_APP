import 'package:flutter/material.dart';
import 'package:mindshare_ai/screens/homePage.dart';
import 'package:mindshare_ai/screens/profilePage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/profile': (context) => ProfilePage(account: 1),
      },

      title: 'Mindshare AI',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}