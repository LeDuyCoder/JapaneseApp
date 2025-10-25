class FolderModel {
  final int id;
  final String name;
  final String dateCreated;
  final int amountTopic;

  FolderModel({required this.id, required this.name, required this.dateCreated, required this.amountTopic});

  factory FolderModel.fromMap(Map<String, dynamic> m) => FolderModel(
    id: m['id'],
    name: m['namefolder'],
    dateCreated: m['datefolder'],
    amountTopic: m['amountTopic'] ?? 0,
  );
}
