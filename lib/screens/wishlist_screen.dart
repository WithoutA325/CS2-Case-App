import 'package:flutter/material.dart';

import '../state/cs2_store.dart';
import '../widgets/cs2_image.dart';
import '../widgets/rarity_chip.dart';
import 'skin_detail_screen.dart';

class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key, required this.store});

  final Cs2Store store;

  @override
  Widget build(BuildContext context) {
    final wishlist = store.wishlist;

    if (wishlist.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.favorite_border, size: 46),
              const SizedBox(height: 14),
              Text(
                'Wishlista jest pusta',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text(
                'Wejdz w szczegoly skina i dodaj go do listy obserwowanych.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      itemCount: wishlist.length,
      separatorBuilder: (_, _) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final skin = wishlist[index];
        return Dismissible(
          key: ValueKey(skin.id),
          direction: DismissDirection.endToStart,
          background: Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 20),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.errorContainer,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.delete_outline),
          ),
          onDismissed: (_) => store.toggleWishlist(skin),
          child: Card(
            child: ListTile(
              contentPadding: const EdgeInsets.all(12),
              leading: SizedBox.square(
                dimension: 64,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.18),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Cs2Image(url: skin.imageUrl, padding: EdgeInsets.zero),
                ),
              ),
              title: Text(
                skin.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 8),
                child: RarityChip(rarity: skin.rarity),
              ),
              trailing: IconButton(
                tooltip: 'Usun',
                onPressed: () => store.toggleWishlist(skin),
                icon: const Icon(Icons.delete_outline),
              ),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) =>
                        SkinDetailScreen(initialSkin: skin, store: store),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
