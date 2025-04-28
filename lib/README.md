# Barkeeper

A cross-platform mobile application to streamline bar inventory management by integrating a Bluetooth kitchen scale and camera-based barcode scanning into a unified workflow.

## Goals

- **Automate Weekly Inventory**: Replace manual spreadsheet entry by capturing bottle weights and barcodes in a single tap-and-scan flow.
- **Unified Codebase**: Build one Flutter app that compiles for both iOS and Android.
- **Secure Manager Operations**: Protect product catalog and session management behind a PIN.
- **Open Staff Workflow**: Allow any staff member to start or resume an inventory session and record entries without authentication.
- **Robust Data Reporting**: Store persistent catalogs and session entries in SQLite, then export joined reports (name, barcode, liquor weight, timestamp) as CSV.

## Major Decisions

- **Framework & Language**: Choosing **Flutter (Dart)** for hot reload, rich UI, and single codebase deployment to iOS & Android.

- **Architecture**: Implementing **Clean Architecture** with three layers:
  1. **Presentation**: Widgets + Riverpod providers for state management.
  2. **Domain**: Pure Dart use cases and entity models.
  3. **Data**: Repositories & local data sources (SQLite via Drift or sqflite).

- **Bluetooth Scale Integration**: Using **flutter_reactive_ble** to connect to the Decent Scale (Service UUID `FFF0`, Char UUID `FFF4`).

- **Barcode Scanning**: Employing **mobile_scanner** (ML Kit / AVFoundation) for high-performance, on-device decoding.

- **Database Schema**:
  - **Products** (manager CRUD): `barcode` (PK), `dry_weight`, `name`.
  - **InventorySessions**: `id`, `session_name`, `created_at`, `created_by`, `status`.
  - **InventoryEntries**: `id`, `session_id` (FK), `barcode`, `bottle_weight`, `timestamp`, `scanned_by`.

- **Authentication**: Manager screens (products & sessions) protected by a PIN stored securely (`flutter_secure_storage`, SHA-256). Rate-limited attempts and optional DB encryption via SQLCipher.

- **Mocks & Dev Fixtures**: A `lib/dev` folder contains JSON fixtures and mock services for BLE and barcode, toggled via a compile-time flag for rapid UI prototyping and testing.

- **Folder Structure**: Feature-based modules under `lib/features`, shared widgets under `lib/shared`, core services under `lib/core`, and router/injection at root.

- **Testing & CI**:
  - **Unit tests** for domain logic & repositories (with mocks).
  - **Widget tests** for key screens.
  - **Integration tests** for full scan → export flows.
  - CI pipeline configured to lint, test, build, and deploy via Fastlane or GitHub Actions.

## Folder Layout

lib/
├── main.dart                  # App entrypoint (sets up DI, runs App widget)
├── app.dart                   # MaterialApp (theme, routes)
├── injection.dart             # Dependency-injection setup (get_it/Riverpod providers)
├── core/                      # Cross-cutting utilities & services
│   ├── constants/             # App-wide constants (e.g. BLE UUIDs)
│   ├── errors/                # Custom exceptions / failures
│   ├── utils/                 # Parsers, formatters, conversion helpers
│   └── services/              # Platform-agnostic services
│       ├── ble_service.dart   # Wraps flutter_reactive_ble
│       └── barcode_service.dart # Wraps mobile_scanner
├── features/                  # Each “feature” is a self-contained module
│   ├── auth/                  # PIN auth for manager areas
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
└── router/
    └── app_router.dart        # Route definitions (auto_route or plain)

