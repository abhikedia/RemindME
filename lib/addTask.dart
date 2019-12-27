import './homepage.dart';
import 'package:flutter/material.dart';
import './utils/database_helper.dart';
import './model/task.dart';

class AddTask extends StatefulWidget {
  @override
  _AddTaskState createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  TextEditingController controller = TextEditingController();
  final formKey = new GlobalKey<FormState>();
  String task;
  int count = 609;
  var dbHelper;
  bool isUpdating;

  @override
  void initState() {
    super.initState();
    dbHelper = DatabaseHelper();
    isUpdating = false;
  }

  @override
  Widget build(BuildContext context) {
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      FlatButton(
                        onPressed: validate,
                        child: Text(isUpdating ? 'UPDATE' : 'ADD'),
                      ),
                      FlatButton(
                        onPressed: () {
                          setState(() {
                            isUpdating = false;
                          });
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

  clearName() {
    controller.text = '';
  }

  validate() async{
    count++;
    if (formKey.currentState.validate()) {
      formKey.currentState.save();
      if (isUpdating) {
        count++;
        print(count);
        Tasks e = Tasks(count, 'hey', task, 'gonda', 0);
        dbHelper.update(e);
        setState(() {
          isUpdating = false;
        });
      } else {
        Tasks e = Tasks(count, 'hey', task, 'gonda', 0);
        print("pressed");
        await dbHelper.insert(e);
      }
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    }
  }
}
