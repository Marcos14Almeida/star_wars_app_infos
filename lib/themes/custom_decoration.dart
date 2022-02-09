import 'package:flutter/material.dart';

//Borda dourada em torno dos botões
List<BoxShadow> customBorderShadow(){
  Color gold = const Color(0xFFC0AA05);
  return [BoxShadow(
      color: gold,
      blurRadius: 10.0,
      blurStyle: BlurStyle.outer
  )];
}