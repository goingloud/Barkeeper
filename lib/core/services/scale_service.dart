/// Abstraction for any scale-based weight provider.
abstract class ScaleService {
  Stream<double> get weightStream;
  Future<void> connect();
  Future<void> disconnect();
}
