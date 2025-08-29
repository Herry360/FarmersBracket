import 'package:intl/intl.dart';

class SouthAfricaUtils {
  // South African provinces
  static const List<String> provinces = ['Mpumalanga'];

  // Format ZAR currency
  static String formatZAR(double amount) {
    return NumberFormat.currency(
      locale: 'en_ZA',
      symbol: 'R',
      decimalDigits: 2,
    ).format(amount);
  }

  // Validate South African phone number
  static bool isValidPhoneNumber(String phone) {
    final regex = RegExp(r'^(\+27|0)[6-8][0-9]{8}\$');
    return regex.hasMatch(phone);
  }

  // Validate RSA ID number
  static bool isValidRSAID(String idNumber) {
    if (idNumber.length != 13) return false;

    try {
      // Basic validation - check if it's all digits and valid date
      // Removed unused local variable 'year'
      final month = int.parse(idNumber.substring(2, 4));
      final day = int.parse(idNumber.substring(4, 6));

      if (month < 1 || month > 12) return false;
      if (day < 1 || day > 31) return false;

      return true;
    } catch (e) {
      return false;
    }
  }

  // Calculate VAT (15% in South Africa)
  static double calculateVAT(double amount) {
    return amount * 0.15;
  }

  // Get province tax rates (simplified)
  static double getProvinceTaxRate(String province) {
    const taxRates = {'Mpumalanga': 1.05, 'Other': 1.05};
    return taxRates[province] ?? taxRates['Mpumalanga']!;
  }
}
