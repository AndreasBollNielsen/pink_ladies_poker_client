import 'dart:ui';
import 'package:provider/provider.dart';

import 'Lobby.dart';
import 'package:flutter/material.dart';
import '../Providers/ApiProvider.dart';

class Login extends StatefulWidget {
  Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<ApiProvider>(context);
    var myTextController = TextEditingController();
    return Center(
      child: Container(
        width: 350,
        height: 350,
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
              controller: myTextController,
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'user name',
                  hintText: 'Enter your desired user name'),
            ),
          ),
          // Padding(
          //   padding: const EdgeInsets.all(8.0),
          //   child: ElevatedButton(
          //     onPressed: () {
          //       provider.PlayGame(myTextController.text);
          //       //provider.GetAES();
          //       //provider.StartGame(myTextController.text);
          //       // Navigator.push(context,
          //       //     MaterialPageRoute(builder: (context) => const Lobby()));
          //     },
          //     child: const Text('Get keys'),
          //   ),
          // ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () async {
                // provider.GetAES();
                await provider.PlayGame(myTextController.text);
                // Navigator.push(context,
                //     MaterialPageRoute(builder: (context) => const Lobby()));
              },
              child: const Text('Start Game'),
            ),
          )
        ]),
      ),
    );
  }
}
