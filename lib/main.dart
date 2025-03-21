import 'package:alumniconnectmca/auth_state/auth_checker.dart';
import 'package:alumniconnectmca/providers/profile_provider.dart';
import 'package:alumniconnectmca/providers/home_provider.dart';
import 'package:alumniconnectmca/providers/signup_providers.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:alumniconnectmca/pages/home_page.dart';
import 'package:alumniconnectmca/pages/profile_page.dart';
import 'package:alumniconnectmca/pages/login_page.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => SignupProvider()),
        ChangeNotifierProvider(create: (_) => HomeProvider()),
        ChangeNotifierProvider(create: (_) => ProfileProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Alumni Connect',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => AuthChecker(),
        '/home': (context) => HomePage(),
        '/profile': (context) => ProfilePage(),
        '/login': (context) => LoginPage(),
      },
    );
  }
}
