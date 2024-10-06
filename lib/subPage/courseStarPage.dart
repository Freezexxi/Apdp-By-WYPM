import 'package:flutter/material.dart';
import 'package:apdpbywypm/constants.dart';
import 'package:apdpbywypm/models/courseStar.dart';
import 'package:apdpbywypm/utils/hoverable_containerStar.dart';
import 'package:apdpbywypm/utils/custom_text_fieldStar.dart';
import 'package:apdpbywypm/models/studentStar.dart';

class CourseStarPage extends StatefulWidget {
  const CourseStarPage({super.key});

  @override
  State<CourseStarPage> createState() => _CoursesPageState();
}

class _CoursesPageState extends State<CourseStarPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => {},
          icon: const Icon(Icons.menu_rounded),
        ),
        centerTitle: true,
        title: const Text("Manage Courses"),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              onPressed: () => {},
              icon: const Icon(Icons.logout_rounded),
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(
                  Colors.redAccent.withOpacity(0.2),
                ),
                shape: WidgetStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12), // Rounded border
                  ),
                ),
                side: WidgetStateProperty.all(
                  const BorderSide(
                    color: Colors.redAccent, // Border color redAccent
                    width: 1, // Border width
                  ),
                ),
              ),
            ),
          ),
        ],
        backgroundColor: Colors.tealAccent,
      ),
      body: const SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              _CourseRegisterForm(),
              Padding(
                padding: EdgeInsets.all(8),
                child: _CourseList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CourseRegisterForm extends StatefulWidget {
  const _CourseRegisterForm();

  @override
  State<_CourseRegisterForm> createState() => _CourseRegisterFormState();
}

class _CourseRegisterFormState extends State<_CourseRegisterForm> {
  final TextEditingController _courseName = TextEditingController();
  final TextEditingController _courseFee = TextEditingController();
  final TextEditingController _courseAbout = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  Future<void> createCourse() async {
    if (_formKey.currentState!.validate()) {
      var uniqueId = uuid.v1();
      CourseStar s1 = CourseStar(uniqueId, _courseName.text,
          double.parse(_courseFee.text), _courseAbout.text);

      bool status = await s1.createCourse();
      SnackBar snackBar;
      if (status) {
        snackBar = const SnackBar(
          content: Text("Created a course!"),
        );
      } else {
        snackBar = const SnackBar(
          content: Text("Creating course failed!"),
        );
      }
      setState(() {
        _courseName.text = '';
        _courseFee.text = '';
        _courseAbout.text = '';
      });
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  @override
  void dispose() {
    _courseName.dispose();
    _courseFee.dispose();
    _courseAbout.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 40),
        child: Form(
          // Wrap the form elements in a Form widget
          key: _formKey,
          child: Column(
            children: [
              const Text(
                'Create Course Here!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 21,
                ),
              ),
              const SizedBox(height: 30),
              Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      controller: _courseName,
                      hintText: 'Course Name',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the course name';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: CustomTextField(
                      controller: _courseFee,
                      hintText: 'Course Fee',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a valid fee';
                        }

                        // Check if the value is a valid number
                        final parsedValue = double.tryParse(value);
                        if (parsedValue == null || parsedValue <= 0) {
                          return 'Please enter a valid positive number';
                        }

                        return null; // Return null if validation is successful
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: CustomTextField(
                  controller: _courseAbout,
                  hintText: 'About Course',
                  minLines: 2,
                  maxLines: 4,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter breif about course';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 30),
              SizedBox(
                height: 50, // Set your desired height
                child: ElevatedButton(
                  onPressed: createCourse,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.tealAccent,
                  ),
                  child: const Text(
                    'Create Course',
                    style: TextStyle(fontSize: 20),
                  ), // Button label
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CourseList extends StatefulWidget {
  const _CourseList();

  @override
  State<_CourseList> createState() => _CourseListState();
}

class _CourseListState extends State<_CourseList> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        minHeight: 200,
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                // Name Search Field
                Expanded(
                  child: TextField(
                    decoration: const InputDecoration(
                      labelText: 'Search by Name',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 300,
            child: StreamBuilder<List<CourseStar>>(
              stream: CourseStar.getCourses(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No courses found.'));
                }

                final courses = snapshot.data!.where((course) {
                  final matchesSearch = '${course.courseName}'
                      .toLowerCase()
                      .contains(_searchQuery.toLowerCase());
                  return matchesSearch;
                }).toList();

                if (courses.isEmpty) {
                  return const Center(
                      child: Text('No courses match your criteria.'));
                }

                return ListView.builder(
                  itemCount: courses.length,
                  itemBuilder: (BuildContext context, int index) {
                    final course = courses[index];
                    return _CourseHoverableContainer(course: course);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _CourseHoverableContainer extends StatelessWidget {
  final CourseStar course;

  const _CourseHoverableContainer({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) {
        // Optionally implement hover effects
      },
      onExit: (_) {
        // Optionally remove hover effects
      },
      child: Card(
        elevation: 4,
        child: ListTile(
          title: Text(
            course.courseName,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            course.courseAbout,
            style: const TextStyle(fontSize: 14),
          ),
          trailing: Text(
            '\$${course.courseFee.toStringAsFixed(2)}',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          onTap: () {
            // Handle tap if needed
          },
        ),
      ),
    );
  }
}
