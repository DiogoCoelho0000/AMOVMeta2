import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/contact.dart';
import '../models/location.dart';
import 'package:location/location.dart' as location_package;
/*
class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'contacts.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // Cria a tabela de contatos
    await db.execute('''
      CREATE TABLE contacts (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        email TEXT,
        phone TEXT NOT NULL,
        imagePath TEXT,
        birthDate TEXT
      )
    ''');

    // Cria a tabela de localizações
    await db.execute('''
      CREATE TABLE locations (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        contact_id INTEGER NOT NULL,
        latitude REAL NOT NULL,
        longitude REAL NOT NULL,
        FOREIGN KEY (contact_id) REFERENCES contacts (id) ON DELETE CASCADE
      )
    ''');
  }

  // Inserir um contato sem localizações
  Future<int> insertContact(Contact contact) async {
    final db = await database;
    return await db.insert('contacts', contact.toMap());
  }

  // Inserir um contato com localizações
  Future<int> insertContactWithLocations(Contact contact) async {
    final db = await database;

    // Salva o contato
    int contactId = await db.insert('contacts', contact.toMap());

    // Salva as localizações associadas
    if (contact.locations != null) {
      for (var location in contact.locations!) {
        await insertLocation(contactId, location as Location);
      }
    }

    return contactId;
  }

  // Buscar todos os contatos
  Future<List<Contact>> getContacts() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('contacts');
    return List.generate(maps.length, (i) => Contact.fromMap(maps[i]));
  }

  // Buscar todos os contatos com localizações
  Future<List<Contact>> getContactsWithLocations() async {
    final db = await database;

    // Busca todos os contatos
    final List<Map<String, dynamic>> contactMaps = await db.query('contacts');

    List<Contact> contacts = [];
    for (var contactMap in contactMaps) {
      // Busca localizações associadas
      int contactId = contactMap['id'];
      List<Location> locations = await getLocations(contactId);

      // Cria o contato com as localizações
      //contacts.add(Contact.fromMap(contactMap, locations: locations.isNotEmpty ? locations : null));
    }

    return contacts;
  }

  // Atualizar um contato
  Future<int> updateContact(Contact contact) async {
    final db = await database;
    return await db.update(
      'contacts',
      contact.toMap(),
      where: 'id = ?',
      whereArgs: [contact.id],
    );
  }

  // Atualizar um contato com localizações
  Future<int> updateContactWithLocations(Contact contact) async {
    final db = await database;

    // Atualiza o contato
    int result = await db.update(
      'contacts',
      contact.toMap(),
      where: 'id = ?',
      whereArgs: [contact.id],
    );

    // Remove as localizações antigas
    await deleteLocations(contact.id!);

    // Insere as localizações atualizadas
    if (contact.locations != null) {
      for (var location in contact.locations!) {
        await insertLocation(contact.id!, location as Location);
      }
    }

    return result;
  }

  // Deletar um contato
  Future<void> deleteContact(int id) async {
    final db = await database;
    await db.delete(
      'contacts',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Inserir uma localização
  Future<int> insertLocation(int contactId, Location location) async {
    final db = await database;
    return await db.insert('locations', {
      'contact_id': contactId,
      'latitude': location.latitude,
      'longitude': location.longitude,
    });
  }

  // Buscar localizações de um contato
  Future<List<Location>> getLocations(int contactId) async {
    final db = await database;
    final List<Map<String, dynamic>> result = await db.query(
      'locations',
      where: 'contact_id = ?',
      whereArgs: [contactId],
    );

    return result.map((map) => Location.fromMap(map)).toList();
  }

  // Excluir todas as localizações de um contato
  Future<void> deleteLocations(int contactId) async {
    final db = await database;
    await db.delete(
      'locations',
      where: 'contact_id = ?',
      whereArgs: [contactId],
    );
  }

  // Limpar o banco de dados
  Future<void> clearDatabase() async {
    final db = await database;
    await db.delete('locations');
    await db.delete('contacts');
  }
}
*/