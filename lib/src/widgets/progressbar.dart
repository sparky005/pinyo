import 'package:flutter/material.dart';

class ProgressBar extends StatelessWidget {
  final Stream<bool> _isLoading;
  ProgressBar(this._isLoading);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _isLoading,
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data) {
          return LinearProgressIndicator();
        }
        else {
          return Container();
        }
      }
    );
  }
}
