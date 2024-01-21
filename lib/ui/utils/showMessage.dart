import 'package:flutter/material.dart';

showMsg(BuildContext context, String title) {
  return ScaffoldMessenger.of(context)
      .showSnackBar(SnackBar(content: Text(title)));
}
