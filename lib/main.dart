import 'package:alumniconnectmca/auth_state/auth_checker.dart';
import 'package:alumniconnectmca/pages/alumni_page/alumni_home.dart';
import 'package:alumniconnectmca/pages/alumni_page/alumni_profile.dart';
import 'package:alumniconnectmca/pages/students_page/alumni_page.dart';
import 'package:alumniconnectmca/pages/students_page/home_page.dart';
import 'package:alumniconnectmca/pages/students_page/profile_page.dart';
import 'package:alumniconnectmca/pages/login_page.dart';
import 'package:alumniconnectmca/providers/alumni_provider/alumni_home_provider.dart';
import 'package:alumniconnectmca/providers/alumni_provider/alumni_profile_provider.dart';
import 'package:alumniconnectmca/providers/students_provider/home_provider.dart';
import 'package:alumniconnectmca/providers/students_provider/profile_provider.dart';
import 'package:alumniconnectmca/providers/signup_providers.dart';
import 'package:alumniconnectmca/providers/students_provider/alumni_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => SignupProvider()),
        ChangeNotifierProvider(create: (_) => HomeProvider()),           // Student HomeProvider
        ChangeNotifierProvider(create: (_) => ProfileProvider()),        // Student ProfileProvider
        ChangeNotifierProvider(create: (_) => AlumniHomeProvider()),     // Alumni HomeProvider
        ChangeNotifierProvider(create: (_) => ProfileProviderAlumni()),
        ChangeNotifierProvider(create: (_) => AlumniProvider())// Alumni ProfileProvider
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
      // Let AuthChecker decide which home page to display.
      home: AuthChecker(),
      routes: {
        '/login': (context) => LoginPage(),
        // Student routes
        '/studentHome': (context) => HomePage(),
        '/studentProfile': (context) => ProfilePage(),
        '/findAlumni' : (context) => AlumniPage(),
        // Alumni routes
        '/alumniHome': (context) => AlumniHomePage(),
        '/alumniProfile': (context) => ProfilePageAlumni(),
        // You can add more routes (like chat, events posting, etc.) here.
      },
    );
  }
}
