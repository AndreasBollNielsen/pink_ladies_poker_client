import 'dart:ui';
import 'package:provider/provider.dart';

import 'Lobby.dart';
import 'package:flutter/material.dart';
import '../Providers/ApiProvider.dart';

class Login extends StatefulWidget {
  const Login();

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<ApiProvider>(context);
    return Center(
      child: Container(
        width: 350,
        height: 250,
        margin: const EdgeInsets.all(10),
        color: Colors.amber,
        child: Column(children: [
          Container(
            width: 300,
            height: 100,
            child: Image.asset('graphics/flower.jpg'),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'user name',
                  hintText: 'Enter your desired user name'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {
                provider.GetAES();
                // Navigator.push(context,
                //     MaterialPageRoute(builder: (context) => const Lobby()));
              },
              child: const Text('Login'),
            ),
          )
        ]),
      ),
    );
  }
}
