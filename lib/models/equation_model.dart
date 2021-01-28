import 'package:flutter/material.dart';

class MathEquation {
  final DateTime id;
  final String result;
  final int time;
  MathEquation({this.id, this.result, this.time});
}

class Equation {
  final DateTime id;
  final String equation;
  bool onProssecc;
  final double a;
  final double c;
  final String op;
  final int time;
  Equation(
      {this.id,
      this.equation,
      this.a,
      this.c,
      this.op,
      this.time,
      this.onProssecc = false});
}
