import 'package:flutter/material.dart';

InputDecoration inputDecoration = InputDecoration(
  filled: true,
  fillColor: Colors.white,
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.green, width: 2),
    borderRadius: BorderRadius.circular(18.0),
  ),
  border: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.green, width: 2),
    borderRadius: BorderRadius.circular(18.0),
  ),
  errorBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.green, width: 2),
    borderRadius: BorderRadius.circular(18.0),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.green, width: 2),
    borderRadius: BorderRadius.circular(18.0),
  ),
);

BoxDecoration textFaildDecoration = BoxDecoration(
  borderRadius: BorderRadius.circular(12.0),
  boxShadow: [shadow],
);

// Shadow decoration
BoxShadow shadow = BoxShadow(
  color: Colors.greenAccent.withOpacity(0.06),
  offset: Offset(0, 21),
  blurRadius: 53,
);
