part of contact_app;

const kDbVersion = 1;
const kSqliteCntactDbName = "contact";

class ContactDb {
  static ContactDb? _instance;

  ContactDb._();

  static ContactDb get instance {
    _instance ??= ContactDb._();
    return _instance!;
  }

  late final Database _sql;

  Future<File> getFilePath(String fileName) async {
    var databasesPath = await getDatabasesPath();
    return File('$databasesPath/$fileName');
  }

  Future<void> initializeContactDb() async {
    final dbPath = await getFilePath('contact_app.db');
    // await dbPath.delete();
    // return;

    final db = await openDatabase(
      dbPath.path,
      onCreate: (db, version) {
        return db.execute('''
        CREATE TABLE $kSqliteCntactDbName (
          identifier INTEGER PRIMARY KEY AUTOINCREMENT,
          givenName TEXT NOT NULL,
          middleName TEXT,
          familyName TEXT,
          phoneNumbers TEXT NOT NULL,
          isFavorite INTEGER NOT NULL DEFAULT 0,
          emails TEXT
        )
        ''');
      },
      version: kDbVersion,
    );
    _sql = db;
  }
}

extension ContactDbMethods on ContactDb {
  Future<List<ContactStoreModel>> getAllContacts() async {
    final List<Map<String, dynamic>> maps = await _sql.query(
      kSqliteCntactDbName,
      orderBy: 'givenName COLLATE NOCASE ASC',
    );
    return maps.map((map) => ContactStoreModel.fromMap(map)).toList();
  }

  Future<int> insertContact(ContactStoreModel contact) async {
    return await _sql.insert(
      kSqliteCntactDbName,
      contact.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> updateContact(ContactStoreModel contact) async {
    return await _sql.update(
      kSqliteCntactDbName,
      contact.toMap(),
      where: 'identifier = ?',
      whereArgs: [contact.identifier],
    );
  }

  Future<int> deleteContact(String identifier) async {
    return await _sql.delete(
      kSqliteCntactDbName,
      where: 'identifier = ?',
      whereArgs: [identifier],
    );
  }

  Future<ContactStoreModel?> getContactById(String identifier) async {
    final List<Map<String, dynamic>> result = await _sql.query(
      kSqliteCntactDbName,
      where: 'identifier = ?',
      whereArgs: [identifier],
    );
    if (result.isNotEmpty) {
      return ContactStoreModel.fromMap(result.first);
    }
    return null;
  }

  Future<void> toggleFavorite(String identifier, bool isFav) async {
    await _sql.update(
      kSqliteCntactDbName,
      {'isFavorite': isFav ? 1 : 0},
      where: 'identifier = ?',
      whereArgs: [identifier],
    );
  }

  Future<List<ContactStoreModel>> getFavoriteContacts() async {
    final List<Map<String, dynamic>> maps = await _sql.query(
      kSqliteCntactDbName,
      where: 'isFavorite = ?',
      whereArgs: [1],
    );
    return maps.map((map) => ContactStoreModel.fromMap(map)).toList();
  }
}
