import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:apdpbywypm/models/studentStar.dart';
import 'package:apdpbywypm/constants.dart';

class StudentStarPage extends StatelessWidget {
  const StudentStarPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: () => {}, icon: Icon(Icons.menu_sharp)),
        centerTitle: true,
        title: const Text("Star Students Managemet"),
        actions: [
          IconButton(onPressed: () => {}, icon: Icon(Icons.logout_sharp))
        ],
        backgroundColor: const Color.fromARGB(255, 255, 241, 118),
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 650,
              color: Colors.grey,
            ),
            Container(
              width: double.infinity,
              height: 950,
              color: Colors.green,
            )
          ],
        ),
      )),
    );
  }
}

class _StudentStarReg extends StatefulWidget {
  const _StudentStarReg({super.key});

  @override
  State<_StudentStarReg> createState() => __StudentStarRegState();
}

class __StudentStarRegState extends State<_StudentStarReg> {
  final TextEditingController _stuFirstNameC = TextEditingController();
  final TextEditingController _stuLastNameC = TextEditingController();
  final TextEditingController _stuPhoneC = TextEditingController();
  final TextEditingController _stuEmailC = TextEditingController();
  final TextEditingController _stuAddressC = TextEditingController();
  String? _sectionValue;
  final _formKey = GlobalKey<FormState>();

  Future<void> registerStudentStar() async {
    if (_formKey.currentState!.validate()) {
      var uniqueId = uuid.v1();
      Student s1 = Student(
        uniqueId,
        _stuFirstNameC.text,
        _stuLastNameC.text,
        _stuPhoneC.text,
        _stuEmailC.text,
        _stuAddressC.text,
        _sectionValue!,
      );

      bool status = await s1.registerStudentStar();
      SnackBar snackBar;
      if (status) {
        snackBar = const SnackBar(
          content: Text("Registered Student Successfully!"),
        );
      } else {
        snackBar = const SnackBar(
          content: Text("Registeration Failed!"),
        );
      }
      setState(() {
        _stuFirstNameC.text = '';
        _stuLastNameC.text = '';
        _stuPhoneC.text = '';
        _stuEmailC.text = '';
        _stuAddressC.text = '';
        _sectionValue = null;
      });
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  @override
  void dispose() {
    _stuFirstNameC.dispose();
    _stuLastNameC.dispose();
    _stuPhoneC.dispose();
    _stuEmailC.dispose();
    _stuAddressC.dispose();
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
                'Register Student Here!',
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
                      controller: _stuFirstNameC,
                      hintText: 'Student First Name',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter student first name';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: CustomTextField(
                      controller: _stuLastNameC,
                      hintText: 'Student Last Name',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter student last name';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      controller: _stuPhoneC,
                      hintText: 'Student Phone Number',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter student phone number';
                        } else if (value.length < 11) {
                          return 'Phone number must be at least 11 digits';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: CustomTextField(
                      controller: _stuEmailC,
                      hintText: 'Student Email',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter student email';
                        } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                            .hasMatch(value)) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: CustomTextField(
                  controller: _stuAddressC,
                  hintText: 'Student Address',
                  minLines: 2,
                  maxLines: 4,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter student address';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 30),
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                      hint: const Text('Select Desire Section'),
                      items: ['Morning', 'Afternoon', 'Evening']
                          .map((String section) {
                        return DropdownMenuItem<String>(
                          value: section,
                          child: Text(section),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _sectionValue = newValue;
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: SizedBox(
                      height: 50,
                      child: ElevatedButton(
                        onPressed: registerStudentStar,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.tealAccent,
                        ),
                        child: const Text(
                          'Save',
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
