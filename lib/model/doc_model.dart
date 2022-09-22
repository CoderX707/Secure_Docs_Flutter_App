final String tableDocs = 'docs';

class DocFields {
  static final List<String> values = [
    /// Add all fields
    id, title, filebase64, time
  ];

  static const String id = '_id';
  static const String title = 'title';
  static const String filebase64 = 'filebase64';
  static const String time = 'time';
}

class Doc {
  final int? id;

  final String title;
  final String filebase64;
  final DateTime createdTime;

  const Doc({
    this.id,
    required this.title,
    required this.filebase64,
    required this.createdTime,
  });

  Doc copy({
    int? id,
    String? title,
    String? filebase64,
    DateTime? createdTime,
  }) =>
      Doc(
        id: id ?? this.id,
        title: title ?? this.title,
        filebase64: filebase64 ?? this.filebase64,
        createdTime: createdTime ?? this.createdTime,
      );

  static Doc fromJson(Map<String, Object?> json) => Doc(
        id: json[DocFields.id] as int?,
        title: json[DocFields.title] as String,
        filebase64: json[DocFields.filebase64] as String,
        createdTime: DateTime.parse(json[DocFields.time] as String),
      );

  Map<String, Object?> toJson() => {
        DocFields.id: id,
        DocFields.title: title,
        DocFields.filebase64: filebase64,
        DocFields.time: createdTime.toIso8601String(),
      };
}
