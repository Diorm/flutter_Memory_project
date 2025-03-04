import 'package:flutter/material.dart';
import 'package:school_management_system/Screen/Filieres/list_filieres.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: true, home: ListFilieres());
  }
}
