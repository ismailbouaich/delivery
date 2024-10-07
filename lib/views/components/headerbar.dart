import 'package:flutter/material.dart';

class Headerbar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;

  const Headerbar({Key? key, required this.title, this.actions}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      backgroundColor: Colors.blue,
      actions: actions,
    );
  }
  
  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}