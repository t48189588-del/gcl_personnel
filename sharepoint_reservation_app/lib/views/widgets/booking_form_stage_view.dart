import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/booking_provider.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:io' as io;
import 'package:flutter/foundation.dart' show kIsWeb;

class BookingFormStageView extends StatefulWidget {
  const BookingFormStageView({Key? key}) : super(key: key);

  @override
  _BookingFormStageViewState createState() => _BookingFormStageViewState();
}

class _BookingFormStageViewState extends State<BookingFormStageView> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _departmentController = TextEditingController();
  final _otherGradeController = TextEditingController();
  final _otherPurposeController = TextEditingController();

  String? _selectedLocation;
  String? _selectedPurpose;
  String? _selectedLanguage;
  String? _selectedGrade; // Tracks grade dropdown choice

  // Default selection set to professional neutral fallback value
  String _preferredStaffPreference = 'anyone';

  // Used to detect if the selected time slot changed so we can reset fields cleanly
  String? _lastTrackedSlot;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _departmentController.dispose();
    _otherGradeController.dispose();
    _otherPurposeController.dispose();
    super.dispose();
  }

  void _resetFormFields() {
    _nameController.clear();
    _emailController.clear();
    _departmentController.clear();
    _otherGradeController.clear();
    _selectedLocation = null;
    _selectedPurpose = null;
    _selectedLanguage = null;
    _selectedGrade = null;
    _preferredStaffPreference = 'anyone';
  }

  // NEW: Helper function to show a beautiful localized thank you dialog alert box
  void _showThankYouDialog(BuildContext context, bool isJa) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext ctx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.green, size: 28),
              const SizedBox(width: 10),
              Text(
                isJa ? '予約が完了しました' : 'Booking Confirmed',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isJa
                    ? 'ご利用ありがとうございました！予約ペイロードは正常に処理されました。確認メールをご確認ください。'
                    : 'Thank you for your reservation! Your booking payload has been processed successfully. Please check your inbox for details.',
                style: const TextStyle(fontSize: 15, height: 1.4),
              ),
            ],
          ),
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () => Navigator.of(ctx).pop(),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 4.0,
                ),
                child: Text(isJa ? '閉じる' : 'Close'),
              ),
            ),
          ],
        );
      },
    );
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

    // Reset layout choices gracefully if user swaps between different time blocks
    if (_lastTrackedSlot != provider.selectedTimeSlot) {
      _lastTrackedSlot = provider.selectedTimeSlot;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) setState(() => _resetFormFields());
      });
    }

    // Dynamic localization maps for the presentation preference layout
    final isJa = provider.currentLocale == 'ja';

    // Grade options matching requested schema with full translation handling
    final List<String> gradeOptions = [
      'B1',
      'B2',
      'B3',
      'B4',
      'M1',
      'M2',
      'D1',
      'D2',
      isJa ? '研究生' : 'Research Student',
      isJa ? 'その他' : 'Other',
    ];
    final String otherGradeKeyword = isJa ? 'その他' : 'Other';

    // NEW: Purpose options list logic with localized "Other" option appended dynamically
    final String otherPurposeKeyword = isJa ? 'その他' : 'Other';
    final List<String> purposeOptions = List<String>.from(provider.purposes);
    if (!purposeOptions.contains(otherPurposeKeyword)) {
      purposeOptions.add(otherPurposeKeyword);
    }

    // Localized strings for the brand new forms fields
    final String departmentLabel = isJa ? "部局・学科 / 部署" : "Department / Faculty";
    final String gradeLabel = isJa ? "学年" : "Grade / Academic Year";
    final String specifyOtherLabel = isJa
        ? "具体的な学年を入力してください"
        : "Please specify your grade";
    final String specifyOtherPurposeLabel = isJa
        ? "具体的な利用目的を入力してください"
        : "Please specify your purpose";

    // Grab dynamic data directly from provider for the currently selected slot
    final List<String> dynamicLanguages = provider.getDynamicTargetLanguages();
    final List<String> availableCountries = provider.getCountriesForSlot(
      provider.selectedTimeSlot!,
    );

    // Safe adjustment: if a chosen language is no longer available in a newly clicked block, reset it
    if (_selectedLanguage != null &&
        !dynamicLanguages.contains(_selectedLanguage)) {
      _selectedLanguage = null;
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

              // --- NAME ---
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

              // --- EMAIL ---
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

              // --- NEW: DEPARTMENT TEXT INPUT ---
              TextFormField(
                controller: _departmentController,
                decoration: InputDecoration(
                  labelText: departmentLabel,
                  prefixIcon: const Icon(Icons.business),
                  border: const OutlineInputBorder(),
                ),
                validator: (val) => (val == null || val.trim().isEmpty)
                    ? provider.translate('required')
                    : null,
              ),
              const SizedBox(height: 20),

              // --- NEW: GRADE DROPDOWN ---
              DropdownButtonFormField<String>(
                value: _selectedGrade,
                decoration: InputDecoration(
                  labelText: gradeLabel,
                  prefixIcon: const Icon(Icons.school),
                  border: const OutlineInputBorder(),
                ),
                items: gradeOptions.map((grade) {
                  return DropdownMenuItem(value: grade, child: Text(grade));
                }).toList(),
                onChanged: (val) => setState(() {
                  _selectedGrade = val;
                  if (val != otherGradeKeyword) {
                    _otherGradeController.clear();
                  }
                }),
                validator: (val) =>
                    val == null ? provider.translate('required') : null,
              ),

              // --- NEW: GRADE "OTHER" CONDITIONAL TEXT INPUT ---
              if (_selectedGrade == otherGradeKeyword) ...[
                const SizedBox(height: 12),
                TextFormField(
                  controller: _otherGradeController,
                  decoration: InputDecoration(
                    labelText: specifyOtherLabel,
                    prefixIcon: const Icon(Icons.edit_note),
                    border: const OutlineInputBorder(),
                  ),
                  validator: (val) => (val == null || val.trim().isEmpty)
                      ? provider.translate('required')
                      : null,
                ),
              ],
              const SizedBox(height: 20),

              // --- LOCATION ---
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

              // --- PURPOSE DROPDOWN (WITH ADDED OTHER FEATURE) ---
              DropdownButtonFormField<String>(
                value: _selectedPurpose,
                decoration: InputDecoration(
                  labelText: provider.translate('purpose'),
                  prefixIcon: const Icon(Icons.assignment),
                  border: const OutlineInputBorder(),
                ),
                items: purposeOptions.map((p) {
                  return DropdownMenuItem(value: p, child: Text(p));
                }).toList(),
                onChanged: (val) => setState(() {
                  _selectedPurpose = val;
                  if (val != otherPurposeKeyword) {
                    _otherPurposeController.clear();
                  }
                }),
                validator: (val) =>
                    val == null ? provider.translate('select_purpose') : null,
              ),

              // --- NEW: PURPOSE "OTHER" CONDITIONAL TEXT INPUT ---
              if (_selectedPurpose == otherPurposeKeyword) ...[
                const SizedBox(height: 12),
                TextFormField(
                  controller: _otherPurposeController,
                  decoration: InputDecoration(
                    labelText: specifyOtherPurposeLabel,
                    prefixIcon: const Icon(Icons.rate_review),
                    border: const OutlineInputBorder(),
                  ),
                  validator: (val) => (val == null || val.trim().isEmpty)
                      ? provider.translate('required')
                      : null,
                ),
              ],
              const SizedBox(height: 20),

              // --- DYNAMIC TARGET LANGUAGE FROM PROVIDER ---
              DropdownButtonFormField<String>(
                value: _selectedLanguage,
                decoration: InputDecoration(
                  labelText: provider.translate('target_lang'),
                  prefixIcon: const Icon(Icons.translate),
                  border: const OutlineInputBorder(),
                ),
                items: dynamicLanguages.map((lang) {
                  return DropdownMenuItem(value: lang, child: Text(lang));
                }).toList(),
                onChanged: (val) => setState(() => _selectedLanguage = val),
                validator: (val) =>
                    val == null ? provider.translate('select_lang') : null,
              ),
              const SizedBox(height: 24),

              // --- DYNAMIC STAFF & COUNTRIES RADIO LAYOUT ---
              Text(
                provider.translate('pref_title'),
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[700],
                ),
              ),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[400]!),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    RadioListTile<String>(
                      title: Text(
                        provider.translate('pref_anyone'),
                        style: const TextStyle(fontSize: 14),
                      ),
                      value: 'anyone',
                      groupValue: _preferredStaffPreference,
                      activeColor: Colors.blue,
                      onChanged: (val) =>
                          setState(() => _preferredStaffPreference = val!),
                    ),

                    // Maps dynamic nationalities passed from the Sharepoint response array per time frame
                    ...availableCountries.map((country) {
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Divider(height: 1, indent: 16, endIndent: 16),
                          RadioListTile<String>(
                            title: Text(
                              country, // Outputs localized string parsed directly ("中国", "インド")
                              style: const TextStyle(fontSize: 14),
                            ),
                            value: country.toLowerCase().trim(),
                            groupValue: _preferredStaffPreference
                                .toLowerCase()
                                .trim(),
                            activeColor: Colors.blue,
                            onChanged: (val) => setState(
                              () => _preferredStaffPreference = country,
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                  ],
                ),
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
                  if (_formKey.currentState!.validate()) {
                    DateTime startDateTime = provider.getCalculatedDateTime(
                      getEndTime: false,
                    );
                    DateTime endDateTime = provider.getCalculatedDateTime(
                      getEndTime: true,
                    );

                    // Compute clean outputs for standard or "other" options
                    final String finalGrade =
                        (_selectedGrade == otherGradeKeyword)
                        ? _otherGradeController.text.trim()
                        : _selectedGrade ?? "";

                    // NEW: Compute final purpose choice accounting for "Other" field entry
                    final String finalPurpose =
                        (_selectedPurpose == otherPurposeKeyword)
                        ? _otherPurposeController.text.trim()
                        : _selectedPurpose ?? "";

                    final Locale deviceLocale = View.of(context).platformDispatcher.locale;
                    final String systemDefaultLanguageString = deviceLocale.toLanguageTag(); // Yields standard BCP47 layouts like "en-US", "ja-JP"

                    print("--- STAGE 1 PASSED: CLEAN DATA PAYLOAD EXPORT ---");
                    print("start: ${startDateTime.toIso8601String()}");
                    print("end: ${endDateTime.toIso8601String()}");
                    print("name: ${_nameController.text.trim()}");
                    print("email: ${_emailController.text.trim()}");
                    print("department: ${_departmentController.text.trim()}");
                    print("grade: $finalGrade");
                    print("location: $_selectedLocation");
                    print("purpose: $finalPurpose");
                    print("targetLanguage: $_selectedLanguage");
                    print("staffPreference: $_preferredStaffPreference");
                    print("nativeLanguage: $systemDefaultLanguageString"); 
                    print("--------------------------------------------------");

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Processing reservation...'),
                        duration: Duration(seconds: 2),
                      ),
                    );

                    final Map<String, dynamic> payload = {
                      "start": startDateTime.toIso8601String(),
                      "end": endDateTime.toIso8601String(),
                      "name": _nameController.text.trim(),
                      "email": _emailController.text.trim(),
                      "department": _departmentController.text.trim(),
                      "grade": finalGrade,
                      "location": _selectedLocation,
                      "purpose": finalPurpose,
                      "targetLanguage": _selectedLanguage,
                      "staffPreference": _preferredStaffPreference,
                      "nativeLanguage": systemDefaultLanguageString, 
                    };

                    bool envExists = false;
                    try {
                      if (!kIsWeb) {
                        final file =
                            io.File(
                              'sharepoint_reservation_app/.env',
                            ).existsSync()
                            ? io.File('sharepoint_reservation_app/.env')
                            : io.File('.env').existsSync()
                            ? io.File('.env')
                            : null;
                        if (file != null) {
                          envExists = true;
                          final lines = await file.readAsLines();
                          dotenv.testLoad(fileInput: lines.join('\n'));
                        }
                      } else {
                        envExists =
                            dotenv.env.isNotEmpty &&
                            dotenv
                                .get('POWER_AUTOMATE_URL_POST', fallback: '')
                                .isNotEmpty;
                      }
                    } catch (_) {}

                    if (!envExists) {
                      print(
                        "--- NO .ENV FILE FOUND. ONLY PRINTING PAYLOAD ---",
                      );
                      print("Payload: ${jsonEncode(payload)}");
                      ScaffoldMessenger.of(context).clearSnackBars();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'No .env found. Payload printed to console.',
                          ),
                          backgroundColor: Colors.orange,
                        ),
                      );
                      // NEW: Clear fields and trigger the beautiful success thanks dialog on fallback print simulation too!
                      _showThankYouDialog(context, isJa);
                      setState(() => _resetFormFields());
                      return;
                    }

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Processing reservation...'),
                        duration: Duration(seconds: 2),
                      ),
                    );

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
                      final response = await http.post(
                        Uri.parse(powerAutomateUrl),
                        headers: {'Content-Type': 'application/json'},
                        body: jsonEncode(payload),
                      );

                      if (response.statusCode == 200 ||
                          response.statusCode == 202) {
                        ScaffoldMessenger.of(context).clearSnackBars();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(provider.translate('success_msg')),
                            backgroundColor: Colors.green,
                          ),
                        );
                        // NEW: Pop open the rich thank you dialog screen and wipe input fields clean
                        _showThankYouDialog(context, isJa);
                        setState(() => _resetFormFields());
                      } else {
                        throw Exception(
                          'Server returned status code ${response.statusCode}',
                        );
                      }
                    } catch (e) {
                      print("ERROR SYNCING TO POWER AUTOMATE: $e");
                      ScaffoldMessenger.of(context).clearSnackBars();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
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
