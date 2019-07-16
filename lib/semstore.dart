/// # What is semstore?
///
/// semstore implements a (flutter) application data storage which combines Sembast and cloud_firestore.
///
/// The sembast component provides local storage for the app needs.
///
/// The cloud_firestore component is used to provide cloud access for example for long term security, for data sharing with other users
/// or for reception of remote updates.
///
/// The app API is broadly speaking similar to the sembast 'store' API ( a store can also be seen as a 'collection')
///
/// There is a further Configuration API for modifying run-time behaviour..
///
/// # What can be stored?
///
/// Data which can be stored, as might be expected in a NoSQL context must respect the following:
///
/// * record *keys* must be of type String
/// * records themselves must be of type Map<String,dynamic>
///
/// The values of each map key are subject to the same constraints as in sembast itself.
///
/// # Why do this?
///
/// The motivations for doing this apparently perverse thing are:
///
/// * as of now (July 2019) the dart cloud_firestore package does not implement disableNetwork (or indeed enableNetwork)
///   functionality. This would be useful to help control the load (or more importantly the costs!) on
///   the firestore database in situations where an occasional refresh, initiated by the app, is good enough.
///
/// * it is potentially useful to be able to activate or de-activate cloud storage at run-time (for 'pro' version apps, for example)
///
///

library semstore;

/// the [Database] class is the root of all access to the storage
export "src/database.dart";

/// the Configuration information for semstore
export "src/configuration.dart";

