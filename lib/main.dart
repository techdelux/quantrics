import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:lmgmt/authScreen.dart';
import 'package:lmgmt/ui/listView.dart';
import 'package:lmgmt/utils/authentication.dart';
import 'package:url_strategy/url_strategy.dart';

void main() async {
  setPathUrlStrategy();
  await Firebase.initializeApp();
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Future getUserInfo() async {
    await getUser();
    setState(() {});
    print(uid);
  }

  @override
  void initState() {
    getUserInfo();

    super.initState();
  }

  Widget build(BuildContext context) {
    Widget _defaultHome = CallAuth();
    bool _result = (uid != null);
    if (_result) {
      _defaultHome = new CallInterface();
    }
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'QUANTRICS',
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
        backgroundColor: Colors.blueGrey[800],
        bottomAppBarColor: Colors.black,
        cardColor: Colors.blueGrey[800],
      ),
      // home: AuthDialog());
      // home: CallAuth());
      home: _defaultHome,
      routes: {
        // '/': (context) => LandingScreen(),
        '/login': (BuildContext context) => new CallAuth(),
        // '/home': (BuildContext context) => new HomePage(),
        '/home': (BuildContext context) => new CallInterface(),
      },
    );
  }
}
