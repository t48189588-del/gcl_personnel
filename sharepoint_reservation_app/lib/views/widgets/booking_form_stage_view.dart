import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/booking_provider.dart';

class BookingFormStageView extends StatefulWidget {
  const BookingFormStageView({Key? key}) : super(key: key);

  @override
  _BookingFormStageViewState createState() => _BookingFormStageViewState();
}

class _BookingFormStageViewState extends State<BookingFormStageView> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();

  String? _selectedLocation;
  String? _selectedPurpose;
  String? _selectedLanguage;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<BookingProvider>(context);

    if (!provider.isFormVisible) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.calendar_today, size: 48, color: Colors.grey[400]),
              const SizedBox(height: 16),
              Text(
                provider.translate('prompt'),
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              ),
            ],
          ),
        ),
      );
    }

    return Form(
      key: _formKey,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.edit_calendar, color: Colors.blue),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      "${provider.translate('booking_slot')}: ${provider.selectedTimeSlot}",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ],
              ),
              const Divider(height: 32),

              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: provider.translate('name'),
                  prefixIcon: const Icon(Icons.person),
                  border: const OutlineInputBorder(),
                ),
                validator: (val) => (val == null || val.trim().isEmpty)
                    ? provider.translate('required')
                    : null,
              ),
              const SizedBox(height: 20),

              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: provider.translate('email'),
                  prefixIcon: const Icon(Icons.email),
                  border: const OutlineInputBorder(),
                ),
                validator: (val) {
                  if (val == null || val.trim().isEmpty)
                    return provider.translate('required');
                  if (!RegExp(
                    r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                  ).hasMatch(val.trim())) {
                    return provider.translate('invalid_email');
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              DropdownButtonFormField<String>(
                value: _selectedLocation,
                decoration: InputDecoration(
                  labelText: provider.translate('location'),
                  prefixIcon: const Icon(Icons.place),
                  border: const OutlineInputBorder(),
                ),
                items: provider.locations.map((loc) {
                  return DropdownMenuItem(value: loc, child: Text(loc));
                }).toList(),
                onChanged: (val) => setState(() => _selectedLocation = val),
                validator: (val) =>
                    val == null ? provider.translate('select_loc') : null,
              ),
              const SizedBox(height: 20),

              DropdownButtonFormField<String>(
                value: _selectedPurpose,
                decoration: InputDecoration(
                  labelText: provider.translate('purpose'),
                  prefixIcon: const Icon(Icons.assignment),
                  border: const OutlineInputBorder(),
                ),
                items: provider.purposes.map((p) {
                  return DropdownMenuItem(value: p, child: Text(p));
                }).toList(),
                onChanged: (val) => setState(() => _selectedPurpose = val),
                validator: (val) =>
                    val == null ? provider.translate('select_purpose') : null,
              ),
              const SizedBox(height: 20),

              DropdownButtonFormField<String>(
                value: _selectedLanguage,
                decoration: InputDecoration(
                  labelText: provider.translate('target_lang'),
                  prefixIcon: const Icon(Icons.translate),
                  border: const OutlineInputBorder(),
                ),
                items: provider.targetLanguages.map((lang) {
                  return DropdownMenuItem(value: lang, child: Text(lang));
                }).toList(),
                onChanged: (val) => setState(() => _selectedLanguage = val),
                validator: (val) =>
                    val == null ? provider.translate('select_lang') : null,
              ),
              const SizedBox(height: 32),

              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 54),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    DateTime startDateTime = provider.getCalculatedDateTime(
                      getEndTime: false,
                    );
                    DateTime endDateTime = provider.getCalculatedDateTime(
                      getEndTime: true,
                    );

                    print("--- STAGE 1 PASSED: CLEAN DATA PAYLOAD EXPORT ---");
                    print("start: ${startDateTime.toIso8601String()}");
                    print("end: ${endDateTime.toIso8601String()}");
                    print("name: ${_nameController.text.trim()}");
                    print("email: ${_emailController.text.trim()}");
                    print("location: $_selectedLocation");
                    print("purpose: $_selectedPurpose");
                    print("targetLanguage: $_selectedLanguage");
                    print("--------------------------------------------------");

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(provider.translate('success_msg')),
                        backgroundColor: Colors.green,
                      ),
                    );
                  }
                },
                child: Text(
                  provider.translate('verify_btn'),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
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
