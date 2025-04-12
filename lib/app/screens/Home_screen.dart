import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gitgram/app/screens/AuthScreen.dart';

import '../cubits/auth/auth_cubit.dart';

class HomeScreen extends StatefulWidget {
  final String token;
  const HomeScreen({super.key, required this.token});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Token : ${widget.token}',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => BlocProvider.of<AuthCubit>(context).signOut().then(
                (_) => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AuthScreen()))),
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );
  }
}
