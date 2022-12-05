import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' show ConsumerWidget, StateProvider, WidgetRef;
import 'package:geoquiz/common/colors.dart';
import 'package:geoquiz/common/headings.dart';
import 'package:geoquiz/common/keys.dart';
import 'package:geoquiz/controller/application_controller.dart';
import 'package:provider/provider.dart';

import '../common/avatar.dart';
import '../common/navigation.dart';
import '../common/page_wrapper.dart';
import '../common/spaced_column.dart';
import '../controller/dtos/userdto.dart';
import '../services/firebase/auth.dart';

class DashboardPage extends ConsumerWidget with Keys {
  const DashboardPage({Key? key}) : super(key: key);

  Future<void> _signOut(AuthBase auth) async {
    try {
      await auth.signOut();
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AuthBase auth = Provider.of<AuthBase>(context);
    final ApplicationController userController = ApplicationController();

    final bottomNavigationIndex = ref.watch(pageNavigationProvider);
    return PageWrapper(
      backgroundImage: const AssetImage("assets/images/background_image.png"),
      bottomNav: createBottomNavigation(bottomNavigationIndex.index, (index) {
        changePage(ref, AppPageExtension.getByNavIndex(index));
      }),
      child: _buildContent(context, ref),
    );
  }

  Future<UserDTO> _getUserData(AuthBase auth, ApplicationController userController) async {
    await userController.initializeUser(auth);
    return await userController.getUserData(auth.currentUser!.uid);
  }

  Widget _buildContent(BuildContext context, WidgetRef ref) {
    final AuthBase auth = Provider.of<AuthBase>(context);
    final ApplicationController userController = ApplicationController();
    return FutureBuilder(
      future: _getUserData(auth, userController),
      builder: (BuildContext context, AsyncSnapshot<UserDTO> snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        final UserDTO userDTO = snapshot.data!;
        return Padding(
          padding: const EdgeInsets.fromLTRB(8.0, 48.0, 8.0, 8.0),
          child: SpacedColumn(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: 20,
            children: [
              _buildProfileCard(context, ref, userDTO),
              _buildStatsCard(context, ref, userDTO),
              _buildPlayCard(context, ref, userDTO),
            ],
          ),
        );
        // return a widget here (you have to return a widget to the builder)
    });
  }

  Widget _buildProfileCard(BuildContext context, WidgetRef ref, UserDTO userDTO) {
    final AuthBase auth = Provider.of<AuthBase>(context);
    return Card(
      color: Colors.white70,
      elevation: 10,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SpacedColumn(
          children: [
            Row(
              children: [
                Avatar(uid: userDTO.uid, name: userDTO.name, size: 60),
                const SizedBox(
                  width: 16,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Show elipsis if name is too long
                    Row(
                      children: [
                        Text(
                          "${userDTO.name.length > 14 ? "${userDTO.name.substring(0, 12)}..." : userDTO.name}#${userDTO.uid.substring(0, 4)}",
                          style: Theme.of(context).textTheme.headline6,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        buildLevelBadge(userDTO.level),
                      ],
                    ),
                    _buildXpBar(userDTO),
                  ],
                ),
                const SizedBox(
                  width: 16,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.logout),
                        onPressed: () => _signOut(auth),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ]
        ),
      ),
    );
  }

  Widget buildLevelBadge(int level) {
    // Use assets/images/hexagon_icon.png as the background image
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/hexagon_icon.png"),
          fit: BoxFit.contain,
          filterQuality: FilterQuality.high,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(11.0),
        child: Text(
          level.toString(),
          style: const TextStyle(fontSize: 16),
        ),
      ),
    );
  }

  Widget _buildXpBar(UserDTO userDTO) {
    return Text(
      "XP: ${userDTO.xp} / 1000",
      style: const TextStyle(fontSize: 16),
    );
  }


  Widget _buildStatsCard(BuildContext context, WidgetRef ref, UserDTO userDTO) {
    return Card(
      color: Colors.white70,
      elevation: 10,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SpacedColumn(
          crossAxisAlignment: CrossAxisAlignment.center,
          spacing: 20,
          children: [
            const Heading(text: "Your Stats", level: Headings.h2),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildStatBadge("assets/images/stats_icon.png", "Highscore", userDTO.highScore.toString()),
                _buildStatBadge("assets/images/game_played_icon.png", "Games Played", userDTO.leaderBoard.toString()),
                _buildStatBadge("assets/images/fire_icon.png", "Best Streak", userDTO.bestStreak.toString()),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildStatBadge(String image, String text, String value) {
    return SpacedColumn(
      children: [
        Container(
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.backgroundLight,
          ),
          child: Image(
            image: AssetImage(image),
            width: 100,
            height: 100,
            filterQuality: FilterQuality.high,
          ),
        ),
        Heading(
          text: text,
          level: Headings.h6,
          styleOverride: const TextStyle(color: AppColors.textDarkSecondary),
        ),
        Text(
          value,
          style: const TextStyle(fontSize: 24),
        ),
      ]
    );
  }


  Widget _buildPlayCard(BuildContext context, WidgetRef ref, UserDTO userDTO) {
    return Container(
      height: 100,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: () {
                changePage(ref, AppPage.gameSelection);
              },
              style: ElevatedButton.styleFrom(
                primary: AppColors.primary,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
              ),
              child: const Text(
                "Quick Play",
                style: TextStyle(
                  fontSize: 20,
                ),
              )),
          ],
        )
      ),
    );
  }
}
