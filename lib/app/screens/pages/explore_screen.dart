import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gitgram/utils/constants/color_const.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  Future<Map<String, dynamic>> fetchTrendingRepos({
    DateTime? sinceDate,
    int perPage = 20,
    String? token,
  }) async {
    // Default to 7 days ago
    final since = sinceDate ?? DateTime.now().subtract(Duration(days: 7));
    final sinceIso = since.toIso8601String().split('T').first;

    // Build the search query
    final uri = Uri.https('api.github.com', '/search/repositories', {
      'q': 'created:>$sinceIso',
      'sort': 'stars',
      'order': 'desc',
      'per_page': perPage.toString(),
    });

    // Optional auth to bump rate limits
    final headers = {
      'Accept': 'application/vnd.github.v3+json',
      if (token != null && token.isNotEmpty) 'Authorization': 'token $token',
    };

    final response = await http.get(uri, headers: headers);
    if (response.statusCode != 200) {
      throw Exception('GitHub API returned ${response.statusCode}');
    }

    final body = json.decode(response.body) as Map<String, dynamic>;
    final items = (body['items'] as List<dynamic>).map((raw) {
      final repo = raw as Map<String, dynamic>;
      return {
        'name': repo['full_name'],
        'stars': repo['stargazers_count'],
      };
    }).toList();

    return {'items': items};
  }

  String? token;

  List<Map<String, dynamic>> items = [];

  @override
  void initState() {
    super.initState();

    getToken();

    fetchTrendingRepos(token: token);
  }

  Future<void> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final repos = await fetchTrendingRepos(token: token);

    setState(() {
      this.token = token;

      items = repos['items'];
    });

    print(items);
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColor.blackColor,
      appBar: AppBar(
        backgroundColor: Colors.black,
        automaticallyImplyLeading: false,
        title: Text(
          'Explore',
          style: GoogleFonts.pacifico(
            color: Colors.white,
            fontSize: 28,
          ),
        ),
        actions: const [],
      ),
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1 / 1.2,
        ),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];

          final name = item['name'];
          final stars = item['stars'];

          return Container(
            margin: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColor.bgBlackColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  height: mq.height * 0.2,
                  // width: mq.width * 0.4,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(name,
                        style: GoogleFonts.montserrat(
                          textStyle: TextStyle(
                            color: Colors.white,
                            fontSize: mq.height * 0.03,
                            fontWeight: FontWeight.bold,
                            overflow: TextOverflow.clip,
                          ),
                        )),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Icon(Icons.star_border),
                      SizedBox(width: 10),
                      Text('120k',
                          style: GoogleFonts.montserrat(
                            textStyle: TextStyle(
                              color: Colors.white,
                              fontSize: mq.height * 0.018,
                              fontWeight: FontWeight.bold,
                            ),
                          )),
                    ],
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
