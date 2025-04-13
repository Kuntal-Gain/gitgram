import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../widgets/profile_widgets.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: mq.height * 0.05),
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: Image.network(
                    'https://avatars.githubusercontent.com/u/166943482?v=4',
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
                      Text('  @Kuntal-Gain',
                          style: GoogleFonts.merienda(
                            textStyle: TextStyle(
                              fontSize: mq.width * 0.05,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          )),
                      profileCard(
                        followers: 100,
                        following: 100,
                        repos: 100,
                      ),
                    ],
                  ),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Flutter Developer | Flutter | Firebase",
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
            )
          ],
        ),
      ),
    );
  }
}
