import 'package:flutter/material.dart';

import '../models/crate.dart';
import '../models/skin.dart';
import '../state/cs2_store.dart';
import '../widgets/cs2_image.dart';
import '../widgets/rarity_chip.dart';
import 'skin_detail_screen.dart';

class CrateDetailScreen extends StatelessWidget {
  const CrateDetailScreen({
    super.key,
    required this.crate,
    required this.store,
  });

  final Cs2Crate crate;
  final Cs2Store store;

  @override
  Widget build(BuildContext context) {
    final skins = [...crate.contains, ...crate.containsRare];

    return Scaffold(
      appBar: AppBar(title: Text(crate.name)),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 210,
                    width: double.infinity,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: Theme.of(
                          context,
                        ).colorScheme.surfaceContainerHigh,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Cs2Image(url: crate.imageUrl),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    crate.marketHashName ?? crate.name,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    crate.description?.isNotEmpty == true
                        ? crate.description!
                        : 'Zawartosc skrzynki pobrana z CSGO-API i zapisana w lokalnym cache Hive.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 14),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      Chip(label: Text(crate.type)),
                      if (crate.firstSaleDate != null)
                        Chip(label: Text('Od ${crate.firstSaleDate}')),
                      Chip(label: Text('${crate.contains.length} skinow')),
                      if (crate.containsRare.isNotEmpty)
                        Chip(label: Text('${crate.containsRare.length} rare')),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
            sliver: SliverGrid.builder(
              itemCount: skins.length,
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 230,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 0.72,
              ),
              itemBuilder: (context, index) {
                return _SkinTile(skin: skins[index], store: store);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _SkinTile extends StatelessWidget {
  const _SkinTile({required this.skin, required this.store});

  final Skin skin;
  final Cs2Store store;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => SkinDetailScreen(initialSkin: skin, store: store),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.18),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: SizedBox.expand(child: Cs2Image(url: skin.imageUrl)),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                skin.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: 8),
              RarityChip(rarity: skin.rarity),
            ],
          ),
        ),
      ),
    );
  }
}
