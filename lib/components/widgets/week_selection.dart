import 'package:flutter/material.dart';

class NumberOfWeeksSelector extends StatefulWidget {
  final ValueChanged<int>? onChanged; // Define the onChanged callback

  const NumberOfWeeksSelector({Key? key, this.onChanged}) : super(key: key);

  @override
  _NumberOfWeeksSelectorState createState() => _NumberOfWeeksSelectorState();
}

class _NumberOfWeeksSelectorState extends State<NumberOfWeeksSelector> {
  int _weeks = 1;
  late TextEditingController _textEditingController;

  @override
  void initState() {
    super.initState();
    _textEditingController = TextEditingController(text: '$_weeks');
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  void _incrementWeeks() {
    setState(() {
      _weeks++;
      _textEditingController.text = '$_weeks';
      widget.onChanged?.call(_weeks); // Call the onChanged callback
    });
  }

  void _decrementWeeks() {
    setState(() {
      if (_weeks > 1) {
        _weeks--;
        _textEditingController.text = '$_weeks';
        widget.onChanged?.call(_weeks); // Call the onChanged callback
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'Duration in weeks:',
          style: TextStyle(
              fontWeight: FontWeight.bold, color: Colors.white, fontSize: 18.0),
        ),
        const SizedBox(
          width: 10.0,
        ),
        IconButton(
          icon: const Icon(
            Icons.remove,
            color: Color(0xffA0826A),
          ),
          onPressed: _decrementWeeks,
        ),
        SizedBox(
          width: 50,
          height: 50,
          child: TextFormField(
            controller: _textEditingController,
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            onChanged: (value) {
              setState(() {
                if (value.isNotEmpty) {
                  _weeks = int.parse(value);
                  widget.onChanged?.call(_weeks); // Call the onChanged callback
                }
              });
            },
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintStyle:
                  TextStyle(color: Colors.white), // Set text color to white
              counterStyle: TextStyle(
                  color: Colors.white), // Set counter text color to white
              suffixStyle: TextStyle(
                  color: Colors.white), // Set suffix text color to white
            ),
          ),
        ),
        IconButton(
          icon: const Icon(
            Icons.add,
            color: Color(0xffA0826A),
          ),
          onPressed: _incrementWeeks,
        ),
      ],
    );
  }
}
