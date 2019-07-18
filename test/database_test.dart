import 'package:flutter_test/flutter_test.dart';
import 'package:semstore/semstore.dart' as semstore;
import 'package:sembast/sembast.dart' as sembast;
import 'package:cloud_firestore/cloud_firestore.dart' as firestore;

void main() {
  setUp(() {});

  group("open Database", () {
    test("with Firestore", () async {
      var dbConfig = semstore.Configuration(
        useFirestore: true,
        storeConfigurations: {
          "xyzzy": semstore.StoreConfiguration(
            firestoreCollectionName: "xyzzy_collection",
          )
        },
      );

      var db = semstore.Database(
        path: '/tmp/semstore.db',
        userId: "fred",
        configuration: dbConfig,
      );

      await db.openSemstore();

      expect(db.configuration.useFirestore, true);
      expect(db, isA<semstore.Database>());
      expect(db.semDb, isA<sembast.Database>());
      expect(db.fireDb, isA<firestore.Firestore>());

      expect(db.semDb.path, "/tmp/semstore.db");
    });

    test("without Firestore", () async {
      var dbConfig =
          semstore.Configuration(useFirestore: false, storeConfigurations: {});

      var db = semstore.Database(
        path: '/tmp/semstore.db',
        // userId: "fred",
        configuration: dbConfig,
      );

      await db.openSemstore();

      expect(db.configuration.useFirestore, false);
      expect(db, isA<semstore.Database>());
      expect(db.semDb, isA<sembast.Database>());
      expect(db.fireDb, null);

      expect(db.semDb.path, "/tmp/semstore.db");
    });

    test("without Firestore, non persistent sembast", () async {
      var dbConfig = semstore.Configuration(
          useFirestore: false,
          sembastPersistent: false,
          storeConfigurations: {});

      var db = semstore.Database(
        path: '/tmp/semstore.db',
        // userId: "fred",
        configuration: dbConfig,
      );

      await db.openSemstore();

      expect(db.configuration.useFirestore, false);
      expect(db.configuration.sembastPersistent, false);
      expect(db, isA<semstore.Database>());
      expect(db.semDb, isA<sembast.Database>());
      expect(db.fireDb, null);

      expect(db.semDb.path, "/tmp/semstore.db");
    });
  });
}
