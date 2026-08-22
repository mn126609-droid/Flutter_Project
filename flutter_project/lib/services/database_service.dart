import 'package:hive_ce_flutter/hive_ce_flutter.dart';
import '../models/medicine_model.dart';

class MedicineDatabase {
  static const String boxName = 'medicines';
  late Box<Map> _box;

  Future<void> init() async {
    await Hive.initFlutter();
    _box = await Hive.openBox<Map>(boxName);
  }

  bool get isEmpty => _box.isEmpty;

  List<Medicine> getAll() {
    return _box.values
        .map((m) => Medicine.fromMap(Map<String, dynamic>.from(m)))
        .toList();
  }

  Future<void> add(Medicine medicine) {
    return _box.put(medicine.id.toString(), medicine.toMap());
  }

  Future<void> update(Medicine medicine) {
    return _box.put(medicine.id.toString(), medicine.toMap());
  }

  Future<void> delete(int id) {
    return _box.delete(id.toString());
  }
}
