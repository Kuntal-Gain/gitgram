import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gitgram/app/cubits/post/post_cubit.dart';
import 'package:gitgram/app/widgets/post_widget.dart';
import 'package:gitgram/domain/entities/user_entity.dart';
import 'package:gitgram/utils/custom/custom_snackbar.dart';
import 'package:google_fonts/google_fonts.dart';

class FeedScreen extends StatefulWidget {
  final UserEntity user;

  const FeedScreen({super.key, required this.user});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  @override
  void initState() {
    super.initState();

    BlocProvider.of<PostCubit>(context)
        .fetchFeedPosts(username: widget.user.login);
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        automaticallyImplyLeading: false,
        title: Text(
          'Gitgram',
          style: GoogleFonts.pacifico(
            color: Colors.white,
            fontSize: 28,
          ),
        ),
        actions: const [],
      ),
      body: BlocBuilder<PostCubit, PostState>(
        builder: (ctx, state) {
          if (state is PostLoading) {
            return const Center(
              child: CircularProgressIndicator(
                color: Color.fromARGB(255, 66, 255, 73),
              ),
            );
          }

          if (state is PostLoaded) {
            final posts = [...state.posts]
              ..sort((a, b) => b.pushedAt.compareTo(a.pushedAt));

            return ListView.builder(
              itemCount: posts.length,
              itemBuilder: (context, index) {
                final post = posts[index];
                return postCard(mq, post);
              },
            );
          }

          if (state is PostError) {
            failureBar(context, state.message);
          }

          return SizedBox();
        },
      ),
    );
  }
}
