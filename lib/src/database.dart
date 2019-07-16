import 'package:flutter/material.dart';
import 'package:sembast/sembast.dart' as sembast;
import 'package:sembast/sembast_io.dart' as sembast_io;
import 'package:sembast/sembast_memory.dart' as sembast_memory;
import 'package:cloud_firestore/cloud_firestore.dart' as firestore;
import 'package:semstore/src/configuration.dart';

/// [Database] is a handle for accessing the semstore data store
class Database {

  /// the sembast database
  @visibleForTesting
  get semDb => _semDb;
  sembast.Database _semDb;

  /// the Firestore database
  @visibleForTesting
  get fireDb => _fireDb;
  firestore.Firestore _fireDb;

  /// setup a semstore database at a given filesystem path
  Future<Database> openDatabase(String path) async {
    _semDb = Configuration.sembastPersistent
        ? await sembast_io.databaseFactoryIo.openDatabase(path)
        : await sembast_memory.databaseFactoryMemory.openDatabase(path);

    _fireDb = Configuration.useFirestore ? firestore.Firestore.instance : null;

    return this;
  }
}
