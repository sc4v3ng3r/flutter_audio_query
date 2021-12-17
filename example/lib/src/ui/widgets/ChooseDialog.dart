import 'package:flutter/material.dart';

class ChooseDialog extends StatefulWidget {
  final String title;
  final List<String> options;
  final _callback;
  final int indexSelected;

  ChooseDialog(
      {required String title,
      required List<String> options,
      ValueChanged<int>? onChange,
      int initialSelectedIndex = 0})
      : title = title,
        options = options,
        indexSelected = initialSelectedIndex,
        _callback = onChange;

  @override
  _ChooseDialogState createState() => _ChooseDialogState();
}

class _ChooseDialogState extends State<ChooseDialog> {
  late int selectedIndex;

  @override
  void initState() {
    super.initState();
    selectedIndex = widget.indexSelected;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: ListView.builder(
          shrinkWrap: true,
          itemCount: widget.options.length,
          itemBuilder: (context, index) {
            return RadioListTile<int>(
                title: Text(widget.options[index]),
                value: index,
                groupValue: selectedIndex,
                onChanged: (value) {
                  setState(() {
                    selectedIndex = value as int;
                  });

                  if (widget._callback != null) widget._callback(selectedIndex);
                });
          }),
    );
  }
}
