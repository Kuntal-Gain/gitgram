import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:gitgram/app/screens/splash_screen.dart';
import 'package:gitgram/app/cubits/auth/auth_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'dependency_injection.dart' as di;
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  print(
      'token : ${(await SharedPreferences.getInstance()).getString('token')}');

  await dotenv.load(); // Load environment variables
  await di.init(); // Set up dependency injection
  runApp(const MyApp());
}

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
      ],
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: SplashScreen(),
      ),
    );
  }
}
