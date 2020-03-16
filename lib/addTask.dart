import './homepage.dart';
import 'package:flutter/material.dart';
import './utils/database_helper.dart';
import './model/task.dart';
import './utils/maps.dart';
import './main.dart';

class AddTask extends StatefulWidget {
  @override
  _AddTaskState createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  TextEditingController controller = TextEditingController();
  TextEditingController controller1 = TextEditingController();
  final formKey = new GlobalKey<FormState>();
  var dbHelper;
  String task;

  // ignore: non_constant_identifier_names
  String task_description;
  double lat = 0.0;
  double long = 0.0;
  int location = 0;

  @override
  void initState() {
    super.initState();
    dbHelper = DatabaseHelper();
  }

  bool toggleValue = false;

  @override
  Widget build(BuildContext context) {
    var _onPressed;

    return Scaffold(
        appBar: new AppBar(
          title: Text("RemindME"),
          backgroundColor: Colors.greenAccent,
        ),
        body: new Container(
          child: Form(
            key: formKey,
            child: Padding(
              padding: EdgeInsets.all(15.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                verticalDirection: VerticalDirection.down,
                children: <Widget>[
                  TextFormField(
                    controller: controller,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(labelText: 'Task'),
                    validator: (val) => val.length == 0 ? 'Enter Task' : null,
                    onSaved: (val) => task = val,
                  ),
                  TextFormField(
                    controller: controller1,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(labelText: 'Task Description'),
                    validator: (val) =>
                        val.length == 0 ? 'Enter Task Description' : null,
                    onSaved: (val) => task_description = val,
                  ),
                  AnimatedContainer(
                    duration: Duration(milliseconds: 1000),
                    height: 40.0,
                    width: 100.0,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0),
                        color: toggleValue
                            ? Colors.green
                            : Colors.red.withOpacity(0.5)),
                    child: Stack(
                      children: <Widget>[
                        AnimatedPositioned(
                          duration: Duration(milliseconds: 1000),
                          curve: Curves.easeIn,
                          top: 3.0,
                          left: toggleValue ? 60.0 : 0.0,
                          right: toggleValue ? 0.0 : 60.0,
                          child: InkWell(
                            onTap: toggleButton,
                            child: AnimatedSwitcher(
                              duration: Duration(milliseconds: 1000),
                              transitionBuilder:
                                  (Widget child, Animation<double> animation) {
                                return RotationTransition(
                                    child: child, turns: animation);
                              },
                              child: toggleValue
                                  ? Icon(Icons.remove_circle_outline,
                                      color: Colors.red,
                                      size: 35.0,
                                      key: UniqueKey())
                                  : Icon(Icons.check_circle,
                                      color: Colors.green,
                                      size: 35.0,
                                      key: UniqueKey()),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  ListTile(
                    title: new RaisedButton(
                      child: new Text("Set Location"),
                      onPressed: _onPressed,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      FlatButton(
                        onPressed: validate,
                        child: Text("Add Task"),
                      ),
                      FlatButton(
                        onPressed: () {
                          setState(() {});
                          clearName();
                        },
                        child: Text('CANCEL'),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ));
  }

//  _onPressed() {
//
//  }
  clearName() {
    controller.text = '';
  }

  toggleButton() {
    setState(() {
      toggleValue = !toggleValue;
      if (toggleValue == false) {
        lat = 0.0;
        long = 0.0;
        location = 0;
      } else {
        lat = 1.1;
        long = 1.1;
        location = 1;
      }
    });
  }

  validate() async {
    count++;
    if (formKey.currentState.validate()) {
      formKey.currentState.save();
      Tasks e = Tasks(count, task_description, task, lat, long, location, 0);
      print("Inserting Record");
      await dbHelper.insert(e);
    }
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => HomePage()),
    );
  }
}
