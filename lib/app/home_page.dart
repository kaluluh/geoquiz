import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:geoquiz/models/city.dart';
import 'package:geoquiz/services/auth.dart';
import 'package:geoquiz/services/database.dart';
import 'package:provider/provider.dart';

import '../main.dart';
import '../models/stats.dart';
import '../models/user.dart';
import '../services/city_data_service.dart';


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

  _createInitData(BuildContext context){
    final database = Provider.of<Database>(context,listen: false);
    var name = auth.currentUser?.isAnonymous == true ? "anonymous": auth.currentUser?.email?.split('@')[0];
    if( name != null) {
      database.setUserDeatils(User(auth.currentUser?.uid,name, "Hungary"));
    }
    database.setStats(Stats(0, 0, 0, 0,0));
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
    _createInitData(context);
    return StreamBuilder<User>(
        stream: database.userDetailStream(),
        builder: (context,snapshot){
          if(snapshot.hasData) {
            final userdata = snapshot.data!;
            final User user = snapshot.data!;
            return Column(
              children: [
                Text(
                  'Welcome ${userdata.name}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 32.0, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 48.0),
                ElevatedButton(
                  onPressed: () {},
                  child: const Text('Start Quiz'),
                ),
                _getStats(context),
                _getCityData(context)
              ],
            );
          }
          return const Center(child:CircularProgressIndicator());
        },
    );
  }

  Widget _getCityData(BuildContext context) {
    var city = CityDaraService.fetchCityData("Budapest");
    return FutureBuilder<City>(
        future: city,
        builder: (context, snapshot) {
      if (snapshot.hasData) {
        return Text(snapshot.data!.name);
      } else if (snapshot.hasError) {
        return Text('${snapshot.error}');
      }
      return const CircularProgressIndicator();
      },
    );
  }


  Widget _getStats(BuildContext context) {
    final database = Provider.of<Database>(context,listen: false);
    return StreamBuilder<Stats>(
        stream: database.getStats(),
        builder: (context,snapshot) {
          if(snapshot.hasData) {
            final stats = snapshot.data!;
            return Column(
              children: [
                Text(
                  'XP ${stats.xp}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
                ),
                Text(
                  'highscore ${stats.highScore}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
                ),
                Text(
                  'Best streak ${stats.bestStreak}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
                ),Text(
                  'Level ${stats.level}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
                ), Text(
                'Leader board ${stats.leaderBoard}',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
                ),
              ],
            );
          }
          return const Center(child:CircularProgressIndicator());
        }
    );
  }
}
