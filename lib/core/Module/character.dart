class character{
  final String text, romaji;
  final String? image;
  final List<dynamic> example;
  final int? level;

  character(this.level, {required this.text, required this.romaji, this.image, required this.example});

}