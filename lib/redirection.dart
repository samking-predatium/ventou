import 'package:flutter/widgets.dart';

class Redirection extends StatelessWidget {
  const Redirection({super.key, required this.onPhone, required this.onTablet, required this.onDesktop});

  final Widget onPhone;
  final Widget onTablet;
  final Widget onDesktop;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints){
        if(constraints.maxWidth < 768){
          return onPhone;
        }else if(constraints.maxWidth < 1024){
          return onTablet;
        } else {
          return onDesktop;
        }
      }
    );
  }
}