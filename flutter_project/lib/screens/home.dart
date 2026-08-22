import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/medicine_model.dart';
import '../providers/medicine_provider.dart';
import '../utils/constants.dart';
import 'add_record.dart';
import 'components/medicine_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Medicine? _findNextDose(List<Medicine> medicines) {
    final pending = medicines.where((m) => !m.taken).toList();
    if (pending.isEmpty) return null;
    pending.sort((a, b) => _minutesOfDay(a.time).compareTo(_minutesOfDay(b.time)));
    return pending.first;
  }

  int _minutesOfDay(String time) {
    try {
      final parts = time.trim().split(' ');
      final hm = parts[0].split(':');
      var hour = int.parse(hm[0]) % 12;
      final minute = int.parse(hm[1]);
      if (parts.length > 1 && parts[1].toUpperCase() == 'PM') hour += 12;
      return hour * 60 + minute;
    } catch (_) {
      return 24 * 60;
    }
  }

  @override
  Widget build(BuildContext context) {
    final filterCategories = ['All', ...categoriesList];

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: _isSearching
            ? TextField(
                controller: _searchController,
                autofocus: true,
                style: const TextStyle(color: primaryColor),
                cursorColor: Colors.black,
                decoration: const InputDecoration(
                    hintText: 'Search medicine...',
                    hintStyle: TextStyle(color: primaryColor),
                    border: InputBorder.none),
                onChanged: (q) =>
                    context.read<MedicineCubit>().setSearchQuery(q),
              )
            : Row(
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: const Color(0xffFDE5EF),
                      borderRadius: BorderRadius.circular(13),
                    ),
                    child: const Icon(
                      Icons.medication_outlined,
                      color: Color(0xffC50050),
                      size: 25,
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    'MedTrack',
                    style: TextStyle(
                      color: Color(0xffC50050),
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
        actions: [
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search,
                color: primaryColor),
            onPressed: () {
              setState(() {
                if (_isSearching) {
                  _searchController.clear();
                  context.read<MedicineCubit>().setSearchQuery('');
                }
                _isSearching = !_isSearching;
              });
            },
          ),
        ],
      ),
      body: BlocBuilder<MedicineCubit, MedicineState>(
        builder: (context, state) {
          final total = state.medicines.length;
          final taken = state.medicines.where((m) => m.taken).length;
          final progress = total == 0 ? 0.0 : taken / total;
          final nextDose = _findNextDose(state.medicines);

          final list = state.medicines.where((m) {
            final matchCat = state.selectedFilter == 'All' ||
                m.category == state.selectedFilter;
            final matchQuery = state.searchQuery.isEmpty ||
                m.name.toLowerCase().contains(state.searchQuery.toLowerCase());
            return matchCat && matchQuery;
          }).toList();

          return Column(
            children: [
              if (!_isSearching) ...[
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 56,
                          height: 56,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              CircularProgressIndicator(
                                value: progress,
                                strokeWidth: 6,
                                backgroundColor: const Color(0xFFF0F0F0),
                                valueColor:
                                    const AlwaysStoppedAnimation(primaryColor),
                              ),
                              Text('${(progress * 100).round()}%',
                                  style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: textColor)),
                            ],
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("Today's Progress",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: textColor)),
                              const SizedBox(height: 4),
                              Text('$taken of $total taken',
                                  style: const TextStyle(
                                      color: subTextColor, fontSize: 13)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                if (nextDose != null)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: primaryColor,
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(nextDose.time,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold)),
                              const SizedBox(height: 4),
                              const Text('Next Dose',
                                  style: TextStyle(color: Colors.white70)),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                                '${nextDose.name} - ${nextDose.dosage}',
                                style: const TextStyle(color: Colors.white)),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],

              // Filter Chips
              SizedBox(
                height: 50,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  itemCount: filterCategories.length,
                  itemBuilder: (context, i) {
                    final cat = filterCategories[i];
                    final isSel = state.selectedFilter == cat;
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: ChoiceChip(
                        label: Text(cat,
                            style: TextStyle(
                                color: isSel ? Colors.white : textColor,
                                fontWeight: isSel
                                    ? FontWeight.bold
                                    : FontWeight.normal)),
                        selected: isSel,
                        selectedColor: primaryColor,
                        backgroundColor: cardColor,
                        onSelected: (val) {
                          if (val) context.read<MedicineCubit>().setFilter(cat);
                        },
                      ),
                    );
                  },
                ),
              ),

              // Medicines List
              Expanded(
                child: list.isEmpty
                    ? Center(
                        child: Text(
                          state.searchQuery.isNotEmpty
                              ? 'No medicine matches "${state.searchQuery}"'
                              : 'No medicines found.',
                          style: const TextStyle(
                              fontSize: 16, color: subTextColor),
                        ),
                      )
                    : ListView.builder(
                        itemCount: list.length,
                        itemBuilder: (context, i) => MedicineCard(
                          medicine: list[i],
                          onDelete: () => context
                              .read<MedicineCubit>()
                              .deleteMedicine(list[i].id),
                          onToggleTaken: () => context
                              .read<MedicineCubit>()
                              .toggleTaken(list[i].id),
                        ),
                      ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(0xffC50050),
        onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => AddRecordScreen(screen: 'Add Medicine'))),
        icon: const Icon(
          Icons.add,
          color: Colors.white,
          size: 30,
        ),
        label: const Text('Add Medicine',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }
}
