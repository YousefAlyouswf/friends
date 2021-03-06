import 'package:flutter/material.dart';
import 'package:new_chat/services/helperFunctions.dart';
import 'package:new_chat/toggel/toggelSigninAndSignup.dart';
import 'package:new_chat/views/chatRooms.dart';
import 'dart:ui' as ui;
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool alreadySigned = false;
  @override
  void initState() {
    super.initState();

    HelperFunction.getUserLoggedIn().then((value) {
      setState(() {
        if (value == null) {
          alreadySigned = false;
        } else {
          alreadySigned = value;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    String _sysLng = ui.window.locale.languageCode;
    HelperFunction.saveUserLanguage(_sysLng);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: [
        // ... app-specific localization delegate[s] here
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('en'), // English
        const Locale('ar'), // Arabic
      ],
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: alreadySigned ? ChatRooms() : ToggleSigninAndSignup(),
    );
  }
}
