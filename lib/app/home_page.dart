import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:geoquiz/models/city.dart';
import 'package:geoquiz/services/auth.dart';
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
      backgroundColor: Colors.grey[200],
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
}
