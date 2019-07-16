import 'package:flutter_test/flutter_test.dart';

import 'package:semstore/semstore.dart';
import 'package:sembast/sembast.dart' as sembast;
import 'package:cloud_firestore/cloud_firestore.dart' as firestore;


void main() {
  setUp((){});

  group("open Database", () {

    test("with Firestore",() async {

      var db = await Database().openDatabase('/tmp/semstore.db');

      expect(Configuration.useFirestore,true);
      expect(db, isA<Database>());
      expect(db.semDb, isA<sembast.Database>());
      expect(db.fireDb, isA<firestore.Firestore>());

      expect(db.semDb.path, "/tmp/semstore.db");

    });

    test("without Firestore",() async {

      Configuration.useFirestore = false;

      var db = await Database().openDatabase('/tmp/semstore.db');

      expect(Configuration.useFirestore,false);
      expect(db, isA<Database>());
      expect(db.semDb, isA<sembast.Database>());
      expect(db.fireDb, null);

      expect(db.semDb.path, "/tmp/semstore.db");

    });

    test("non-persistent sembast",() async {

      Configuration.sembastPersistent = false;

      var db = await Database().openDatabase('something_not_a_filename');

      expect(Configuration.useFirestore,true);
      expect(db, isA<Database>());
      expect(db.semDb, isA<sembast.Database>());
      expect(db.fireDb, isA<firestore.Firestore>());

      expect(db.semDb.path, "something_not_a_filename");

    });
  });

}