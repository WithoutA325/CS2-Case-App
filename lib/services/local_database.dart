import 'package:hive_flutter/hive_flutter.dart';

import '../models/crate.dart';
import '../models/skin.dart';

class LocalDatabase {
  LocalDatabase._({
    required this.cratesBox,
    required this.skinDetailsBox,
    required this.wishlistBox,
  });

  static const cratesBoxName = 'crates_cache';
  static const skinDetailsBoxName = 'skin_details_cache';
  static const wishlistBoxName = 'wishlist';

  final Box<dynamic> cratesBox;
  final Box<dynamic> skinDetailsBox;
  final Box<dynamic> wishlistBox;

  static Future<LocalDatabase> open() async {
    return LocalDatabase._(
      cratesBox: await Hive.openBox<dynamic>(cratesBoxName),
      skinDetailsBox: await Hive.openBox<dynamic>(skinDetailsBoxName),
      wishlistBox: await Hive.openBox<dynamic>(wishlistBoxName),
    );
  }

  List<Cs2Crate> loadCrates() {
    final rawItems = cratesBox.get('items');
    if (rawItems is! List) {
      return const [];
    }

    return rawItems
        .whereType<Map>()
        .map((item) => item.map((key, value) => MapEntry(key.toString(), value)))
        .map(Cs2Crate.fromJson)
        .toList();
  }

  DateTime? loadLastUpdated() {
    final value = cratesBox.get('updatedAt')?.toString();
    return value == null ? null : DateTime.tryParse(value);
  }

  Future<void> saveCrates(List<Cs2Crate> crates) async {
    await cratesBox.put(
      'items',
      crates.map((crate) => crate.toJson()).toList(),
    );
    await cratesBox.put('updatedAt', DateTime.now().toIso8601String());
  }

  Skin? loadSkinDetails(String id) {
    final rawItem = skinDetailsBox.get(id);
    if (rawItem is! Map) {
      return null;
    }

    return Skin.fromJson(
      rawItem.map((key, value) => MapEntry(key.toString(), value)),
    );
  }

  Future<void> saveSkinDetails(Skin skin) async {
    await skinDetailsBox.put(skin.id, skin.toJson());
  }

  List<Skin> loadWishlist() {
    return wishlistBox.values
        .whereType<Map>()
        .map((item) => item.map((key, value) => MapEntry(key.toString(), value)))
        .map(Skin.fromJson)
        .toList();
  }

  bool isWishlisted(String id) {
    return wishlistBox.containsKey(id);
  }

  Future<void> addToWishlist(Skin skin) async {
    await wishlistBox.put(skin.id, skin.toJson());
  }

  Future<void> removeFromWishlist(String id) async {
    await wishlistBox.delete(id);
  }
}
