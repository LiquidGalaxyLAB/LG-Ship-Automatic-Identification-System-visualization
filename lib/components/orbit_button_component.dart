import 'package:ais_visualizer/utils/constants/colors.dart';
import 'package:flutter/material.dart';

class OrbitButton extends StatefulWidget {
  final Future<bool> Function() startOrbit;
  final Future<void> Function() stopOrbit;
  final String startText;
  final String stopText;
  final ButtonStyle? style;

  const OrbitButton({
    Key? key,
    required this.startOrbit,
    required this.stopOrbit,
    required this.startText,
    required this.stopText,
    this.style,
  }) : super(key: key);

  @override
  _OrbitButtonState createState() => _OrbitButtonState();
}

class _OrbitButtonState extends State<OrbitButton> {
  bool _isOrbiting = false;

  void _toggleOrbit() async {
    if (_isOrbiting) {
      await widget.stopOrbit();
      setState(() {
        _isOrbiting = false;
      });
    } else {
      final success = await widget.startOrbit();
      if (success) {
        setState(() {
          _isOrbiting = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: _toggleOrbit,
      style: widget.style ??
          ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 0),
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
          Text(
            _isOrbiting ? widget.stopText : widget.startText,
            style: widget.style?.textStyle?.resolve({
                  WidgetState.pressed,
                }) ??
                Theme.of(context)
                    .textTheme
                    .headlineMedium!
                    .copyWith(color: AppColors.darkerGrey),
          ),
        ],
      ),
    );
  }
}
