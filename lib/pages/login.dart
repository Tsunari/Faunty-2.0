import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../entities/user_role.dart';

// Register a new user and save their role in Firestore
Future<User?> registerWithEmail(String email, String password, UserRole role) async {
  try {
    final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    // Save user role in Firestore
    await FirebaseFirestore.instance.collection('users').doc(credential.user!.uid).set({
      'email': email,
      'role': role.name,
    });
    return credential.user;
  } catch (e) {
    print('Registration error: $e');
    return null;
  }
}

// Login with email and password
Future<User?> loginWithEmail(String email, String password) async {
  try {
    final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return credential.user;
  } catch (e) {
    print('Login error: $e');
    return null;
  }
}

// Fetch user role from Firestore

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  String? _error;

  Future<void> _login() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final user = await loginWithEmail(email, password);
    setState(() {
      _isLoading = false;
    });
    if (user != null) {
      // Navigate to home page and remove login from stack
      Navigator.of(context).pushReplacementNamed('/home');
    } else {
      setState(() {
        _error = 'Login failed. Please check your credentials.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
              ),
              const SizedBox(height: 24),
              if (_error != null) ...[
                Text(_error!, style: const TextStyle(color: Colors.red)),
                const SizedBox(height: 12),
              ],
              _isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _login,
                      child: const Text('Login'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}

