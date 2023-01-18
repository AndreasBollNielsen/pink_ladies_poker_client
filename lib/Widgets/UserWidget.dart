import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import '../Models/User.dart';

class UserWidget extends StatefulWidget {
  final User user;

  const UserWidget({required this.user});

  @override
  State<UserWidget> createState() => _UserWidgetState();
}

class _UserWidgetState extends State<UserWidget> {
  @override
  Widget build(BuildContext context) {
    var card1 = 'back';
    var card2 = 'back';
    print(widget.user.PocketCards.length);
    print(widget.user.UserName);
    if (widget.user.PocketCards.length > 0) {
      card1 = widget.user.PocketCards[0];
      card2 = widget.user.PocketCards[1];
    }

    return SizedBox(
      child: Container(
        width: 100,
        height: 72,
        // color: Colors.amber,
        child: Stack(
          children: [
            Stack(
              children: [
                Positioned(
                  left: 0,
                  top: 5,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.only(bottomLeft: Radius.circular(5)),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0x54000000),
                          spreadRadius: 2,
                          blurRadius: 5,
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: Image.asset(
                        'graphics/${card1}.jpg',
                        width: 60,
                        height: 90,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 30,
                  top: 5,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.only(bottomLeft: Radius.circular(5)),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0x54000000),
                          spreadRadius: 2,
                          blurRadius: 5,
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: Image.asset(
                        'graphics/${card2}.jpg',
                        width: 60,
                        height: 90,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Positioned(
              left: 0,
              top: 30,
              child: Container(
                width: 90,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white, width: 2),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  //crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 90,
                      color: Colors.black,
                      child: Text(
                        widget.user.UserName,
                        style: TextStyle(color: Colors.white, fontSize: 10),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Container(
                      width: 90,
                      color: Colors.black,
                      child: Text(
                        widget.user.Saldo.toString(),
                        style: TextStyle(color: Colors.white, fontSize: 12),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Container(
                      width: 90,
                      color: Colors.black,
                      child: Text(
                        widget.user.State,
                        style: TextStyle(color: Colors.white, fontSize: 10),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
