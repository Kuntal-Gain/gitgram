// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gitgram/app/cubits/user/user_cubit.dart';
import 'package:gitgram/app/screens/pages/feed_screen.dart';
import 'package:water_drop_nav_bar/water_drop_nav_bar.dart';
import '../../utils/custom/custom_snackbar.dart';
import 'pages/explore_screen.dart';
import 'pages/search_screen.dart';
import 'pages/user_screen.dart';

class HomeScreen extends StatefulWidget {
  final String token;
  const HomeScreen({super.key, required this.token});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Widget> _screens = [];
  int currentIdx = 0;
  bool _hasShownSuccessBar = false;

  @override
  void initState() {
    BlocProvider.of<UserCubit>(context).getUser(token: widget.token);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: BlocBuilder<UserCubit, UserState>(
        builder: (context, state) {
          if (state is UserLoading) {
            return const Center(
              child: CircularProgressIndicator(
                color: Color.fromARGB(255, 66, 255, 73),
              ),
            );
          }
          if (state is UserLoaded) {
            final user = state.user;
            if (!_hasShownSuccessBar) {
              successBar(context, 'Successfully login as ${user.login}');
              _hasShownSuccessBar = true;
            }
            _screens = [
              FeedScreen(user: user),
              const SearchScreen(),
              const ExploreScreen(),
              UserProfileScreen(user: user, isCurrentUser: true),
            ];

            return _screens[currentIdx];
          }
          return const SizedBox.shrink();
        },
      ),
      bottomNavigationBar: WaterDropNavBar(
        waterDropColor: Colors.white,
        backgroundColor: Colors.black,
        onItemSelected: (index) {
          setState(() {
            currentIdx = index;
          });
        },
        selectedIndex: currentIdx,
        barItems: [
          BarItem(
            filledIcon: Icons.home,
            outlinedIcon: Icons.home_outlined,
          ),
          BarItem(
            filledIcon: Icons.screen_search_desktop_rounded,
            outlinedIcon: Icons.screen_search_desktop_outlined,
          ),
          BarItem(
              filledIcon: Icons.explore, outlinedIcon: Icons.explore_outlined),
          BarItem(
              filledIcon: Icons.person, outlinedIcon: Icons.person_outlined),
        ],
      ),
    );
  }
}
