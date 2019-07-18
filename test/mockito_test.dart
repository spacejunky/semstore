import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';
import '';

// Investigate how best to mock with Firestore

var getIt = GetIt();

class MockFirestore extends Mock implements Firestore {}

class MockCollectionReference extends Mock implements CollectionReference {}

class MockQuerySnapshot extends Mock implements QuerySnapshot {}

class MockDocumentSnapshot extends Mock implements DocumentSnapshot {}

bool mock = true;
//bool mock = false;

Firestore fs;

void main() {
  setUp(() {
    getIt.registerSingleton<Firestore>(Firestore.instance);
    if (mock) {
      getIt.allowReassignment = true;
      getIt.registerSingleton<Firestore>(MockFirestore());
    }
    fs = getIt<Firestore>();
  });

  group("test mockito with firestore", () {
    test("firestore.instance", () async {
      if (mock) {
        var mockCollectionReference = MockCollectionReference();
        var mockQuerySnapshot = MockQuerySnapshot();
        var mockDocumentSnapshot = MockDocumentSnapshot();
        var mockFredDocument = <String, dynamic>{
          "uid": "fred1234",
          "count": 1,
        };

        when(fs.collection("/fred")).thenReturn(mockCollectionReference);
        when(mockCollectionReference.snapshots()).thenAnswer((_) => Stream.fromIterable([mockQuerySnapshot,mockQuerySnapshot]));
        when(mockQuerySnapshot.documents).thenReturn([mockDocumentSnapshot,mockDocumentSnapshot]);
        when(mockDocumentSnapshot.data).thenReturn(mockFredDocument);
      }

      expect(fs, isA<Firestore>());
      expect(fs.collection("/fred"), isA<CollectionReference>());
      await expectLater(fs.collection("/fred").snapshots(), emitsInOrder([isA<QuerySnapshot>(),isA<QuerySnapshot>(), emitsDone]));
      await expectLater(fs.collection("/fred").snapshots().map((qs) => qs.documents),
          emitsInOrder([isA<List<DocumentSnapshot>>(), isA<List<DocumentSnapshot>>(),emitsDone]));
      await fs.collection("/fred").snapshots().listen((qs) {
        qs.documents.forEach((ds) {
          expect(ds.data,<String, dynamic>{
            "uid": "fred1234",
            "count": 1,
          });
        });
      });
    });
  });
}
