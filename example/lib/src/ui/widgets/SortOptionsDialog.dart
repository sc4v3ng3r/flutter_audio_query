
import 'package:flutter/material.dart';

class SortOptionsDialog extends StatefulWidget {
  final String title;
  final List<String> options;
  final _callback;
  final int indexSelected;

  SortOptionsDialog({String title, List<String> options, void onChange(int index), int initialSelectedIndex = 0} ) :
      title = title,
      options = options,
      indexSelected = initialSelectedIndex,
      _callback = onChange;

  @override
  _SortOptionsDialogState createState() => _SortOptionsDialogState();
}

class _SortOptionsDialogState extends State<SortOptionsDialog> {
  int selectedIndex;

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
          itemBuilder: (context, index){
            return
              RadioListTile(
                  title: Text(widget.options[index]),
                  value: index,
                  groupValue: selectedIndex,
                  onChanged: (value){
                    setState(() {
                      selectedIndex = value;
                    });

                    if (widget._callback != null)
                      widget._callback(selectedIndex);
                  }
              );
          }
      ),
    );
  }
}
