import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

//ingredientDatabase handles all local database operations (SQLite)
class IngredientDatabase {
  //singleton pattern: single instance of IngredientDatabase
  static final IngredientDatabase instance = IngredientDatabase._init();

  //private variable to hold database instance
  static Database? _database;

  //private constructor
  IngredientDatabase._init();

  //getter to retrieve database, initializing if necessary
  Future<Database> get database async {
    if (_database != null) return _database!; //if database already exists, return it
    _database = await _initDB('ingredients.db'); //else, initialize it
    return _database!;
  }

  // Initialize the database
  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath(); //get default database location on device
    final path = join(dbPath, filePath); //create a full path for database
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB, //call _createDB when database is first created
    );
  }

  //define table structure when database is created
  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE ingredients (
        id INTEGER PRIMARY KEY AUTOINCREMENT, -- Unique ID auto-incremented
        name TEXT NOT NULL,                   -- Ingredient name
        description TEXT NOT NULL,            -- Description of the ingredient
        healthRating INTEGER NOT NULL,        -- Health rating (e.g., 1-10)
        category TEXT NOT NULL                -- Category (e.g., preservative, sweetener)
      )
    ''');
  }

  //insert a new ingredient into database
  Future<void> insertIngredient({
    required String name,
    required String description,
    required int healthRating,
    required String category,
  }) async {
    final db = await instance.database; //get database instance
    await db.insert(
      'ingredients', //table name
      {
        'name': name,
        'description': description,
        'healthRating': healthRating,
        'category': category,
      },
      conflictAlgorithm: ConflictAlgorithm.replace, //replace if duplicate ID
    );
  }

  //delete an ingredient by ID
  Future<void> deleteIngredient(int id) async {
    final db = await instance.database; //get database instance
    await db.delete(
      'ingredients', //table name
      where: 'id = ?', //delete where id matches
      whereArgs: [id], //provide the id value
    );
  }

  //retrieve all ingredients from database
  Future<List<Map<String, dynamic>>> getIngredients() async {
    final db = await instance.database; //get database instance
    final result = await db.query('ingredients'); //query whole ingredients table
    return result; //return list of ingredients
  }

  //close the database 
  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
