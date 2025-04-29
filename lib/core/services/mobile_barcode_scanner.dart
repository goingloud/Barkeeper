import 'package:barkeeper/core/services/barcode_scanner.dart';

/// Real implementation using mobile_scanner / ML Kit.
class MobileBarcodeScanner implements BarcodeScanner {
  @override
  Future<String?> scan() => throw UnimplementedError();
}
