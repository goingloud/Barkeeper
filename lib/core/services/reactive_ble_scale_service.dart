import 'package:barkeeper/core/services/scale_service.dart';

/// Real implementation using flutter_reactive_ble.
class ReactiveBleScaleService implements ScaleService {
  @override
  Stream<double> get weightStream => throw UnimplementedError();

  @override
  Future<void> connect() => throw UnimplementedError();

  @override
  Future<void> disconnect() => throw UnimplementedError();
}
