import 'package:equationApp/main.dart';
import 'package:equationApp/models/equation_model.dart';
import 'package:equationApp/services/calculation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets("testing app", (WidgetTester tester) async {
    await tester.pumpWidget(MyApp());
    expect(2 + 2, equals(4));
  });

  double addEquation(double a, double b) {
    var result = 0.0;
    result = a + b;
    return result;
  }

  double subEquation(double a, double b) {
    var result = 0.0;
    if (a < b) {
      result = b - a;
      return result;
    }
    result = a - b;
    return result;
  }

  double subEquationWithNagative(double a, double b) {
    var result = 0.0;
    result = a - b;
    return result;
  }

  double mulEquation(double a, double b) {
    var result = 0.0;
    result = a * b;
    return result;
  }

  double divEquation(double a, double b) {
    var result = 0.0;
    result = a / b;
    return result;
  }

  test('Add equation', () {
    expect(addEquation(10, 12), equals(10 + 12));
  });

  test('Subtract Equation ', () {
    expect(subEquation(15, 18), equals(3));
  });

  test('Subtract Equation with negative value', () {
    expect(subEquationWithNagative(10, 12), equals(-2));
  });

  test('Multiply Function', () {
    expect(mulEquation(0, 12), equals(0));
  });
  test('Dividing Function', () {
    expect(divEquation(12, 2), equals(6));
  });

  test('Dividing Function with infinity value to check', () {
    expect(divEquation(12, 0), equals(double.infinity));
  });
}
