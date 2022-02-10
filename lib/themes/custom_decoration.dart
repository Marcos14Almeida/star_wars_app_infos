import 'package:flutter/material.dart';

Color gold = const Color(0xFFC0AA05);

//Borda dourada em torno dos botões
//Dá um efeito de "sabre de luz"
List<BoxShadow> customBorderShadow(){
  return [BoxShadow(
      color: gold,
      blurRadius: 10.0,
      blurStyle: BlurStyle.outer
  )];
}

BoxDecoration customBoxDecoration(){
  return BoxDecoration(
    color: Colors.black54,
    border: Border.all(
      width: 2.0,
      color: gold,
    ),
    borderRadius: const BorderRadius.all(Radius.circular(25.0)),
    boxShadow: customBorderShadow(),
  );
}