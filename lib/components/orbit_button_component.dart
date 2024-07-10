import 'package:ais_visualizer/utils/constants/colors.dart';
import 'package:flutter/material.dart';

class OrbitButton extends StatefulWidget {
  final VoidCallback startOrbit;
  final VoidCallback stopOrbit;
  final String startText;
  final String stopText;

  const OrbitButton({
    Key? key,
    required this.startOrbit,
    required this.stopOrbit,
    required this.startText,
    required this.stopText,
  }) : super(key: key);

  @override
  _OrbitButtonState createState() => _OrbitButtonState();
}

class _OrbitButtonState extends State<OrbitButton> {
  bool _isOrbiting = false;

  void _toggleOrbit() {
    setState(() {
      if (_isOrbiting) {
        widget.stopOrbit();
      } else {
        widget.startOrbit();
      }
      _isOrbiting = !_isOrbiting;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: _toggleOrbit,
      style: ElevatedButton.styleFrom(
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
            style: Theme.of(context)
                .textTheme
                .headlineMedium!
                .copyWith(color: AppColors.darkerGrey),
          ),
        ],
      ),
    );
  }
}
