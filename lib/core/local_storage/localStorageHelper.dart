// ignore_for_file: file_names

import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';


// ignore: avoid_classes_with_only_static_members
class LocalStorageHelper {
  static FlutterSecureStorage prefs = const FlutterSecureStorage();
  static const String _prefix = 'one_lib_dev_';


  static Future logout() async {
    await prefs.deleteAll();
  }

  //Shared prefences
  static Future setInt(String key, int value) async {
    await prefs.write(key: '$_prefix$key', value: value.toString());
  }

  static Future setDouble(String key, double value) async {
    await prefs.write(key: '$_prefix$key', value: value.toString());
  }

  static Future setBool(String key, bool value) async {
    print('$_prefix$key');
    await prefs.write(key: '$_prefix$key', value: value ? 'true' : 'false');
  }

  static Future setString(String key, String value) async {
    await prefs.write(key: '$_prefix$key', value: value);
  }

  static Future setStringList(String key, List<String> values) async {
    await prefs.write(key: '$_prefix$key', value: values.join("||"));
  }

  static Future setFcmTopics(List<String> values) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('fcm_topics', values.join("||"));
    print('TOPICS: $values');
  }

  static Future<dynamic> getData(String key) async {
    return prefs.read(key: '$_prefix$key');
  }

  static Future<int?> getInt(String key) async {
    try {
      final value = await prefs.read(key: '$_prefix$key');
      if (value != null) {
        return int.parse(value);
      }
    } catch (e) {}
    return null;
  }

  static Future setCurrentUser(String username) async {
    // LocalStorageHelper._prefix = username;
    await prefs.write(key: 'one_lib_current_user', value: username);
  }

  static Future<String?> getCurrentUser() async {
    try {
      final value = await prefs.read(key: 'one_lib_current_user');
      if (value != null) {
        // LocalStorageHelper._prefix = value;
        return value;
      }
    } catch (e) {}
    return null;
  }

  static Future saveUsers(String users) async {
    await prefs.write(key: 'one_lib_list_users', value: users);
  }

  static Future<String> getUsers() async {
    try {
      final value = await prefs.read(key: 'one_lib_list_users');
      if (value != null) {
        return value;
      }
    } catch (e) {}
    return '[]';
  }

  static Future<String> getTimeInstallApp() async {
    try {
      final _prefs = await SharedPreferences.getInstance();
      final time = _prefs.getString('time_install_app');
      if (time != null) {
        return time;
      } else {
        prefs.deleteAll();
        final time = DateTime.now().millisecondsSinceEpoch.toString();
        await _prefs.setString('time_install_app', time);
        return time;
      }
    } catch (e) {
      print('error = $e');
    }
    return 'none';
  }

  static Future<double?> getDouble(String key) async {
    try {
      final value = await prefs.read(key: '$_prefix$key');
      if (value != null) {
        return double.parse(value);
      }
    } catch (e) {}
    return null;
  }

  static Future<bool?> getBool(String key) async {
    print('$_prefix$key');
    try {
      final value = await prefs.read(key: '$_prefix$key');
      print('value = $value');
      if (value != null) {
        return value == 'true';
      }
    } catch (e) {
      print("ERRROR = $e");
    }
    return null;
  }

  static Future<String?> getString(String key) async {
    try {
      final value = await prefs.read(key: '$_prefix$key');
      if (value != null) {
        return value;
      }
    } catch (e) {}
    return null;
  }

  static Future<List<String>?> getFcmTopics() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final value = prefs.getString('fcm_topics');
      if (value != null) {
        return value.split('||');
      }
    } catch (e) {}
    return null;
  }

  static Future<List<String>?> getStringList(String key) async {
    try {
      final value = await prefs.read(key: '$_prefix$key');
      if (value != null) {
        return value.split('||');
      }
    } catch (e) {}
    return null;
  }

  static Future removeData(String key) async {
    await prefs.delete(key: '$_prefix$key');
  }

  //Write and read file
  static late String _fileName;

  static String get _getFileName {
    return _fileName;
  }

  static void _setFileName(String filename) {
    _fileName = filename;
  }

  static Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  static Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/$_getFileName.txt');
  }

  static Future<File> writeToFile(String fileName, dynamic data) async {
    _setFileName(fileName);
    final file = await _localFile;
    // Write the file
    return file.writeAsString('$data');
  }

  static Future<String> readFromFile(String filename) async {
    try {
      _setFileName(filename);
      final file = await _localFile;
      // Read the file
      final contents = await file.readAsString();
      return contents;
    } catch (e) {
      // If encountering an error, return ""
      return '';
    }
  }

  //SQLite
  static late String _databasebName = '';

  static late String _tableName = '';

  static late String _arguments = '';

  static late int _sqliteVersion = -1;

  static bool _databaseCreated() {
    if (_databasebName == '' || _tableName == '' || _sqliteVersion == -1) {
      return false;
    } else {
      return true;
    }
  }

  //Create a table in SQLite
  static Future<Database> createDatabase(
      String db, String table, String arg, int version) async {
    final String path = await getDatabasesPath();
    _databasebName = db;
    _tableName = table;
    _arguments = arg;
    _sqliteVersion = version;
    return openDatabase(join(path, '$db.db'),
        onCreate: (database, version) async {
      await database.execute(
        arg,
      );
    }, version: version);
  }

  static Future<Database?> _initializeDB() async {
    if (!_databaseCreated()) {
      return null;
    }
    final String path = await getDatabasesPath();
    return openDatabase(join(path, '$_databasebName.db'),
        onCreate: (database, version) async {
      await database.execute(
        _arguments,
      );
    }, version: _sqliteVersion);
  }

  //Saving data in SQLite
  static Future<int> insertRow(String table, List<dynamic> dataList) async {
    int result = 0;
    final Database? db = await _initializeDB();
    if (db == null) {
      return -1;
    } else {
      for (var user in dataList) {
        result = await db.insert(table, user.toMap());
      }
      return result;
    }
  }
}
