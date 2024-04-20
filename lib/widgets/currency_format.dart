import 'package:intl/intl.dart';

class CurrencyFormat {
  CurrencyFormat(double? balance, int i);

  static String convertToIdr(dynamic number, int decimalDigit) {
    NumberFormat currencyFormatter = NumberFormat.currency(
      locale: 'id',
      symbol: 'PKR ',
      decimalDigits: decimalDigit,
    );
    return currencyFormatter.format(number);
  }
}
