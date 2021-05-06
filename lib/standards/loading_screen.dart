import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingWidget extends StatelessWidget {
  // loadingType = 0 -> means that return full page loading screen
  // loadingType = 1 -> means that return only the loading widget that can be displayed in a small portion of another widget
  int loadingType;
  LoadingWidget({this.loadingType});

  @override
  Widget build(BuildContext context) {
    return loadingType == 0 || loadingType == null
        ? const SpinKitDoubleBounce(
            color: Colors.white,
            size: 60,
          )
        : const SpinKitCircle(
            color: Colors.white,
            size: 20,
          );
  }
}
