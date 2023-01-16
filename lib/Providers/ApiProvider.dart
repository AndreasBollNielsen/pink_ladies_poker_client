import 'dart:convert';
import 'package:encrypt/encrypt.dart';
import 'package:flutter/cupertino.dart';
import 'package:pink_ladies_poker_client/Models/PokerTable.dart';
import '../Helpers/EncryptionHelper.dart';
import 'package:encrypt/encrypt.dart' as crypto;
import 'package:http/http.dart' as http;

import '../Models/User.dart';

class ApiProvider with ChangeNotifier {
  late crypto.Key AESKey;
  late crypto.IV AESVector;
  late User MyUser;
  late bool GotKeys = false;

  void PlayGame(String userName) async {
    if (!GotKeys) {
      await GetAES().whenComplete(() => CreateUser(userName));
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
      Uri.parse('http://192.168.42.49:3000/api/GetAES'),
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
      Uri.parse('http://192.168.42.49:3000/api/CreateUser'),
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
    var jsonbody = jsonEncode(<String, String>{
      'userID': user.UserID.toString(),
      'tableID': user.TableID.toString()
    });

    //decrypt data
    final _encrypter = crypto.Encrypter(crypto.AES(AESKey, mode: AESMode.cbc));
    final encrypted = _encrypter.encrypt(jsonbody, iv: AESVector);

    //send post request
    final response = await http.post(
      Uri.parse('http://192.168.0.20:3000/api/CreateUser'),
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

  //Convert byteData to json
  Future ConvertBytesToJson(dynamic encryptedData) async {
    final _encrypter = crypto.Encrypter(crypto.AES(AESKey, mode: AESMode.cbc));
    final EncryptedType = crypto.Encrypted.fromBase64(encryptedData);
    final decrypted = _encrypter.decrypt(EncryptedType, iv: AESVector);
    // print(decrypted +
    //     ".-----------------------------------------------------------------");
    final Map<String, dynamic> data = json.decode(decrypted);
    // print(data);

    var userList = data['users'] as List;
    var collectiveCards = data['collectiveCards'] as List;
    var cardDeck = data['cardDeck'] as List;

    // print(data);
     PokerTable table = PokerTable.ConvertFromJson(data);
    // print(table.collectiveCards[0]);
    // List<User> users = [];
    // for (var i = 0; i < userList.length; i++) {
    //   var jsonCards = jsonDecode(userList[i]['pocketCards']);
    //   List<String>? pocketCards = jsonCards != null ? List.from(jsonCards) : null;
    //   User user = User.ConvertFromJson(userList[i]);

    //   users.add(user);
    // }
    // print(table);
    print(userList);
    print(collectiveCards);
    print(cardDeck);

    // List<User> userObjects =
    //     userList.map((user) => User.ConvertFromJson(user)).toList();
    // print(userObjects);
  }
}
