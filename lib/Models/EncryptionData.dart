import 'package:flutter/foundation.dart';

//deprecated
class EcryptionData {
  final dynamic data;

  const EcryptionData({required this.data});

  factory EcryptionData.fromJson(Map<String, dynamic> json) {
    return EcryptionData(
      data: json['data'],
    );
  }
}
