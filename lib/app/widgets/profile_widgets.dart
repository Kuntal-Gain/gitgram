import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Widget profileCard(
    {required int followers, required int following, required int repos}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: [
      profileCardTile("Repos", repos),
      profileCardTile("Followers", followers),
      profileCardTile("Following", following),
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
