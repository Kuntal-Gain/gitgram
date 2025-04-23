import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gitgram/app/screens/pages/user_screen.dart';
import 'package:gitgram/data/models/user_model.dart';
import 'package:gitgram/domain/entities/user_entity.dart';
import 'package:gitgram/utils/constants/color_const.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class SearchScreen extends StatefulWidget {
  final UserEntity user;
  const SearchScreen({super.key, required this.user});
  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  Future<Map<String, dynamic>> searchGitHubUsers(String query) async {
    final url = Uri.parse('https://api.github.com/search/users?q=$query');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    } else {
      throw Exception('GitHub search failed: ${response.statusCode}');
    }
  }

  Future<UserEntity> getUserData({required String username}) async {
    final url = Uri.parse('https://api.github.com/users/$username');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      return UserModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('GitHub user data failed: ${response.statusCode}');
    }
  }

  bool isSearching = false;

  List<Map<String, dynamic>> searchResults = [];
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        surfaceTintColor: Colors.black,
        automaticallyImplyLeading: false,
        title: Text(
          'Search',
          style: GoogleFonts.pacifico(
            color: Colors.white,
            fontSize: 28,
          ),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 16),
          Container(
            height: mq.height * 0.06,
            width: mq.width,
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12.0),
                  child: Icon(
                    Icons.search,
                    color: Colors.grey,
                  ),
                ),
                Expanded(
                  child: TextField(
                    style: const TextStyle(color: Colors.black),
                    controller: _controller,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Search',
                      fillColor: Colors.black,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    final query = _controller.text;
                    setState(() {
                      isSearching = true;
                    });

                    searchGitHubUsers(query).then((data) {
                      setState(() {
                        searchResults =
                            List<Map<String, dynamic>>.from(data['items']);
                        isSearching = false;
                        _controller.clear();
                      });
                    });
                  },
                  icon: const Icon(
                    Icons.arrow_circle_right_sharp,
                    size: 40,
                    color: AppColor.blackColor,
                  ),
                )
              ],
            ),
          ),
          const SizedBox(height: 16),
          if (isSearching)
            const Expanded(
              child: Center(
                child: CircularProgressIndicator(
                  color: Colors.green,
                ),
              ),
            )
          else
            Expanded(
              child: ListView.builder(
                itemCount: searchResults.length,
                itemBuilder: (context, index) {
                  final result = searchResults[index];
                  return ListTile(
                    onTap: () async {
                      final res = await getUserData(username: result['login']);

                      Navigator.push(
                        // ignore: use_build_context_synchronously
                        context,
                        MaterialPageRoute(
                          builder: (context) => UserProfileScreen(
                            user: res,
                            isCurrentUser: false,
                            curr_user: widget.user,
                            isSearch: true,
                          ),
                        ),
                      );
                    },
                    title: Text(result['login']),
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(result['avatar_url']),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
