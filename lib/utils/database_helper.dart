import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'package:trabalhoflutter/models/contact.dart';
import 'package:trabalhoflutter/models/location.dart';
/*
class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  static const _dbName = "contacts_app.db";
  static const _dbVersion = 1;

  static const String contactTable = 'contacts';
  static const String locationTable = 'locations';

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _dbName);

    return await openDatabase(
      path,
      version: _dbVersion,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $contactTable (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        email TEXT NOT NULL,
        phone TEXT NOT NULL,
        imagePath TEXT,
        birthDate TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE $locationTable (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        contactId INTEGER NOT NULL,
        latitude REAL NOT NULL,
        longitude REAL NOT NULL,
        FOREIGN KEY (contactId) REFERENCES $contactTable (id) ON DELETE CASCADE
      )
    ''');
  }

  // Método para apagar o banco de dados (útil para testes)
  Future<void> deleteDatabase(String path) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _dbName);
    await deleteDatabase(path);
  }

  // Métodos para o gerenciamento de contatos

  Future<int> insertContact(Contact contact) async {
    final db = await database;

    // Inserir o contato
    int contactId = await db.insert(contactTable, contact.toMap());

    // Inserir as localizações associadas
    if (contact.locations != null) {
      for (var location in contact.locations!) {
        await db.insert(locationTable, {
          'contactId': contactId,
          ...location.toMap(),
        });
      }
    }

    return contactId;
  }

  Future<int> updateContact(Contact contact) async {
    final db = await database;

    // Atualizar o contato
    int rowsAffected = await db.update(
      contactTable,
      contact.toMap(),
      where: 'id = ?',
      whereArgs: [contact.id],
    );

    // Atualizar localizações
    if (contact.locations != null) {
      // Primeiro, apagar as localizações antigas
      await db.delete(
        locationTable,
        where: 'contactId = ?',
        whereArgs: [contact.id],
      );

      // Inserir as novas localizações
      for (var location in contact.locations!) {
        await db.insert(locationTable, {
          'contactId': contact.id,
          ...location.toMap(),
        });
      }
    }

    return rowsAffected;
  }

  Future<int> deleteContact(int contactId) async {
    final db = await database;

    // Deletar o contato e suas localizações associadas (cascade já configurado)
    return await db.delete(
      contactTable,
      where: 'id = ?',
      whereArgs: [contactId],
    );
  }

  Future<List<Contact>> getContacts() async {
    final db = await database;

    // Buscar contatos
    final List<Map<String, dynamic>> contactMaps = await db.query(contactTable);

    // Buscar localizações e associar aos contatos
    List<Contact> contacts = [];
    for (var contactMap in contactMaps) {
      final List<Map<String, dynamic>> locationMaps = await db.query(
        locationTable,
        where: 'contactId = ?',
        whereArgs: [contactMap['id']],
      );

      List<LocationModel> locations = locationMaps
          .map((locationMap) => LocationModel.fromMap(locationMap))
          .toList();

      contacts.add(Contact.fromMap(contactMap, locations: locations));
    }

    return contacts;
  }

  // Métodos para gerenciar localizações específicas

  Future<List<LocationModel>> getLocationsByContactId(int contactId) async {
    final db = await database;

    final List<Map<String, dynamic>> locationMaps = await db.query(
      locationTable,
      where: 'contactId = ?',
      whereArgs: [contactId],
    );

    return locationMaps
        .map((locationMap) => LocationModel.fromMap(locationMap))
        .toList();
  }
}
*/