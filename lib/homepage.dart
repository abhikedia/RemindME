import 'package:flutter/material.dart';
import 'dart:async';
import './model/task.dart';
import './utils/database_helper.dart';
import './addTask.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<List<Tasks>> tasks;
  var dbHelper;
  bool isUpdating;
  String name;
  int curUserId;
  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    dbHelper = DatabaseHelper();
    isUpdating = false;
    refreshList();
  }

  refreshList() {
    setState(() {
      tasks = dbHelper.getTasks();
    });
  }

  SingleChildScrollView dataTable(List<Tasks> employees) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: DataTable(
        columns: [
          DataColumn(
            label: Text('Serial'),
          ),
          DataColumn(
            label: Text('Task'),
          ),
          DataColumn(
            label: Text('Description'),
          ),
          DataColumn(
            label: Text('Done?'),
          )
        ],
        rows: employees
            .map(
              (employee) => DataRow(cells: [
                DataCell(
                  new Text(employee.id.toString()),
//                  onTap: () {
//                    setState(() {
//                      isUpdating = true;
//                      curUserId = employee.id;
//                    });
//                    controller.text = employee.title;

                ),
                DataCell(
                  new Text(employee.title),
                  onTap: () {
                    setState(() {
                      isUpdating = true;
                      curUserId = employee.id;
                    });
                    controller.text = employee.title;
                  },
                ),
                DataCell(
                  new Text(employee.description),
                  onTap: () {
                    setState(() {
                      isUpdating = true;
                      curUserId = employee.id;
                    });
                    controller.text = employee.done.toString();
                  },
                ),
                DataCell(
                  new Text(employee.title),
                  onTap: () {
                    setState(() {
                      isUpdating = true;
                      curUserId = employee.id;
                    });
                    controller.text = employee.title;
                  },
                ),
              ]),
            )
            .toList(),
      ),
    );
  }

  list() {
    return Expanded(
      child: FutureBuilder(
        future: tasks,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return dataTable(snapshot.data);
          }

          if (null == snapshot.data || snapshot.data.length == 0) {
            return Text("No Data Found");
          }

          return CircularProgressIndicator();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("RemindME"),
        backgroundColor: Colors.greenAccent,
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddTask()),
          );
        },
        backgroundColor: Colors.greenAccent,
        child: new Icon(Icons.add),
      ),
      body: new Container(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          verticalDirection: VerticalDirection.down,
          children: <Widget>[
            list(),
          ],
        ),
      ),
    );
  }
}
