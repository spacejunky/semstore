import 'package:flutter/material.dart';
import 'package:sembast/sembast.dart' as sembast;
import 'package:sembast/sembast_io.dart' as sembast_io;
import 'package:sembast/sembast_memory.dart' as sembast_memory;
import 'package:cloud_firestore/cloud_firestore.dart' as firestore;
import 'package:semstore/src/configuration.dart';

/// [Database]  is a semstore data store
class Database {
  /// setup a semstore database at a given filesystem path
  Database({
    @required String path,
    @required Configuration configuration,
    String userId = "",
  })  : assert(path != ""),
        assert(configuration != null),
        assert(userId != "" || !configuration.useFirestore),
        _path = path,
        _userId = userId,
        _configuration = configuration;

  Future<void> openSemstore() async {
    _semDb = await _openSembast(_path);

    _fireDb = await _openFirestore();
  }

  /// the sembast database
  @visibleForTesting
  get semDb => _semDb;
  sembast.Database _semDb;

  /// the Firestore database
  @visibleForTesting
  get fireDb => _fireDb;
  firestore.Firestore _fireDb;

  /// path of the database
  @visibleForTesting
  get path => _path;
  String _path;

  /// a userId
  @visibleForTesting
  get userId => _userId;
  String _userId;

  /// the Configuration info
  @visibleForTesting
  get configuration => _configuration;
  var _configuration;

  // open the sembast part
  Future<sembast.Database> _openSembast(String path) async {
    if (_configuration.sembastPersistent) {
      return await sembast_io.databaseFactoryIo.openDatabase(path);
    } else {
      return await sembast_memory.databaseFactoryMemory.openDatabase(path);
    }
  }

  // open the firestore part
  Future<firestore.Firestore> _openFirestore() async {
    return _configuration.useFirestore ? firestore.Firestore.instance : null;
  }

  /// close a semstore database
  void closeDatabase() {
    semDb.close();
    // flush or wait for pending writes?
    // release client resources?
    // TODO: what should be done to closedown firestore database?
  }
}
