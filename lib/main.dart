import 'package:flutter/material.dart';
import 'Screens/LoginPage.dart';
import 'package:provider/provider.dart';
import 'Providers/ApiProvider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ApiProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pink Ladies Poker Game',
      theme: ThemeData(
        primarySwatch: Colors.pink,
      ),
      home: const PokerApp(),
    );
  }
}

class PokerApp extends StatelessWidget {
  const PokerApp({super.key});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pink Ladies Poker Game')),
      body: Builder(builder: (context) {
        return Login();
      }),
    );
  }
}
