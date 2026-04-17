import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/app_provider.dart';
import '../../models/models.dart';
import '../junior/junior_dashboard.dart';
import '../../theme/app_theme.dart';
import '../common/app_actions.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'dart:typed_data';

class SetupProfileScreen extends StatefulWidget {
  final StaffMember applicant;
  const SetupProfileScreen({super.key, required this.applicant});

  @override
  State<SetupProfileScreen> createState() => _SetupProfileScreenState();
}

class _SetupProfileScreenState extends State<SetupProfileScreen> {
  late TextEditingController _nameController;
  late TextEditingController _descController;
  String _nativeLanguage = 'English';
  final List<String> _selectedOtherLanguages = [];
  String _degree = 'Bachelors';
  Uint8List? _profileImageData;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.applicant.name);
    _descController = TextEditingController(text: "Hello! I am a new applicant.");
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      final bytes = await image.readAsBytes();
      setState(() {
        _profileImageData = bytes;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.read<AppProvider>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Complete Your Profile'),
        actions: buildGlobalAppActions(context),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 500),
          child: ListView(
            padding: const EdgeInsets.all(24),
            children: [
              const Text('Welcome! Please complete your profile to access the portal.', style: TextStyle(fontSize: 18)),
              const SizedBox(height: 24),
              Center(
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 60,
                      backgroundImage: _profileImageData != null 
                        ? MemoryImage(_profileImageData!) 
                        : null,
                      child: _profileImageData == null ? const Icon(Icons.person, size: 60) : null,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: CircleAvatar(
                        backgroundColor: Theme.of(context).primaryColor,
                        child: IconButton(
                          icon: const Icon(Icons.camera_alt, color: Colors.white),
                          onPressed: _pickImage,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Full Name', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _nativeLanguage,
                decoration: const InputDecoration(labelText: 'Native Language', border: OutlineInputBorder()),
                items: ['English', 'Japanese', 'Spanish', 'French'].map((l) => DropdownMenuItem(value: l, child: Text(l))).toList(),
                onChanged: (val) {
                  if (val != null) setState(() => _nativeLanguage = val);
                },
              ),
              const SizedBox(height: 16),
              const Text('Other Speaking Languages', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: ['German', 'Chinese', 'Korean', 'Italian', 'Portuguese'].map((lang) {
                  final isSelected = _selectedOtherLanguages.contains(lang);
                  return FilterChip(
                    label: Text(lang),
                    selected: isSelected,
                    onSelected: (val) {
                      setState(() {
                        if (val) _selectedOtherLanguages.add(lang);
                        else _selectedOtherLanguages.remove(lang);
                      });
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _degree,
                decoration: const InputDecoration(labelText: 'Highest Degree', border: OutlineInputBorder()),
                items: ['Bachelors', 'Masters', 'PhD'].map((l) => DropdownMenuItem(value: l, child: Text(l))).toList(),
                onChanged: (val) {
                  if (val != null) setState(() => _degree = val);
                },
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _descController,
                decoration: const InputDecoration(labelText: 'Personal Description (Visitor Facing)', border: OutlineInputBorder()),
                maxLines: 3,
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 50)),
                onPressed: () {
                  widget.applicant.name = _nameController.text;
                  widget.applicant.nativeLanguage = _nativeLanguage;
                  widget.applicant.otherLanguages = _selectedOtherLanguages;
                  widget.applicant.degree = _degree;
                  widget.applicant.personalDescription = _descController.text;
                  if (_profileImageData != null) {
                    widget.applicant.profilePicturePath = base64Encode(_profileImageData!);
                  }
                  
                  provider.completeSetup(widget.applicant);
                  
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => Theme(
                        data: AppTheme.juniorTheme,
                        child: const JuniorDashboard(),
                      ),
                    ),
                  );
                },
                child: const Text('Complete Setup & Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
