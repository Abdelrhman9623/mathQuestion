import 'package:equationApp/models/equation_model.dart';
import 'package:flutter/material.dart';
import 'dart:math';

import 'package:flutter/services.dart';
import 'package:location/location.dart';

class Calculation extends ChangeNotifier {
  List<MathEquation> _items = [];
  List<Equation> _pindingItems = [];
  Location _location = Location();

  List<MathEquation> get items {
    return [..._items];
  }

  List<Equation> get pindItems {
    return [..._pindingItems];
  }

  double _addEquation(double a, double b) {
    var result = 0.0;
    result = a + b;
    return result;
  }

  double _subEquation(double a, double b) {
    var result = 0.0;
    result = a - b;
    return result;
  }

  double _mulEquation(double a, double b) {
    var result = 0.0;
    result = a * b;
    return result;
  }

  double _divEquation(double a, double b) {
    var result = 0.0;
    result = a / b;
    return result;
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
            notifyListeners();
          });
        } else {
          Future.delayed(Duration(seconds: _equations[i].time), () {
            _result.add(MathEquation(
                id: _equations[i].id,
                result: _divEquation(_equations[i].a, _equations[i].c) ==
                        double.infinity
                    ? '${_equations[i].a} ${_equations[i].op} ${_equations[i].a} = NaNaN'
                    : '${_equations[i].a} ${_equations[i].op} ${_equations[i].a} = ' +
                        _divEquation(_equations[i].a, _equations[i].c)
                            .toString(),
                time: _equations[i].time));

            _items.addAll(_result);
            notifyListeners();
          });
        }
      }
    } catch (e) {
      throw e;
    }
  }

// TO GET CUREENT USER LOCATION
  void getLocation(BuildContext context) async {
    _location.requestPermission();
    await _location.hasPermission();
    var address = await _location.getLocation();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Container(
          height: 100,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text('Lat: ${address.latitude}'),
              Text('Long: ${address.longitude}'),
            ],
          ),
        ),
      ),
    );
  }
}
