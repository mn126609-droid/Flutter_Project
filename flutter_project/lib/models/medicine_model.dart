class Medicine {
  final int id;
  final String name;
  final String dosage;
  final String category;
  final String type;
  final String frequency;
  final String duration;
  final DateTime date;
  final String time;
  final String notes;
  final bool taken;

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
    this.taken = false,
  });

  Medicine copyWith({
    int? id,
    String? name,
    String? dosage,
    String? category,
    String? type,
    String? frequency,
    String? duration,
    DateTime? date,
    String? time,
    String? notes,
    bool? taken,
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
      taken: taken ?? this.taken,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'dosage': dosage,
      'category': category,
      'type': type,
      'frequency': frequency,
      'duration': duration,
      'date': date.millisecondsSinceEpoch,
      'time': time,
      'notes': notes,
      'taken': taken,
    };
  }

  factory Medicine.fromMap(Map<String, dynamic> map) {
    return Medicine(
      id: map['id'] as int,
      name: map['name'] as String,
      dosage: map['dosage'] as String,
      category: map['category'] as String,
      type: map['type'] as String,
      frequency: map['frequency'] as String,
      duration: map['duration'] as String,
      date: DateTime.fromMillisecondsSinceEpoch(map['date'] as int),
      time: map['time'] as String,
      notes: map['notes'] as String? ?? '',
      taken: map['taken'] as bool? ?? false,
    );
  }
}
