import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' show ConsumerWidget, ProviderScope, WidgetRef;
import 'package:geoquiz/app/game_page.dart';
import 'package:geoquiz/app/intro_page.dart';
import 'package:geoquiz/game/game_controller.dart';
import 'package:provider/provider.dart';
import '../common/navigation.dart';
import 'dashboard_page.dart';

import '../services/firebase/auth.dart';
import 'game_select_page.dart';

class LandingPage extends ConsumerWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = Provider.of<AuthBase>(context, listen: true);
    return StreamBuilder<User?>(
      stream: auth.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          final User? user = snapshot.data;
          var activePage = ref.watch(pageNavigationProvider);
          if (user == null) {
            return const IntroductionPage();
          }
          return activePage.page;
        }
        return Container(
          color: Colors.white,
          child: const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          ),
        );
      },
    );
  }
}