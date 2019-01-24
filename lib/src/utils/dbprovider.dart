import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pinyo/src/models/post.dart';
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
    return await openDatabase(path, version: 2, onOpen: (db) {
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
        await db.execute("CREATE TABLE Tags("
                 "id INTEGER PRIMARY KEY,"
                 "tag TEXT,"
                 "tagCount INT"
                 ")");
      },
      onUpgrade: (Database db, int oldVersion, int newVersion) async {
        await db.execute("CREATE TABLE Tags("
                 "id INTEGER PRIMARY KEY,"
                 "tag TEXT,"
                 "tagCount INT"
                 ")");
      }
    );
  }

  Future<int> savePost(Post post) async {
    final db = await database;
    // returns the id
    return db.insert("Posts", toJson(post));
  }

  Future<int> saveTag(String tag) async {
    final db = await database;
    return db.insert("Tags", {'tag': tag});
  }

  Future<Post> getPostById(int id) async {
    final db = await database;
    var res = await db.query("Posts", where: "id = ?", whereArgs: [id]);
    return res.isNotEmpty ? parsePostFromJson(res.toString()) : Null;
  }

  getPostByHash(String hash) async {
    final db = await database;
    var res = await db.query("Posts", where: "hash = ?", whereArgs: [hash]);
    return res.isNotEmpty ? parsePost(res.first) : Null;
  }

  getTagByName(String tag) async {
    final db = await database;
    var res = await db.query("Tags", where: "tag = ?", whereArgs: [tag]);
    return res.isNotEmpty ? res.first['tag'] : Null;
  }

  Future<List<Post>> getAllPosts() async {
    final db = await database;
    var res = await db.query("Posts", orderBy: "time DESC");
    List<Post> list =
        res.isNotEmpty ? res.map((post) => parsePost(post)).toList() : [];
    return list;
  }

  Future<List<String>> getAllTags() async {
    final db = await database;
    var res = await db.query("Tags");
    List<String> list =
        res.isNotEmpty ? res.toList().map((i) => i['tag'].toString()).toList() : [];
    return list;
  }

  Future<List<Post>> getPostsByTag(String tag) async {
    final db = await database;
    var res = await db.query("Posts", where: "tags LIKE '%$tag%'");
    List<Post> list =
        res.isNotEmpty ? res.map((post) => parsePost(post)).toList() : [];
    return list;
  }

  Future<int> checkAndInsert(Post post) async {
    final curPost = await getPostByHash(post.hash);
    if(curPost == Null) {
      return savePost(post);
    } else if (post.meta != curPost.meta) {
      updatePost(post);
    }
    return 0;
  }

  Future<int> checkAndInsertTag(String tag) async {
    final curTag = await getTagByName(tag);
    if(curTag != tag) {
      return saveTag(tag);
    }
    return 0;
  }

  Future<int> updatePost(Post newPost) async {
    print('updating post ${newPost.hash}, ${newPost.id}');
    final db = await database;
    var res = await db.update("Posts", toJson(newPost),
      where: "hash = ?", whereArgs: [newPost.hash]);
    return res;
  }
  // TODO: Add delete method

  // TODO: clear posts that are no longer actually in pinboard
  // will likely have to do this during update
}