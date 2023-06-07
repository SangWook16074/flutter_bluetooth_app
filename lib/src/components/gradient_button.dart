import 'package:flutter/material.dart';

class GradientButton extends StatelessWidget {
  final double width;
  final double height;
  final Widget? child;
  final void Function()? onPressed;
  const GradientButton(
      {super.key,
      required this.width,
      required this.height,
      this.child,
      this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)),
      child: Container(
        height: height,
        width: width,
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25.0),
            gradient: const LinearGradient(
              colors: [
                Color(0xff03b6dc),
                Color(0xff69e4ff),
              ],
            )),
        child: InkWell(
          onTap: onPressed!,
          child: Center(
            child: child,
          ),
        ),
      ),
    );
  }
}
