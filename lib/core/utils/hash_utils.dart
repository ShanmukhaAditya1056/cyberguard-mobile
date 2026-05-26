import 'dart:convert';

import 'package:crypto/crypto.dart';

class HashUtils {
  static String sha1Hex(String input) {
    final bytes = utf8.encode(input.trim());
    return sha1.convert(bytes).toString().toUpperCase();
  }

  static String sha256Hex(String input) {
    final bytes = utf8.encode(input.trim());
    return sha256.convert(bytes).toString();
  }
}
