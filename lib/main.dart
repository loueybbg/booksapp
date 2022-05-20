//@dart=2.9
import 'package:book_tracker/screens/get_started_page.dart';
import 'package:book_tracker/screens/login_page.dart';
import 'package:book_tracker/screens/main_screen.dart';
import 'package:book_tracker/screens/page_not_found.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider<User>(
          initialData: null,
          create: (context) => FirebaseAuth.instance.authStateChanges(),
        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'BookTracker',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),

        // initialRoute: '/',
        // routes: {
        //   '/': (context) => GetStartedPage(),
        //   '/main': (context) => MainScreenPage(),
        //   '/login': (context) => LoginPage()
        // },
        // home: LoginPage()

        initialRoute: '/',
        onGenerateRoute: (settings) {
          return MaterialPageRoute(
            builder: (context) {
              return RouteController(settingName: settings.name);
            },
          );
        },
        onUnknownRoute: (settings) {
          return MaterialPageRoute(
            builder: (context) {
              return PageNotFound();
            },
          );
        },
      ),
    );
  }
}

class RouteController extends StatelessWidget {
  final String settingName;

  const RouteController({Key key, this.settingName}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final userSignedIn = Provider.of<User>(context) != null;

    final signedInGotoMain =
        userSignedIn && settingName == '/main'; // they are good to go!
    final notSignedIngotoMain = !userSignedIn &&
        settingName == '/main'; // not signed in user trying to to the mainPage
    if (settingName == '/') {
      return const GetStartedPage();
    } else if (settingName == '/login' || notSignedIngotoMain) {
      return const LoginPage();
    } else if (signedInGotoMain) {
      return const MainScreenPage();
    } else {
      return PageNotFound();
    }
  }
}
