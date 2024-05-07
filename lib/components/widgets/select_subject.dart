import 'package:flutter/material.dart';

class Subject {
  final String name;
  bool isSelected;

  Subject(this.name, {this.isSelected = false});
}

class SubjectSelection extends StatefulWidget {
  const SubjectSelection({super.key});

  @override
  _SubjectSelectionState createState() => _SubjectSelectionState();
}

class _SubjectSelectionState extends State<SubjectSelection> {
  List<Subject> subjects = [
    Subject('Math'),
    Subject('Physics'),
    Subject('History'),
    Subject('English'),
    Subject('Geography'),
    Subject('Kiswahili'),
    Subject('Divinity'),
    Subject('Civics'),
    Subject('Chemistry'),
    Subject('Biology'),
    Subject('Commerce'),
    Subject('B/Keeping'),
  ];

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: subjects.map(buildSubjectButton).toList(),
    );
  }

  Widget buildSubjectButton(Subject subject) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: ElevatedButton(
        onPressed: () =>
            setState(() => subject.isSelected = !subject.isSelected),
        style: ElevatedButton.styleFrom(
          backgroundColor: subject.isSelected ? Colors.orange : Colors.white,
        ),
        child: Text(subject.name),
      ),
    );
  }
}
