import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoadingWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Center(
            child: Transform.scale(
                scale: 0.5,
                child: CircularProgressIndicator(
                    color: Theme.of(context).buttonColor))));
  }
}
