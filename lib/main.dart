import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ux_cam_issue/home.dart';
import 'package:ux_cam_issue/login.dart';
import 'package:ux_cam_issue/ux_cam.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // This widget is the root of your application.
    // initialize the UXCam
    UXCam().initialize();

    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FutureBuilder<String?>(
        future: getCurrentUser(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.none ||
              snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasData) {
            return const Home();
          }

          return const Login();
        },
      ),
    );
  }

  /// get the current user from shared prefs.
  Future<String?> getCurrentUser() async {
    var prefs = await SharedPreferences.getInstance();
    return prefs.getString("user");
  }
}
