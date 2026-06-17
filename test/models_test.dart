import 'package:cs2_skins_app/models/crate.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('parses crate with contained skins', () {
    final crate = Cs2Crate.fromJson({
      'id': 'crate-4904',
      'name': 'Kilowatt Case',
      'type': 'Case',
      'image': 'https://example.com/case.png',
      'first_sale_date': '2024-01-16',
      'contains': [
        {
          'id': 'skin-135748',
          'name': 'Dual Berettas | Hideout',
          'image': 'https://example.com/skin.png',
          'rarity': {
            'id': 'rarity_rare_weapon',
            'name': 'Mil-Spec Grade',
            'color': '#4b69ff',
          },
          'paint_index': '1169',
        },
      ],
      'contains_rare': [],
    });

    expect(crate.id, 'crate-4904');
    expect(crate.contains, hasLength(1));
    expect(crate.contains.first.name, 'Dual Berettas | Hideout');
    expect(crate.contains.first.rarity.name, 'Mil-Spec Grade');
  });
}
