import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pinyo/src/models/post.dart';
import 'package:pinyo/src/utils/serializers.dart';
import 'package:sqflite/sqflite.dart';

class DBProvider {
  DBProvider._();
  static final DBProvider db = DBProvider._();
  static Database _database;

  Future<Database> get database async {
    if (_database != null)
      return _database;
    
    _database = await initDB();
    return _database;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "posts.db");
    return await openDatabase(path, version: 1, onOpen: (db) {
      }, onCreate: (Database db, int version) async {
        await db.execute("CREATE TABLE Posts ("
                "id INTEGER PRIMARY KEY,"
                "href TEXT,"
                "description TEXT,"
                "extended TEXT,"
                "meta TEXT,"
                "hash TEXT,"
                "time TEXT,"
                "shared TEXT,"
                "toread TEXT,"
                "tags TEXT"
                ")");
      }
    );
  }

  Future<int> savePost(Post post) async {
    print("Saving post");
    final db = await database;
    // returns the id
    return db.insert("Posts", toJson(post));
  }

  Future<Post> getPostById(int id) async {
    final db = await database;
    var res = await db.query("Posts", where: "id = ?", whereArgs: [id]);
    return res.isNotEmpty ? parsePostFromJson(res.toString()) : Null;
  }

  getPostByHash(String hash) async {
    print("getting");
    final db = await database;
    var res = await db.query("Posts", where: "hash = ?", whereArgs: [hash]);
    print("got it");
    return res.isNotEmpty ? parsePostFromJson(res.toString()) : Null;
  }

  Future<List<Post>> getAllPosts() async {
    final db = await database;
    var res = await db.query("Posts");
    List<Post> list =
        res.isNotEmpty ? res.map((post) => parsePost(post)).toList() : [];
    return list;
  }

  Future<List<Post>> getPostsByTag(String tag) async {
    final db = await database;
    var res = await db.query("Posts", where: "tag = ?", whereArgs: [tag]);
    List<Post> list =
        res.isNotEmpty ? res.map((post) => parsePost(post)).toList() : [];
    return list;
  }

  Future<int> checkAndInsert(Post post) async {
    print("Checking and inserting...");
    if(await getPostByHash(post.hash) == Null) {
      return savePost(post);
    }
    return 0;
  }
  
  // TODO: Add update an delete methods

}