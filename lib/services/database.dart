// why create abstract interface?
// in future we might decide that we want to swap database
// it's good to have common API that we can define
// inside an abstract class

import 'package:time_tracker/services/api_path.dart';
import 'package:time_tracker/services/firestore_services.dart';

import '../app/home/models/job.dart';

abstract class Database {
  // * CREATE, UPDATE, DELETE

  // Create a new job / edit an existing job
  // Future<void> setJob(Job job);
  Future<void> setJob(Job job);

  // Delete and existing job
  Future<void> deleteJob(Job job);

  // Create a new entry / edit an existing entry
  //// Future<void> setEntry(Entry entry);

  // Delete an existing entry
  //// Future<void> deleteEntry(Entry entry);

  // * READ

  // List all my jobs
  Stream<List<Job>> jobsStream(); // [286]

  // List all entries for a given job
  //// Stream<List<Entry>> entriesStream({Job job});
}

// [302] - DateTime to use as unique Job ID
String documentIdFromCurrentDate() => DateTime.now().toIso8601String();

class FirestoreDatabase implements Database {
  // ignore: unnecessary_null_comparison
  FirestoreDatabase({required this.uid}) : assert(uid != null);
  final String uid;

  // [293]
  // gives an error since the constructor is private
  // final _service = FirestoreService();
  final _service = FirestoreService.instance;

  @override
  Future<void> setJob(Job job) => _service.setData(
        path: APIPath.job(uid, job.id),
        data: job.toMap(),
      );

  @override
  Stream<List<Job>> jobsStream() => _service.collectionStream(
        path: APIPath.jobs(uid),
        builder: (data, documentId) => Job.fromMap(data, documentId),
      );

  // [318]
  @override
  Future<void> deleteJob(Job job) =>
      _service.deleteData(path: APIPath.job(uid, job.id));
}
