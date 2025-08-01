import 'package:flutter/material.dart';
import '../components/custom_app_bar.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});
  
  static void doSomething() {
    print('Button pressed!');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Home',
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              doSomething();
            },
          ),
        ],
      ),
      body: Center(
        child: Text('Home Page'),
      ),
    );
  }
}
