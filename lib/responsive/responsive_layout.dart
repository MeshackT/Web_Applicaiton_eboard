import 'package:flutter/material.dart';


/*
still about to implement this
*/
class ResponsiveLayout extends StatelessWidget {
  final Widget mobileScaffold;
  final Widget desktopScaffold;

  const ResponsiveLayout({
    Key? key,
    required this.mobileScaffold,
    required this.desktopScaffold,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (context, constraints){
          if(constraints.maxWidth < 1100){
            return mobileScaffold;
          }else{
            return desktopScaffold;
          }
        });
  }
}
