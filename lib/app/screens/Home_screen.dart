import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gitgram/app/cubits/user/user_cubit.dart';
import 'package:gitgram/app/screens/AuthScreen.dart';
import 'package:gitgram/app/screens/pages/feed_screen.dart';
import 'package:water_drop_nav_bar/water_drop_nav_bar.dart';
import 'package:gitgram/dependency_injection.dart' as di;
import '../../utils/custom/custom_snackbar.dart';
import '../cubits/auth/auth_cubit.dart';
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
          print(state);
          if (state is UserLoading) {
            return Center(
              child: CircularProgressIndicator(
                color: const Color.fromARGB(255, 66, 255, 73),
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
              const FeedScreen(),
              const SearchScreen(),
              const ExploreScreen(),
              UserProfileScreen(user: user),
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
