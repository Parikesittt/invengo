import 'package:intl/intl.dart';

String formatRupiahWithoutSymbol(int amount) {
  final formatCurrency = NumberFormat.currency(
    locale: 'id_ID',
    symbol: '',
    decimalDigits: 0,
  );
  return formatCurrency.format(amount).trim();
}
