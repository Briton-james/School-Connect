import 'package:flutter/material.dart';

class Subject {
  final String name;
  bool isSelected;

  Subject(this.name, {this.isSelected = false});
}

class SubjectSelection extends StatefulWidget {
  final SelectedSubjectsCallback? onSelectedSubjectsChanged;

  const SubjectSelection({Key? key, this.onSelectedSubjectsChanged})
      : super(key: key);

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
        onPressed: () {
          setState(() => subject.isSelected = !subject.isSelected);
          widget.onSelectedSubjectsChanged?.call(getSelectedSubjects());
        },
        style: ElevatedButton.styleFrom(
          backgroundColor:
              subject.isSelected ? const Color(0xffA0826A) : Colors.white,
        ),
        child: Text(subject.name),
      ),
    );
  }

  List<Subject> getSelectedSubjects() {
    return subjects.where((subject) => subject.isSelected).toList();
  }
}

typedef SelectedSubjectsCallback = void Function(
    List<Subject> selectedSubjects);
