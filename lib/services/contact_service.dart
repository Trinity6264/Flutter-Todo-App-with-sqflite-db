import 'package:agokansie/models/contact_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class ContactService {
  Future<Database> openCustomDatabase() async {
    return openDatabase(join(await getDatabasesPath(), 'contacts.db'),
        onCreate: _createTable, version: 1);
  }

  // creating table and passing fields to it(Non nullable)
  Future<void> _createTable(Database db, int id) async {
    return await db.execute(
      'CREATE TABLE contact (id INTEGER PRIMARY KEY, name TEXT, number TEXT,time TEXT)',
    );
  }

  // Insert data
  Future<Database> insertData({required ContactHelper helper}) async {
    final db = await openCustomDatabase();
    db.insert('contact', helper.toMap(),
        conflictAlgorithm: ConflictAlgorithm.ignore);
    return db;
  }

  // Update
  Future<Database> updateData(List id, ContactHelper helper, ) async {
    final db = await openCustomDatabase();
    db.update('contact', helper.toMap(), where: 'id = ?', whereArgs: id);
    return db;
  }

  // Delete
  Future deleteData(List id) async {
    final db = await openCustomDatabase();
    db.delete('contact', where: 'id = ?', whereArgs: id);
    return id;
  }

  // getData
  Future<List<Map>> fetchData() async {
    final db = await openCustomDatabase();
    return db.query('contact', orderBy: 'time');
  }
}
