import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:gitgram/app/cubits/user/user_cubit.dart';
import 'package:gitgram/app/screens/splash_screen.dart';
import 'package:gitgram/app/cubits/auth/auth_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dependency_injection.dart' as di;
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await dotenv.load(); // Load environment variables
  await di.init(); // Set up dependency injection
  runApp(const MyApp());
}

// Future<Map<String, dynamic>?> fetchGitHubUserInfo(String token) async {
//   final url = Uri.parse('https://api.github.com/user');

//   final response = await http.get(
//     url,
//     headers: {
//       'Authorization': 'Bearer $token',
//       'Accept': 'application/vnd.github+json',
//     },
//   );

//   if (response.statusCode == 200) {
//     return jsonDecode(response.body);
//   } else {
//     print(
//         'Failed to fetch user info: ${response.statusCode} - ${response.body}');
//     return null;
//   }
// }

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // cubits
        BlocProvider<AuthCubit>(
          create: (context) => di.sl<AuthCubit>(),
        ),
        BlocProvider<UserCubit>(
          create: (context) => di.sl<UserCubit>(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark(),
        home: SplashScreen(),
      ),
    );
  }
}
