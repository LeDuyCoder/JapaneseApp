abstract class CharacterEvent{}

class LoadCharacterEvent extends CharacterEvent{
  final String type;
  final List<Map<String, dynamic>> rowData;

  LoadCharacterEvent({required this.type, required this.rowData});
}