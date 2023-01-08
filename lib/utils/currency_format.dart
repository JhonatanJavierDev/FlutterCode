import 'package:money2/money2.dart';
import 'package:provider/provider.dart';
import 'package:catalinadev/provider/home_provider.dart';
import 'package:catalinadev/utils/utility.dart';

stringToCurrency(double idr, context) {
  final currencySetting = Provider.of<HomeProvider>(context, listen: false);
  var symbol = '';
  String? code = 'USD';
  var thousandSeparator = '.';
  var decimalSeparator = ',';
  var decimalNumber = 0;
  bool invertSeparators = false;

  symbol = currencySetting.currency.description != null
      ? convertHtmlUnescape(currencySetting.currency.description!)
      : '';
  code = currencySetting.currency.title;
  decimalNumber = currencySetting.formatCurrency.slug != null
      ? int.parse(currencySetting.formatCurrency.slug!)
      : 0;
  thousandSeparator = currencySetting.formatCurrency.image ?? ".";
  decimalSeparator = currencySetting.formatCurrency.title ?? ",";

  if (thousandSeparator == '.' && decimalSeparator == '.') {
    decimalSeparator = ',';
  } else if (thousandSeparator == ',' && decimalSeparator == ',') {
    decimalSeparator = '.';
  }

  var pattern = '';

  if (decimalNumber == 0) {
    pattern = 'S#$thousandSeparator###';
  } else if (decimalNumber == 1) {
    pattern = 'S#$thousandSeparator###${decimalSeparator}0';
  } else if (decimalNumber == 2) {
    pattern = 'S#$thousandSeparator###${decimalSeparator}00';
  } else if (decimalNumber == 3) {
    pattern = 'S#$thousandSeparator###${decimalSeparator}000';
  }

  if (thousandSeparator == '.' && decimalSeparator == ',') {
    invertSeparators = true;
  }

  final currency = Currency.create(code!, 3,
      invertSeparators: invertSeparators, symbol: symbol, pattern: pattern);

  var c = Currencies();
  c.register(currency);

  final convertedPrice = Money.fromNumWithCurrency(idr, currency);
  return convertedPrice.toString();
}

formatCurrency(double idr, context) {
  final currencySetting = Provider.of<HomeProvider>(context, listen: false);
  var symbol = 'Rp ';
  String? code = 'IDR';
  String? thousandSeparator = '.';
  String? decimalSeparator = ',';
  var decimalNumber = 0;
  bool invertSeparators = false;

  symbol = convertHtmlUnescape(currencySetting.currency.description!);
  code = currencySetting.currency.title;
  decimalNumber = int.parse(currencySetting.formatCurrency.slug!);
  thousandSeparator = currencySetting.formatCurrency.image;
  decimalSeparator = currencySetting.formatCurrency.title;

  var pattern = '';

  if (decimalNumber == 0) {
    pattern = 'S#$thousandSeparator###';
  } else if (decimalNumber == 1) {
    pattern = 'S#$thousandSeparator###${decimalSeparator}0';
  } else if (decimalNumber == 2) {
    pattern = 'S#$thousandSeparator###${decimalSeparator}00';
  } else if (decimalNumber == 3) {
    pattern = 'S#$thousandSeparator###${decimalSeparator}000';
  }

  if (thousandSeparator == '.' && decimalSeparator == ',') {
    invertSeparators = true;
  }

  final currency = Currency.create(code!, 0,
      invertSeparators: invertSeparators, symbol: symbol, pattern: pattern);
  final convertedPrice = Money.fromNumWithCurrency(idr, currency);
  return convertedPrice.toString();
}
