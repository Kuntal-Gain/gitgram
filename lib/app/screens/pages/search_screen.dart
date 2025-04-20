import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gitgram/utils/constants/color_const.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

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
            margin: EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: const Icon(
                    Icons.search,
                    color: Colors.grey,
                  ),
                ),
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Search',
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
          if (isSearching)
            Expanded(
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
