import 'package:faunty/components/role_gate.dart';
import 'package:faunty/firebase_options.dart';
import 'package:faunty/models/user_roles.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'pages/home/home_page.dart';
import 'pages/login.dart';
import 'pages/cleaning/cleaning.dart';
import 'pages/catering/catering.dart';
import 'pages/more/more_page.dart';
import 'components/navigation_bar.dart';
import 'pages/program/program_page.dart';
import 'pages/splash_page.dart';
import 'pages/welcome/user_welcome_page.dart';
import 'state_management/user_provider.dart';
import 'package:faunty/i18n/strings.g.dart';
import 'package:faunty/tools/translation_helper.dart';
import 'state_management/theme_provider.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  LocaleSettings.useDeviceLocale(); // Localization setup
  // String storedLocale = loadFromStorage(); // with shared preferences or any other method
  // LocaleSettings.setLocaleRaw(storedLocale);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    TranslationProvider(
      child: ProviderScope(
        child: Faunty(),
      ),
    ),
  );
}

class Faunty extends ConsumerWidget {
  const Faunty({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) { 
    return MaterialApp(
      title: translation(context: context, 'Faunty'),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.green,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      themeMode: ref.watch(themeProvider).value == AppThemeMode.dark
        ? ThemeMode.dark
        : ref.watch(themeProvider).value == AppThemeMode.light
            ? ThemeMode.light
            : ThemeMode.system,

      initialRoute: '/splash',
      routes: {
        '/splash': (context) => const SplashPage(),
        '/login': (context) => const LoginPage(),
        '/home': (context) => const MainPage(),
        '/user-welcome': (context) => const UserWelcomePage(),
      },
    );
  }
}

class MainPage extends ConsumerStatefulWidget {
  const MainPage({super.key});

  @override
  ConsumerState<MainPage> createState() => _MainPageState();
}

class _MainPageState extends ConsumerState<MainPage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    HomePage(),
    CleaningPage(),
    CateringPage(),
    ProgramPage(),
    MorePage(),
  ];

  void _onDestinationSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final userAsync = ref.watch(userProvider);
    return RoleGate(
      minRole: UserRole.talebe,
      showChildOnPages: ['/login'],
      fallback: Builder(
        builder: (context) {
          // check if user is logged in if not go to login page
          if (userAsync is AsyncData && userAsync.value == null) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (ModalRoute.of(context)?.settings.name != '/login') {
                Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
              }
            });
          }
          if (userAsync is AsyncData && userAsync.value != null && userAsync.value!.role == UserRole.user) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (ModalRoute.of(context)?.settings.name != '/user-welcome') {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => const UserWelcomePage(),
                    settings: const RouteSettings(name: '/user-welcome'),
                  ),
                );
              }
            });
          }
          return const SizedBox.shrink();
        },
      ),
      child: Scaffold(
        body: _pages[_selectedIndex],
        bottomNavigationBar: NavBar(
          selectedIndex: _selectedIndex,
          onDestinationSelected: _onDestinationSelected,
        ),
      ),
    );
  }
}
