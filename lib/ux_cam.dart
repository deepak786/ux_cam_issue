import 'package:flutter/material.dart';
import 'package:flutter_uxcam/flutter_uxcam.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UXCam {
  /// to create a single instance
  factory UXCam() {
    _instance ??= UXCam._();
    return _instance!;
  }

  UXCam._();

  static UXCam? _instance;

  /// initialize the UXCam.
  /// This generally should be called in root widget of the app.
  Future<void> initialize() async {
    var prefs = await SharedPreferences.getInstance();
    var user = prefs.getString("user");

    // initialize the UXCam https://uxcam-documentation.readme.io/docs/flutter
    // this method is called to comply with Apple's privacy guidelines
    await FlutterUxcam.optIntoSchematicRecordings().then((value) {
      debugPrint(">>UXCam optIntoSchematicRecordings done");
    });

    // start the UXCam
    // TODO add the app key
    FlutterUxConfig config = FlutterUxConfig(userAppKey: "");
    await FlutterUxcam.startWithConfiguration(config).then((value) {
      debugPrint(">>UXCam startWithConfiguration done");
    });

    if (user == null) {
      debugPrint(">>UXCam user is null so opting out.");
      // currently there is no user loggedIn.
      // optOutOverall: this will disable the recordings. We want to have the recordings
      // on demand such as if the user is loggedIn. https://uxcam-documentation.readme.io/docs/opt-in-opt-out#opt-out-a-user
      // by default it is already optIn. So recording will started as soon as UXCam is initialized.
      await FlutterUxcam.optOutOverall().then((value) {
        debugPrint(">>UXCam optOutOverall done");
      });

      // cancel the current session if it is recording already
      await FlutterUxcam.cancelCurrentSession().then((value) {
        debugPrint(">>UXCam cancelCurrentSession done");
      });

      // verify the isRecording
      await FlutterUxcam.isRecording().then((value) {
        debugPrint(">>UXCam isRecording >>>>> $value");
      });
    } else {
      debugPrint(">>UXCam user is not null so setting the userIdentity.");
      // user is already loggedIn so set the session identity
      await FlutterUxcam.setUserIdentity(user).then((value) {
        debugPrint(">>UXCam setUserIdentity done.");
      });
    }
  }

  /// start a new session of UXCam.
  /// Generally when a user is loggedIn.
  Future<void> startNewSession() async {
    var prefs = await SharedPreferences.getInstance();
    var user = prefs.getString("user");
    if (user == null) {
      debugPrint(">>UXCam user is null");
      return;
    }
    // check if the session is already recording
    bool isRecording = await FlutterUxcam.isRecording();
    if (isRecording) {
      // session is already recording
      // so do nothing.
      debugPrint(">>UXCam recording session is already recording");
    } else {
      // optIn for the recordings https://uxcam-documentation.readme.io/docs/opt-in-opt-out#opt-in-a-user
      await FlutterUxcam.optInOverall();
      // set the user identity to new session
      await FlutterUxcam.setUserIdentity(user);
      // check if the recording already started
      bool sessionAlreadyStarted = await FlutterUxcam.isRecording();
      if (sessionAlreadyStarted) {
        // on iOS it seems that the session recording started after calling optInOverall.
        // because if startNewSession is called here then the UXCam dashboard shows a recording of 1 second.
        // Which means previous session was already there.
        // So a check is added to check if there is session already started after optInOverall.
        // if not then the new session will started.
        debugPrint(
            ">>UXCam new recording session is already started without calling startNewSession");
      } else {
        // start the UXCam recording session
        await FlutterUxcam.startNewSession();
        debugPrint(">>UXCam new recording session started");
      }
    }
  }

  /// stop the current UXCam session.
  /// This will upload the current session.
  Future<void> stopSession() async {
    // stop the UXCam session and upload the session recording.
    await FlutterUxcam.stopSessionAndUploadData();
    // optOut from the recordings until the user logs in.
    await FlutterUxcam.optOutOverall();
  }
}
