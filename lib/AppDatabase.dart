// Picks the right openConnection() for the platform:
//   Chrome (web)      -> web.dart
//   Android/Windows   -> native.dart
import 'connection.dart'
if (dart.library.js_interop) 'web.dart'
if (dart.library.io) 'native.dart';

import 'package:drift/drift.dart';

part 'AppDatabase.g.dart'; // drift creates this file for us later

@DriftDatabase(
  include: {'Contact.drift'}, // our table + SQL statements
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(openConnection());

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onUpgrade: (migrator, from, to) async {
        await migrator.createAll();
      },
      beforeOpen: (details) async {},
    );
  }
}