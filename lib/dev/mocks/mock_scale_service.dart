import 'dart:async';
import 'package:barkeeper/core/services/scale_service.dart';

/// Mock that emits dummy weights for testing.
class MockScaleService implements ScaleService {
  final _ctrl = StreamController<double>.broadcast();
  Timer? _timer;

  @override
  Stream<double> get weightStream => _ctrl.stream;

  @override
  Future<void> connect() async {
    _timer = Timer.periodic(const Duration(milliseconds: 500), (_) {
      _ctrl.add(500 + 50 * (0.5 - DateTime.now().millisecond / 1000));
    });
  }

  @override
  Future<void> disconnect() async {
    _timer?.cancel();
    await _ctrl.close();
  }
}
