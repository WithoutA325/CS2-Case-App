import 'package:flutter/material.dart';

import '../models/crate.dart';
import '../state/cs2_store.dart';
import '../widgets/cs2_image.dart';
import 'crate_detail_screen.dart';
import 'wishlist_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.store});

  final Cs2Store store;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  String _query = '';
  String _type = 'All';

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.store,
      builder: (context, _) {
        final screens = [
          _CratesTab(
            store: widget.store,
            query: _query,
            type: _type,
            onQueryChanged: (value) => setState(() => _query = value),
            onTypeChanged: (value) => setState(() => _type = value),
          ),
          WishlistScreen(store: widget.store),
        ];

        return Scaffold(
          appBar: AppBar(
            title: const Text('CS2 Case Library'),
            actions: [
              IconButton(
                tooltip: 'Odswiez',
                onPressed: widget.store.isRefreshing
                    ? null
                    : widget.store.refreshCrates,
                icon: widget.store.isRefreshing
                    ? const SizedBox.square(
                        dimension: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.sync),
              ),
            ],
          ),
          body: screens[_selectedIndex],
          bottomNavigationBar: NavigationBar(
            selectedIndex: _selectedIndex,
            onDestinationSelected: (index) {
              setState(() => _selectedIndex = index);
            },
            destinations: [
              const NavigationDestination(
                icon: Icon(Icons.inventory_2_outlined),
                selectedIcon: Icon(Icons.inventory_2),
                label: 'Skrzynki',
              ),
              NavigationDestination(
                icon: const Icon(Icons.favorite_border),
                selectedIcon: const Icon(Icons.favorite),
                label: 'Wishlista (${widget.store.wishlist.length})',
              ),
            ],
          ),
        );
      },
    );
  }
}

class _CratesTab extends StatelessWidget {
  const _CratesTab({
    required this.store,
    required this.query,
    required this.type,
    required this.onQueryChanged,
    required this.onTypeChanged,
  });

  final Cs2Store store;
  final String query;
  final String type;
  final ValueChanged<String> onQueryChanged;
  final ValueChanged<String> onTypeChanged;

  @override
  Widget build(BuildContext context) {
    if (store.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (store.crates.isEmpty && store.errorMessage != null) {
      return _MessageState(
        icon: Icons.wifi_off_outlined,
        title: 'Brak danych',
        message: store.errorMessage!,
        actionLabel: 'Sprobuj ponownie',
        onAction: store.refreshCrates,
      );
    }

    final types = ['All', ...store.crates.map((crate) => crate.type).toSet()];
    final normalizedQuery = query.trim().toLowerCase();
    final filteredCrates = store.crates.where((crate) {
      final matchesQuery =
          normalizedQuery.isEmpty ||
          crate.name.toLowerCase().contains(normalizedQuery);
      final matchesType = type == 'All' || crate.type == type;
      return matchesQuery && matchesType;
    }).toList();

    return RefreshIndicator(
      onRefresh: store.refreshCrates,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: [
          _StatusPanel(store: store),
          const SizedBox(height: 12),
          TextField(
            onChanged: onQueryChanged,
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.search),
              hintText: 'Szukaj skrzynki',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 42,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: types.length,
              separatorBuilder: (_, _) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final current = types[index];
                return FilterChip(
                  label: Text(current == 'All' ? 'Wszystkie' : current),
                  selected: current == type,
                  onSelected: (_) => onTypeChanged(current),
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          if (filteredCrates.isEmpty)
            const _MessageState(
              icon: Icons.search_off,
              title: 'Nic nie znaleziono',
              message: 'Zmien fraze wyszukiwania albo filtr typu.',
            )
          else
            ...filteredCrates.map(
              (crate) => _CrateCard(crate: crate, store: store),
            ),
        ],
      ),
    );
  }
}

class _StatusPanel extends StatelessWidget {
  const _StatusPanel({required this.store});

  final Cs2Store store;

  @override
  Widget build(BuildContext context) {
    final updated = store.lastUpdated;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          const Icon(Icons.storage_outlined),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${store.crates.length} skrzynek zapisanych lokalnie',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(height: 2),
                Text(
                  updated == null
                      ? 'Dane zostana zapisane po pierwszym pobraniu.'
                      : 'Ostatnia aktualizacja: ${_formatDate(updated)}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static String _formatDate(DateTime dateTime) {
    final local = dateTime.toLocal();
    final day = local.day.toString().padLeft(2, '0');
    final month = local.month.toString().padLeft(2, '0');
    final hour = local.hour.toString().padLeft(2, '0');
    final minute = local.minute.toString().padLeft(2, '0');
    return '$day.$month.${local.year} $hour:$minute';
  }
}

class _CrateCard extends StatelessWidget {
  const _CrateCard({required this.crate, required this.store});

  final Cs2Crate crate;
  final Cs2Store store;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Card(
        child: InkWell(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => CrateDetailScreen(crate: crate, store: store),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                SizedBox.square(
                  dimension: 86,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.18),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Cs2Image(url: crate.imageUrl),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        crate.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '${crate.contains.length} skinow + ${crate.containsRare.length} rzadkich dropow',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          Chip(label: Text(crate.type)),
                          if (crate.firstSaleDate != null)
                            Chip(label: Text(crate.firstSaleDate!)),
                        ],
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _MessageState extends StatelessWidget {
  const _MessageState({
    required this.icon,
    required this.title,
    required this.message,
    this.actionLabel,
    this.onAction,
  });

  final IconData icon;
  final String title;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 44),
            const SizedBox(height: 14),
            Text(title, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: 18),
              FilledButton.icon(
                onPressed: onAction,
                icon: const Icon(Icons.refresh),
                label: Text(actionLabel!),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
