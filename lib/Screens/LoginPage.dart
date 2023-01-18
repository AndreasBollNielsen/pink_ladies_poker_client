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
    return Container(
      child: Center(
          child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            color: Colors.black,
          ),
          Container(
            child: Image.asset("graphics/table.jpg"),
          ),
          Container(
            width: 350,
            height: 350,
            margin: const EdgeInsets.all(10),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 300,
                    height: 20,
                    child: DefaultTextStyle(
                      style: TextStyle(color: Colors.white, fontSize: 15),
                      textAlign: TextAlign.center,
                      child: Text('Vælg venligst et brugernavn'),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: myTextController,
                      style: TextStyle(color: Colors.pinkAccent),
                      decoration: InputDecoration(
                          labelStyle:
                              TextStyle(color: Colors.white, fontSize: 15),
                          hintStyle:
                              TextStyle(color: Colors.white, fontSize: 15),
                          enabledBorder: new OutlineInputBorder(
                            borderRadius: new BorderRadius.circular(5.0),
                            borderSide: BorderSide(color: Colors.pink),
                          ),
                          focusedBorder: new OutlineInputBorder(
                            borderRadius: new BorderRadius.circular(5.0),
                            borderSide: BorderSide(color: Colors.pink),
                          ),
                          hintText: 'Indtast ønsket brugernavn'),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: () async {
                        // provider.GetAES();
                        await provider.PlayGame(myTextController.text);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Lobby()));
                      },
                      child: const Text('Start Spil'),
                    ),
                  )
                ]),
          ),
        ],
      )),
    );
  }
}
