import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_app/controllers/authentication.dart';
import 'package:my_app/views/main_layout.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);

  final AuthenticationController _authController = Get.put(AuthenticationController());

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      title: 'Home Page',
      actions: [
        IconButton(
          icon: Icon(Icons.logout),
          onPressed: () {
            _authController.logout();
          },
        ),
      ],
      child: _buildHomeContent(),
    );
  }

  Widget _buildHomeContent() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Text(
            'Welcome to the Home Page!',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              print('Button pressed!');
            },
            child: const Text('Press Me'),
          ),
        ],
      ),
    );
  }
}