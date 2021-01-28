import 'package:equationApp/services/calculation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  static const route_name = '/home';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final GlobalKey<ScaffoldState> _scafoldKey = GlobalKey();
  double a;
  double b;
  String o;
  int time;
  var isShow = true;
  bool add = false;
  bool sub = false;
  bool mul = false;
  bool div = false;

  void _submit() async {
    if (!_formKey.currentState.validate()) {
      return;
    }
    if (o == null) {
      _scafoldKey.currentState.showSnackBar(SnackBar(
        backgroundColor: Theme.of(context).errorColor,
        content: Text(
          'TO COMPLETE THIS EQUATION YOU MUST SELECT ONE OF THIS (+,×,÷,-)',
          style: TextStyle(color: Colors.white),
          textAlign: TextAlign.center,
        ),
      ));
      return;
    }
    FocusScope.of(context).unfocus();
    _formKey.currentState.save();
    try {
      await Provider.of<Calculation>(context, listen: false)
          .backgroundServices(a, b, o, time);
    } catch (e) {
      throw e;
    }
  }

  @override
  Widget build(BuildContext context) {
    final cal = Provider.of<Calculation>(context, listen: false);

    return Scaffold(
      key: _scafoldKey,
      appBar: AppBar(
        title: Text('MathQuestion '),
        actions: [
          IconButton(
            icon: Icon(Icons.room),
            onPressed: () => cal.getLocation(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Wrap(
          // crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    child: TextFormField(
                      keyboardType: TextInputType.numberWithOptions(
                          decimal: false, signed: true),
                      decoration: InputDecoration(hintText: 'Enter Number'),
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      // ignore: missing_return
                      validator: (val) {
                        if (val.isEmpty) {
                          return 'Please enter number';
                        }
                      },
                      onSaved: (val) {
                        setState(() {
                          a = double.parse(val.trim());
                        });
                      },
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    child: TextFormField(
                      keyboardType: TextInputType.numberWithOptions(
                          decimal: false, signed: true),
                      decoration:
                          InputDecoration(hintText: 'Enter Another Number'),
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      // ignore: missing_return
                      validator: (val) {
                        if (val.isEmpty) {
                          return 'Please enter number';
                        }
                        if (val == '0' && o == '/') {
                          return 'Nubmer must be bigger then 0';
                        }
                      },

                      onSaved: (val) {
                        setState(() {
                          b = double.parse(val.trim());
                        });
                      },
                    ),
                  ),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        FlatButton(
                          shape: RoundedRectangleBorder(
                              side: BorderSide(color: Colors.amberAccent)),
                          color: add ? Colors.amber : Colors.transparent,
                          child: Text('+'),
                          onPressed: () {
                            setState(() {
                              o = '+';
                              add = true;
                              sub = false;
                              mul = false;
                              div = false;
                            });
                          },
                        ),
                        FlatButton(
                          shape: RoundedRectangleBorder(
                              side: BorderSide(color: Colors.amberAccent)),
                          color: sub ? Colors.amber : Colors.transparent,
                          child: Text('-'),
                          onPressed: () {
                            setState(() {
                              o = '-';
                              add = false;
                              sub = true;
                              mul = false;
                              div = false;
                            });
                          },
                        ),
                        FlatButton(
                          shape: RoundedRectangleBorder(
                              side: BorderSide(color: Colors.amberAccent)),
                          color: mul ? Colors.amber : Colors.transparent,
                          child: Text('×'),
                          onPressed: () {
                            setState(() {
                              o = '×';
                              add = false;
                              sub = false;
                              mul = true;
                              div = false;
                            });
                          },
                        ),
                        FlatButton(
                          shape: RoundedRectangleBorder(
                              side: BorderSide(color: Colors.amberAccent)),
                          color: div ? Colors.amber : Colors.transparent,
                          child: Text('÷'),
                          onPressed: () {
                            setState(() {
                              o = '/';
                              add = false;
                              sub = false;
                              mul = false;
                              div = true;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    child: TextFormField(
                      keyboardType: TextInputType.numberWithOptions(
                          decimal: false, signed: true),
                      decoration: InputDecoration(
                          hintText: 'Enter time to calculate ex: 5s to 30s'),
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      // ignore: missing_return
                      validator: (val) {
                        if (val.isEmpty) {
                          return 'Please enter time for excute';
                        } else if (int.parse(val.trim()) < 5 ||
                            int.parse(val.trim()) > 30) {
                          return 'Dely time must be between 5s to 30s';
                        }
                      },
                      onSaved: (val) {
                        setState(() {
                          time = int.parse(val.trim());
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                Center(
                  child: FlatButton(
                    minWidth: MediaQuery.of(context).size.width,
                    child: Text('calculate'.toUpperCase()),
                    onPressed: _submit,
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Text('Result'),
            ),
            Consumer<Calculation>(
              builder: (context, items, _) => ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: items.items.length,
                  itemBuilder: (context, i) {
                    return Card(
                      margin: const EdgeInsets.symmetric(
                          vertical: 4, horizontal: 10),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Math Quation: ${items.items[i].result}')
                          ],
                        ),
                      ),
                    );
                  }),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Text('pending  Equations'),
            ),
            Consumer<Calculation>(
              builder: (context, items, _) => ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: items.pindItems.length,
                  itemBuilder: (context, i) {
                    Future.delayed(Duration(seconds: items.pindItems[i].time),
                        () {
                      setState(() {
                        items.pindItems[i].onProssecc = true;
                      });
                    });
                    return AnimatedOpacity(
                      opacity: items.pindItems[i].onProssecc ? 1 : 0.5,
                      duration: Duration(milliseconds: 800),
                      curve: Curves.fastOutSlowIn,
                      child: Card(
                        elevation: 0,
                        margin: const EdgeInsets.symmetric(
                            vertical: 4, horizontal: 10),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Add: ${items.pindItems[i].equation}'),
                              Text('Delay Time: ${items.pindItems[i].time}'),
                              Text(items.pindItems[i].onProssecc
                                  ? 'Done'
                                  : 'waiting .....')
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
