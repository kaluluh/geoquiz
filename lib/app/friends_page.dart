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
import '../services/firebase/validators.dart';

final updateFriendsList = StateProvider<bool>((ref) => false);

class FriendsPage extends ConsumerWidget with Keys, EmailLoginFormValidators {
  FriendsPage({Key? key}) : super(key: key);

  final TextEditingController _friendNameController = TextEditingController();
  final FocusNode _friendNameFocusNode = FocusNode();

  String get _friendName => _friendNameController.text;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AuthBase auth = Provider.of<AuthBase>(context);
    final ApplicationController userController = ApplicationController();
    userController.initializeUser(auth);


    final bottomNavigationIndex = ref.watch(pageNavigationProvider);
    return PageWrapper(
      backgroundImage: const AssetImage("assets/images/background_image.png"),
      bottomNav: createBottomNavigation(bottomNavigationIndex.index, (index) {
        changePage(ref, AppPageExtension.getByNavIndex(index));
      }),
      child: _buildContent(context, ref, userController),
    );
  }

  Widget _buildContent(BuildContext context, WidgetRef ref, ApplicationController userController) {
    final AuthBase auth = Provider.of<AuthBase>(context);
    final ApplicationController userController = ApplicationController();
    var updateList = ref.watch(updateFriendsList);
    return FutureBuilder(
      future: userController.getUserData(auth.currentUser!.uid),
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
              _buildAddFriendCard(context, ref, userDTO, userController),
              updateList ? const Center(
                child: CircularProgressIndicator(),
              ) : Expanded(child: _buildFriendsCard(context, ref, userDTO, userController)),
            ],
          ),
        );
        // return a widget here (you have to return a widget to the builder)
      });
  }

  Widget _buildAddFriendCard(BuildContext context, WidgetRef ref, UserDTO userDTO, ApplicationController userController) {
    return Card(
      color: Colors.white70,
      elevation: 10,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SpacedColumn(
          spacing: 10,
          children: [
            const Heading(text: "Add friend", level: Headings.h5),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: TextField(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Friend Code',
                    ),
                    controller: _friendNameController,
                    focusNode: _friendNameFocusNode,
                    textInputAction: TextInputAction.done,
                    enabled: !ref.read(updateFriendsList.notifier).state,
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () async {
                    if (_friendName.isNotEmpty) {
                      ref.read(updateFriendsList.notifier).state = true;
                      var auth = Provider.of<AuthBase>(context, listen: false);
                      await userController.addFriendByCode(auth.currentUser!.uid, _friendName);
                      // Wait for extra 1 second to show the loading indicator
                      await Future.delayed(const Duration(seconds: 1));
                      ref.read(updateFriendsList.notifier).state = false;
                      _friendNameController.clear();
                    }
                  },
                  child: const Text("Add"),
                ),
              ],
            ),
          ],
        )
      ),
    );
  }

  Widget _buildFriendsCard(BuildContext context, WidgetRef ref, UserDTO userDTO, ApplicationController userController) {
    return Card(
      color: Colors.white70,
      elevation: 10,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SpacedColumn(
          spacing: 10,
          children: [
            const Heading(text: "Friends", level: Headings.h5),
            ListView.builder(
              shrinkWrap: true,
              itemCount: userDTO.friends.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  leading: Avatar(
                    uid: userDTO.friends[index].uid,
                    name: userDTO.friends[index].name,
                    size: 36,
                  ),
                  title: Text("${userDTO.friends[index].name}#${userDTO.friends[index].uid.substring(0, 4)}")
                );
              },
            ),
          ],
        )
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
}
