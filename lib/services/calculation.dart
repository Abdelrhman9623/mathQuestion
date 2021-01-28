import 'package:equationApp/models/equation_model.dart';
import 'package:flutter/material.dart';
import 'dart:math';

import 'package:flutter/services.dart';

class Calculation extends ChangeNotifier {
  List<MathEquation> _items = [];
  List<Equation> _pindingItems = [];
  DateTime _getId;
  double add;
  double sub;
  double mul;
  double div;
  DateTime get id => _getId;

  List<MathEquation> get items {
    return [..._items];
  }

  List<Equation> get pindItems {
    return [..._pindingItems];
  }

  _addEquation(double a, double b) {
    return add = a + b;
  }

  _subEquation(double a, double b) {
    return sub = a - b;
  }

  _mulEquation(double a, double b) {
    return mul = a * b;
  }

  double _divEquation(double a, double b) {
    return div = a / b;
  }

  Equation findById(DateTime id) {
    return _pindingItems.firstWhere((equation) => equation.id == id);
  }

  Future<void> backgroundServices(
      double x, double y, String operators, int second) async {
    try {
      List<Equation> _equations = [];
      _equations.add(Equation(
          id: DateTime.now(),
          a: x,
          c: y,
          op: operators,
          time: second,
          equation: '$x $operators $y'));
      _pindingItems.addAll(_equations);
      List<MathEquation> _result = [];
      for (var i = 0; i < _equations.length; i++) {
        if (_equations[i].op == '+') {
          Future.delayed(Duration(seconds: _equations[i].time), () {
            _result.add(MathEquation(
                id: _equations[i].id,
                result:
                    '${_equations[i].a} ${_equations[i].op} ${_equations[i].c} = ' +
                        _addEquation(_equations[i].a, _equations[i].c)
                            .toString(),
                time: _equations[i].time));
            _items.addAll(_result);
            removeEquation(_equations[i].id, _equations[i].time);
            notifyListeners();
          });
        } else if (_equations[i].op == '-') {
          Future.delayed(Duration(seconds: _equations[i].time), () {
            _result.add(MathEquation(
                id: _equations[i].id,
                result:
                    '${_equations[i].a} ${_equations[i].op} ${_equations[i].a} = ' +
                        _subEquation(_equations[i].a, _equations[i].c)
                            .toString(),
                time: _equations[i].time));
            _items.addAll(_result);
            removeEquation(_equations[i].id, _equations[i].time);
            notifyListeners();
          });
        } else if (_equations[i].op == '×' ||
            _equations[i].op == '*' ||
            _equations[i].op == 'x') {
          Future.delayed(Duration(seconds: _equations[i].time), () {
            _result.add(MathEquation(
                id: _equations[i].id,
                result:
                    '${_equations[i].a} ${_equations[i].op} ${_equations[i].a} = ' +
                        _mulEquation(_equations[i].a, _equations[i].c)
                            .toString(),
                time: _equations[i].time));
            _items.addAll(_result);
            removeEquation(_equations[i].id, _equations[i].time);
            notifyListeners();
          });
        } else {
          Future.delayed(Duration(seconds: _equations[i].time), () {
            _result.add(MathEquation(
                id: _equations[i].id,
                result:
                    '${_equations[i].a} ${_equations[i].op} ${_equations[i].a} = ' +
                        _divEquation(_equations[i].a, _equations[i].c)
                            .toStringAsFixed(2),
                time: _equations[i].time));

            _items.addAll(_result);
            removeEquation(_equations[i].id, _equations[i].time);
            notifyListeners();
          });
        }
      }
    } catch (e) {
      throw e;
    }
  }

  void removeEquation(DateTime id, int time) {
    print(id);
    Future.delayed(Duration(seconds: time), () {
      print('id');
      _pindingItems.remove(id);
      notifyListeners();
    });
  }

  clearPending() {
    _pindingItems = [];
    notifyListeners();
  }
}
