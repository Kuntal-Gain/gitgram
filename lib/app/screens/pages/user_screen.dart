import 'package:flutter/material.dart';
import 'package:gitgram/app/widgets/post_widget.dart';
import 'package:gitgram/domain/entities/user_entity.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../widgets/profile_widgets.dart';

class UserProfileScreen extends StatefulWidget {
  final UserEntity user;
  const UserProfileScreen({super.key, required this.user});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
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
                    height: mq.height * 0.1,
                    width: mq.width * 0.7,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('  @${widget.user.login}',
                            style: GoogleFonts.merienda(
                              textStyle: TextStyle(
                                fontSize: mq.width * 0.05,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            )),
                        profileCard(
                          followers: widget.user.followers,
                          following: widget.user.following,
                          repos: widget.user.publicRepos,
                        ),
                      ],
                    ),
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  widget.user.bio!,
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              ),
              Text(
                "Posts",
                style: GoogleFonts.montserrat(
                  textStyle: TextStyle(
                    fontSize: 40,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              postCard(mq, widget.user),
              postCard(mq, widget.user),
            ],
          ),
        ),
      ),
    );
  }
}
