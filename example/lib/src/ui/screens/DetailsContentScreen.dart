import 'dart:io';
import 'package:flutter/material.dart';

class DetailsContentScreen extends StatelessWidget {
  final Widget bodyContent;
  final String? appBarBackgroundImage;
  final String? appBarTitle;

  DetailsContentScreen(
      {required this.bodyContent,
      this.appBarBackgroundImage,
      this.appBarTitle});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              expandedHeight: 200.0,
              floating: false,
              pinned: true,
              snap: false,
              flexibleSpace: FlexibleSpaceBar(
                centerTitle: true,
                title: Text(
                  appBarTitle!,
                  maxLines: 1,
                  softWrap: true,
                  overflow: TextOverflow.fade,
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                background: (appBarBackgroundImage == null)
                    ? Image.asset(
                        "assets/no_cover.png",
                        fit: BoxFit.cover,
                      )
                    : Image.file(
                        File(appBarBackgroundImage!),
                        fit: BoxFit.cover,
                      ),
              ),
            ),
          ];
        },
        body: this.bodyContent,
      ),
    );
  }
}
