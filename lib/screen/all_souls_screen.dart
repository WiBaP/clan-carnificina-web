import 'package:flutter/material.dart';
import '../data/souls_data.dart';

// Tela principal que lista todas as souls com filtros e busca
class AllSouls extends StatefulWidget {
  const AllSouls({super.key});

  @override
  State<AllSouls> createState() => _AllSoulsState();
}

class _AllSoulsState extends State<AllSouls> {
  String selectedRarity = 'All';
  String selectedAttribute = 'All';
  String selectedPvp = 'All';
  String searchQuery = '';

  final ScrollController _scrollController = ScrollController();

  Color getColorByRarity(String rarity) {
    switch (rarity.toLowerCase()) {
      case 'legendary':
        return const Color(0xFFFFD700);
      case 'rare':
        return Colors.lightBlueAccent;
      case 'common':
        return Colors.white70;
      default:
        return Colors.white70;
    }
  }

  List<String> getAllAttributes() {
    final attributesSet = <String>{};
    for (final soul in souls) {
      attributesSet.addAll(soul.attributes.keys);
    }
    return ['All', ...attributesSet];
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filteredSouls = souls.where((soul) {
      if (selectedRarity != 'All' &&
          soul.rarity.toLowerCase() != selectedRarity.toLowerCase()) {
        return false;
      }
      if (selectedAttribute != 'All' &&
          !soul.attributes.containsKey(selectedAttribute)) {
        return false;
      }
      if (selectedPvp == 'Yes' && !soul.pvp) {
        return false;
      }
      if (selectedPvp == 'No' && soul.pvp) {
        return false;
      }
      if (searchQuery.isNotEmpty &&
          !soul.displayName.toLowerCase().contains(searchQuery.toLowerCase())) {
        return false;
      }
      return true;
    }).toList();

    return Container(
      color: Colors.black, // <-- fundo preto
      child: Column(
        children: [
          // Linha com títulos (Rarity, Attribute, PVP)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
            child: Row(
              children: [
                const SizedBox(
                  width: 120,
                  child: Text(''),
                ), // espaço do Total Souls
                const Spacer(),
                const SizedBox(
                  width: 100,
                  child: Text(
                    'Rarity',
                    style: TextStyle(
                      color: Colors.white70,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
                const SizedBox(width: 8),
                const SizedBox(
                  width: 120,
                  child: Text(
                    'Attribute',
                    style: TextStyle(
                      color: Colors.white70,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
                const SizedBox(width: 8),
                const SizedBox(
                  width: 80,
                  child: Text(
                    'PVP',
                    style: TextStyle(
                      color: Colors.white70,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
                const Spacer(),
                const SizedBox(width: 200), // espaço da search bar
              ],
            ),
          ),

          // Linha com Total Souls + filtros + search
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 120,
                  child: Text(
                    'Total Souls: ${filteredSouls.length}',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ),
                const Spacer(),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: 100,
                      child: DropdownButton<String>(
                        value: selectedRarity,
                        dropdownColor: Colors.black87,
                        style: const TextStyle(color: Colors.white),
                        isExpanded: true,
                        items: const [
                          DropdownMenuItem(value: 'All', child: Text('All')),
                          DropdownMenuItem(
                            value: 'Legendary',
                            child: Text('Legendary'),
                          ),
                          DropdownMenuItem(value: 'Rare', child: Text('Rare')),
                          DropdownMenuItem(
                            value: 'Common',
                            child: Text('Common'),
                          ),
                        ],
                        onChanged: (value) =>
                            setState(() => selectedRarity = value!),
                      ),
                    ),
                    const SizedBox(width: 8),
                    SizedBox(
                      width: 120,
                      child: DropdownButton<String>(
                        value: selectedAttribute,
                        dropdownColor: Colors.black87,
                        style: const TextStyle(color: Colors.white),
                        isExpanded: true,
                        items: getAllAttributes()
                            .map(
                              (attr) => DropdownMenuItem(
                                value: attr,
                                child: Text(attr),
                              ),
                            )
                            .toList(),
                        onChanged: (value) =>
                            setState(() => selectedAttribute = value!),
                      ),
                    ),
                    const SizedBox(width: 8),
                    SizedBox(
                      width: 80,
                      child: DropdownButton<String>(
                        value: selectedPvp,
                        dropdownColor: Colors.black87,
                        style: const TextStyle(color: Colors.white),
                        isExpanded: true,
                        items: const [
                          DropdownMenuItem(value: 'All', child: Text('All')),
                          DropdownMenuItem(value: 'Yes', child: Text('Yes')),
                          DropdownMenuItem(value: 'No', child: Text('No')),
                        ],
                        onChanged: (value) =>
                            setState(() => selectedPvp = value!),
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                SizedBox(
                  width: 200,
                  child: TextField(
                    onChanged: (value) => setState(() => searchQuery = value),
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Search Soul',
                      hintStyle: const TextStyle(color: Colors.white54),
                      filled: true,
                      fillColor: Colors.black54,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 8,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                        borderSide: BorderSide.none,
                      ),
                      isDense: true,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Grid de Souls
          Expanded(
            child: RawScrollbar(
              thumbVisibility: true,
              interactive: true,
              thickness: 6,
              radius: const Radius.circular(4),
              thumbColor: Colors.white,
              controller: _scrollController,
              child: GridView(
                controller: _scrollController,
                padding: const EdgeInsets.all(8),
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 300,
                  mainAxisSpacing: 50,
                  crossAxisSpacing: 50,
                  childAspectRatio: 1,
                ),
                children: filteredSouls.map((soul) {
                  final rarityColor = getColorByRarity(soul.rarity);
                  return MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      onTap: () {},
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.black.withAlpha((0.7 * 255).toInt()),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: rarityColor, width: 1),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withAlpha(
                                (0.5 * 255).toInt(),
                              ),
                              blurRadius: 4,
                              offset: const Offset(2, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  soul.displayName,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: rarityColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                if (soul.pvp)
                                  const Padding(
                                    padding: EdgeInsets.only(left: 6),
                                    child: Text(
                                      'PVP',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.red,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Image.asset(
                              'assets/souls/${soul.name}',
                              width: 40,
                              height: 40,
                            ),
                            const SizedBox(height: 4),
                            Container(height: 1, color: rarityColor),
                            const SizedBox(height: 2),
                            Row(
                              children: const [
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    'Attribute',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 11,
                                      color: Colors.white70,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    'LV1',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 11,
                                      color: Colors.white70,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    'LV2',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 11,
                                      color: Colors.white70,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    'LV3',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 11,
                                      color: Colors.white70,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Container(height: 1, color: Colors.white24),
                            const SizedBox(height: 2),
                            Expanded(
                              child: SingleChildScrollView(
                                child: Column(
                                  children: soul.attributes.entries.map((
                                    entry,
                                  ) {
                                    final attrName = entry.key;
                                    final levels = entry.value;
                                    final isPercentAttr = [
                                      'evade',
                                      'aging success',
                                      'own spec chance',
                                      'block',
                                      'critical',
                                      'experience',
                                      'own item type',
                                    ].contains(attrName.toLowerCase());
                                    String formatValue(num value) =>
                                        isPercentAttr ? '+$value%' : '+$value';
                                    return Column(
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              flex: 2,
                                              child: Text(
                                                attrName,
                                                style: const TextStyle(
                                                  fontSize: 11,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                            ...levels.map(
                                              (lv) => Expanded(
                                                child: Text(
                                                  formatValue(lv),
                                                  textAlign: TextAlign.center,
                                                  style: const TextStyle(
                                                    fontSize: 11,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Container(
                                          height: 1,
                                          color: Colors.white24,
                                        ),
                                      ],
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                            Text(
                              'Rarity: ${soul.rarity}',
                              style: TextStyle(
                                fontSize: 11,
                                color: rarityColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
