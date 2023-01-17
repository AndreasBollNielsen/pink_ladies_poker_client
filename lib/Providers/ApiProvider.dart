import 'dart:convert';
import 'package:encrypt/encrypt.dart';
import 'package:flutter/cupertino.dart';
import 'package:pink_ladies_poker_client/Models/PokerTable.dart';
import '../Helpers/EncryptionHelper.dart';
import '../Helpers/Config.dart';
import 'package:encrypt/encrypt.dart' as crypto;
import 'package:http/http.dart' as http;
import '../Models/User.dart';
import '../Models/position.dart';

class ApiProvider with ChangeNotifier {
  late crypto.Key AESKey;
  late crypto.IV AESVector;
  late User MyUser = User(0, 0, '', 0, '', 0);
  late PokerTable pokerTable;
  late bool GotKeys = false;
  bool hideAppbar = true;
  late List<Position> positions = [
    Position(50, 175),
    Position(50, 475),
    Position(75, 50),
    Position(260, 50),
    Position(280, 250),
    Position(280, 425),
    Position(260, 600),
    Position(75, 600)
  ];

  Future<void> PlayGame(String userName) async {
    if (!GotKeys) {
      await GetAES().whenComplete(() => CreateUser(userName));
      MyUser.UserName = userName;
      MyUser.UserID = 1;
      print(MyUser.UserID);
    } else {
      await CreateUser(userName);
    }
  }

  Future<void> GetAES() async {
    //generate encryption keys
    var keyPair = EncryptionHelper.generateRSAkeyPair(
        EncryptionHelper.exampleSecureRandom());
    final publicKey = keyPair.publicKey;
    final myprivateKey = keyPair.privateKey;
    final publicKeyPem = EncryptionHelper.encodePublicKeyToPem(publicKey);

    //Send public key to Server & return encrypted AES keys
    final response = await http.post(
      Uri.parse('http://${Config.IP}:3000/api/GetAES'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'publicKey': publicKeyPem,
      }),
    );

    //Decrypt AES keys & assign to global variables
    if (response.statusCode == 200) {
      try {
        var jsonobj = jsonDecode(response.body);
        //EcryptionData fromjson = EcryptionData.fromJson(jsonobj);

        //Create encryption object from base64 string
        final encrypter = crypto.Encrypter(
            crypto.RSA(publicKey: publicKey, privateKey: myprivateKey));
        var encryptedData = crypto.Encrypted.fromBase64(jsonobj['data']);

        //decrypt data
        var json = jsonDecode(encrypter.decrypt(encryptedData));

        //convert from base64 string to dataTypes Key & IV
        AESKey = crypto.Key.fromBase64(json['key']);
        AESVector = crypto.IV.fromBase64(json['iv']);
        print("key: ${AESKey.base64} iv: ${AESVector.base64}");

        //test symmetric encryption & decryption

        //final decrypted = encrypter.decrypt(encrypted, iv: AESVector);
        GotKeys = true;
        print("get keys is done");
      } catch (e) {
        print(e);
      }
    } else {
      throw Exception('Failed to get keys: ' + response.statusCode.toString());
    }
  }

  //create new user
  Future<void> CreateUser(String userName) async {
    print("creating user");
    var jsonbody = jsonEncode(<String, String>{'userName': userName});

    //encrypt data
    final _encrypter = crypto.Encrypter(crypto.AES(AESKey, mode: AESMode.cbc));
    final encrypted = _encrypter.encrypt(jsonbody, iv: AESVector);

    //send post request
    final response = await http.post(
      Uri.parse('http://${Config.IP}:3000/api/CreateUser'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'data': encrypted.base64,
      }),
    );
    if (response.statusCode == 200) {
      print("user created");
    }
  }

  //leave game
  Future<bool> LeaveGame(User user) async {
    print(user.UserID);

    var jsonbody = jsonEncode(<String, String>{
      'userID': user.UserID.toString(),
      'tableID': user.TableID.toString()
    });

    //decrypt data
    final _encrypter = crypto.Encrypter(crypto.AES(AESKey, mode: AESMode.cbc));
    final encrypted = _encrypter.encrypt(jsonbody, iv: AESVector);

    //send post request
    final response = await http.post(
      Uri.parse('http://${Config.IP}:3000/api/LeaveTable'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'data': encrypted.base64,
      }),
    );

    if (response.statusCode == 200) {
      return true;
    }
    return false;
  }

  //Convert json to model
  List<User> ConvertJsonToModel(dynamic encryptedData) {
    //Decrypt data
    final _encrypter = crypto.Encrypter(crypto.AES(AESKey, mode: AESMode.cbc));
    final EncryptedType = crypto.Encrypted.fromBase64(encryptedData);
    final decrypted = _encrypter.decrypt(EncryptedType, iv: AESVector);

    //decode from json
    final Map<String, dynamic> data = json.decode(decrypted);
    ;

    //convert json to model for users
    final userList =
        (data['users'] as List).map((i) => new User.ConvertFromJson(i));

    //set app user when starting new game
    if (MyUser.UserID == 0) {
      for (final user in userList) {
        if (user.UserName == MyUser.UserName) {
          MyUser = user;

          break;
        }
      }
    }

    //remove duplicate from user list
    //userList.remove

    //convert pokertable to model
    PokerTable table = PokerTable.ConvertFromJson(data);
    table.users = userList.toList();

    //remove duplicate of app user
    table.users.removeWhere((user) => user.UserID == MyUser.UserID);
    print("current user:  ${table.currentUser}");
    //print(table.users);

    return table.users;
  }

  Future UserInteraction(User user) async {
    var jsonbody = jsonEncode(<String, String>{
      'tableID': user.TableID.toString(),
      'id': user.UserID.toString(),
      'action': user.State,
      'value': user.Bet.toString()
    });

    //encrypt data
    final _encrypter = crypto.Encrypter(crypto.AES(AESKey, mode: AESMode.cbc));
    final encrypted = _encrypter.encrypt(jsonbody, iv: AESVector);

    //send post request
    final response = await http.post(
      Uri.parse('http://${Config.IP}:3000/api/Useraction'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'data': encrypted.base64,
      }),
    );
    if (response.statusCode == 200) {
      print("user created");
    }
  }

  //return list of user positions at table
  List<Position> GetPositions() {
    return positions;
  }

  //return list of fake users for testing
  List<User> GetFakeUsers() {
    List<User> fakeUsers = [
      User(0, 0, 'andreas', 0, '', 0),
      User(0, 0, 'andreas1', 0, '', 0),
      User(0, 0, 'andreas2', 0, '', 0),
      User(0, 0, 'andreas3', 0, '', 0),
      User(0, 0, 'andreas4', 0, '', 0),
      User(0, 0, 'andreas5', 0, '', 0),
      User(0, 0, 'andreas6', 0, '', 0),
      User(0, 0, 'andreas7', 0, '', 0),
    ];

    return fakeUsers;
  }
}
