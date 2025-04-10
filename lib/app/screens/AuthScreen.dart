import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/logo.png',
                height: mq.height * 0.3,
                width: mq.width * 0.3,
              ),
              Text(
                "Gitgram",
                style: GoogleFonts.pacifico(
                  textStyle: TextStyle(
                    fontSize: mq.width * 0.1,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.all(mq.width * 0.04),
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text:
                        "by clicking following icon it opens up GitHub official authentication page , write creds to continue this proccess.",
                    style: TextStyle(
                      fontSize: mq.width * 0.04,
                      color: Colors.white,
                    ),
                  ),
                  TextSpan(
                    text: "No Account Required.",
                    style: TextStyle(
                      fontSize: mq.width * 0.04,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // button

          SizedBox(height: mq.height * 0.04),

          Container(
            height: mq.height * 0.07,
            width: mq.width * 0.9,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: const Color(0xff1B1F23),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.white,
                  child: Image.network(
                      'https://cdn.pixabay.com/photo/2022/01/30/13/33/github-6980894_960_720.png'),
                ),
                const SizedBox(width: 10),
                const Text(
                  "Login with GitHub",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: EdgeInsets.all(mq.width * 0.04),
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: "by accepting this you are agreeing our ",
                    style: TextStyle(
                      fontSize: mq.width * 0.04,
                      color: Colors.white,
                    ),
                  ),
                  TextSpan(
                    text: "terms ",
                    style: TextStyle(
                      fontSize: mq.width * 0.04,
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: "and",
                    style: TextStyle(
                      fontSize: mq.width * 0.04,
                      color: Colors.white,
                    ),
                  ),
                  TextSpan(
                    text: " conditions.",
                    style: TextStyle(
                      fontSize: mq.width * 0.04,
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
