import 'package:flutter/material.dart';
import 'package:ais_visualizer/utils/constants/colors.dart';

class FloatingArrow extends StatelessWidget {
  final bool isOpen;
  final VoidCallback onTap;

  const FloatingArrow({
    required this.isOpen,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: isOpen ? 400 - 40 : 0,
      top: isOpen ? -5 : MediaQuery.of(context).size.height / 2 - 80,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 70,
          height: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: AppColors.primaryBackground,
            boxShadow: const [
              BoxShadow(
                color: AppColors.softGrey,
                spreadRadius: 3,
                blurRadius: 10,
                offset: Offset(3, 0),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.only(right: 40),
            child: Center(
              child: Icon(
                isOpen ? Icons.arrow_forward_ios : Icons.arrow_back_ios,
                color: AppColors.grey,
                size: 18.0,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
