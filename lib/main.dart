import 'package:flutter/material.dart';

import 'pages/home_page.dart';
import 'pages/cleaning.dart';
import 'pages/catering.dart';
import 'pages/contacts.dart';
import 'pages/more_page.dart';
import 'components/navigation_bar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.green,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      themeMode: ThemeMode.dark,

      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return NavBar(
      pages: [
        HomePage(),
        CleaningPage(),
        CateringPage(),
        ProgramPage(),
        MorePage(),
      ],
      titles: const ['Home', 'Cleaning', 'Catering', 'Contacts', 'More'],
      actions: [
        [
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: IconButton(
              icon: Icon(Icons.add),
              onPressed: HomePage.doSomething,
            ),
          ),
        ], // Home
        [], // Cleaning
        [], // Catering
        [], // Program
        [], // More
      ],
    );
  }
}
