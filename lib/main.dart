import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:geoquiz/app/landing_page.dart';
import 'package:geoquiz/services/auth.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const GeoQuizApp());
}

class GeoQuizApp extends StatelessWidget {
  const GeoQuizApp({Key? key, bool useMockAuth = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Provider<AuthBase>(
      create: (_) => Auth(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'GeoQuiz',
        theme: ThemeData(
          primarySwatch: Colors.indigo,
        ),
        home: const LandingPage(),
      ),
    );
  }
}
