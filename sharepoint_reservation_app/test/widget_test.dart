import 'package:flutter_test/flutter_test.dart';
import 'package:sharepoint_reservation_app/providers/booking_provider.dart';

void main() {
  group('BookingProvider', () {
    test('initial selectedDay is today', () {
      final provider = BookingProvider();
      final now = DateTime.now();
      expect(provider.selectedDay.year, now.year);
      expect(provider.selectedDay.month, now.month);
      expect(provider.selectedDay.day, now.day);
    });

    test('getJapaneseCountForSlot returns 0 before any data is loaded', () {
      final provider = BookingProvider();
      expect(provider.getJapaneseCountForSlot('09:00 AM - 09:30 AM'), 0);
    });

    test('getIntlCountForSlot returns 0 before any data is loaded', () {
      final provider = BookingProvider();
      expect(provider.getIntlCountForSlot('09:00 AM - 09:30 AM'), 0);
    });

    test('selectDay updates selectedDay and clears time slot', () {
      final provider = BookingProvider();
      final tomorrow = DateTime.now().add(const Duration(days: 1));
      // We call selectDay — it will also trigger fetchSharePointBookings
      // but that is fire-and-forget; we verify the synchronous state change.
      provider.selectDay(tomorrow);
      expect(provider.selectedDay.day, tomorrow.day);
      expect(provider.selectedTimeSlot, isNull);
    });

    test('timeSlots is empty when no bookings are cached', () {
      final provider = BookingProvider();
      expect(provider.timeSlots, isEmpty);
    });

    test('translate returns key as fallback for unknown key', () {
      final provider = BookingProvider();
      expect(provider.translate('nonexistent_key'), 'nonexistent_key');
    });

    test('setLocale accepts only en or ja', () {
      final provider = BookingProvider();
      provider.setLocale('fr');
      expect(provider.currentLocale, 'en');
      provider.setLocale('ja');
      expect(provider.currentLocale, 'ja');
    });
  });
}
