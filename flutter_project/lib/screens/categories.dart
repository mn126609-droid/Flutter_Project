import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../providers/medicine_provider.dart';
import '../utils/constants.dart';

class CategoryScreen extends StatelessWidget {
  final VoidCallback? onCategorySelected;

  const CategoryScreen({super.key, this.onCategorySelected});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text(
          'Categories',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: primaryColor,
        automaticallyImplyLeading: false,
      ),
      body: BlocBuilder<MedicineCubit, MedicineState>(
        builder: (context, state) {
          return GridView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: categoriesList.length + 1,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 14,
              crossAxisSpacing: 14,
              childAspectRatio: 1.2,
            ),
            itemBuilder: (context, index) {
              if (index == categoriesList.length) {
                return _AddCategoryTile(onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                          'Categories are fixed for now — custom categories are coming soon.'),
                    ),
                  );
                });
              }

              final category = categoriesList[index];
              final count =
                  state.medicines.where((m) => m.category == category).length;
              final style = styleForCategory(category);

              return _CategoryTile(
                name: category,
                count: count,
                color: style.color,
                icon: style.icon,
                onTap: () {
                  context.read<MedicineCubit>().setFilter(category);
                  onCategorySelected?.call();
                },
              );
            },
          );
        },
      ),
    );
  }
}

class _CategoryTile extends StatelessWidget {
  final String name;
  final int count;
  final Color color;
  final IconData icon;
  final VoidCallback onTap;

  const _CategoryTile({
    required this.name,
    required this.count,
    required this.color,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: textColor, size: 22),
            ),
            const Spacer(),
            Text(name,
                style: const TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 16, color: textColor)),
            const SizedBox(height: 2),
            Text('$count items',
                style: const TextStyle(fontSize: 12, color: subTextColor)),
          ],
        ),
      ),
    );
  }
}

class _AddCategoryTile extends StatelessWidget {
  final VoidCallback onTap;
  const _AddCategoryTile({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: _OutlinedTileBox(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            CircleAvatar(
              radius: 18,
              backgroundColor: Color(0xFFF0F0F0),
              child: Icon(Icons.add, color: subTextColor),
            ),
            SizedBox(height: 8),
            Text('Add Category',
                style: TextStyle(color: subTextColor, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}

class _OutlinedTileBox extends StatelessWidget {
  final Widget child;
  const _OutlinedTileBox({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
            color: subTextColor.withValues(alpha: 0.4), width: 1.4),
      ),
      child: child,
    );
  }
}
