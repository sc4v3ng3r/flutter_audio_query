import 'dart:io';
import 'package:flutter/material.dart';

class ItemHolderWidget<T> extends StatelessWidget {

  final T item;
  final _callback;
  final Widget title, subtitle, infoText;
  final String imagePath;
  final double width,height;

  ItemHolderWidget( { this.item, this.imagePath, this.title = const Text("Title"),
    this.subtitle = const Text("Subtitle"), this.infoText = const Text("Info text"),
    this.width = 150, this.height = 250, void onItemTap(final T info)} ) :
    _callback = onItemTap;

  @override
  Widget build(BuildContext context) {

    final mainContainer = Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: (imagePath == null) ? AssetImage("assets/no_cover.png")
              : FileImage( File( imagePath )),
          fit: BoxFit.cover,
          alignment: AlignmentDirectional.center,
        ),
    ),

      child: Stack(

        alignment: AlignmentDirectional.bottomCenter,
        children: <Widget>[


          Container(
            color: Color.fromRGBO(0xff, 0xff, 0xff, 0.5),
            padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Flexible(child: title),
                Flexible(child: subtitle),
                Flexible(child: infoText),
              ],
            ),
          ),

          Positioned.fill(
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: (_callback != null) ? () => _callback(item) : null,
                ),
              ),
          ),
        ],
      ),
    );

    return Card(
      elevation: 4.0,
      child: mainContainer,
    );
  }
}
