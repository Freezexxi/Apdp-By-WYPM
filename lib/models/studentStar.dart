import 'package:cloud_firestore/cloud_firestore.dart';

final CollectionReference _studentFireStore =
    FirebaseFirestore.instance.collection("student");

// Student Class
class Student {
  final String _stuId;
  String firstName;
  String lastName;
  String stuEmail;
  String stuPhone;
  String stuAddress;
  String stuSection;

  Student(this._stuId, this.firstName, this.lastName, this.stuEmail,
      this.stuPhone, this.stuAddress, this.stuSection);

  // Method to calculate discount, overridden in subclasses
  num getDiscount() {
    return 0; // Default discount is 0
  }

  // Getter for StudentId
  String get studentId => _stuId;

  // Method to convert a Student object to a Map (for Firestore)
  Map<String, dynamic> toMap() {
    return {
      'stuId': _stuId,
      'firstName': firstName,
      'lastName': lastName,
      'stuEmail': stuEmail,
      'stuPhone': stuPhone,
      'stuAddress': stuAddress,
      'stuSection': stuSection,
    };
  }

  // Static method to create a Student object from Firestore data
  static Student fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Student(
      data['stuId'],
      data['firstName'],
      data['lastName'],
      data['stuEmail'],
      data['stuPhone'],
      data['stuAddress'],
      data['stuSection'],
    );
  }

  // Create student in Firestore
  Future<bool> registerStudent(Student student) async {
    bool status = false;

    try {
      await _studentFireStore
          .doc(_stuId)
          .set(toMap()); // Convert to map before adding
      status = true;
    } catch (error) {
      print("Error: $error");
      status = false;
    }

    return status;
  }

  // Read students from Firestore
  Future<List<Student>> readStudents() async {
    List<Student> list = [];

    try {
      // Fetch the snapshot from Firestore
      QuerySnapshot snapshot = await _studentFireStore.get();

      // Loop through each document in the snapshot
      snapshot.docs.forEach((doc) {
        // Convert each document to a Student object
        Student x = Student.fromDocument(doc);
        // Add the student to the list
        list.add(x);
      });
    } catch (error) {
      print('Error reading students: $error');
      list = []; // Return an empty list if there is an error
    }

    return list;
  }

  //Read student by stuID
  Future<Student?> readStudentById(String stuId) async {
    try {
      QuerySnapshot snapshot =
          await _studentFireStore.where('sId', isEqualTo: stuId).get();

      if (snapshot.docs.isNotEmpty) {
        // Convert the first document to a Student object
        return Student.fromDocument(snapshot.docs.first);
      } else {
        // No student found with the given ID
        return null;
      }
    } catch (error) {
      print("Error reading student by stuId: $error");
      return null;
    }
  }

  Future<bool> updateStudent() async {
    bool status = false;

    try {
      await _studentFireStore.doc(_stuId).update(toMap());
      status = true;
    } catch (error) {
      print("Error updating student: $error");
      status = false;
    }

    return status;
  }

  // Delete a student from Firestore
  Future<bool> deleteStudent() async {
    bool status = false;

    try {
      await _studentFireStore.doc(_stuId).delete();
      status = true;
    } catch (error) {
      print("Error deleting student: $error");
      status = false;
    }

    return status;
  }
}

class BronzeStudent extends Student {
  @override
  num getDiscount() => 5;

  BronzeStudent(super.stuId, super.firstName, super.lastName, super.stuEmail,
      super.stuPhone, super.stuAddress, super.stuSection);
}

class SilverStudent extends Student {
  @override
  num getDiscount() => 10;

  SilverStudent(super.stuId, super.firstName, super.lastName, super.stuEmail,
      super.stuPhone, super.stuAddress, super.stuSection);
}

class GoldStudent extends Student {
  @override
  num getDiscount() => 20;

  GoldStudent(super.stuId, super.firstName, super.lastName, super.stuEmail,
      super.stuPhone, super.stuAddress, super.stuSection);
}
