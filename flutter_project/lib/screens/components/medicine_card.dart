import 'package:flutter/material.dart';
import '../../models/medicine_model.dart';
import '../../utils/constants.dart';
import 'package:flutter_project/screens/record_details.dart';

class MedicineCard extends StatelessWidget {
  final Medicine medicine;
  final VoidCallback? onDelete;
  final VoidCallback? onToggleTaken;

  const MedicineCard({
    super.key,
    required this.medicine,
    this.onDelete,
    this.onToggleTaken,
  });

  @override
  Widget build(BuildContext context) {
    final style = styleForCategory(medicine.category);

    final card = InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => MedicineScreen(medicine: medicine)));
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 6,
                offset: const Offset(0, 2)),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: style.color,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(style.icon, color: textColor, size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(medicine.name,
                      style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: textColor)),
                  const SizedBox(height: 2),
                  Text(
                    '${medicine.dosage} • ${medicine.category}',
                    style: const TextStyle(fontSize: 13, color: subTextColor),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(medicine.time,
                    style: const TextStyle(fontSize: 12, color: subTextColor)),
                const SizedBox(height: 6),
                GestureDetector(
                  onTap: onToggleTaken,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: medicine.taken
                          ? const Color(0xFFE6E6E6)
                          : primaryColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      medicine.taken ? 'Taken' : 'Take',
                      style: TextStyle(
                        color: medicine.taken ? subTextColor : Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );

    if (onDelete == null) return card;

    return Dismissible(
      key: ValueKey(medicine.id),
      direction: DismissDirection.endToStart,
      confirmDismiss: (_) async {
        return await showDialog<bool>(
              context: context,
              builder: (ctx) => AlertDialog(
                title: const Text('Delete Medicine'),
                content:
                    Text('Are you sure you want to delete "${medicine.name}"?'),
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
      },
      onDismissed: (_) => onDelete!(),
      background: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        alignment: Alignment.centerRight,
        decoration: BoxDecoration(
          color: Colors.redAccent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(Icons.delete_outline, color: Colors.white),
      ),
      child: card,
    );
  }
}
