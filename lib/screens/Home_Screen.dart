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
  AnimationController animation;
  Location _location = Location();
  Widget result;
  double a;
  double b;
  String o;
  int time;
  var isShow = true;
  bool add = false;
  bool sub = false;
  bool mul = false;
  bool div = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getLocation();
  }

  Future<void> getLocation() async {
    var per = await _location.hasPermission();
    if (per.index != null) {
      var address = await _location.getLocation();

      print(address);
    } else {
      _location.requestPermission();
      var address = await _location.getLocation();

      print(address);
    }
  }

  void _submit() async {
    final cal = Provider.of<Calculation>(context, listen: false);
    if (!_formKey.currentState.validate()) {
      return;
    }
    FocusScope.of(context).unfocus();
    _formKey.currentState.save();
    // setState(() {
    //   isShow = true;
    // });
    await Provider.of<Calculation>(context, listen: false)
        .backgroundServices(a, b, o, time);
  }

  @override
  Widget build(BuildContext context) {
    final cal = Provider.of<Calculation>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text('MathQuestion '),
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
