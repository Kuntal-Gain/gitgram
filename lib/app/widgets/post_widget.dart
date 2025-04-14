import 'package:flutter/material.dart';
import 'package:gitgram/domain/entities/post_entity.dart';
import 'package:gitgram/utils/constants/color_const.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../domain/entities/user_entity.dart';
import 'profile_widgets.dart';

Widget postCard(Size size, UserEntity user) {
  return SingleChildScrollView(
    child: Container(
      padding: EdgeInsets.all(size.width * 0.02),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // profile
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: Image.network(
                  user.avatarUrl,
                  width: size.width * 0.1,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '  @${user.login}',
                    style: GoogleFonts.montserrat(
                      textStyle: TextStyle(
                        fontSize: size.width * 0.035,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    width: size.width * 0.8,
                    padding: EdgeInsets.only(left: size.width * 0.02),
                    child: Text(
                      '${user.bio}',
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.montserrat(
                        textStyle: TextStyle(
                          fontSize: size.width * 0.025,
                          color: Colors.white,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: size.height * 0.01),
          Container(
            color: AppColor.whiteColor,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        children: [
                          Text(
                            '${user.login}/',
                            style: GoogleFonts.montserrat(
                              textStyle: TextStyle(
                                fontSize: size.width * 0.07,
                                color: AppColor.bgBlackColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          Text(
                            'Socialseed',
                            style: GoogleFonts.montserrat(
                              textStyle: TextStyle(
                                fontSize: size.width * 0.08,
                                color: AppColor.bgBlackColor,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.network(
                        user.avatarUrl,
                        width: size.width * 0.15,
                        height: size.height * 0.15,
                      ),
                    ),
                  ],
                ),
                postCardWidget(contribs: 1, issues: 0, stars: 0, forks: 0),
                SizedBox(height: size.height * 0.05),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Last committed 2 days ago'),
          ),
        ],
      ),
    ),
  );
}

Widget postCardWidget(
    {required int contribs,
    required int issues,
    required int stars,
    required int forks}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: [
      postCardTile("Contributors", contribs),
      postCardTile("Issues", issues),
      postCardTile("Stars", stars),
      postCardTile("Forks", forks),
    ],
  );
}

Widget postCardTile(String label, int val) => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          val.toString(),
          style: GoogleFonts.montserrat(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColor.bgBlackColor,
          ),
        ),
        Text(
          label,
          style: GoogleFonts.montserrat(
            fontSize: 18,
            fontWeight: FontWeight.normal,
            color: AppColor.blackColor,
          ),
        ),
      ],
    );
