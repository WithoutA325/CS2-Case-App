import 'skin.dart';

class Cs2Crate {
  const Cs2Crate({
    required this.id,
    required this.name,
    required this.type,
    required this.imageUrl,
    required this.contains,
    required this.containsRare,
    this.description,
    this.firstSaleDate,
    this.marketHashName,
    this.rental = false,
  });

  final String id;
  final String name;
  final String type;
  final String imageUrl;
  final List<Skin> contains;
  final List<Skin> containsRare;
  final String? description;
  final String? firstSaleDate;
  final String? marketHashName;
  final bool rental;

  factory Cs2Crate.fromJson(Map<String, dynamic> json) {
    return Cs2Crate(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? 'Unknown crate',
      type: json['type']?.toString() ?? 'Crate',
      imageUrl: json['image']?.toString() ?? '',
      description: json['description']?.toString(),
      firstSaleDate: json['first_sale_date']?.toString(),
      marketHashName: json['market_hash_name']?.toString(),
      rental: json['rental'] == true,
      contains: _skinList(json['contains']),
      containsRare: _skinList(json['contains_rare']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'image': imageUrl,
      'description': description,
      'first_sale_date': firstSaleDate,
      'market_hash_name': marketHashName,
      'rental': rental,
      'contains': contains.map((skin) => skin.toJson()).toList(),
      'contains_rare': containsRare.map((skin) => skin.toJson()).toList(),
    };
  }

  static List<Skin> _skinList(Object? value) {
    if (value is! List) {
      return const [];
    }

    return value
        .whereType<Map>()
        .map((item) => item.map((key, value) => MapEntry(key.toString(), value)))
        .map(Skin.fromJson)
        .toList();
  }
}
