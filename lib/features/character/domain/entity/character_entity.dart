enum CharacterGroupType {
  basic,
  dakuon,
  combo,
  small,
  longVowel,
}

class CharacterEntity {
  final String text;
  final String romaji;
  final String? sound;
  final int level;

  const CharacterEntity({
    required this.text,
    required this.romaji,
    this.sound,
    required this.level,
  });

  bool get isCompleted => level >= 27;

  double get progress => level / 27;
}
