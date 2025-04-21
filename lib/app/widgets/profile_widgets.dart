import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gitgram/domain/entities/user_entity.dart';

import '../screens/pages/following_list.dart';

Widget profileCard({required UserEntity user, required BuildContext ctx}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: [
      profileCardTile("Repos", user.publicRepos),
      profileCardTile("Followers", user.followers),
      GestureDetector(
        onTap: () {
          Navigator.push(
            ctx,
            MaterialPageRoute(
              builder: (context) => FollowingList(
                user: user,
              ),
            ),
          );
        },
        child: profileCardTile("Following", user.following),
      ),
    ],
  );
}

Widget profileCardTile(String label, int val) => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          val.toString(),
          style: GoogleFonts.montserrat(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: GoogleFonts.montserrat(
            fontSize: 20,
            fontWeight: FontWeight.normal,
          ),
        ),
      ],
    );
