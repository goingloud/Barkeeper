import 'package:get_it/get_it.dart';

// Dev config
import 'package:barkeeper/dev/config/dev_config.dart';

// Scale abstractions & implementations
import 'package:barkeeper/core/services/scale_service.dart';
import 'package:barkeeper/core/services/reactive_ble_scale_service.dart';
import 'package:barkeeper/dev/mocks/mock_scale_service.dart';

// Barcode abstractions & implementations
import 'package:barkeeper/core/services/barcode_scanner.dart';
import 'package:barkeeper/core/services/mobile_barcode_scanner.dart';
import 'package:barkeeper/dev/mocks/mock_barcode_scanner.dart';

final getIt = GetIt.instance;

void setupDependencies() {
  if (useMocks) {
    // Mocks for rapid local development
    getIt.registerLazySingleton<ScaleService>(() => MockScaleService());
    getIt.registerLazySingleton<BarcodeScanner>(() => MockBarcodeScanner());
  } else {
    // Real hardware implementations
    getIt.registerLazySingleton<ScaleService>(() => ReactiveBleScaleService());
    getIt.registerLazySingleton<BarcodeScanner>(() => MobileBarcodeScanner());
  }
}
