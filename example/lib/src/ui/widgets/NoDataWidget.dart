import 'package:flutter/material.dart';

class NoDataWidget extends StatelessWidget {
  final String? title;

  NoDataWidget({this.title});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          IconButton(
            iconSize: 120,
            onPressed: null,
            icon: Icon(Icons.not_interested),
          ),
          Text(
            title!,
            maxLines: 1,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16.0,
            ),
          ),
        ],
      ),
    );
  }
}
