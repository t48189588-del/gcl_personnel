import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/booking_provider.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

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
                onPressed: () async {
                  // 1. Added 'async' here
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

                    // 2. Show a "Processing..." SnackBar or Loading indicator
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Processing reservation...'),
                        duration: Duration(seconds: 2),
                      ),
                    );

                    // 3. Construct your JSON payload
                    final Map<String, dynamic> payload = {
                      "start": startDateTime.toIso8601String(),
                      "end": endDateTime.toIso8601String(),
                      "name": _nameController.text.trim(),
                      "email": _emailController.text.trim(),
                      "location": _selectedLocation,
                      "purpose": _selectedPurpose,
                      "targetLanguage": _selectedLanguage,
                    };

                    // 4. Replace this with your actual Power Automate HTTP POST URL
                    final String powerAutomateUrl = dotenv.get(
                      'POWER_AUTOMATE_URL_POST',
                      fallback: '',
                    );

                    if (powerAutomateUrl.isEmpty) {
                      print(
                        "ERROR: Power Automate URL is missing from configuration.",
                      );
                      ScaffoldMessenger.of(context).clearSnackBars();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Configuration error. Contact admin.'),
                          backgroundColor: Colors.red,
                        ),
                      );
                      return;
                    }

                    try {
                      // 5. Fire off the network request
                      final response = await http.post(
                        Uri.parse(powerAutomateUrl),
                        headers: {'Content-Type': 'application/json'},
                        body: jsonEncode(payload),
                      );

                      // 6. Handle the result (Power Automate typically returns 200 or 202)
                      if (response.statusCode == 200 ||
                          response.statusCode == 202) {
                        // Clear previous processing snackbar and show success
                        ScaffoldMessenger.of(context).clearSnackBars();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(provider.translate('success_msg')),
                            backgroundColor: Colors.green,
                          ),
                        );

                        // Optional senior practice: Clear text controllers / reset state here if desired
                      } else {
                        throw Exception(
                          'Server returned status code ${response.statusCode}',
                        );
                      }
                    } catch (e) {
                      print("ERROR SYNCING TO POWER AUTOMATE: $e");

                      // 7. Show error UI to the user if the backend connection fails
                      ScaffoldMessenger.of(context).clearSnackBars();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Failed to submit reservation. Please try again.',
                          ),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
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
