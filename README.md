# Barkeeper

A cross-platform mobile application to streamline bar inventory management by integrating a Bluetooth kitchen scale and camera-based barcode scanning into a unified workflow.

## Goals

- **Automate Weekly Inventory**: Replace manual spreadsheet entry by capturing bottle weights and barcodes in a single tap-and-scan flow.  
- **Unified Codebase**: Build one Flutter app that compiles for both iOS and Android.  
- **Secure Manager Operations**: Protect product catalog and session management behind a PIN.  
- **Open Staff Workflow**: Allow any staff member to start or resume an inventory session and record entries without authentication.  
- **Robust Data Reporting**: Store persistent catalogs and session entries in SQLite, then export joined reports (name, barcode, liquor weight, timestamp) as CSV.  

## Major Decisions

- **Framework & Language**: Flutter (Dart) for hot reload, rich UI, single codebase.  
- **Architecture**: Clean Architecture with Presentation (Widgets + Riverpod), Domain (use-cases & entities), Data (repositories + Drift).  
- **BLE Scale**: flutter_reactive_ble → Decent Scale (Service UUID `FFF0`, Char UUID `FFF4`).  
- **Barcode**: mobile_scanner (ML Kit / AVFoundation) for on-device decoding.  
- **Persistence**: Drift (SQLite) with tables for Products, Sessions, and Entries.  
- **Auth**: PIN-protected manager screens via flutter_secure_storage (SHA-256).  
- **Mocks & Dev Fixtures**: A `lib/dev` folder with `dev_config.dart` toggle and mock services.  
- **Testing & CI**: Unit, widget, integration tests + GitHub Actions / Fastlane pipelines.

## Folder Layout

```text
lib/
├── main.dart                  # App entrypoint (sets up DI, runs App widget)
├── app.dart                   # MaterialApp (theme, routes)
├── injection.dart             # Dependency-injection setup (get_it/Riverpod providers)
├── core/                      # Cross-cutting utilities & services
│   ├── constants/             # App-wide constants (e.g. BLE UUIDs)
│   ├── errors/                # Custom exceptions / failures
│   ├── utils/                 # Parsers, formatters, conversion helpers
│   └── services/              # Platform-agnostic services
│       ├── barcode_scanner.dart  # Wraps mobile_scanner
│       ├── mobile_barcode_scanner.dart  # Each “feature” is a self-contained module
│       ├── reactive_ble_scale.dart  # PIN auth for manager areas
│       └── scale_service.dart
├── dev/                 
│   ├── config/                  
│   │   └── dev_config.dart
│   ├── data/
│   └── mocks/
│           ├── mock_barcode_scanner.dart
│           └── mock_scale_service.dart
├── features/                 
│   ├── auth/                  
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   │   └── pin_local_data_source.dart
│   │   │   └── repositories/
│   │   │       └── pin_repository_impl.dart
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   └── pin.dart
│   │   │   └── usecases/
│   │   │       └── verify_pin.dart
│   │   └── presentation/
│   │       ├── providers/     # Riverpod/BLoC providers
│   │       └── screens/
│   │           └── pin_entry_screen.dart
│   │
│   ├── products/              # Manager CRUD on Products
│   │   ├── data/
│   │   │   ├── models/
│   │   │   │   └── product_model.dart
│   │   │   ├── datasources/
│   │   │   │   └── product_local_data_source.dart
│   │   │   └── repositories/
│   │   │       └── product_repository_impl.dart
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   └── product.dart
│   │   │   └── usecases/
│   │   │       ├── add_product.dart
│   │   │       ├── update_product.dart
│   │   │       └── delete_product.dart
│   │   └── presentation/
│   │       ├── providers/
│   │       └── screens/
│   │           ├── product_list_screen.dart
│   │           └── product_form_screen.dart
│   │       └── widgets/
│   │           └── product_tile.dart
│   │
│   ├── sessions/              # Manager list/edit/delete inventory sessions
│   │   ├── data/
│   │   │   ├── models/
│   │   │   │   └── session_model.dart
│   │   │   ├── datasources/
│   │   │   │   └── session_local_data_source.dart
│   │   │   └── repositories/
│   │   │       └── session_repository_impl.dart
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   └── inventory_session.dart
│   │   │   └── usecases/
│   │   │       ├── create_session.dart
│   │   │       ├── get_sessions.dart
│   │   │       └── delete_session.dart
│   │   └── presentation/
│   │       ├── providers/
│   │       └── screens/
│   │           └── session_list_screen.dart
│   │       └── widgets/
│   │           └── session_tile.dart
│   │
│   └── inventory/             # Open to all staff for scanning & entry
│       ├── data/
│       │   ├── models/
│       │   │   └── entry_model.dart
│       │   ├── datasources/
│       │   │   └── entry_local_data_source.dart
│       │   └── repositories/
│       │       └── entry_repository_impl.dart
│       ├── domain/
│       │   ├── entities/
│       │   │   └── inventory_entry.dart
│       │   └── usecases/
│       │       ├── add_entry.dart
│       │       ├── get_entries.dart
│       │       └── export_entries.dart
│       └── presentation/
│           ├── providers/
│           └── screens/
│               └── inventory_screen.dart
│           └── widgets/
│               └── entry_list_item.dart
│
├── shared/                    # Reusable widgets & helpers
│   ├── widgets/
│   │   ├── loading_indicator.dart
│   │   └── error_dialog.dart
│   └── extensions/            # Dart extensions on core types
│
└── router/                    # Routing definitions
    └── app_router.dart        # Route definitions (auto_route or plain)
```

## What’s Done

1. **Project skeleton & DI**  
   - Directory structure under `lib/`, with `core/`, `dev/`, `features/`, etc.  
   - `injection.dart` registers `ScaleService` & `BarcodeScanner` toggled by `useMocks`.  
2. **Service layer**  
   - Defined `ScaleService` & `BarcodeScanner` interfaces.  
   - Added `ReactiveBleScaleService` & `MobileBarcodeScanner` stubs.  
   - Added `MockScaleService` & `MockBarcodeScanner` in `lib/dev/mocks/`.  
3. **Smoke-test UI**  
   - `app.dart` + `main.dart` with “Connect Scale” & “Scan Barcode” buttons.  
   - Mock services drive fake weights and canned SnackBar codes.  
4. **Testing**  
   - Widget test updated to verify smoke-test UI renders and responds.

## Remaining Work

- **Real hardware integration**  
  - Implement BLE logic in `ReactiveBleScaleService`.  
  - Hook up camera scanning in `MobileBarcodeScanner`.  
- **Database layer**  
  - Define Drift tables & migrations; build repositories & data sources.  
- **Manager features**  
  - PIN-entry flow and protected CRUD screens for Products & Sessions.  
- **Inventory workflow UI**  
  - Session picker, live weight + scan → persist entries; CSV export.  
- **Comprehensive testing**  
  - Unit tests for domain/use-cases, repository mocks.  
  - Widget tests for all screens.  
  - Integration tests covering full scan → export flow.  
- **CI/CD & Docs**  
  - Lint/test/build pipelines configured.  
  - API docs for BLE UUIDs, database schema, developer onboarding.

  ## Bugs

  1. **Connect scale allows multiple connections at a time, (weights cycle faster in test)**
      - Env:Development
      - Build: Smoketest
      - Importance: moderate
