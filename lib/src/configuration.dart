import 'package:meta/meta.dart';

/// Configuration options for the combined datastore
class Configuration {
  Configuration(
      {this.useFirestore = true,
      this.sembastPersistent = true,
      @required this.storeConfigurations,})
      : assert(storeConfigurations.isNotEmpty  || !useFirestore);

  /// whether or not to activate cloud_firestors
  final bool useFirestore;

  /// whether the sembast database should be persistent or in-memory only
  final bool sembastPersistent;

  /// [StoreConfiguration] data for each store used
  final Map<String,StoreConfiguration> storeConfigurations;
}

/// Firestore backing configuration information for a sembaststore
class StoreConfiguration {
  StoreConfiguration({@required this.firestoreCollectionName})
      : assert(firestoreCollectionName != "");

  // the associated firestore collection
  final String firestoreCollectionName;
}
