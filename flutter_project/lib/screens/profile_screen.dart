import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../providers/medicine_provider.dart';
import '../utils/constants.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text('Profile',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: primaryColor,
        automaticallyImplyLeading: false,
      ),
      body: BlocBuilder<MedicineCubit, MedicineState>(
        builder: (context, state) {
          final total = state.medicines.length;
          final taken = state.medicines.where((m) => m.taken).length;
          final categoriesInUse =
              state.medicines.map((m) => m.category).toSet().length;

          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: primaryColor,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  children: [
                    const CircleAvatar(
                      radius: 36,
                      backgroundColor: Colors.white,
                      child: Icon(Icons.person, color: primaryColor, size: 36),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'MedTrack User',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Organize your joyful health journey.',
                      style: TextStyle(color: Colors.white70),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(child: _StatCard(label: 'Medicines', value: '$total')),
                  const SizedBox(width: 12),
                  Expanded(child: _StatCard(label: 'Taken Today', value: '$taken')),
                  const SizedBox(width: 12),
                  Expanded(
                      child: _StatCard(
                          label: 'Categories', value: '$categoriesInUse')),
                ],
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const ListTile(
                  leading: Icon(Icons.info_outline, color: primaryColor),
                  title: Text('About MedTrack',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(
                      'A simple app to keep track of your medicine schedule and history.'),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  const _StatCard({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text(value,
              style: const TextStyle(
                  fontSize: 22, fontWeight: FontWeight.bold, color: primaryColor)),
          const SizedBox(height: 4),
          Text(label,
              style: const TextStyle(fontSize: 12, color: subTextColor),
              textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
