class Medicine {
  final String id;
  final String name;
  final String dosage;
  final String category;
  final String type;
  final String frequency;
  final String duration;
  final DateTime date;
  final String time;
  final String notes;

  Medicine({
    required this.id,
    required this.name,
    required this.dosage,
    required this.category,
    required this.type,
    required this.frequency,
    required this.duration,
    required this.date,
    required this.time,
    this.notes = '',
  });

  Medicine copyWith({
    String? id,
    String? name,
    String? dosage,
    String? category,
    String? type,
    String? frequency,
    String? duration,
    DateTime? date,
    String? time,
    String? notes,
  }) {
    return Medicine(
      id: id ?? this.id,
      name: name ?? this.name,
      dosage: dosage ?? this.dosage,
      category: category ?? this.category,
      type: type ?? this.type,
      frequency: frequency ?? this.frequency,
      duration: duration ?? this.duration,
      date: date ?? this.date,
      time: time ?? this.time,
      notes: notes ?? this.notes,
    );
  }
}
