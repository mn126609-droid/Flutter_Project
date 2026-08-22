import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../models/medicine_model.dart';
import '../providers/medicine_provider.dart';
import '../utils/constants.dart';

class AddRecordScreen extends StatefulWidget {
  const AddRecordScreen({
    super.key,
    required this.screen,
    this.medicine,
  });
  final String screen;
  final Medicine? medicine;

  @override
  State<AddRecordScreen> createState() => _AddRecordScreenState();
}

class _AddRecordScreenState extends State<AddRecordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _dosageController = TextEditingController();
  final _frequencyController = TextEditingController();
  final _durationController = TextEditingController();
  final _notesController = TextEditingController();

  late String _selectedCategory;
  late String _selectedType;
  late DateTime _selectedDate;
  late TimeOfDay _selectedTime;

  @override
  void initState() {
    super.initState();
    final medicine = widget.medicine;
    if (medicine != null) {
      _nameController.text = medicine.name;
      _dosageController.text = medicine.dosage;
      _frequencyController.text = medicine.frequency;
      _durationController.text = medicine.duration;
      _notesController.text = medicine.notes;
      _selectedCategory = medicine.category;
      _selectedType = medicine.type;
      _selectedDate = medicine.date;
      _selectedTime = _parseTime(medicine.time);
    } else {
      _selectedCategory = categoriesList.first;
      _selectedType = typesList.first;
      _selectedDate = DateTime.now();
      _selectedTime = TimeOfDay.now();
    }
  }

  TimeOfDay _parseTime(String time) {
    try {
      final dt = DateFormat('hh:mm a').parse(time.trim());
      return TimeOfDay(hour: dt.hour, minute: dt.minute);
    } catch (_) {
      return TimeOfDay.now();
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _dosageController.dispose();
    _frequencyController.dispose();
    _durationController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  bool get isEditMode => widget.medicine != null;

  void _saveMedicine() {
    if (!_formKey.currentState!.validate()) return;

    final dt = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
      _selectedTime.hour,
      _selectedTime.minute,
    );

    final medicine = Medicine(
      // If editing → keep the SAME ID
      // If adding → create a NEW ID
      id: isEditMode
          ? widget.medicine!.id
          : DateTime.now().millisecondsSinceEpoch,

      name: _nameController.text.trim(),

      dosage: _dosageController.text.trim().isEmpty
          ? '1 dose'
          : _dosageController.text.trim(),

      category: _selectedCategory,

      type: _selectedType,

      frequency: _frequencyController.text.trim().isEmpty
          ? 'Once daily'
          : _frequencyController.text.trim(),

      duration: _durationController.text.trim().isEmpty
          ? '7 days'
          : _durationController.text.trim(),

      date: _selectedDate,

      time: DateFormat('hh:mm a').format(dt),

      notes: _notesController.text.trim(),

      taken: isEditMode ? widget.medicine!.taken : false,
    );

    final cubit = context.read<MedicineCubit>();

    if (isEditMode) {
      cubit.updateMedicine(medicine);
      // Edit is opened from Details, which is itself pushed on top of Home,
      // so pop both to land back on Home instead of Details.
      Navigator.popUntil(context, (route) => route.isFirst);
    } else {
      cubit.addMedicine(medicine);
      Navigator.pop(context);
    }
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {String? hint,
      IconData? icon,
      int maxLines = 1,
      String? Function(String?)? validator}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style:
                const TextStyle(fontWeight: FontWeight.bold, color: textColor)),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: cardColor,
            prefixIcon: icon != null ? Icon(icon, color: primaryColor) : null,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none),
          ),
        ),
        const SizedBox(height: 14),
      ],
    );
  }

  Widget _buildDropdown(String label, String value, List<String> items,
      ValueChanged<String?> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style:
                const TextStyle(fontWeight: FontWeight.bold, color: textColor)),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
              color: cardColor, borderRadius: BorderRadius.circular(12)),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              isExpanded: true,
              value: value,
              items: items
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: onChanged,
            ),
          ),
        ),
        const SizedBox(height: 14),
      ],
    );
  }

  Widget _buildPickerTile(
      String label, String value, IconData icon, VoidCallback onTap) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style:
                const TextStyle(fontWeight: FontWeight.bold, color: textColor)),
        const SizedBox(height: 6),
        InkWell(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
            decoration: BoxDecoration(
                color: cardColor, borderRadius: BorderRadius.circular(12)),
            child: Row(
              children: [
                Icon(icon, size: 18, color: primaryColor),
                const SizedBox(width: 8),
                Text(value, style: const TextStyle(color: textColor)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text(widget.screen,
            style: const TextStyle(
                fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: primaryColor,
        leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildTextField('Medicine Name *', _nameController,
                  hint: 'e.g. Panadol',
                  icon: Icons.medication,
                  validator: (v) => (v == null || v.trim().isEmpty)
                      ? 'Name is required'
                      : null),
              _buildTextField('Dosage', _dosageController,
                  hint: 'e.g. 500 mg', icon: Icons.fitness_center),
              _buildDropdown('Category', _selectedCategory, categoriesList,
                  (v) => setState(() => _selectedCategory = v!)),
              _buildDropdown('Type', _selectedType, typesList,
                  (v) => setState(() => _selectedType = v!)),
              Row(
                children: [
                  Expanded(
                      child: _buildTextField('Frequency', _frequencyController,
                          hint: 'e.g. Twice daily', icon: Icons.repeat)),
                  const SizedBox(width: 12),
                  Expanded(
                      child: _buildTextField('Duration', _durationController,
                          hint: 'e.g. 7 days', icon: Icons.timelapse)),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: _buildPickerTile(
                      'Start Date',
                      DateFormat('yyyy-MM-dd').format(_selectedDate),
                      Icons.calendar_today,
                      () async {
                        final d = await showDatePicker(
                            context: context,
                            initialDate: _selectedDate,
                            firstDate: DateTime(2020),
                            lastDate: DateTime(2030));
                        if (d != null) setState(() => _selectedDate = d);
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildPickerTile(
                      'Time',
                      _selectedTime.format(context),
                      Icons.access_time,
                      () async {
                        final t = await showTimePicker(
                            context: context, initialTime: _selectedTime);
                        if (t != null) setState(() => _selectedTime = t);
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              _buildTextField('Notes (Optional)', _notesController,
                  hint: 'e.g. After meal',
                  icon: Icons.note_alt_outlined,
                  maxLines: 3),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12))),
                  onPressed: _saveMedicine,
                  child: Text(
                    isEditMode ? 'Update Medicine' : 'Save Medicine',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
