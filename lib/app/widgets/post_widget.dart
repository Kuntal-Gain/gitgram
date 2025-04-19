import 'package:flutter/material.dart';
import 'package:gitgram/domain/entities/post_entity.dart';
import 'package:gitgram/utils/constants/color_const.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../domain/entities/user_entity.dart';

String getRelativeTime(String pushedAt) {
  DateTime date = DateTime.parse(pushedAt);
  Duration diff = DateTime.now().difference(date);

  if (diff.inDays > 7) {
    return "${diff.inDays ~/ 7} weeks ago";
  }
  if (diff.inDays > 0) {
    return "${diff.inDays} days ago";
  }
  if (diff.inHours > 0) {
    return "${diff.inHours} hours ago";
  }
  if (diff.inMinutes > 0) {
    return "${diff.inMinutes} minutes ago";
  }
  return "just now";
}

Widget postCard(Size size, PostEntity post) {
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
                  post.owner.avatarUrl,
                  width: size.width * 0.1,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '  @${post.owner.login}',
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
                      post.language,
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
                      child: SizedBox(
                        width: size.width * 0.7,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${post.owner.login}/',
                              style: GoogleFonts.montserrat(
                                textStyle: TextStyle(
                                  fontSize: size.width * 0.07,
                                  color: AppColor.bgBlackColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            Text(
                              post.name,
                              style: GoogleFonts.montserrat(
                                textStyle: TextStyle(
                                  fontSize: size.width * 0.08,
                                  color: AppColor.bgBlackColor,
                                  fontWeight: FontWeight.w900,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.network(
                        post.owner.avatarUrl,
                        width: size.width * 0.15,
                        height: size.height * 0.15,
                      ),
                    ),
                  ],
                ),
                postCardWidget(
                    contribs: post.watchersCount,
                    issues: post.openIssuesCount,
                    stars: post.stargazersCount,
                    forks: post.forksCount),
                SizedBox(height: size.height * 0.05),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
                'Last committed ${getRelativeTime(post.pushedAt.toString())}'),
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
      postCardTile("Watchers", contribs),
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
