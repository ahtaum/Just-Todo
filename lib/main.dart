import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'tab_route.dart';
import 'package:todo/config/data.dart';

void main() async {
  await Supabase.initialize(
    url: supabaseUrl, 
    anonKey: supabaseKey
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tab Example',
      theme: ThemeData(primarySwatch: Colors.red),
      home: TabRoute(),
    );
  }
}
