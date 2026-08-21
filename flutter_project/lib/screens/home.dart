import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

  @override
  Widget build(BuildContext context) {
    final filterCategories = ['All', ...categoriesList];

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: _isSearching
            ? TextField(
                controller: _searchController,
                autofocus: true,
                style: const TextStyle(color: Colors.white),
                cursorColor: Colors.white,
                decoration: const InputDecoration(hintText: 'Search medicine...', hintStyle: TextStyle(color: Colors.white70), border: InputBorder.none),
                onChanged: (q) => context.read<MedicineCubit>().setSearchQuery(q),
              )
            : const Text('Medicine Tracker', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: primaryColor,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search, color: Colors.white),
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
      body: Column(
        children: [
          // Filter Chips
          BlocBuilder<MedicineCubit, MedicineState>(
            builder: (context, state) {
              return SizedBox(
                height: 50,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  itemCount: filterCategories.length,
                  itemBuilder: (context, i) {
                    final cat = filterCategories[i];
                    final isSel = state.selectedFilter == cat;
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: ChoiceChip(
                        label: Text(cat, style: TextStyle(color: isSel ? Colors.white : textColor, fontWeight: isSel ? FontWeight.bold : FontWeight.normal)),
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
              );
            },
          ),

          // Medicines List
          Expanded(
            child: BlocBuilder<MedicineCubit, MedicineState>(
              builder: (context, state) {
                final list = state.medicines.where((m) {
                  final matchCat = state.selectedFilter == 'All' || m.category == state.selectedFilter;
                  final matchQuery = state.searchQuery.isEmpty || m.name.toLowerCase().contains(state.searchQuery.toLowerCase());
                  return matchCat && matchQuery;
                }).toList();

                if (list.isEmpty) {
                  return Center(
                    child: Text(
                      state.searchQuery.isNotEmpty ? 'No medicine matches "${state.searchQuery}"' : 'No medicines found.',
                      style: const TextStyle(fontSize: 16, color: subTextColor),
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: list.length,
                  itemBuilder: (context, i) => MedicineCard(
                    medicine: list[i],
                    onDelete: () => context.read<MedicineCubit>().deleteMedicine(list[i].id),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: primaryColor,
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AddRecordScreen())),
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Add Medicine', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }
}
