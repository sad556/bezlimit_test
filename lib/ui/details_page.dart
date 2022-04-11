import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DetailsPage extends StatefulWidget {
  final int maxLength;
  final int currentIndex;

  const DetailsPage(
      {Key? key, required this.maxLength, required this.currentIndex})
      : super(key: key);

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.currentIndex.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            maxLength: widget.maxLength.toString().length,
            controller: _controller,
            keyboardType: TextInputType.number,
            inputFormatters: [
              CustomFormatter(widget.maxLength),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: ElevatedButton(
        child: const Text('Save'),
        onPressed: () {
          int? res = int.tryParse(_controller.text);
          Navigator.of(context).pop(res != null ? res-1: null);
        },
      ),
    );
  }
}

class CustomFormatter extends TextInputFormatter {
  final int max;

  CustomFormatter(this.max);

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) return newValue;
    var v = int.tryParse(newValue.text);
    if (v == null || v > max) return oldValue;
    return newValue.copyWith(text: v.toString());
  }

}