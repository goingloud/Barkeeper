/// Abstraction for any barcode-scanner provider.
abstract class BarcodeScanner {
  Future<String?> scan();
}
