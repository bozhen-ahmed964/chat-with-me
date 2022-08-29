import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SettingScreen extends StatefulWidget {
  SettingScreen({Key? key}) : super(key: key);

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text('Settings', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: false,
        leading: (IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: FaIcon(
              FontAwesomeIcons.arrowLeftLong,
              size: 28,
            ))),
        backgroundColor: Color.fromARGB(255, 168, 5, 65),
      ),

    );
  }
}


class SettingScreenState extends StatefulWidget {
  SettingScreenState({Key? key}) : super(key: key);

  @override
  State<SettingScreenState> createState() => _SettingScreenStateState();
}

class _SettingScreenStateState extends State<SettingScreenState> {



  @override
  Widget build(BuildContext context) {
    return Container();
  }
}