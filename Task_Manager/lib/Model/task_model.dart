class Task {
  String id;
  String name;
  String description;
  String status; // open / completed
  DateTime dueDate;

  Task({
    required this.id,
    required this.name,
    required this.description,
    required this.status,
    required this.dueDate,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'description': description,
        'status': status,
       'dueDate': dueDate.toIso8601String()
      };

  factory Task.fromMap(Map<String, dynamic> map) {
  return Task(
    id: map['id'] ?? '',
    name: map['name'] ?? '',
    description: map['description'] ?? '',
    status: map['status'] ?? 'open',
    dueDate: map['dueDate'] != null ? DateTime.tryParse(map['dueDate']) ?? DateTime.now() : DateTime.now(),
  );
}

}
