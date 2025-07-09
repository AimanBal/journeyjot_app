//screens/ add_edit_jot_screen.dart
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:hive/hive.dart';
import 'package:journeyjot_app/theme/app_theme.dart';
import '../models/jot_model.dart';

class AddEditJotScreen extends StatefulWidget {
  final String? jotId;
  final String userEmail;

  const AddEditJotScreen({super.key, this.jotId, required this.userEmail});

  @override
  State<AddEditJotScreen> createState() => _AddEditJotScreenState();
}

class _AddEditJotScreenState extends State<AddEditJotScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController(); // ✅ Title field added
  final _descController = TextEditingController();
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  Uint8List? _imageBytes;
  late Box<JotModel> jotBox;
  JotModel? _currentJot;

  @override
  void initState() {
    super.initState();
    _initializeHive();
  }

  Future<void> _initializeHive() async {
    if (!Hive.isBoxOpen('jotsBox')) {
      await Hive.openBox<JotModel>('jotsBox');
    }
    jotBox = Hive.box<JotModel>('jotsBox');
    await _loadExistingJot();
  }

  Future<void> _loadExistingJot() async {
    if (widget.jotId == null) return;

    _currentJot = jotBox.get(widget.jotId!);
    if (_currentJot != null) {
      setState(() {
        _titleController.text = _currentJot!.title; // ✅ Load title
        _descController.text = _currentJot!.description;
        _selectedDate = _currentJot!.dateTime;
        _selectedTime = TimeOfDay.fromDateTime(_currentJot!.dateTime);
        _imageBytes = _getImageBytes(_currentJot!.imagePath);
      });
    }
  }

  Future<void> _pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      final bytes = await picked.readAsBytes();
      setState(() => _imageBytes = bytes);
    }
  }

  Future<void> _saveJot() async {
    if (!_formKey.currentState!.validate() ||
        _selectedDate == null ||
        _selectedTime == null) {
      return;
    }

    final dateTime = DateTime(
      _selectedDate!.year,
      _selectedDate!.month,
      _selectedDate!.day,
      _selectedTime!.hour,
      _selectedTime!.minute,
    );

    final jot = JotModel(
      id: widget.jotId ?? DateTime.now().millisecondsSinceEpoch.toString(),
      title: _titleController.text.trim(),
      description: _descController.text.trim(),
      imagePath: _imageBytes != null ? _imageBytes!.join(',') : '',
      dateTime: dateTime,
      userEmail: widget.userEmail,
    );

    if (widget.jotId != null) {
      jotBox.put(widget.jotId!, jot);
    } else {
      jotBox.put(jot.id, jot);
    }

    Navigator.pop(context);
  }

  Uint8List? _getImageBytes(String imagePath) {
    try {
      return imagePath.isNotEmpty
          ? Uint8List.fromList(imagePath.split(',').map(int.parse).toList())
          : null;
    } catch (e) {
      print('Error decoding image: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.jotId != null;

    return AppBackground(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false, // Disable default back icon
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => _showCancelAlert(context), // ✅ Custom handler
          ),
          title: Text(
            isEditing ? 'Edit Jot' : 'Add Jot',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _titleController, // ✅ Title input field added
                  decoration: const InputDecoration(labelText: 'Title'),
                  validator: (value) =>
                      value == null || value.isEmpty ? 'Enter a title' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _descController,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(), // ✅ Adds a modern border
                    prefixIcon:
                        Icon(Icons.notes), // ✅ Description icon for clarity
                  ),
                  style: const TextStyle(
                      fontSize: 14), // ✅ Makes input text smaller
                  maxLines:
                      3, // ✅ Allows a few lines but avoids excessive height
                  textAlignVertical:
                      TextAlignVertical.top, // ✅ Keeps text positioned neatly
                  validator: (value) => value == null || value.isEmpty
                      ? 'Enter description'
                      : null,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.calendar_today),
                        label: Text(_selectedDate == null
                            ? 'Select Date'
                            : '${_selectedDate!.year}-${_selectedDate!.month}-${_selectedDate!.day}'),
                        onPressed: () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: _selectedDate ?? DateTime.now(),
                            firstDate: DateTime(2020),
                            lastDate: DateTime(2100),
                          );
                          if (picked != null) {
                            setState(() => _selectedDate = picked);
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.access_time),
                        label: Text(_selectedTime == null
                            ? 'Select Time'
                            : _selectedTime!.format(context)),
                        onPressed: () async {
                          final picked = await showTimePicker(
                            context: context,
                            initialTime: _selectedTime ?? TimeOfDay.now(),
                          );
                          if (picked != null) {
                            setState(() => _selectedTime = picked);
                          }
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  icon: const Icon(Icons.image),
                  label: const Text('Pick Image'),
                  onPressed: _pickImage,
                ),
                if (_imageBytes != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Image.memory(
                      _imageBytes!,
                      height: 180,
                      fit: BoxFit.cover,
                    ),
                  ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _saveJot,
                  child: Text(isEditing ? 'Update Jot' : 'Save Jot'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showCancelAlert(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Discard changes?'),
        content: const Text(
            'Are you sure you want to cancel? Your jot will not be saved.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(), // Closes the dialog
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
              Navigator.of(context).pop(); // Navigate back
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Yes'),
          ),
        ],
      ),
    );
  }
}
