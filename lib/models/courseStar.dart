import 'package:cloud_firestore/cloud_firestore.dart';

final CollectionReference _courseFireStore =
    FirebaseFirestore.instance.collection("courses");

class CourseStar {
  final String _courseID;
  String courseName;
  double courseFee;
  String courseAbout;

  CourseStar(this._courseID, this.courseName, this.courseFee, this.courseAbout);

  String get courseStarID => _courseID;

  Map<String, dynamic> toMap() {
    return {
      'courseID': _courseID,
      'courseName': courseName,
      'fees': courseFee,
      'courseAbout': courseAbout
    };
  }

  // Static method to create a Course object from Firestore data
  static CourseStar fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return CourseStar(data['courseID'], data['courseName'], data['fees'],
        data['courseAbout']);
  }

  // Create a course in Firestore
  Future<bool> createCourse() async {
    bool status = false;

    try {
      await _courseFireStore.doc(_courseID).set(toMap());
      status = true;
    } catch (error) {
      print("Error registering course: $error");
      status = false;
    }

    return status;
  }

  // Read courses from Firestore
  static Future<List<CourseStar>> readStudents() async {
    List<CourseStar> list = [];

    try {
      QuerySnapshot snapshot = await _courseFireStore.get();
      snapshot.docs.forEach((doc) {
        CourseStar x = fromDocument(doc);
        list.add(x);
      });
    } catch (error) {
      print('Error reading courses: $error');
      list = [];
    }

    return list;
  }

  // Read course by Id
  static Future<CourseStar?> readCourseById(String courseID) async {
    try {
      QuerySnapshot snapshot =
          await _courseFireStore.where('courseID', isEqualTo: courseID).get();

      if (snapshot.docs.isNotEmpty) {
        return fromDocument(snapshot.docs.first);
      } else {
        return null;
      }
    } catch (error) {
      print("Error reading course by id: $error");
      return null;
    }
  }

  // Update course in Firestore
  Future<bool> updateCourse() async {
    bool status = false;

    try {
      await _courseFireStore.doc(_courseID).update(toMap());
      status = true;
    } catch (error) {
      print("Error updating course: $error");
      status = false;
    }

    return status;
  }

  // Delete course from Firestore
  Future<bool> deleteCourse() async {
    bool status = false;

    try {
      await _courseFireStore.doc(_courseID).delete();
      status = true;
    } catch (error) {
      print("Error deleting student: $error");
      status = false;
    }

    return status;
  }
}
