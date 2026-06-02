import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/booking_provider.dart';
import 'widgets/calendar_stage_view.dart';
import 'widgets/booking_form_stage_view.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Safely extract the device/browser language code directly from system diagnostics
    final String deviceLanguage =
        PlatformDispatcher.instance.locale.languageCode;

    // Set locale inside our provider model
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<BookingProvider>(
        context,
        listen: false,
      ).setLocale(deviceLanguage);
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<BookingProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          provider.translate('title'),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1200),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  CalendarStageView(),
                  SizedBox(height: 32),
                  Divider(thickness: 1, height: 1),
                  SizedBox(height: 32),
                  BookingFormStageView(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
