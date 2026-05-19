import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../../providers/app_provider.dart';
import '../../models/models.dart';
import 'package:intl/intl.dart';

class ExternalMeetingRequestScreen extends StatefulWidget {
  const ExternalMeetingRequestScreen({super.key});

  @override
  State<ExternalMeetingRequestScreen> createState() => _ExternalMeetingRequestScreenState();
}

class _ExternalMeetingRequestScreenState extends State<ExternalMeetingRequestScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _departmentController = TextEditingController();
  
  String _meetingType = 'Online';
  String _studyYear = 'B1';
  String _purpose = 'Conversation';
  String? _selectedLanguage;
  DateTime? _selectedDate;
  DateTime? _selectedTime;

  final List<String> _studyYears = ['B1', 'B2', 'B3', 'B4', 'M1', 'M2', 'D1', 'D2', 'Research student'];
  final List<String> _purposes = ['Assignment', 'Conversation', 'Presentation practice'];

  @override
  void dispose() {
    _nameController.dispose();
    _departmentController.dispose();
    super.dispose();
  }

  List<DateTime> _getAvailableDates(AppProvider provider) {
    final approvedBlocks = provider.blocks.where((b) => b.status == 'approved').toList();
    Set<DateTime> dates = {};
    for (var b in approvedBlocks) {
      if (b.startTime.isAfter(DateTime.now())) {
        dates.add(DateTime(b.startTime.year, b.startTime.month, b.startTime.day));
      }
    }
    return dates.toList()..sort();
  }

  List<DateTime> _getAvailableTimesForDate(AppProvider provider, DateTime date) {
    final approvedBlocks = provider.blocks.where((b) => b.status == 'approved' && 
        b.startTime.year == date.year && b.startTime.month == date.month && b.startTime.day == date.day && b.startTime.isAfter(DateTime.now())).toList();
    Set<DateTime> times = {};
    for (var b in approvedBlocks) {
      times.add(b.startTime);
    }
    return times.toList()..sort();
  }

  List<String> _getAvailableLanguagesForTime(AppProvider provider, DateTime time) {
    final blocks = provider.blocks.where((b) => b.status == 'approved' && b.startTime == time).toList();
    Set<String> languages = {};
    for (var b in blocks) {
      try {
        final staff = provider.staff.firstWhere((s) => s.id == b.staffId);
        languages.add(staff.nativeLanguage);
        for (var skill in staff.languageSkills) {
          languages.add(skill.language);
        }
      } catch (e) {
        // Staff not found
      }
    }
    return languages.toList()..sort();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();
    
    final availableDates = _getAvailableDates(provider);
    final availableTimes = _selectedDate != null ? _getAvailableTimesForDate(provider, _selectedDate!) : <DateTime>[];
    final availableLanguages = _selectedTime != null ? _getAvailableLanguagesForTime(provider, _selectedTime!) : <String>[];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Request a Meeting'),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Card(
            margin: const EdgeInsets.all(24),
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Form(
                key: _formKey,
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    const Text('Schedule a meeting with GCL Staff', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 24),
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(labelText: 'Type of Meeting', border: OutlineInputBorder()),
                      value: _meetingType,
                      items: const [
                        DropdownMenuItem(value: 'Online', child: Text('Online [Teams]')),
                        DropdownMenuItem(value: 'In Person', child: Text('In Person')),
                      ],
                      onChanged: (val) => setState(() => _meetingType = val!),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(labelText: 'Name', border: OutlineInputBorder()),
                      validator: (val) => val == null || val.isEmpty ? 'Please enter your name' : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _departmentController,
                      decoration: const InputDecoration(labelText: 'Department', border: OutlineInputBorder()),
                      validator: (val) => val == null || val.isEmpty ? 'Please enter your department' : null,
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(labelText: 'Study Year', border: OutlineInputBorder()),
                      value: _studyYear,
                      items: _studyYears.map((y) => DropdownMenuItem(value: y, child: Text(y))).toList(),
                      onChanged: (val) => setState(() => _studyYear = val!),
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(labelText: 'Purpose', border: OutlineInputBorder()),
                      value: _purpose,
                      items: _purposes.map((p) => DropdownMenuItem(value: p, child: Text(p))).toList(),
                      onChanged: (val) => setState(() => _purpose = val!),
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<DateTime>(
                      decoration: const InputDecoration(labelText: 'Date', border: OutlineInputBorder()),
                      value: _selectedDate,
                      items: availableDates.map((d) => DropdownMenuItem(value: d, child: Text(DateFormat('yyyy-MM-dd').format(d)))).toList(),
                      onChanged: (val) {
                        setState(() {
                          _selectedDate = val;
                          _selectedTime = null;
                          _selectedLanguage = null;
                        });
                      },
                      validator: (val) => val == null ? 'Please select a date' : null,
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<DateTime>(
                      decoration: const InputDecoration(labelText: 'Time (30 min block)', border: OutlineInputBorder()),
                      value: _selectedTime,
                      items: availableTimes.map((t) => DropdownMenuItem(value: t, child: Text('${DateFormat('HH:mm').format(t)} - ${DateFormat('HH:mm').format(t.add(const Duration(minutes: 30)))}'))).toList(),
                      onChanged: availableTimes.isEmpty ? null : (val) {
                        setState(() {
                          _selectedTime = val;
                          _selectedLanguage = null;
                        });
                      },
                      validator: (val) => val == null ? 'Please select a time' : null,
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(labelText: 'Language', border: OutlineInputBorder()),
                      value: _selectedLanguage,
                      items: availableLanguages.map((l) => DropdownMenuItem(value: l, child: Text(l))).toList(),
                      onChanged: availableLanguages.isEmpty ? null : (val) {
                        setState(() => _selectedLanguage = val);
                      },
                      validator: (val) => val == null ? 'Please select a language' : null,
                    ),
                    const SizedBox(height: 32),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 50)),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          final request = ExternalMeetingRequest(
                            id: const Uuid().v4(),
                            meetingType: _meetingType,
                            name: _nameController.text,
                            department: _departmentController.text,
                            studyYear: _studyYear,
                            purpose: _purpose,
                            language: _selectedLanguage!,
                            requestedDate: _selectedDate!,
                            requestedTime: _selectedTime!,
                          );
                          provider.addExternalMeetingRequest(request);
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Meeting request submitted successfully!')));
                          Navigator.pop(context);
                        }
                      },
                      child: const Text('Submit Request'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
