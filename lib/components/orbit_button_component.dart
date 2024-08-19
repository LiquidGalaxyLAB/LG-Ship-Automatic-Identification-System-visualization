import 'dart:async';

import 'package:ais_visualizer/utils/constants/colors.dart';
import 'package:flutter/material.dart';

class OrbitButton extends StatefulWidget {
  final Future<bool> Function() startOrbit;
  final Future<void> Function() stopOrbit;
  final String startText;
  final String stopText;
  final ButtonStyle? style;
  final int timeInMilliSeconds;

  const OrbitButton({
    Key? key,
    required this.startOrbit,
    required this.stopOrbit,
    required this.startText,
    required this.stopText,
    this.style,
    required this.timeInMilliSeconds,
  }) : super(key: key);

  @override
  _OrbitButtonState createState() => _OrbitButtonState();
}

class _OrbitButtonState extends State<OrbitButton> {
  bool _isOrbiting = false;
  Timer? _timer;
  Timer? _progressTimer;
  double _progress = 0.0;

  void _toggleOrbit() async {
    if (_isOrbiting) {
      await widget.stopOrbit();
      _timer?.cancel(); // Cancel the main timer
      _progressTimer?.cancel(); // Cancel the progress timer
      setState(() {
        _isOrbiting = false;
        _progress = 0.0; // Reset progress when stopped
      });
    } else {
      final success = await widget.startOrbit();
      if (success) {
        setState(() {
          _isOrbiting = true;
        });

        // Start the main timer to automatically switch back after the specified time
        _timer =
            Timer(Duration(milliseconds: widget.timeInMilliSeconds), () async {
          if (_isOrbiting) {
            await widget.stopOrbit();
            setState(() {
              _isOrbiting = false;
              _progress = 0.0; // Reset progress when stopped
            });
          }
        });

        // Start the progress indicator timer
        _progressTimer = Timer.periodic(Duration(milliseconds: 50), (timer) {
          if (!_isOrbiting) {
            timer.cancel();
            return;
          }
          setState(() {
            _progress += 50 / widget.timeInMilliSeconds;
            if (_progress >= 1.0) {
              _progress = 1.0;
              timer.cancel(); // Stop the timer when progress is complete
            }
          });
        });
      }
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _progressTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 10.0),
          width: 270.0,
          child: ElevatedButton(
            onPressed: _toggleOrbit,
            style: widget.style ??
                ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30.0, vertical: 0),
                  textStyle: Theme.of(context).textTheme.bodySmall,
                  backgroundColor: AppColors.textContainerBackground,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(width: 8.0),
                Flexible(
                  child: Text(
                    _isOrbiting ? widget.stopText : widget.startText,
                    style: widget.style?.textStyle
                            ?.resolve({WidgetState.pressed}) ??
                        Theme.of(context)
                            .textTheme
                            .headlineMedium!
                            .copyWith(color: AppColors.darkerGrey),
                    softWrap: true,
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
        if (_isOrbiting)
          Container(
            margin: const EdgeInsets.symmetric(vertical: 10.0),
            width: 270.0,
            height: 5.0,
            decoration: BoxDecoration(
              color: Colors.grey[500],
              borderRadius: BorderRadius.circular(5.0),
            ),
            child: LinearProgressIndicator(
              value: _progress,
              backgroundColor: Colors.transparent,
              color: const Color.fromARGB(255, 17, 40, 95),
            ),
          ),
      ],
    );
  }
}
