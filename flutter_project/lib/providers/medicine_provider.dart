import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/medicine_model.dart';
import '../services/database_service.dart';

class MedicineState {
  final List<Medicine> medicines;
  final String selectedFilter;
  final String searchQuery;
  final bool isLoading;

  MedicineState({
    required this.medicines,
    this.selectedFilter = 'All',
    this.searchQuery = '',
    this.isLoading = false,
  });

  MedicineState copyWith({
    List<Medicine>? medicines,
    String? selectedFilter,
    String? searchQuery,
    bool? isLoading,
  }) {
    return MedicineState(
      medicines: medicines ?? this.medicines,
      selectedFilter: selectedFilter ?? this.selectedFilter,
      searchQuery: searchQuery ?? this.searchQuery,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class MedicineCubit extends Cubit<MedicineState> {
  final MedicineDatabase _db;

  MedicineCubit(this._db) : super(MedicineState(medicines: []));

  Future<void> loadMedicines() async {
    emit(state.copyWith(isLoading: true));

    if (_db.isEmpty) {
      final seedMedicines = [
        Medicine(
          id: 1,
          name: 'Vitamin D3',
          dosage: '1000 IU',
          category: 'Vitamins',
          type: 'Capsule',
          frequency: 'Once daily',
          duration: '30 days',
          date: DateTime.now(),
          time: '08:00 AM',
          notes: 'Take after breakfast',
        ),
        Medicine(
          id: 2,
          name: 'Amoxicillin',
          dosage: '500 mg',
          category: 'Antibiotics',
          type: 'Tablet',
          frequency: 'Every 8 hours',
          duration: '7 days',
          date: DateTime.now(),
          time: '12:00 PM',
          notes: 'Complete full course',
        ),
        Medicine(
          id: 3,
          name: 'Panadol Extra',
          dosage: '500 mg',
          category: 'Pain Relief',
          type: 'Tablet',
          frequency: 'As needed',
          duration: '3 days',
          date: DateTime.now(),
          time: '02:00 PM',
          notes: 'Take with a full glass of water',
        ),
      ];

      for (final medicine in seedMedicines) {
        await _db.add(medicine);
      }
    }

    emit(state.copyWith(medicines: _db.getAll(), isLoading: false));
  }

  Future<void> addMedicine(Medicine medicine) async {
    await _db.add(medicine);
    final updatedList = List<Medicine>.from(state.medicines)..add(medicine);
    emit(state.copyWith(medicines: updatedList));
  }

  Future<void> updateMedicine(Medicine medicine) async {
    await _db.update(medicine);
    final updatedList = List<Medicine>.from(state.medicines);
    final i = updatedList.indexWhere((m) => m.id == medicine.id);
    if (i != -1) {
      updatedList[i] = medicine;
      emit(state.copyWith(medicines: updatedList));
    }
  }

  Future<void> deleteMedicine(int id) async {
    await _db.delete(id);
    final updatedList = state.medicines.where((item) => item.id != id).toList();
    emit(state.copyWith(medicines: updatedList));
  }

  Future<void> toggleTaken(int id) async {
    final i = state.medicines.indexWhere((m) => m.id == id);
    if (i == -1) return;
    final updated = state.medicines[i].copyWith(taken: !state.medicines[i].taken);
    await _db.update(updated);
    final updatedList = List<Medicine>.from(state.medicines);
    updatedList[i] = updated;
    emit(state.copyWith(medicines: updatedList));
  }

  void setFilter(String filter) {
    emit(state.copyWith(selectedFilter: filter));
  }

  void setSearchQuery(String query) {
    emit(state.copyWith(searchQuery: query));
  }
}
