import 'package:flutter/material.dart';
import 'package:kroozer/pages/Api.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
        color: Color.fromARGB(255, 85, 85, 85),
        debugShowCheckedModeBanner: false,
        home: Kroozer());
  }
}
