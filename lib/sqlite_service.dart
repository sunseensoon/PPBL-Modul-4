import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'models/user.dart';

class DatabaseHandler {
  late Database _database;

  // Initialize SQLite Database
  Future<void> initializeDB() async {
    String path = join(await getDatabasesPath(), 'saham_database.db');
    _database =
        await openDatabase(path, version: 1, onCreate: (db, version) async {
      await db.execute('''
        CREATE TABLE saham(
          tickerId INTEGER PRIMARY KEY AUTOINCREMENT,
          ticker TEXT NOT NULL,
          open INTEGER,
          high INTEGER,
          last INTEGER,
          change REAL
        )
      ''');
    });
  }

  // Insert Saham into the database
  Future<int> insertSaham(Saham saham) async {
    return await _database.insert(
      'saham',
      saham.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Retrieve all Saham records
  Future<List<Saham>> retrieveSaham() async {
    final List<Map<String, dynamic>> maps = await _database.query('saham');
    return List.generate(maps.length, (i) {
      return Saham.fromMap(maps[i]);
    });
  }

  // Delete a Saham by tickerId
  Future<void> deleteSaham(int tickerId) async {
    await _database.delete(
      'saham',
      where: 'tickerId = ?',
      whereArgs: [tickerId],
    );
  }

  // Add sample data into the database
  Future<void> addSampleData() async {
    List<Saham> listOfSaham = [
      Saham(ticker: "TLKM", open: 3380, high: 3500, last: 3490, change: 2.05),
      Saham(ticker: "AMMN", open: 6750, high: 6750, last: 6500, change: -3.7),
      Saham(ticker: "BREN", open: 4500, high: 4610, last: 4580, change: 1.78),
      Saham(ticker: "CUAN", open: 5200, high: 5525, last: 5400, change: 3.85),
    ];

    for (var saham in listOfSaham) {
      await insertSaham(saham);
    }
  }
}
