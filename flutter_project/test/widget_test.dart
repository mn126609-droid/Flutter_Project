import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_project/models/medicine_model.dart';

void main() {
  test('Medicine toMap/fromMap round-trip preserves all fields', () {
    final medicine = Medicine(
      id: 1,
      name: 'Vitamin D3',
      dosage: '1000 IU',
      category: 'Vitamins',
      type: 'Capsule',
      frequency: 'Once daily',
      duration: '30 days',
      date: DateTime(2026, 1, 1),
      time: '08:00 AM',
      notes: 'Take after breakfast',
      taken: true,
    );

    final restored = Medicine.fromMap(medicine.toMap());

    expect(restored.id, medicine.id);
    expect(restored.name, medicine.name);
    expect(restored.dosage, medicine.dosage);
    expect(restored.category, medicine.category);
    expect(restored.type, medicine.type);
    expect(restored.frequency, medicine.frequency);
    expect(restored.duration, medicine.duration);
    expect(restored.date, medicine.date);
    expect(restored.time, medicine.time);
    expect(restored.notes, medicine.notes);
    expect(restored.taken, medicine.taken);
  });

  test('Medicine copyWith only overrides given fields', () {
    final medicine = Medicine(
      id: 1,
      name: 'Amoxicillin',
      dosage: '500 mg',
      category: 'Antibiotics',
      type: 'Tablet',
      frequency: 'Every 8 hours',
      duration: '7 days',
      date: DateTime(2026, 1, 1),
      time: '12:00 PM',
    );

    final updated = medicine.copyWith(taken: true);

    expect(updated.taken, true);
    expect(updated.name, medicine.name);
    expect(updated.id, medicine.id);
  });
}
