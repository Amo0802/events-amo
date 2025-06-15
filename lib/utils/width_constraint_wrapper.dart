import 'package:flutter/material.dart';

class WidthConstraintWrapper extends StatelessWidget {
  final Widget child;

  const WidthConstraintWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 1000;

    return Center(
      child: Container(
        width: isMobile ? screenWidth : 400,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
          borderRadius: isMobile ? null : BorderRadius.circular(20),
        ),
        clipBehavior: isMobile ? Clip.none : Clip.antiAlias,
        child: child,
      ),
    );
  }
}
