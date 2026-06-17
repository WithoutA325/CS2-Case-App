import 'package:flutter/material.dart';

import '../models/skin.dart';
import '../state/cs2_store.dart';
import '../widgets/cs2_image.dart';
import '../widgets/rarity_chip.dart';

class SkinDetailScreen extends StatefulWidget {
  const SkinDetailScreen({
    super.key,
    required this.initialSkin,
    required this.store,
  });

  final Skin initialSkin;
  final Cs2Store store;

  @override
  State<SkinDetailScreen> createState() => _SkinDetailScreenState();
}

class _SkinDetailScreenState extends State<SkinDetailScreen> {
  late Future<Skin> _skinFuture;

  @override
  void initState() {
    super.initState();
    _skinFuture = widget.store.loadSkinDetails(widget.initialSkin);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.store,
      builder: (context, _) {
        return FutureBuilder<Skin>(
          future: _skinFuture,
          initialData: widget.initialSkin,
          builder: (context, snapshot) {
            final skin = snapshot.data ?? widget.initialSkin;
            final isWishlisted = widget.store.isWishlisted(skin.id);

            return Scaffold(
              appBar: AppBar(
                title: Text(skin.name),
                actions: [
                  IconButton(
                    tooltip: isWishlisted
                        ? 'Usun z wishlisty'
                        : 'Dodaj do wishlisty',
                    onPressed: () => widget.store.toggleWishlist(skin),
                    icon: Icon(
                      isWishlisted ? Icons.favorite : Icons.favorite_border,
                    ),
                  ),
                ],
              ),
              body: ListView(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                children: [
                  SizedBox(
                    height: 310,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: Theme.of(
                          context,
                        ).colorScheme.surfaceContainerHigh,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Cs2Image(url: skin.imageUrl),
                    ),
                  ),
                  const SizedBox(height: 18),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          skin.marketHashName ?? skin.name,
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                      ),
                      const SizedBox(width: 12),
                      RarityChip(rarity: skin.rarity),
                    ],
                  ),
                  const SizedBox(height: 12),
                  if (snapshot.connectionState == ConnectionState.waiting)
                    const LinearProgressIndicator(),
                  const SizedBox(height: 12),
                  Text(
                    _cleanDescription(skin.description) ??
                        'Pelne szczegoly pojawia sie po pobraniu z endpointu skins.json. Jesli jestes offline, aplikacja pokazuje dane zapisane przy skrzynce.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 18),
                  _DetailsGrid(skin: skin),
                  const SizedBox(height: 18),
                  FilledButton.icon(
                    onPressed: () => widget.store.toggleWishlist(skin),
                    icon: Icon(
                      isWishlisted ? Icons.favorite : Icons.favorite_border,
                    ),
                    label: Text(
                      isWishlisted ? 'Usun z wishlisty' : 'Dodaj do wishlisty',
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  String? _cleanDescription(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null;
    }

    return value
        .replaceAll(RegExp(r'<[^>]*>'), '')
        .replaceAll('&quot;', '"')
        .trim();
  }
}

class _DetailsGrid extends StatelessWidget {
  const _DetailsGrid({required this.skin});

  final Skin skin;

  @override
  Widget build(BuildContext context) {
    final items = <_DetailItem>[
      _DetailItem('Bron', skin.weapon),
      _DetailItem('Kategoria', skin.category),
      _DetailItem('Paint index', skin.paintIndex),
      _DetailItem('Phase', skin.phase),
      _DetailItem('Min float', skin.minFloat?.toStringAsFixed(2)),
      _DetailItem('Max float', skin.maxFloat?.toStringAsFixed(2)),
      _DetailItem('StatTrak', skin.stattrak ? 'Tak' : 'Nie'),
      _DetailItem('Souvenir', skin.souvenir ? 'Tak' : 'Nie'),
    ].where((item) => item.value != null && item.value!.isNotEmpty).toList();

    return GridView.builder(
      itemCount: items.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 210,
        childAspectRatio: 2.65,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemBuilder: (context, index) {
        final item = items[index];
        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                item.label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.labelMedium,
              ),
              const SizedBox(height: 3),
              Text(
                item.value!,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ],
          ),
        );
      },
    );
  }
}

class _DetailItem {
  const _DetailItem(this.label, this.value);

  final String label;
  final String? value;
}
