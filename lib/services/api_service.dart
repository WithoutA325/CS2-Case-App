import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/crate.dart';
import '../models/skin.dart';

class Cs2ApiService {
  Cs2ApiService({http.Client? client}) : _client = client ?? http.Client();

  static const _baseUrl =
      'https://raw.githubusercontent.com/ByMykel/CSGO-API/main/public/api/en';

  final http.Client _client;

  Future<List<Cs2Crate>> fetchCrates() async {
    final response = await _get('/crates.json');
    final decoded = jsonDecode(response.body);

    if (decoded is! List) {
      throw const FormatException('API returned invalid crates data');
    }

    return decoded
        .whereType<Map>()
        .map((item) => item.map((key, value) => MapEntry(key.toString(), value)))
        .map(Cs2Crate.fromJson)
        .where((crate) => crate.type == 'Case' && crate.contains.isNotEmpty)
        .toList();
  }

  Future<Skin?> fetchSkinDetails(String skinId) async {
    final response = await _get('/skins.json');
    final decoded = jsonDecode(response.body);

    if (decoded is! List) {
      throw const FormatException('API returned invalid skins data');
    }

    for (final item in decoded.whereType<Map>()) {
      final json = item.map((key, value) => MapEntry(key.toString(), value));
      if (json['id']?.toString() == skinId) {
        return Skin.fromJson(json);
      }
    }

    return null;
  }

  Future<http.Response> _get(String path) async {
    final uri = Uri.parse('$_baseUrl$path');
    final response = await _client.get(uri);

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('Request failed: ${response.statusCode}');
    }

    return response;
  }
}
