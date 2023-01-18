import 'package:flutter/material.dart';
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
    // var myTextController = TextEditingController();
    var userInfo = "your";
    double _currentSliderValue = 0;
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
                } else if (snapshot.connectionState == ConnectionState.active) {
                  if (snapshot.hasData) {
                    print('got data');
                    var users = provider.ConvertJsonToModel(snapshot.data);
                    var positions = provider.GetPositions();
                    userInfo = provider.userInfo;
                    print("------pokertable: ${provider.pokerTable}");
                    return Stack(
                      children: [
                        Positioned(
                          bottom: 50,
                          left: 325,
                          child: UserWidget(user: provider.MyUser),
                        ),
                        Positioned(
                          left: 475,
                          bottom: 3,
                          child: Container(
                            width: 100,
                            height: 35,
                            // color: Colors.green,
                            child: Text(' ${provider.MyUser.Bet}',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 14),
                                textAlign: TextAlign.center),
                          ),
                        ),
                        Center(
                          child: Container(
                            width: 350,
                            height: 90,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              textDirection: TextDirection.ltr,
                              children: [
                                if (provider.pokerTable != null)
                                  for (int i = 0;
                                      i <
                                          provider.pokerTable!.collectiveCards
                                              .length;
                                      i++)
                                    Image.asset(
                                        "graphics/${provider.pokerTable!.collectiveCards[i]}.jpg"),
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
                        Positioned(
                          left: 300,
                          top: 25,
                          child: Container(
                            width: 200,
                            height: 50,
                            color: Colors.blue,
                            child: Text(
                              provider.userInfo,
                              style:
                                  TextStyle(color: Colors.white, fontSize: 14),
                              textAlign: TextAlign.center,
                            ),
                          ),
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
                  return Text('no connection...');
                }
              },
            ),
            Stack(
              children: [
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
                  left: 0,
                  top: 325,
                  child: ElevatedButton(
                    onPressed: () => {
                      Navigator.pop(context),
                    },
                    child: Text('return'),
                  ),
                ),
                Positioned(
                  bottom: 0,
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
                              provider.MyUser.State = 'bet',
                              provider.MyUser.Bet = 25,
                              provider.UserInteraction(provider.MyUser),
                              // Navigator.pop(context),
                            },
                            child: Text('Call'),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(1.0),
                          child: ElevatedButton(
                            onPressed: () => {
                              //call api
                              provider.MyUser.State = 'fold',
                              provider.MyUser.Bet = 0,
                              provider.UserInteraction(provider.MyUser),
                            },
                            child: Text('Fold'),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () => {
                            //call api
                            provider.MyUser.State = 'check',
                            provider.MyUser.Bet = 0,
                            provider.UserInteraction(provider.MyUser),
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
                              provider.MyUser.Bet = 25,
                              provider.UserInteraction(provider.MyUser),
                            },
                            child: Text('Bet'),
                          ),
                        ),
                        // Material(
                        //   child: Container(
                        //     width: 100,
                        //     height: 35,
                        //     color: Colors.green,
                        //     child: Slider(
                        //       value: _currentSliderValue,
                        //       min: 0,
                        //       // max: provider.MyUser != null
                        //       //     ? provider.MyUser.Saldo.toDouble()
                        //       //     : 10000.0,
                        //       max: 1000,
                        //       divisions: 100,
                        //       label: _currentSliderValue.round().toString(),
                        //       onChanged: (value) => {
                        //         setState(
                        //           () => {_currentSliderValue = value},
                        //         ),
                        //       },
                        //     ),
                        //   ),
                        // ),
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
