class Soul {
  final String name; // nome do arquivo da imagem
  final String displayName; // nome que vai aparecer na tela
  final Map<String, List<num>> attributes; // exemplo: 'Absorb': [5, 10, 20]
  final String rarity;
  final bool pvp;

  Soul({
    required this.name,
    required this.displayName,
    required this.attributes,
    required this.rarity,
    required this.pvp,
  });
}
