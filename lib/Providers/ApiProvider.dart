import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:rsa_encrypt/rsa_encrypt.dart';
import 'package:pointycastle/api.dart' as crypto;
import 'package:http/http.dart' as http;

class ApiProvider with ChangeNotifier {
  var privateKey;

  Future GetAES() async {
    //generate encryption keys
    Future<crypto.AsymmetricKeyPair> futureKeyPair;
    crypto.AsymmetricKeyPair keyPair;
    Future<crypto.AsymmetricKeyPair<crypto.PublicKey, crypto.PrivateKey>>
        getKeyPair() {
      var helper = RsaKeyHelper();
      return helper.computeRSAKeyPair(helper.getSecureRandom());
    }

    futureKeyPair = getKeyPair();
    keyPair = await futureKeyPair;
    dynamic pkey = keyPair.publicKey;
    dynamic priKey = keyPair.privateKey;
    var rsaHelper = RsaKeyHelper();
    var publicKey = rsaHelper.encodePublicKeyToPemPKCS1(pkey);
    privateKey = rsaHelper.encodePrivateKeyToPemPKCS1(priKey);

    // print("private key " + privateKey);

    // var encryption = encrypt('hello world', pkey);
    // print(encryption);

    // var decryption = decrypt(encryption, priKey);
    // print(decryption);

    final response = await http.post(
      Uri.parse('http://192.168.0.20:3000/api/GetAES'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'publicKey': publicKey,
      }),
    );

    if (response.statusCode == 200) {
      // print('response: ' +  response.body);

      var keys = decrypt(response.body, priKey);
      print("key and iv: " + jsonDecode(keys));
      // return Album.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to get keys: ' + response.statusCode.toString());
    }
  }
}
