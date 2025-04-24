import 'package:alumniconnectmca/auth_state/auth_checker.dart';
import 'package:alumniconnectmca/pages/alumni_page/alumni_home_page.dart';
import 'package:alumniconnectmca/pages/alumni_page/alumni_profile.dart';
import 'package:alumniconnectmca/pages/alumni_page/student_page.dart';
import 'package:alumniconnectmca/pages/students_page/alumni_page.dart';
import 'package:alumniconnectmca/pages/students_page/home_page.dart';
import 'package:alumniconnectmca/pages/students_page/profile_page.dart';
import 'package:alumniconnectmca/pages/students_page/event_list_page.dart';
import 'package:alumniconnectmca/pages/students_page/event_post_page.dart';
import 'package:alumniconnectmca/pages/login_page.dart';
import 'package:alumniconnectmca/providers/alumni_provider/alumni_home_provider.dart';
import 'package:alumniconnectmca/providers/alumni_provider/alumni_profile_provider.dart';
import 'package:alumniconnectmca/providers/students_provider/home_provider.dart';
import 'package:alumniconnectmca/providers/students_provider/profile_provider.dart';
import 'package:alumniconnectmca/providers/students_provider/event_provider.dart';
import 'package:alumniconnectmca/providers/signup_providers.dart';
import 'package:alumniconnectmca/providers/students_provider/alumni_provider.dart';
import 'package:alumniconnectmca/providers/alumni_provider/student_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'providers/chat_provider.dart';
import 'pages/students_page/student_home_page.dart';
import 'pages/students_page/chat_list_page.dart';
import 'pages/alumni_page/event_list_page.dart';
import 'pages/alumni_page/chat_list_page.dart';
import 'pages/students_page/chat_detail_page.dart';
import 'models/chat_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => SignupProvider()),
        ChangeNotifierProvider(create: (_) => HomeProvider()),           // Student HomeProvider
        ChangeNotifierProvider(create: (_) => ProfileProvider()),        // Student ProfileProvider
        ChangeNotifierProvider(create: (_) => EventProvider()),          // Student EventProvider
        ChangeNotifierProvider(create: (_) => AlumniHomeProvider()),     // Alumni HomeProvider
        ChangeNotifierProvider(create: (_) => ProfileProviderAlumni()),
        ChangeNotifierProvider(create: (_) => AlumniProvider()),         // Alumni ProfileProvider
        ChangeNotifierProvider(create: (_) => StudentProvider()),
        ChangeNotifierProvider(create: (_) => ChatProvider()),
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
        '/studentHome': (context) => const StudentHomePage(),
        '/studentProfile': (context) => ProfilePage(),
        '/findAlumni': (context) => AlumniPage(),
        '/student/events': (context) => const StudentEventListPage(),
        '/student/event/post': (context) => EventPostPage(),
        '/student/chats': (context) => const StudentChatListPage(),
        // Alumni routes
        '/alumniHome': (context) => const AlumniHomePage(),
        '/alumniProfile': (context) => ProfilePageAlumni(),
        '/findStudents': (context) => StudentPage(),
        '/alumni/events': (context) => const AlumniEventListPage(),
        '/alumni/chats': (context) => const AlumniChatListPage(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/student/chat/detail' || settings.name == '/alumni/chat/detail') {
          final args = settings.arguments as Map<String, dynamic>;
          return MaterialPageRoute(
            builder: (context) => ChatDetailPage(
              conversation: args['conversation'] as ChatConversation,
              currentUserId: args['currentUserId'] as String,
              currentUserName: args['currentUserName'] as String,
              currentUserType: args['currentUserType'] as String,
            ),
          );
        }
        return null;
      },
    );
  }
}
