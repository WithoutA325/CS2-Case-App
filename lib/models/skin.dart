import 'rarity.dart';

class Skin {
  const Skin({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.rarity,
    this.description,
    this.paintIndex,
    this.phase,
    this.weapon,
    this.category,
    this.minFloat,
    this.maxFloat,
    this.marketHashName,
    this.stattrak = false,
    this.souvenir = false,
  });

  final String id;
  final String name;
  final String imageUrl;
  final Rarity rarity;
  final String? description;
  final String? paintIndex;
  final String? phase;
  final String? weapon;
  final String? category;
  final double? minFloat;
  final double? maxFloat;
  final String? marketHashName;
  final bool stattrak;
  final bool souvenir;

  factory Skin.fromJson(Map<String, dynamic> json) {
    return Skin(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? 'Unknown skin',
      imageUrl: json['image']?.toString() ?? '',
      rarity: Rarity.fromJson(_asMap(json['rarity'])),
      description: json['description']?.toString(),
      paintIndex: json['paint_index']?.toString(),
      phase: json['phase']?.toString(),
      weapon: _asMap(json['weapon'])?['name']?.toString(),
      category: _asMap(json['category'])?['name']?.toString(),
      minFloat: _asDouble(json['min_float']),
      maxFloat: _asDouble(json['max_float']),
      marketHashName: json['market_hash_name']?.toString(),
      stattrak: json['stattrak'] == true,
      souvenir: json['souvenir'] == true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image': imageUrl,
      'rarity': rarity.toJson(),
      'description': description,
      'paint_index': paintIndex,
      'phase': phase,
      'weapon': weapon == null ? null : {'name': weapon},
      'category': category == null ? null : {'name': category},
      'min_float': minFloat,
      'max_float': maxFloat,
      'market_hash_name': marketHashName,
      'stattrak': stattrak,
      'souvenir': souvenir,
    };
  }

  Skin merge(Skin details) {
    return Skin(
      id: id,
      name: details.name,
      imageUrl: details.imageUrl.isNotEmpty ? details.imageUrl : imageUrl,
      rarity: details.rarity,
      description: details.description ?? description,
      paintIndex: details.paintIndex ?? paintIndex,
      phase: details.phase ?? phase,
      weapon: details.weapon ?? weapon,
      category: details.category ?? category,
      minFloat: details.minFloat ?? minFloat,
      maxFloat: details.maxFloat ?? maxFloat,
      marketHashName: details.marketHashName ?? marketHashName,
      stattrak: details.stattrak,
      souvenir: details.souvenir,
    );
  }

  static Map<String, dynamic>? _asMap(Object? value) {
    if (value is Map) {
      return value.map((key, value) => MapEntry(key.toString(), value));
    }
    return null;
  }

  static double? _asDouble(Object? value) {
    if (value is num) {
      return value.toDouble();
    }
    return double.tryParse(value?.toString() ?? '');
  }
}
