import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';

class LoadingIndicatorWidget extends StatelessWidget {
  final int type;
  const LoadingIndicatorWidget({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: 50,
        width: 50,
        child: LoadingIndicator(
          indicatorType: (type == 1)
              ? Indicator.ballSpinFadeLoader
              : Indicator.ballClipRotatePulse,
          colors: [Theme.of(context).colorScheme.primary],
          backgroundColor: Colors.transparent,
        ),
      ),
    );
  }
}
