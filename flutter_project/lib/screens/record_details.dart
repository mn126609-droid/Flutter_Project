import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_project/models/medicine_model.dart';
import 'package:intl/intl.dart';
import '../providers/medicine_provider.dart';
import '../utils/constants.dart';
import 'add_record.dart';

class MedicineScreen extends StatelessWidget {
  const MedicineScreen({super.key, required this.medicine});
  final Medicine medicine;

  @override
  Widget build(BuildContext context) {
    final info = [
      ['Type', medicine.type],
      ['Dosage', medicine.dosage],
      ['Frequency', medicine.frequency],
      ['Date', DateFormat('MMM d, yyyy').format(medicine.date)],
      ['Time', medicine.time],
    ];

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text('Details'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(30),
              decoration: BoxDecoration(
                  color: primaryColor, borderRadius: BorderRadius.circular(24)),
              child: Column(
                children: [
                  const CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.white,
                      child:
                          Icon(Icons.medication, color: primaryColor, size: 36)),
                  const SizedBox(height: 12),
                  Text(medicine.name,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold)),
                  Text('${medicine.dosage} • ${medicine.category}',
                      style: const TextStyle(color: Colors.white70)),
                ],
              ),
            ),
            const SizedBox(height: 31),

            // Info grid
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 1.3,
              children: info
                  .map((e) => Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(e[0].toUpperCase(),
                                style: const TextStyle(
                                    fontSize: 12, color: Colors.grey)),
                            const SizedBox(height: 2),
                            Text(e[1],
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w500)),
                          ],
                        ),
                      ))
                  .toList(),
            ),

            if (medicine.duration.isNotEmpty) ...[
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                    color: Colors.white, borderRadius: BorderRadius.circular(16)),
                child: Row(
                  children: [
                    const Icon(Icons.timelapse, color: primaryColor),
                    const SizedBox(width: 10),
                    Text('Duration: ${medicine.duration}',
                        style: const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w500)),
                  ],
                ),
              ),
            ],

            if (medicine.notes.isNotEmpty) ...[
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                    color: Colors.white, borderRadius: BorderRadius.circular(16)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('NOTES',
                        style: TextStyle(fontSize: 12, color: Colors.grey)),
                    const SizedBox(height: 4),
                    Text(medicine.notes,
                        style: const TextStyle(fontSize: 14)),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 20),

            // Buttons
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AddRecordScreen(
                              screen: 'Edit Medicine',
                              medicine: medicine,
                            )));
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  minimumSize: const Size.fromHeight(50)),
              child: const Text('Edit Details',
                  style: TextStyle(color: Colors.white)),
            ),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: () async {
                final confirmed = await showDialog<bool>(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: const Text('Delete Medicine'),
                        content: Text(
                            'Are you sure you want to delete "${medicine.name}"?'),
                        actions: [
                          TextButton(
                              onPressed: () => Navigator.pop(ctx, false),
                              child: const Text('Cancel')),
                          TextButton(
                              onPressed: () => Navigator.pop(ctx, true),
                              child: const Text('Delete',
                                  style: TextStyle(color: Colors.red))),
                        ],
                      ),
                    ) ??
                    false;

                if (confirmed && context.mounted) {
                  context.read<MedicineCubit>().deleteMedicine(medicine.id);
                  Navigator.pop(context);
                }
              },
              style: OutlinedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50)),
              child: const Text('Delete Medicine',
                  style: TextStyle(color: primaryColor)),
            ),
          ],
        ),
      ),
    );
  }
}
