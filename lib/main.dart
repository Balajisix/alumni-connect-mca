import 'package:alumniconnectmca/auth_state/auth_checker.dart';
import 'package:alumniconnectmca/pages/alumni_page/alumni_home.dart';
import 'package:alumniconnectmca/pages/alumni_page/alumni_profile.dart';
import 'package:alumniconnectmca/pages/alumni_page/student_page.dart';
import 'package:alumniconnectmca/pages/alumni_page/student_details.dart';
import 'package:alumniconnectmca/pages/students_page/alumni_page.dart';
import 'package:alumniconnectmca/pages/students_page/alumni_details.dart';
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
import 'pages/students_page/chat_list_page.dart';
import 'pages/alumni_page/event_list_page.dart';
import 'pages/alumni_page/chat_list_page.dart';
import 'pages/students_page/chat_detail_page.dart';
import 'models/chat_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'providers/auth_provider.dart';
import 'providers/notification_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CustomAuthProvider()),
        ChangeNotifierProvider(create: (_) => ChatProvider()),
        ChangeNotifierProvider(create: (_) => NotificationProvider()),
        ChangeNotifierProvider(create: (_) => SignupProvider()),
        ChangeNotifierProvider(create: (_) => HomeProvider()),
        ChangeNotifierProvider(create: (_) => ProfileProvider()),
        ChangeNotifierProvider(create: (_) => EventProvider()),
        ChangeNotifierProvider(create: (_) => AlumniHomeProvider()),
        ChangeNotifierProvider(create: (_) => ProfileProviderAlumni()),
        ChangeNotifierProvider(create: (_) => AlumniProvider()),
        ChangeNotifierProvider(create: (_) => StudentProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Alumni Connect',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const AuthWrapper(),
        routes: {
          '/login': (context) => LoginPage(),
          // Student routes
          '/home': (context) => HomePage(),
          '/studentProfile': (context) => ProfilePage(),
          '/findAlumni': (context) => AlumniPage(),
          '/student/events': (context) => const StudentEventListPage(),
          '/student/event/post': (context) => EventPostPage(),
          '/student/chats': (context) => const StudentChatListPage(),
          '/student/alumni/details': (context) {
            final alumni = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
            return AlumniDetailPage(alumni: alumni);
          },
          // Alumni routes
          '/alumniHome': (context) => AlumniHomePage(),
          '/alumniProfile': (context) => ProfilePageAlumni(),
          '/findStudents': (context) => StudentPage(),
          '/alumni/events': (context) => const AlumniEventListPage(),
          '/alumni/chats': (context) => const AlumniChatListPage(),
          '/alumni/student/details': (context) {
            final student = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
            return StudentDetailPage(student: student);
          },
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
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<CustomAuthProvider>(context);
    final notificationProvider = Provider.of<NotificationProvider>(context);

    return StreamBuilder<User?>(
      stream: authProvider.authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasData) {
          // Initialize notifications when user is logged in
          if (!notificationProvider.isInitialized) {
            notificationProvider.initialize();
          }

          final user = snapshot.data!;
          final userType = user.email?.endsWith('@alumni.com') ?? false ? 'alumni' : 'student';

          return userType == 'student'
              ? HomePage()
              : AlumniHomePage();
        }

        return LoginPage();
      },
    );
  }
}
