import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import '../Providers/ApiProvider.dart';
import 'package:provider/provider.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class Lobby extends StatefulWidget {
  const Lobby({super.key});

  @override
  State<Lobby> createState() => _LobbyState();
}

class _LobbyState extends State<Lobby> {
  final _channel = WebSocketChannel.connect(
    Uri.parse('ws://192.168.42.49:80'),
  );

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<ApiProvider>(context);
    return Scaffold(
        appBar: AppBar(
          title: Text('poker table'),
        ),
        body: Center(
          child: Container(
              foregroundDecoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("graphics/table.jpg"),
                      fit: BoxFit.fill)),
              alignment: Alignment.center,
              child: StreamBuilder(
                  stream: _channel.stream,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(
                        child: const CircularProgressIndicator(),
                      );
                    } else {
                      provider.ConvertBytesToJson(snapshot.data);
                      return Text('has data');
                    }
                  })),
        )
        // child: ElevatedButton(
        //   child: Text('leave lobby'),
        //   onPressed: () =>
        //       {provider.LeaveGame(provider.MyUser), Navigator.pop(context)},
        // ),
        );
  }
}
