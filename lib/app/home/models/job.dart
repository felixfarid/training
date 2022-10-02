class Job {
  Job({required this.id, required this.name, required this.ratePerHour});

  final String name;
  final int ratePerHour;
  final String id;

  // [280]
  // Method that converts objects of type Job into
  // a map of Key Value pairs.
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'ratePerHour': ratePerHour,
    };
  }

  // [291]
  // to be sure that any data conversions are done inside our model
  // * factory - when implementing a constructor that doesn't always
  // * create a new instance of its class.
  //
  // exactly what we are doing here. If the data is null then we will return
  // null rather than a "Job" object
  factory Job.fromMap(Map<String, dynamic> data, String documentId) {
    if (data == null) {
      return null!;
    }
    final String name = data['name'];
    final int ratePerHour = data['ratePerHour'];
    return Job(
      name: name,
      ratePerHour: ratePerHour,
      id: documentId,
    );
  }
}
