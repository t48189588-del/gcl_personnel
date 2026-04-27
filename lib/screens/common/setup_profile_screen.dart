import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/app_provider.dart';
import '../../models/models.dart';
import '../junior/junior_dashboard.dart';
import '../../theme/app_theme.dart';
import '../common/app_actions.dart';
import '../../l10n/app_localizations.dart';
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
  late TextEditingController _originController;
  late TextEditingController _kanaController;
  String _nativeLanguage = 'English';
  final List<String> _selectedOtherLanguages = [];
  String _currentlyStudying = 'Computer Science';
  Uint8List? _profileImageData;

  final Map<String, String> _languagesWithFlags = {
    'English': '🇺🇸',
    'Japanese': '🇯🇵',
    'Chinese': '🇨🇳',
    'Korean': '🇰🇷',
    'French': '🇫🇷',
    'German': '🇩🇪',
    'Spanish': '🇪🇸',
    'Italian': '🇮🇹',
    'Portuguese': '🇵🇹',
    'Russian': '🇷🇺',
    'Vietnamese': '🇻🇳',
    'Hindi': '🇮🇳',
    'Arabic': '🇸🇦',
    'Bengali': '🇧🇩',
    'Turkish': '🇹🇷',
  };

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.applicant.name);
    _descController = TextEditingController(text: "Hello! I am a new applicant.");
    _originController = TextEditingController();
    _kanaController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    _originController.dispose();
    _kanaController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      final bytes = await image.readAsBytes();
      if (mounted) {
        setState(() {
          _profileImageData = bytes;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.read<AppProvider>();
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(loc.completeYourProfile),
        actions: buildGlobalAppActions(context),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: ListView(
            padding: const EdgeInsets.all(24),
            children: [
              Text(
                loc.welcomeCompleteProfile,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 32),
              Center(
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 60,
                      backgroundImage: _profileImageData != null
                          ? MemoryImage(_profileImageData!)
                          : null,
                      child: _profileImageData == null
                          ? const Icon(Icons.person, size: 60)
                          : null,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: CircleAvatar(
                        backgroundColor: Theme.of(context).primaryColor,
                        child: IconButton(
                          icon:
                              const Icon(Icons.camera_alt, color: Colors.white),
                          onPressed: _pickImage,
                          tooltip: loc.uploadPhoto,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: loc.fullName,
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _originController,
                decoration: InputDecoration(
                  labelText: loc.originCountry,
                  hintText: loc.originCountryHint,
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _kanaController,
                decoration: InputDecoration(
                  labelText: loc.kanaName,
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                initialValue: _nativeLanguage,
                decoration: InputDecoration(
                  labelText: loc.nativeLang,
                  border: const OutlineInputBorder(),
                ),
                items: _languagesWithFlags.entries.map((entry) {
                  return DropdownMenuItem(
                    value: entry.key,
                    child: Text('${entry.value} ${entry.key}'),
                  );
                }).toList(),
                onChanged: (val) {
                  if (val != null) setState(() => _nativeLanguage = val);
                },
              ),
              const SizedBox(height: 24),
              Text(loc.otherLanguages,
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _languagesWithFlags.entries.map((entry) {
                  final isSelected = _selectedOtherLanguages.contains(entry.key);
                  return FilterChip(
                    label: Text('${entry.value} ${entry.key}'),
                    selected: isSelected,
                    onSelected: (val) {
                      setState(() {
                        if (val) {
                          _selectedOtherLanguages.add(entry.key);
                        } else {
                          _selectedOtherLanguages.remove(entry.key);
                        }
                      });
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),
              TextField(
                controller: TextEditingController(text: _currentlyStudying),
                onChanged: (val) => _currentlyStudying = val,
                decoration: InputDecoration(
                  labelText: loc.currentlyStudying,
                  hintText: loc.currentlyStudyingHint,
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _descController,
                decoration: InputDecoration(
                  labelText: loc.personalDescription,
                  border: const OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 56),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () {
                  widget.applicant.name = _nameController.text;
                  widget.applicant.nativeLanguage = _nativeLanguage;
                  widget.applicant.otherLanguages = _selectedOtherLanguages;
                  widget.applicant.degree = _currentlyStudying;
                  widget.applicant.originCountry = _originController.text;
                  widget.applicant.kanaName = _kanaController.text;
                  widget.applicant.personalDescription = _descController.text;
                  if (_profileImageData != null) {
                    widget.applicant.profilePicturePath =
                        base64Encode(_profileImageData!);
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
                child: Text(loc.completeSetupAndLogin),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
