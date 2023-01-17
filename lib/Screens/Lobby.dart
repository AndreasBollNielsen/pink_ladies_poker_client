import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import '../Providers/ApiProvider.dart';
import 'package:provider/provider.dart';
import '../Helpers/Config.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../Widgets/UserWidget.dart';

class Lobby extends StatefulWidget {
  const Lobby({super.key});

  @override
  State<Lobby> createState() => _LobbyState();
}

class _LobbyState extends State<Lobby> {
  final _channel = WebSocketChannel.connect(
    Uri.parse('ws://${Config.IP}:${Config.Port}'),
  );

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<ApiProvider>(context);
    return Container(
      child: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              child: Image.asset("graphics/table.jpg"),
            ),
            StreamBuilder(
              stream: _channel.stream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  print("running");
                  return Center(
                    child: SizedBox(
                      height: 100,
                      width: 100,
                      child: const CircularProgressIndicator(),
                    ),
                    // child: Stack(
                    //   children: [
                    //     Text('test'),
                    //     Positioned(child: UserWidget(user: 'test')),
                    //   ],
                    // ),
                  );
                } else if (snapshot.connectionState == ConnectionState.active) {
                  if (snapshot.hasData) {
                    print('got data');
                    provider.ConvertBytesToJson(snapshot.data);
                    setState(() {});
                    return Text('has data');
                  } else {
                    return Text('no data');
                  }

                  // provider.ConvertBytesToJson(snapshot.data);
                  // return Stack(
                  //   children: [
                  //     Positioned(child: UserWidget(user: 'test')),
                  //   ],

                } else {
                  return Text('State: ${snapshot.connectionState}');
                }
              },
            ),
            Stack(
              children: [
                Positioned(
                    bottom: 45,
                    left: 350,
                    child: UserWidget(user: provider.MyUser)),
                Positioned(
                  left: 0,
                  top: 25,
                  child: ElevatedButton(
                    onPressed: () => {
                      Navigator.pop(context),
                    },
                    child: Text('return'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}







         // child: ElevatedButton(
        //   child: Text('leave lobby'),
        //   onPressed: () =>
        //       {provider.LeaveGame(provider.MyUser), Navigator.pop(context)},
        // ),