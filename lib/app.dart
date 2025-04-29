import 'package:flutter/material.dart';
import 'package:barkeeper/core/services/scale_service.dart';
import 'package:barkeeper/core/services/barcode_scanner.dart';
import 'package:barkeeper/injection.dart';

/// A global key to allow showing SnackBars from anywhere in the app.
final scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    final scale = getIt<ScaleService>();
    final scanner = getIt<BarcodeScanner>();

    return MaterialApp(
      // Attach the global ScaffoldMessengerKey here
      scaffoldMessengerKey: scaffoldMessengerKey,
      home: Scaffold(
        appBar: AppBar(title: const Text('Barkeeper Smoke Test')),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton(
                onPressed: () async {
                  await scale.connect();
                },
                child: const Text('Connect Scale'),
              ),

              const SizedBox(height: 24),

              StreamBuilder<double>(
                stream: scale.weightStream,
                builder: (ctx, snapshot) {
                  final display =
                      snapshot.hasData
                          ? '${snapshot.data!.toStringAsFixed(1)} g'
                          : '-- g';
                  return Text(display, style: const TextStyle(fontSize: 32));
                },
              ),

              const SizedBox(height: 24),

              ElevatedButton(
                onPressed: () async {
                  final code = await scanner.scan();
                  scaffoldMessengerKey.currentState?.showSnackBar(
                    SnackBar(content: Text('Scanned: $code')),
                  );
                },
                child: const Text('Scan Barcode'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
