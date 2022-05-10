import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ux_cam_issue/login.dart';
import 'package:ux_cam_issue/ux_cam.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text("Click on the below button to logout"),
          const SizedBox(height: 16),
          TextButton(
              onPressed: () async {
                // remove the user from prefs
                var prefs = await SharedPreferences.getInstance();
                await prefs.remove("user");

                // stop the ux_cam session
                UXCam().stopSession();

                // navigate to login screen
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => const Login()));
              },
              child: const Text("Logout")),
        ],
      ),
    );
  }
}
