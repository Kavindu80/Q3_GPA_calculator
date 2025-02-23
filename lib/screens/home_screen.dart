import 'package:flutter/material.dart';
import '../widgets/animated_header.dart';
import '../widgets/course_input_field.dart';
import '../widgets/fade_in_animation.dart';
import 'gpa_screen.dart';
import '../utils/constants.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<TextEditingController> _courseNameControllers = [];
  final List<TextEditingController> _creditControllers = [];
  final List<String> _selectedGrades = [];

  void addCourseField() {
    setState(() {
      _courseNameControllers.add(TextEditingController());
      _creditControllers.add(TextEditingController());
      _selectedGrades.add('A+'); // Default grade
    });
  }

  @override
  void initState() {
    super.initState();
    // Initialize with 6 courses by default
    for (int i = 0; i < 6; i++) {
      _courseNameControllers.add(TextEditingController());
      _creditControllers.add(TextEditingController());
      _selectedGrades.add('A+');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'GPA Calculator',
          style: Theme.of(context).textTheme.headlineLarge,
        ),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.deepPurple, Colors.purple],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AnimatedHeader(),
            SizedBox(height: 20),
            ...List.generate(_courseNameControllers.length, (index) {
              return FadeInAnimation(
                delay: index * 200,
                child: CourseInputField(
                  index: index + 1,
                  courseNameController: _courseNameControllers[index],
                  creditController: _creditControllers[index],
                  selectedGrade: _selectedGrades[index],
                  onGradeChanged: (String? value) {
                    setState(() {
                      _selectedGrades[index] = value ?? 'A+';
                    });
                  },
                  onDelete: () {
                    if (_courseNameControllers.length > 1) {
                      setState(() {
                        _courseNameControllers.removeAt(index);
                        _creditControllers.removeAt(index);
                        _selectedGrades.removeAt(index);
                      });
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('At least one course is required')),
                      );
                    }
                  },
                ),
              );
            }),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton.icon(
                onPressed: addCourseField,
                icon: Icon(Icons.add_circle_outline, size: 28, color: const Color.fromARGB(255, 255, 255, 255)),
                label: Text(
                  'Add Another Course',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: const Color.fromARGB(255, 255, 255, 255)),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 5,
                  shadowColor: Colors.purple.withOpacity(0.5),
                ),
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  calculateGPA(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 5,
                  shadowColor: Colors.purple.withOpacity(0.5),
                ),
                child: Text(
                  'Calculate GPA',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void calculateGPA(BuildContext context) {
    double totalGradePoints = 0;
    double totalCredits = 0;

    for (int i = 0; i < _courseNameControllers.length; i++) {
      int credits = int.tryParse(_creditControllers[i].text) ?? 0;
      double gradePoint = gradePoints[_selectedGrades[i]] ?? 0.0;

      totalCredits += credits;
      totalGradePoints += credits * gradePoint;
    }

    double gpa = totalCredits > 0 ? totalGradePoints / totalCredits : 0.0;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GPAScreen(gpa: gpa),
      ),
    );
  }
}