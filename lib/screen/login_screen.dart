import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatwithme/service/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 100,
            ),
            CachedNetworkImage(
              imageUrl:
                  'https://img.freepik.com/free-vector/human-hand-holding-mobile-phone-with-text-messages_74855-6531.jpg',
            ),
            SizedBox(
              height: 40,
            ),
            Text(
              'Welcome To',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 34,
              ),
            ),
            Text(
              'Chat With Me',
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 30,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                textAlign: TextAlign.center,
                'enjoy chatting with random people and stay in touch with them but before that i need you to sign in with your google account please !!',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: SizedBox(
                height: 40,
                width: 230,
                child: ElevatedButton(
                    onPressed: () {
                      AuthService().signInWithGoogle();
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        FaIcon(FontAwesomeIcons.google),
                        Text('Continue with Google',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
