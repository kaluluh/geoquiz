import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geoquiz/services/auth.dart';
import 'package:geoquiz/services/database.dart';
import 'package:provider/provider.dart';

import '../models/stats.dart';
import '../models/user.dart';


class HomePage extends StatelessWidget {
  const HomePage({Key? key, required this.auth}) : super(key: key);
  final AuthBase auth;

  Future<void> _signOut() async {
    try {
      await auth.signOut();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> _createUserDetails(BuildContext context) async {
    try{
      final database = Provider.of<Database>(context,listen:false);
      await database.setUserDeatils(
          User(auth.currentUser?.uid,"Klaudia", "Szucs", "Hungary"));
    } on FirebaseException catch(e){
      print(e.toString());
    }
  }

  _createRandomData(BuildContext context){
    final database = Provider.of<Database>(context,listen: false);
    _createUserDetails(context);
    database.setStats(Stats(2, 69, 666, 666));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GeoQuiz'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _signOut,
          ),
        ],
      ),
      body: _buildDashboard(context),
      backgroundColor: Colors.grey[200],
    );
  }

  Widget _buildDashboard(BuildContext context) {
    final database = Provider.of<Database>(context,listen: false);
    return StreamBuilder<User>(
        stream: database.userDetailStream(),
        builder: (context,snapshot){
          if(snapshot.hasData) {
            final userdata = snapshot.data!;
            final username = "${userdata.first_name} ${userdata.last_name}";

            final User user = snapshot.data!;
            return Column(
              children: [
                Text(
                  'Welcome $username',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 32.0, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 48.0),
                ElevatedButton(
                  onPressed: () {},
                  child: const Text('Start Quiz'),
                ),
                ElevatedButton(
                  // onPressed: () => {},
                  onPressed: () => _createRandomData(context),
                  child: const Text('Create Random Data to the Database'),
                ),
                _getStats(context),
              ],
            );
          }
          return const Center(child:CircularProgressIndicator());
        },
    );
  }

  Widget _getStats(BuildContext context) {
    final database = Provider.of<Database>(context,listen: false);
    return StreamBuilder<Stats>(
        stream: database.getStats(),
        builder: (context,snapshot) {
          // if(snapshot.hasData) {
            final stats = snapshot.data!;

            return Column(
              children: [
                Text(
                  'XP ${stats.XP}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 12.0, fontWeight: FontWeight.normal),
                ),
                Text(
                  'highscore ${stats.highscore}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 12.0, fontWeight: FontWeight.normal),
                ),
                Text(
                  'Best streak ${stats.best_streak}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 12.0, fontWeight: FontWeight.normal),
                ),Text(
                  'Level ${stats.level}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 12.0, fontWeight: FontWeight.normal),
                ),
              ],
            );
          }
        // }
    );
  }
}