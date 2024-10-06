import 'package:cloud_firestore/cloud_firestore.dart';

final CollectionReference _enrollmentStarFireStore =
    FirebaseFirestore.instance.collection('enrollments');

class Enrollment {
  final String _enrollID;
  DateTime enrolledDate;
  num discountRate;
  double totalFee;

  String stuID; // ID of the student (relation)
  String courseID; // ID of the course (relation)

  Enrollment(this._enrollID, this.totalFee, this.enrolledDate,
      this.discountRate, this.stuID, this.courseID);

  // Getter for private enrollId
  String get enrollId => _enrollID;

  //convert object to a Map
  Map<String, dynamic> toMap() {
    return {
      'enId': _enrollID,
      'enrolledT': enrolledDate,
      'discount': discountRate,
      'totalFee': totalFee,
      'studentId': stuID,
      'courseId': courseID
    };
  }

  //method to create enrollment object from doc
  static Enrollment fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return Enrollment(
      data['enrollID'],
      data['enrolledDate'],
      data['discountRate'],
      data['totalFee'],
      data['stuID'],
      data['courseID'],
    );
  }

  // Create (Register) an enrollment in Firestore
  Future<bool> registerStudent() async {
    bool status = false;

    try {
      await _enrollmentStarFireStore.doc(_enrollID).set(toMap());
      status = true;
    } catch (error) {
      print("Error creating enrollment: $error");
      status = false;
    }

    return status;
  }

  // Read (Get) enrollments from Firestore
  static Future<List<Enrollment>> getEnrollments() async {
    List<Enrollment> list = [];

    try {
      QuerySnapshot snapshot = await _enrollmentStarFireStore.get();
      snapshot.docs.forEach((doc) {
        Enrollment x = fromDocument(doc);
        list.add(x);
      });
    } catch (error) {
      print('Error reading enrollments: $error');
      list = [];
    }

    return list;
  }

  // Read enrollment by Id
  static Future<Enrollment?> readStudentById(String enrollID) async {
    try {
      QuerySnapshot snapshot = await _enrollmentStarFireStore
          .where('enrollID', isEqualTo: enrollID)
          .get();

      if (snapshot.docs.isNotEmpty) {
        return fromDocument(snapshot.docs.first);
      } else {
        return null;
      }
    } catch (error) {
      print("Error reading enrollment by id: $error");
      return null;
    }
  }

  // Update a enrollment in Firestore
  Future<bool> updateStudent() async {
    bool status = false;

    try {
      await _enrollmentStarFireStore.doc(_enrollID).update(toMap());
      status = true;
    } catch (error) {
      print("Error updating enrollment: $error");
      status = false;
    }

    return status;
  }

  // Delete a enrollment from Firestore
  Future<bool> deleteStudent() async {
    bool status = false;

    try {
      await _enrollmentStarFireStore.doc(_enrollID).delete();
      status = true;
    } catch (error) {
      print("Error deleting enrollment: $error");
      status = false;
    }

    return status;
  }
}
