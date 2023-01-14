import 'dart:convert';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
//import 'package:pointycastle/random/fortuna_random.dart';
import '../Models/EncryptionData.dart';
import 'package:encrypt/encrypt.dart';
//import 'package:pointycastle/pointycastle.dart';
import "package:pointycastle/export.dart";
import 'package:http/http.dart' as http;
import 'package:rsa_encrypt/rsa_encrypt.dart';
import "package:asn1lib/asn1lib.dart";

class ApiProvider with ChangeNotifier {
  var privateKey;

  Future GetAES() async {
//initialize

    //generate encryption keys

    var keyPair = generateRSAkeyPair(exampleSecureRandom());
    final publicKey = keyPair.publicKey;
    final myprivateKey = keyPair.privateKey;
    final publicKeyPem = encodePublicKeyToPem(publicKey);

    // final encrypter =
    //     Encrypter(RSA(publicKey: publicKey, privateKey: privateKey));
    // //print("before decryption: " + decodedBefore);
    // var data = encrypter.encrypt("hello world");

    // var decryptedData = encrypter.decrypt(data);
    // print(publicKeyPem);

    final response = await http.post(
      Uri.parse('http://192.168.0.20:3000/api/GetAES'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'publicKey': publicKeyPem,
      }),
    );

    //print("private key: " + priKey.toString());

    if (response.statusCode == 200) {
      // print('response: ' + response.body);

      try {
        var jsonobj = jsonDecode(response.body);
        EcryptionData fromjson = EcryptionData.fromJson(jsonobj);

       // print(fromjson.data);
        // Map<String, dynamic> JsonData = jsonobj;
        // var bytesData = JsonData['data'];
        // print("before decryption: ${fromjson.data}");

        final encrypter =
            Encrypter(RSA(publicKey: publicKey, privateKey: myprivateKey));

        // var encrypted = encrypter.encrypt(fromjson.data);

        var encryptedData = Encrypted.fromBase64(fromjson.data);
        // print("before decryption: " + encryptedData.base64);
        var keys = encrypter.decrypt(encryptedData);
        print(keys);
      } catch (e) {
        print(e);
      }
    } else {
      throw Exception('Failed to get keys: ' + response.statusCode.toString());
    }
  }

  AsymmetricKeyPair<RSAPublicKey, RSAPrivateKey> generateRSAkeyPair(
      FortunaRandom secureRandom,
      {int bitLength = 2048}) {
    // Create an RSA key generator and initialize it

    final keyGen = RSAKeyGenerator()
      ..init(ParametersWithRandom(
          RSAKeyGeneratorParameters(BigInt.parse('65537'), bitLength, 64),
          secureRandom));

    // Use the generator

    final pair = keyGen.generateKeyPair();

    // Cast the generated key pair into the RSA key types

    final myPublic = pair.publicKey as RSAPublicKey;
    final myPrivate = pair.privateKey as RSAPrivateKey;

    return AsymmetricKeyPair<RSAPublicKey, RSAPrivateKey>(myPublic, myPrivate);
  }

  encodePublicKeyToPem(RSAPublicKey publicKey) {
    var algorithmSeq = new ASN1Sequence();
    var algorithmAsn1Obj = new ASN1Object.fromBytes(Uint8List.fromList(
        [0x6, 0x9, 0x2a, 0x86, 0x48, 0x86, 0xf7, 0xd, 0x1, 0x1, 0x1]));
    var paramsAsn1Obj =
        new ASN1Object.fromBytes(Uint8List.fromList([0x5, 0x0]));
    algorithmSeq.add(algorithmAsn1Obj);
    algorithmSeq.add(paramsAsn1Obj);

    var publicKeySeq = new ASN1Sequence();
    publicKeySeq.add(ASN1Integer(publicKey.modulus!));
    publicKeySeq.add(ASN1Integer(publicKey.exponent!));
    var publicKeySeqBitString =
        new ASN1BitString(Uint8List.fromList(publicKeySeq.encodedBytes));

    var topLevelSeq = new ASN1Sequence();
    topLevelSeq.add(algorithmSeq);
    topLevelSeq.add(publicKeySeqBitString);
    var dataBase64 = base64.encode(topLevelSeq.encodedBytes);

    return """-----BEGIN PUBLIC KEY-----\r\n$dataBase64\r\n-----END PUBLIC KEY-----""";
  }

  FortunaRandom exampleSecureRandom() {
    final secureRandom = FortunaRandom();

    final seedSource = Random.secure();
    final seeds = <int>[];
    for (int i = 0; i < 32; i++) {
      seeds.add(seedSource.nextInt(255));
    }
    secureRandom.seed(KeyParameter(Uint8List.fromList(seeds)));

    return secureRandom;
  }
}
