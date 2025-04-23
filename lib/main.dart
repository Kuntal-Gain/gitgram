import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:gitgram/app/cubits/user/user_cubit.dart';
import 'package:gitgram/app/screens/splash_screen.dart';
import 'package:gitgram/app/cubits/auth/auth_cubit.dart';
import 'app/cubits/post/post_cubit.dart';
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
        // BlocProvider<UserCubit>(
        //   create: (context) => UserCubit(
        //     getCurrentUserUsecase: di.sl(),
        //     getFollowingUsecase: di.sl(),
        //     getSingleFollowingUsecase: di.sl(),
        //   ),
        // ),
        BlocProvider<UserCubit>(create: (context) => di.sl<UserCubit>()),
        BlocProvider<PostCubit>(
          create: (context) => di.sl<PostCubit>(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark(),
        home: const SplashScreen(),
      ),
    );
  }
}
