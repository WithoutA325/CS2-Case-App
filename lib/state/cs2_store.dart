import 'package:flutter/foundation.dart';

import '../models/crate.dart';
import '../models/skin.dart';
import '../services/api_service.dart';
import '../services/local_database.dart';

class Cs2Store extends ChangeNotifier {
  Cs2Store({required Cs2ApiService apiService, required LocalDatabase database})
    : _apiService = apiService,
      _database = database;

  final Cs2ApiService _apiService;
  final LocalDatabase _database;

  List<Cs2Crate> crates = const [];
  List<Skin> wishlist = const [];
  DateTime? lastUpdated;
  bool isLoading = false;
  bool isRefreshing = false;
  String? errorMessage;

  Future<void> load() async {
    crates = _database.loadCrates();
    wishlist = _database.loadWishlist();
    lastUpdated = _database.loadLastUpdated();
    notifyListeners();

    if (crates.isEmpty) {
      await refreshCrates();
    }
  }

  Future<void> refreshCrates() async {
    isLoading = crates.isEmpty;
    isRefreshing = crates.isNotEmpty;
    errorMessage = null;
    notifyListeners();

    try {
      final freshCrates = await _apiService.fetchCrates();
      await _database.saveCrates(freshCrates);
      crates = freshCrates;
      lastUpdated = _database.loadLastUpdated();
    } catch (_) {
      errorMessage = crates.isEmpty
          ? 'Nie udalo sie pobrac skrzynek. Sprawdz internet i sprobuj ponownie.'
          : 'Nie udalo sie odswiezyc danych. Pokazujemy zapisane skrzynki.';
    } finally {
      isLoading = false;
      isRefreshing = false;
      notifyListeners();
    }
  }

  Future<Skin> loadSkinDetails(Skin skin) async {
    final cached = _database.loadSkinDetails(skin.id);
    if (cached != null) {
      return skin.merge(cached);
    }

    try {
      final details = await _apiService.fetchSkinDetails(skin.id);
      if (details != null) {
        await _database.saveSkinDetails(details);
        return skin.merge(details);
      }
    } catch (_) {
      return skin;
    }

    return skin;
  }

  bool isWishlisted(String skinId) {
    return _database.isWishlisted(skinId);
  }

  Future<void> toggleWishlist(Skin skin) async {
    if (_database.isWishlisted(skin.id)) {
      await _database.removeFromWishlist(skin.id);
    } else {
      await _database.addToWishlist(skin);
    }

    wishlist = _database.loadWishlist();
    notifyListeners();
  }
}
