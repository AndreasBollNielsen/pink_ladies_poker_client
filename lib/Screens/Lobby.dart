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
    var myTextController = TextEditingController();
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
                  //  var users = provider.ConvertJsonToModel(snapshot.data);
                  // var positions = provider.GetPositions();
                  // var users = provider.GetFakeUsers();
                  return Stack(
                    children: [
                      // Positioned(
                      //   bottom: 25,
                      //   left: 325,
                      //   child: UserWidget(user: provider.MyUser),
                      // ),
                      // for (int i = 0; i < users.length; i++)
                      //   Positioned(
                      //     left: positions[i].left,
                      //     bottom: positions[i].bottom,
                      //     child: UserWidget(user: users[i]),
                      //   ),
                      const CircularProgressIndicator()
                    ],
                  );

                  // return Center(
                  //   child: Container(
                  //     // color: Colors.blue,
                  //     width: 650,
                  //     height: 300,
                  //     child: Stack(
                  //       fit: StackFit.loose,
                  //       children: [
                  //         Positioned(
                  //             bottom: 0,
                  //             left: 275,
                  //             child: UserWidget(user: provider.MyUser)),
                  //         Positioned(
                  //             bottom: 0,
                  //             left: 125,
                  //             child: UserWidget(user: provider.MyUser)),
                  //         Positioned(
                  //             bottom: 0,
                  //             left: 420,
                  //             child: UserWidget(user: provider.MyUser)),
                  //         Positioned(
                  //             bottom: 75,
                  //             left: 50,
                  //             child: UserWidget(user: provider.MyUser)),
                  //         Positioned(
                  //             bottom: 200,
                  //             left: 50,
                  //             child: UserWidget(user: provider.MyUser)),
                  //         Positioned(
                  //             bottom: 230,
                  //             left: 200,
                  //             child: UserWidget(user: provider.MyUser)),
                  //         Positioned(
                  //             bottom: 230,
                  //             left: 375,
                  //             child: UserWidget(user: provider.MyUser)),
                  //         Positioned(
                  //             bottom: 200,
                  //             left: 525,
                  //             child: UserWidget(user: provider.MyUser)),
                  //         Positioned(
                  //             bottom: 100,
                  //             left: 525,
                  //             child: UserWidget(user: provider.MyUser)),
                  //         Positioned(
                  //           left: 300,
                  //           top: 125,
                  //           child: SizedBox(
                  //             height: 50,
                  //             width: 50,
                  //             child: const CircularProgressIndicator(),
                  //           ),
                  //         ),
                  //       ],
                  //     ),
                  //   ),
                  // );
                } else if (snapshot.connectionState == ConnectionState.active) {
                  if (snapshot.hasData) {
                    print('got data');
                    var users = provider.ConvertJsonToModel(snapshot.data);
                    var positions = provider.GetPositions();

                    return Stack(
                      children: [
                        Positioned(
                          bottom: 25,
                          left: 325,
                          child: UserWidget(user: provider.MyUser),
                        ),
                        Center(
                          child: Container(
                            width: 60,
                            height: 90,
                            child: Row(
                              children: [
                                // for (int i = 0;i < provider.pokerTable.collectiveCards.length; i++)
                                // Image.asset("${provider.pokerTable.collectiveCards[i]}.jpg"),
                              ],
                            ),
                          ),
                        ),
                        // for(var i in users) UserWidget(user: i)
                        for (int i = 0; i < users.length; i++)
                          Positioned(
                            left: positions[i].left,
                            bottom: positions[i].bottom,
                            child: UserWidget(user: users[i]),
                          ),
                      ],
                    );
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
                // Positioned(
                //     bottom: 45,
                //     left: 350,
                //     child: UserWidget(user: provider.MyUser)),
                Positioned(
                  left: 0,
                  top: 25,
                  child: ElevatedButton(
                    onPressed: () => {
                      provider.LeaveGame(provider.MyUser),
                      Navigator.pop(context),
                    },
                    child: Text('Leave'),
                  ),
                ),
                Positioned(
                  bottom: 20,
                  left: 200,
                  child: Center(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(1.0),
                          child: ElevatedButton(
                            onPressed: () => {
                              //call api
                              Navigator.pop(context),
                            },
                            child: Text('Call'),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(1.0),
                          child: ElevatedButton(
                            onPressed: () => {
                              //call api
                            },
                            child: Text('Fold'),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () => {
                            //call api
                          },
                          child: Text('Check'),
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.only(left: 10, top: 0, right: 0),
                          child: ElevatedButton(
                            onPressed: () => {
                              //call api
                              provider.MyUser.State = 'bet',
                              provider.UserInteraction(provider.MyUser),
                            },
                            child: Text('Bet'),
                          ),
                        ),
                        Material(
                          child: Container(
                            width: 100,
                            height: 35,
                            color: Colors.green,
                            child: TextField(
                              keyboardType: TextInputType.number,
                              controller: myTextController,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: 'Enter bet'),
                              textAlign: TextAlign.center,
                              textAlignVertical: TextAlignVertical.bottom,
                            ),
                          ),
                        ),
                      ],
                    ),
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
