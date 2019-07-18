import 'package:meta/meta.dart';

/// Configuration options for the combined datastore
class Configuration {
  Configuration({
    this.useFirestore = true,
    this.sembastPersistent = true,
    @required this.storeConfigurations,
  }) : assert(storeConfigurations.isNotEmpty || !useFirestore);

  /// whether or not to activate cloud_firestors
  final bool useFirestore;

  /// whether the sembast database should be persistent or in-memory only
  final bool sembastPersistent;

  /// [StoreConfiguration] data for each store used
  final Map<String, StoreConfiguration> storeConfigurations;
}

/// Firestore backing configuration information for a sembaststore
class StoreConfiguration {
  StoreConfiguration({
    @required this.firestoreCollectionName,
    this.initialisation = InitialisationBehaviour.INITIALISATION_NO_ACTION,
    this.localUpdates = LocalUpdateBehaviour.LOCAL_ONLY,
    this.remoteQuery = RemoteQueryOptions.QUERY_NO_FILTER,
    this.remoteUpdates = RemoteUpdateBehaviour.REMOTE_IGNORED,
  })  : _dontNeedFirestore = initialisation != InitialisationBehaviour.INITIALISATION_DOWNLOAD &&
            (localUpdates == LocalUpdateBehaviour.LOCAL_ONLY || localUpdates == LocalUpdateBehaviour.LOCAL_IGNORED) &&
            remoteUpdates == RemoteUpdateBehaviour.REMOTE_IGNORED {
    assert(_dontNeedFirestore || firestoreCollectionName != "");
    assert(_dontNeedFirestore || firestoreCollectionName != null);
  }


  // behaviours result in using firestore or not
  bool _dontNeedFirestore;

  /// the associated firestore collection
  final String firestoreCollectionName;

  /// store behaviours
  LocalUpdateBehaviour localUpdates;
  RemoteUpdateBehaviour remoteUpdates;
  RemoteQueryOptions remoteQuery;
  InitialisationBehaviour initialisation;

  String toString() {
    return "dontNeedFirestore: $_dontNeedFirestore, localUpdates: $localUpdates, remoteUpdates: $remoteUpdates, "
        "remoteQuery: $remoteQuery, initialisation: $initialisation";
  }
}

/// locally initiated update behaviour
enum LocalUpdateBehaviour {
  /// done only locally, not sent to Firestore
  LOCAL_ONLY,

  /// only sent to Firestore
  LOCAL_THRU_FIRESTORE,

  /// done locally and sent to Firestore
  LOCAL_MIRRORED,

  /// sent into a black hole
  LOCAL_IGNORED,
}

/// incoming updates from the firestore backing
enum RemoteUpdateBehaviour {
  /// reflected locally
  REMOTE_ACCEPTED,

  /// sent into a black hole (may be implemented by not establishing query)
  REMOTE_IGNORED,
}

/// access controls for Firestore
enum RemoteQueryOptions {
  /// filter the query established to match with the UID
  QUERY_FILTER_BY_UID,

  /// do not filter the query, return all records
  /// (this will only work if the Firestore rules permit such access)
  QUERY_NO_FILTER,

  /// establish a query that reurns/listens to a single document
  QUERY_SINGLE_DOCUMENT,
}

enum InitialisationBehaviour {
  /// just use the sembast store as it is
  INITIALISATION_NO_ACTION,

  /// clear the sembast store
  INITIALISATION_CLEAR,

  /// clear, and then fill the sembast store based on the configured query
  INITIALISATION_DOWNLOAD,
}
