import 'dart:io';
import 'package:flutter/material.dart';

/*
style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w500),
    )
 */

typedef OnTap = void Function();

class ListItemWidget extends StatelessWidget {
  final String imagePath;
  final Widget title, subtitle;
  final Widget trailing;
  final OnTap onTap;
  final Widget leading;

  ListItemWidget(
      {this.title,
      this.subtitle,
      this.leading,
      this.imagePath,
      this.trailing,
      this.onTap});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ListTile(
          leading: (this.leading == null)
              ? CircleAvatar(
                  backgroundImage: (imagePath == null)
                      ? AssetImage("assets/no_cover.png")
                      : FileImage(File(imagePath)),
                )
              : leading,
          onTap: onTap,
          title: title ?? Container(),
          subtitle: subtitle ?? Container(),
          trailing:
              trailing, //Text("${Utility.parseToMinutesSeconds(int.parse(song.duration))}",
        ),
        Container(
          height: 1.0,
          color: Colors.grey[300],
        ),
      ],
    );
  }
}
