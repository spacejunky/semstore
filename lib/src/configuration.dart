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
    this.initialisation=InitialisationBehaviour.INITIALISATION_NO_ACTION,
    this.localUpdates=LocalUpdateBehaviour.LOCAL_ONLY,
    this.remoteQuery=RemoteQueryOptions.QUERY_FILTER_BY_UID,
    this.remoteUpdates=RemoteUpdateBehaviour.REMOTE_IGNORED,
  })  : assert(firestoreCollectionName != ""),
        assert(firestoreCollectionName != null);

  /// the associated firestore collection
  final String firestoreCollectionName;

  /// store behaviours
  LocalUpdateBehaviour localUpdates;
  RemoteUpdateBehaviour remoteUpdates;
  RemoteQueryOptions remoteQuery;
  InitialisationBehaviour initialisation;
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
  /// just use the senbast store as it is
  INITIALISATION_NO_ACTION,

  /// clear the sembast store
  INITIALISATION_CLEAR,

  /// clear, and then fill the sembast store based on the configured query
  INITIALISATION_DOWNLOAD,

  /// leave the sembast contents as is and retrieve from Firestore by query
  // TODO: This may be the same as INITIALISATION_NO_ACTION
  INITIALISATION_MERGE,
}
