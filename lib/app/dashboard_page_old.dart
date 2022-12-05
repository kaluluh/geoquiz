import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' show StateProvider;
import 'package:geoquiz/common/keys.dart';
import 'package:geoquiz/controller/application_controller.dart';
import 'package:provider/provider.dart';

import '../common/navigation.dart';
import '../common/page_wrapper.dart';
import '../controller/dtos/userdto.dart';
import '../services/firebase/auth.dart';

enum DashboardSubPage { dashboard, profile, games }

final dashboardSubPageProvider = StateProvider<DashboardSubPage>((ref) => DashboardSubPage.games);

class DashboardPage extends StatelessWidget with Keys {
  const DashboardPage({Key? key}) : super(key: key);

  Future<void> _signOut(AuthBase auth) async {
    try {
      await auth.signOut();
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final AuthBase auth = Provider.of<AuthBase>(context);
    final ApplicationController userController = ApplicationController();
    userController.initializeUser(auth);
    return PageWrapper(
      backgroundImage: const AssetImage("assets/images/background_image.png"),
      // bottomNav: createBottomNavigation(),
      child: _buildContent(auth),
    );
  }

  Widget _buildContent(AuthBase auth) {
    final ApplicationController userController = ApplicationController();
    return FutureBuilder(
        future: userController.getUserData(auth.currentUser!.uid),
        builder: (BuildContext context, AsyncSnapshot<UserDTO> snapshot) {
          if (!snapshot.hasData) return Container(); // still loading
          // alternatively use snapshot.connectionState != ConnectionState.done
          final UserDTO userDTO = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildNameContainer(userDTO),
                const SizedBox(
                  height: 40.0,
                ),
                _buildStatsContainer(userDTO),
                const SizedBox(
                  height: 50.0,
                ),
                _displayButtons(auth),
                const SizedBox(
                  height: 30.0,
                ),
                // _buildFriendsContainer(userDTO)
              ],
            ),
          );
          // return a widget here (you have to return a widget to the builder)
        });
  }

  Widget _buildNameContainer(UserDTO userDTO) {
    return Container(
      height: 120.0,
      width: double.infinity,
      child: Card(
          color: Colors.white54,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Column(
                children: [
                  Row(
                    children: [
                      Image.asset(
                        'assets/images/woman_avatar.png',
                        width: 69.0,
                        height: 69.0,
                      ),
                      const SizedBox(
                        width: 40,
                      ),
                      Text(
                        userDTO.name,
                        style: const TextStyle(
                          fontSize: 22.0,
                          fontWeight: FontWeight.bold,
                          color: Color.fromRGBO(0, 0, 0, 1),
                        ),
                      ),
                      const SizedBox(width: 12,),
                      Container(
                        height: 50,
                        width: 50,
                        decoration: const BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage(
                                  'assets/images/hexagon_icon.png'),
                              fit: BoxFit.cover,
                            )
                        ),
                        child: Column(
                          children: [
                            const SizedBox(height: 12),
                            Text(
                              '${userDTO.level}',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold
                              ),
                            ),
                          ],
                        ),
                      ),
                    ]
                  ),
                  Row(
                    children: [
                     const SizedBox(width: 80,),
                      Text(
                        "XP: ${userDTO.xp}/500",
                        style: const TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.normal,
                          color: Color.fromRGBO(0, 0, 0, 1),
                        ),
                      ),
                    ],
                  ),
            ]),
          )),
    );
  }

  Widget _buildStatsContainer(UserDTO userDTO) {
    return Container(
      height: 240.0,
      width: double.infinity,
      child: Card(
        color: Colors.white54,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/stats_icon.png',
                    width: 90.0,
                    height: 90.0,
                  ),
                  const SizedBox(
                    width: 70,
                    height: 140,
                  ),
                  Image.asset(
                    'assets/images/fire_icon.png',
                    width: 90.0,
                    height: 90.0,
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [
                  Text(
                    "HighScore",
                    style: TextStyle(
                      fontSize: 22.0,
                      fontWeight: FontWeight.bold,
                      color: Color.fromRGBO(0, 0, 0, 1),
                    ),
                  ),
                  SizedBox(
                    width: 50,
                  ),
                  Text(
                    "Best Streak",
                    style: TextStyle(
                      fontSize: 22.0,
                      fontWeight: FontWeight.bold,
                      color: Color.fromRGBO(0, 0, 0, 1),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "${userDTO.highScore}",
                    style: const TextStyle(
                      fontSize: 21.0,
                      fontWeight: FontWeight.bold,
                      color: Color.fromRGBO(0, 0, 0, 1),
                    ),
                  ),
                  const SizedBox(
                    width: 145,
                  ),
                  Text(
                    "${userDTO.bestStreak}",
                    style: const TextStyle(
                      fontSize: 21.0,
                      fontWeight: FontWeight.bold,
                      color: Color.fromRGBO(0, 0, 0, 1),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _displayButtons(auth) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ElevatedButton.icon(
          onPressed: () => {},
          label: const Text(
            "QuickPlay",
            style: TextStyle(
              fontSize: 18.0,
            ),
          ),
          icon: const Icon(
            Icons.arrow_forward_ios_outlined,
            size: 18.0,
          ),
          style: ElevatedButton.styleFrom(
            primary: const Color.fromRGBO(253, 205, 28, 1),
            shadowColor: Colors.black,
            minimumSize: const Size(30.0, 70.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
          ),
        ),
        SizedBox(width: 50.0),
        ElevatedButton.icon(
          onPressed: () => _signOut(auth),
          label: const Text(
            "Sign out",
            style: TextStyle(
              fontSize: 18.0,
            ),
          ),
          icon: const Icon(
            Icons.logout,
            size: 20.0,
          ),
          style: ElevatedButton.styleFrom(
            primary: const Color.fromRGBO(11, 11, 56, 1),
            minimumSize: const Size(30.0, 70.0),
            shadowColor: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFriendsContainer(userDTO) {
    return Container(
      height: 150.0,
      width: double.infinity,
      child: Card(
        color: Colors.white54,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                children: [
                  const Text("Friends"),
                  const SizedBox(
                    width: 20.0,
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: ElevatedButton.icon(
                      onPressed: () => {},
                      label: const Text(
                        "add Friends",
                        style: TextStyle(
                          fontSize: 14.0,
                        ),
                      ),
                      icon: const Icon(
                        Icons.add,
                        size: 16.0,
                      ),
                      style: ElevatedButton.styleFrom(
                        primary: const Color.fromRGBO(30, 197, 187, 1),
                        minimumSize: const Size(10.0, 10.0),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10.0,
              ),
              Text("Name"),
              Divider(
                color: Colors.black,
              ),
              Text("Name"),
              Divider(
                color: Colors.black,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
