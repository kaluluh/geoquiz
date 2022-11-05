import 'package:flutter/material.dart';
import 'package:geoquiz/services/auth.dart';

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
      body: _buildContent(),
      backgroundColor: Colors.grey[200],
    );
  }

  Widget _buildContent() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Welcome ${auth.currentUser?.displayName ?? ''}!',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 32.0, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 48.0),
          ElevatedButton(
            onPressed: () {},
            child: const Text('Start Quiz'),
          ),
        ],
      ),
    );
  }
}