import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingSpinner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.lightBlue[100],
      child: Center(
        child: SpinKitFadingCircle(
          color: Colors.blue,
          size: 50.0,
        ),
      ),
    );
  }
}
