import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gitgram/app/screens/pages/user_screen.dart';

import '../../../domain/entities/user_entity.dart';
import '../../cubits/user/user_cubit.dart';

class FollowingList extends StatefulWidget {
  final UserEntity user;
  const FollowingList({super.key, required this.user});

  @override
  State<FollowingList> createState() => _FollowingListState();
}

class _FollowingListState extends State<FollowingList> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    BlocProvider.of<UserCubit>(context)
        .getFollowing(username: widget.user.login);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Following'),
      ),
      body: BlocBuilder<UserCubit, UserState>(
        builder: (context, state) {
          print(state);

          if (state is UserLoading) {
            return const Center(
              child: CircularProgressIndicator(
                color: Color.fromARGB(255, 66, 255, 73),
              ),
            );
          }
          if (state is UserFollowingLoaded) {
            final users = state.user;
            return ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];

                print(user.followers);
                return ListTile(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UserProfileScreen(
                          user: user,
                          isCurrentUser: false,
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
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
