import 'dart:math';
import 'package:barkeeper/core/services/barcode_scanner.dart';

/// Mock that returns canned barcodes (with occasional nulls).
class MockBarcodeScanner implements BarcodeScanner {
  final _codes = ['012345678901', '098765432109', '112233445566'];
  var _i = 0;
  final _rnd = Random();

  @override
  Future<String?> scan() async {
    await Future.delayed(const Duration(seconds: 1));
    if (_rnd.nextDouble() < 0.1) return null;
    return _codes[_i++ % _codes.length];
  }
}
