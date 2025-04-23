import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gitgram/app/cubits/post/post_cubit.dart';
import 'package:gitgram/app/cubits/user/user_cubit.dart';
import 'package:gitgram/app/screens/Home_screen.dart';
import 'package:gitgram/app/screens/pages/following_list.dart';
import 'package:gitgram/app/screens/pages/search_screen.dart';
import 'package:gitgram/app/widgets/post_widget.dart';
import 'package:gitgram/domain/entities/post_entity.dart';
import 'package:gitgram/domain/entities/user_entity.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../utils/custom/custom_snackbar.dart';
import '../../cubits/auth/auth_cubit.dart';
import '../../widgets/profile_widgets.dart';
import '../AuthScreen.dart';

class UserProfileScreen extends StatefulWidget {
  final UserEntity user;
  final bool isCurrentUser;
  // ignore: non_constant_identifier_names
  final UserEntity curr_user;
  final bool isSearch;
  const UserProfileScreen(
      {super.key,
      required this.user,
      required this.isCurrentUser,
      required this.isSearch,
      // ignore: non_constant_identifier_names
      required this.curr_user});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  @override
  void initState() {
    super.initState();

    if (!widget.isCurrentUser) {
      BlocProvider.of<UserCubit>(context)
          .getSingleFollowing(username: widget.user.login);
    }
    BlocProvider.of<PostCubit>(context).fetchPosts(username: widget.user.login);
  }

  void _showLogoutBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.black,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.logout, color: Colors.red),
                title:
                    const Text("Logout", style: TextStyle(color: Colors.white)),
                onTap: () async {
                  Navigator.of(context).pop(); // Close bottom sheet first
                  final isLogout = await showDialog<bool>(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        backgroundColor: Colors.black,
                        title: const Text(
                          'Are you sure you want to logout?',
                          style: TextStyle(color: Colors.white),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: const Text('NO',
                                style: TextStyle(color: Colors.white)),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(context, true),
                            child: const Text('YES',
                                style: TextStyle(color: Colors.white)),
                          ),
                        ],
                      );
                    },
                  );

                  if (isLogout == true) {
                    // ignore: use_build_context_synchronously
                    BlocProvider.of<AuthCubit>(context).signOut();
                    // ignore: use_build_context_synchronously
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (_) => const AuthScreen()),
                      (route) => false,
                    );
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.cancel, color: Colors.grey),
                title:
                    const Text("Cancel", style: TextStyle(color: Colors.white)),
                onTap: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        );
      },
    );
  }

  _bodyWidget(Size mq, UserEntity user, List<PostEntity> posts) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: mq.height * 0.05),
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: Image.network(
                    widget.user.avatarUrl,
                    width: mq.width * 0.3,
                  ),
                ),
                SizedBox(
                  height: mq.height * 0.13,
                  width: mq.width * 0.7,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text('  @${widget.user.login}',
                              style: GoogleFonts.merienda(
                                textStyle: TextStyle(
                                  fontSize: mq.width * 0.05,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              )),
                          const Spacer(),
                          if (widget.isCurrentUser)
                            IconButton(
                              icon: const Icon(Icons.more_vert,
                                  color: Colors.white),
                              onPressed: () => _showLogoutBottomSheet(context),
                            ),
                        ],
                      ),
                      profileCard(
                        user: widget.isCurrentUser ? widget.user : user,
                        ctx: context,
                        curr: widget.curr_user,
                      ),
                    ],
                  ),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                widget.user.bio ?? 'No bio available',
                style: const TextStyle(
                  fontSize: 20,
                ),
              ),
            ),
            Text(
              "Posts",
              style: GoogleFonts.montserrat(
                textStyle: const TextStyle(
                  fontSize: 40,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: const ClampingScrollPhysics(),
              itemCount: posts.length,
              itemBuilder: (context, index) {
                final post = posts[index];

                return postCard(mq, post);
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;

    return Scaffold(
      appBar: (!widget.isCurrentUser)
          ? AppBar(
              surfaceTintColor: Colors.black,
              backgroundColor: Colors.black,
              title: Text(
                '${widget.user.login}\'s Profile',
                style: GoogleFonts.montserrat(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 28,
                ),
              ),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () async {
                  if (!widget.isSearch) {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) => FollowingList(
                              user: widget.user,
                              currentUser: widget.curr_user,
                              isCurrentUser: widget.isCurrentUser,
                            )));
                  } else {
                    final token = (await SharedPreferences.getInstance())
                        .getString("token");

                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => HomeScreen(
                                  token: token!,
                                )));
                  }
                },
              ),
            )
          : null,
      backgroundColor: Colors.black,
      body: BlocBuilder<UserCubit, UserState>(
        builder: (context, state) {
          if (state is UserError) {
            failureBar(context, state.message);
          }
          if (state is UserSingleFollowingLoaded && !widget.isCurrentUser) {
            final user = state.user;

            return BlocBuilder<PostCubit, PostState>(
              builder: (context, state) {
                if (state is PostLoading) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: Color.fromARGB(255, 66, 255, 73),
                    ),
                  );
                }

                if (state is PostError) {
                  // Handle null message case
                  final errorMessage = state.message;
                  failureBar(context, errorMessage);

                  return Center(
                    child: Text(
                      errorMessage,
                      style: const TextStyle(color: Colors.white),
                    ),
                  );
                }
                if (state is PostLoaded) {
                  final posts = [...state.posts]
                    ..sort((a, b) => b.pushedAt.compareTo(a.pushedAt));

                  return _bodyWidget(mq, user, posts);
                }
                return const SizedBox();
              },
            );
          }

          return BlocBuilder<PostCubit, PostState>(
            builder: (context, state) {
              if (state is PostLoading) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: Color.fromARGB(255, 66, 255, 73),
                  ),
                );
              }

              if (state is PostError) {
                // Handle null message case
                final errorMessage = state.message;
                failureBar(context, errorMessage);

                return Center(
                  child: Text(
                    errorMessage,
                    style: const TextStyle(color: Colors.white),
                  ),
                );
              }
              if (state is PostLoaded) {
                final posts = [...state.posts]
                  ..sort((a, b) => b.pushedAt.compareTo(a.pushedAt));

                return _bodyWidget(mq, widget.user, posts);
              }
              return const SizedBox();
            },
          );
        },
      ),
    );
  }
}
