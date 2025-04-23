import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gitgram/app/screens/Home_screen.dart';
import 'package:gitgram/app/screens/pages/user_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../domain/entities/user_entity.dart';
import '../../cubits/user/user_cubit.dart';

class FollowingList extends StatefulWidget {
  final UserEntity user;
  final UserEntity currentUser;
  final bool isCurrentUser;
  const FollowingList(
      {super.key,
      required this.user,
      required this.currentUser,
      required this.isCurrentUser});

  @override
  State<FollowingList> createState() => _FollowingListState();
}

class _FollowingListState extends State<FollowingList> {
  @override
  void initState() {
    super.initState();

    BlocProvider.of<UserCubit>(context).getFollowing(
        username: widget.isCurrentUser
            ? widget.currentUser.login
            : widget.user.login);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Following'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () async {
            final token =
                (await SharedPreferences.getInstance()).getString('token');
            // ignore: use_build_context_synchronously
            Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => HomeScreen(
                      token: token!,
                    )));
          },
        ),
      ),
      body: BlocBuilder<UserCubit, UserState>(
        builder: (context, state) {
          if (state is UserLoading && state.isFollowingList) {
            return const Center(
              child: CircularProgressIndicator(
                color: Color.fromARGB(255, 66, 255, 73),
              ),
            );
          }
          if (state is UserFollowingLoaded) {
            final users = state.users;
            return ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];
                return ListTile(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UserProfileScreen(
                          user: user,
                          isCurrentUser: false,
                          curr_user: widget.currentUser,
                        ),
                      ),
                    );
                  },
                  title: Text(user.login),
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(user.avatarUrl),
                  ),
                );
              },
            );
          }
          if (state is UserError) {
            return Center(
              child: Text(state.message),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
