import 'package:chatwithme/service/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomeScreen> {
  //String? user = FirebaseAuth.instance.currentUser!.email ?? FirebaseAuth.instance.currentUser!.displayName;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text('Friends List', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: false,
        actions: [
          IconButton(
              onPressed: () {
                //  Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (context) => SettingScreen()),
                // );
              },
              icon: FaIcon(
                FontAwesomeIcons.gear,
                size: 28,
              )),
          IconButton(
              onPressed: () {
                AuthService().signOut();
              },
              icon: FaIcon(
                FontAwesomeIcons.rightFromBracket,
                size: 28,
              )),
        ],
        backgroundColor: Color.fromARGB(255, 168, 5, 65),
      ),
    );
  }
}
