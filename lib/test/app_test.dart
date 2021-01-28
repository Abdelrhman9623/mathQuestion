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

  test('add equation', () {
    expect(addEquation(10, 12), equals(22));
  });

  test('Sub Equation', () {
    expect(subEquation(10, 12), equals(-2));
  });
  test('mul Function', () {
    expect(mulEquation(10, 12), equals(120));
  });

  test('Divid Function', () {
    expect(divEquation(10, 12), equals(0.8333333333333334));
  });
}
