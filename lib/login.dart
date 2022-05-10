import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'package:ux_cam_issue/home.dart';
import 'package:ux_cam_issue/ux_cam.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text("Click on the below button to login"),
          const SizedBox(height: 16),
          TextButton(
              onPressed: () async {
                // generate a random uid
                var user = const Uuid().v1();
                // save this id in prefs
                var prefs = await SharedPreferences.getInstance();
                await prefs.setString("user", user);

                // start the ux_cam session
                UXCam().startNewSession();

                // navigate to home screen
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => const Home()));
              },
              child: const Text("Login")),
        ],
      ),
    );
  }
}
