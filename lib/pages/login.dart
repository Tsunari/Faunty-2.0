import 'package:faunty/models/places.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_entity.dart';
import '../state_management/user_provider.dart';
import '../state_management/user_list_provider.dart';

// Register a new user and save their role in Firestore
Future<(User?, String?)> registerWithEmail(String email, String password) async {
  try {
    final credential = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);
    // TODO: Create a user entity and save it in Firestore
    return (credential.user, null);
  } on FirebaseAuthException catch (e) {
    print('Registration error: $e');
    if (e.code == 'email-already-in-use') {
      return (null, 'This email is already registered.');
    } else if (e.code == 'weak-password') {
      return (null, 'Password is too weak. Please use at least 6 characters.');
    } else {
      return (null, 'Registration failed. ${e.message ?? ''}');
    }
  } catch (e) {
    print('Registration error: $e');
    return (null, 'Registration failed. Please try again.');
  }
}

// Login with email and password
Future<User?> loginWithEmail(String email, String password) async {
  try {
    final credential = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
    // TODO: Fetch user role from Firestore
    return credential.user;
  } catch (e) {
    print('Login error: $e');
    return null;
  }
}

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> with SingleTickerProviderStateMixin {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  bool _isLoading = false;
  String? _error;
  bool _isRegisterMode = false;
  String? _selectedPlace;
  List<String> _places = Place.values.map((place) => place.name).toList();
  late AnimationController _animController;
  late Animation<double> _registerFieldsAnim;
  bool _showPassword = false;
  bool _showConfirmPassword = false;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 650),
    );
    _registerFieldsAnim = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeInOutCubic,
    );
    _fetchPlaces();
  }

  Future<void> _fetchPlaces() async {
    // Fetch places from Firestore (assuming collection 'places' with 'name' field) TODO: use firestore service
    try {
      final snapshot = await FirebaseFirestore.instance.collection('places').get();
      print('Fetched places: ${snapshot.docs.length}');
      setState(() {
        if (snapshot.docs.isNotEmpty) {
          _places = snapshot.docs.map((doc) => doc['name'] as String).toList();
        } else {
          _places = Place.values.map((place) => place.name).toList();
        }
      });
    } catch (e) {
      // fallback or ignore
      print('Error fetching places: $e');
      setState(() {
        _places = Place.values.map((place) => place.name).toList();
      });
    }
  }

  @override
  void dispose() {
    _animController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }

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
      // Use allUsersProvider to get user_list from Riverpod
      final allUsersAsync = ref.read(allUsersProvider);
      List<UserEntity> allUsers = [];
      if (allUsersAsync is AsyncData<List<UserEntity>>) {
        allUsers = allUsersAsync.value;
      } else {
        // If not loaded yet, fallback to Firestore (rare, e.g. on cold start) TODO: use firestore service
        final doc = await FirebaseFirestore.instance.collection('user_list').doc(user.uid).get();
        if (doc.exists && doc.data() != null && doc.data()!['place'] != null) {
          allUsers = [UserEntity.fromMap(doc.data()!)];
        }
      }
      final userEntity = allUsers.where((u) => u.uid == user.uid).toList();
      final placeName = userEntity.isNotEmpty ? userEntity.first.place.name : null;
      if (placeName == null) {
        setState(() {
          _error = 'Could not determine your place. Please contact support.';
        });
        return;
      }
      final success = await ref.read(userProvider.notifier).loadUser(uid: user.uid);
      if (success) {
        Navigator.of(context).pushReplacementNamed('/home');
      } else {
        setState(() {
          _error = 'User data not found or incomplete. Please contact support.';
        });
      }
    } else {
      setState(() {
        if (email.isEmpty || password.isEmpty) {
          _error = 'Please enter both your email and password.';
        } else if (!email.contains('@')) {
          _error = 'Please enter a valid email address.';
        } else {
          _error = 'Incorrect email or password. Please try again.';
        }
      });
    }
  }

  Future<void> _register() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();
    final firstName = _firstNameController.text.trim();
    final lastName = _lastNameController.text.trim();
    if (email.isEmpty || password.isEmpty || confirmPassword.isEmpty || firstName.isEmpty || lastName.isEmpty) {
      setState(() {
        _isLoading = false;
        _error = 'Please fill in all fields.';
      });
      return;
    }
    if (!email.contains('@')) {
      setState(() {
        _isLoading = false;
        _error = 'Please enter a valid email address.';
      });
      return;
    }
    if (password != confirmPassword) {
      setState(() {
        _isLoading = false;
        _error = 'Passwords do not match.';
      });
      return;
    }
    if (_selectedPlace == null) {
      setState(() {
        _isLoading = false;
        _error = 'Please select a place.';
      });
      return;
    }
    final (user, regError) = await registerWithEmail(email, password);
    if (user != null) {
      // Save all required user fields in user_list for login and provider TODO: use firestore service
      await FirebaseFirestore.instance.collection('user_list').doc(user.uid).set({
        'uid': user.uid,
        'email': email,
        'place': _selectedPlace!,
        'firstName': firstName,
        'lastName': lastName,
        'role': 'User',
      });
      final success = await ref.read(userProvider.notifier).createUser(
        uid: user.uid,
        email: email,
        place: PlaceExtension.fromString(_selectedPlace!),
        firstName: firstName,
        lastName: lastName,
      );
      if (success) {
        Navigator.of(context).pushReplacementNamed('/home');
      } else {
        setState(() {
          _error = 'Failed to create user. Please try again.';
        });
      }
    } else {
      setState(() {
        _isLoading = false;
        _error = regError ?? 'Registration failed. Please try again.';
      });
    }
    setState(() {
      _isLoading = false;
    });
  }

  void _toggleRegisterMode() {
    setState(() {
      _isRegisterMode = !_isRegisterMode;
      _error = null;
    });
        if (_isRegisterMode) {
          _animController.forward();
          // Remove focus from all fields when entering register mode
          FocusScope.of(context).unfocus();
        } else {
          _animController.reverse();
        }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24.0, 0.0, 24.0, 0.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 400),
                  switchInCurve: Curves.easeInOut,
                  switchOutCurve: Curves.easeInOut,
                    child: !_isRegisterMode
                      ? Hero(
                        tag: 'logo',
                        child: Image.asset(
                        'assets/LogoInverse.png',
                        height: 145,
                        fit: BoxFit.contain,
                        ),
                      )
                      : const SizedBox.shrink(),
                ),
                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 16,
                        offset: Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        _isRegisterMode ? 'Register' : 'Login',
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                  AutofillGroup(
                    child: Column(
                      children: [
                        if (_isRegisterMode) ...[
                          TextField(
                            controller: _firstNameController,
                            decoration: InputDecoration(
                              labelText: 'First Name',
                              prefixIcon: Icon(Icons.person_outline),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            textInputAction: TextInputAction.next,
                            autofillHints: const [AutofillHints.givenName],
                            onEditingComplete: () => FocusScope.of(context).nextFocus(),
                          ),
                          const SizedBox(height: 16),
                          TextField(
                            controller: _lastNameController,
                            decoration: InputDecoration(
                              labelText: 'Last Name',
                              prefixIcon: Icon(Icons.person_outline),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            textInputAction: TextInputAction.next,
                            autofillHints: const [AutofillHints.familyName],
                            onEditingComplete: () => FocusScope.of(context).nextFocus(),
                          ),
                          const SizedBox(height: 16),
                        ],
                        TextField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            labelText: 'Email',
                            prefixIcon: Icon(Icons.email_outlined),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          keyboardType: TextInputType.emailAddress,
                          autofillHints: !_isRegisterMode
                              ? const [AutofillHints.username, AutofillHints.email]
                              : null,
                          autofocus: false,
                          textInputAction: TextInputAction.next,
                          onEditingComplete: () {
                            if (!_isRegisterMode) {
                              final email = _emailController.text.trim();
                              final password = _passwordController.text.trim();
                              if (email.isNotEmpty && password.isNotEmpty) {
                                FocusScope.of(context).unfocus(); // Hide keyboard
                                _login();
                              } else {
                                FocusScope.of(context).nextFocus();
                              }
                            } else {
                              FocusScope.of(context).nextFocus();
                            }
                          },
                          onSubmitted: (_) {
                            if (!_isRegisterMode) {
                              final email = _emailController.text.trim();
                              final password = _passwordController.text.trim();
                              if (email.isNotEmpty && password.isNotEmpty) {
                                FocusScope.of(context).unfocus(); // Hide keyboard
                                _login();
                              } else {
                                FocusScope.of(context).nextFocus();
                              }
                            } else {
                              FocusScope.of(context).nextFocus();
                            }
                          },
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: _passwordController,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            prefixIcon: Icon(Icons.lock_outline),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            suffixIcon: FocusScope(
                              canRequestFocus: false,
                              skipTraversal: true,
                              child: Padding(
                                padding: const EdgeInsetsDirectional.only(end: 8.0),
                                child: IconButton(
                                  icon: Icon(_showPassword ? Icons.visibility_off : Icons.visibility),
                                  onPressed: () {
                                    setState(() {
                                      _showPassword = !_showPassword;
                                    });
                                  },
                                  tooltip: _showPassword ? 'Hide password' : 'Show password',
                                ),
                              ),
                            ),
                          ),
                          obscureText: !_showPassword,
                          autofillHints: !_isRegisterMode
                              ? const [AutofillHints.password]
                              : null,
                          textInputAction: _isRegisterMode ? TextInputAction.next : TextInputAction.done,
                          onEditingComplete: () {
                            if (_isRegisterMode) {
                              FocusScope.of(context).nextFocus();
                            } else {
                              // Try login if all required fields are filled
                              if (_emailController.text.trim().isNotEmpty && _passwordController.text.trim().isNotEmpty) {
                                FocusScope.of(context).unfocus(); // Hide keyboard
                                _login();
                              } else {
                                FocusScope.of(context).unfocus();
                              }
                            }
                          },
                          onSubmitted: (_) {
                            if (_isRegisterMode) {
                              FocusScope.of(context).nextFocus();
                            } else {
                              if (_emailController.text.trim().isNotEmpty && _passwordController.text.trim().isNotEmpty) {
                                FocusScope.of(context).unfocus(); // Hide keyboard
                                _login();
                              }
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                  SizeTransition(
                    sizeFactor: _registerFieldsAnim,
                    axisAlignment: -1.0,
                    child: Column(
                      children: [
                        const SizedBox(height: 16),
                        TextField(
                          controller: _confirmPasswordController,
                          decoration: InputDecoration(
                            labelText: 'Confirm Password',
                            prefixIcon: Icon(Icons.lock_reset),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            suffixIcon: FocusScope(
                              canRequestFocus: false,
                              skipTraversal: true,
                              child: Padding(
                                padding: const EdgeInsetsDirectional.only(end: 8.0),
                                child: IconButton(
                                  icon: Icon(_showConfirmPassword ? Icons.visibility_off : Icons.visibility),
                                  onPressed: () {
                                    setState(() {
                                      _showConfirmPassword = !_showConfirmPassword;
                                    });
                                  },
                                  tooltip: _showConfirmPassword ? 'Hide password' : 'Show password',
                                ),
                              ),
                            ),
                          ),
                          obscureText: !_showConfirmPassword,
                          textInputAction: TextInputAction.next,
                          onSubmitted: (_) => FocusScope.of(context).nextFocus(),
                        ),
                        const SizedBox(height: 16),
                        DropdownButtonFormField<String>(
                          value: _selectedPlace,
                          isExpanded: true,
                          icon: const Icon(Icons.keyboard_arrow_down),
                          items: _places.map((place) => DropdownMenuItem(
                            value: place,
                            child: Row(
                              children: [
                                const Icon(Icons.place_outlined, size: 18),
                                const SizedBox(width: 8),
                                Text(place, style: const TextStyle(fontSize: 16)),
                              ],
                            ),
                          )).toList(),
                          onChanged: (val) => setState(() => _selectedPlace = val),
                          decoration: InputDecoration(
                            labelText: 'Select Place',
                            prefixIcon: Icon(Icons.domain_outlined),
                            suffixIcon: _selectedPlace != null
                                ? IconButton(
                                    icon: const Icon(Icons.clear),
                                    onPressed: () => setState(() => _selectedPlace = null),
                                    tooltip: 'Clear selection',
                                  )
                                : null,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                          ),
                          menuMaxHeight: 300,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  if (_error != null) ...[
                    Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.error.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Theme.of(context).colorScheme.error.withOpacity(0.3)),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.error_outline, color: Theme.of(context).colorScheme.error, size: 22),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              _error!,
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.error,
                                fontWeight: FontWeight.w600,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  _isLoading
                      ? Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              SizedBox(height: 8),
                              CircularProgressIndicator(),
                              SizedBox(height: 16),
                              Text('Please wait...', style: TextStyle(fontSize: 16)),
                            ],
                          ),
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            ElevatedButton(
                              onPressed: _isRegisterMode ? _register : _login,
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: Text(_isRegisterMode ? 'Register' : 'Login',
                                style: const TextStyle(fontSize: 18)),
                            ),
                            const SizedBox(height: 12),
                            TextButton(
                              onPressed: _toggleRegisterMode,
                              child: AnimatedSwitcher(
                                duration: const Duration(milliseconds: 250),
                                child: Text(
                                  _isRegisterMode
                                      ? 'Already have an account? Login'
                                      : 'Don\'t have an account? Register',
                                  key: ValueKey(_isRegisterMode),
                                  style: const TextStyle(fontSize: 15),
                                ),
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
